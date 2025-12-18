metadata name = 'Container Registry Module'
// AVM-compliant Azure Container Registry deployment

@description('Required. The name of the Azure Container Registry.')
param acrName string

@description('Required. The location of the Azure Container Registry.')
param location string

@description('Optional. SKU for the Azure Container Registry.')
param acrSku string = 'Basic'

@description('Optional. Public network access setting for the Azure Container Registry.')
param publicNetworkAccess string = 'Enabled'

@description('Optional. Zone redundancy setting for the Azure Container Registry.')
param zoneRedundancy string = 'Disabled'

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags to be applied to the Container Registry.')
param tags object = {}

@description('Required. Enable telemetry for the AVM deployment.')
param enableTelemetry bool

@description('Required. Enable Redundancy for the AVM deployment.')
param enableRedundancy bool

@description('Required. The secondary location for the Azure Container Registry replication, if redundancy is enabled.')
param secondaryLocation string

@description('Optional. Enable private networking for the Container Registry.')
param enablePrivateNetworking bool = false

@description('Optional. Backend subnet resource ID for private endpoints.')
param backendSubnetResourceId string = ''

@description('Optional. Private DNS zone resource ID for Container Registry.')
param privateDnsZoneResourceId string = ''

module avmContainerRegistry 'br/public:avm/res/container-registry/registry:0.9.3' = {
  name: acrName
  params: {
    name: acrName
    location: location
    acrSku: acrSku
    publicNetworkAccess: publicNetworkAccess
    zoneRedundancy: zoneRedundancy
    roleAssignments: roleAssignments
    tags: tags
    enableTelemetry: enableTelemetry
    replications: enableRedundancy
      ? [
          {
            location: secondaryLocation
            name: 'acrrepl${replace(secondaryLocation, '-', '')}'
          }
        ]
      : null
    // WAF aligned configuration for Private Networking - Network access restrictions
    networkRuleSetDefaultAction: enablePrivateNetworking ? 'Deny' : 'Allow'
    networkRuleSetIpRules: enablePrivateNetworking ? [] : []
    exportPolicyStatus: enablePrivateNetworking ? 'disabled' : 'enabled'
    privateEndpoints: enablePrivateNetworking
      ? [
          {
            name: 'pep-acr-${acrName}'
            customNetworkInterfaceName: 'nic-acr-${acrName}'
            privateDnsZoneGroup: !empty(privateDnsZoneResourceId)
              ? {
                  privateDnsZoneGroupConfigs: [
                    {
                      name: 'acr-dns-zone-group'
                      privateDnsZoneResourceId: privateDnsZoneResourceId
                    }
                  ]
                }
              : null
            subnetResourceId: backendSubnetResourceId
          }
        ]
      : []
  }
}

output name string = avmContainerRegistry.outputs.name
output resourceId string = avmContainerRegistry.outputs.resourceId
output loginServer string = avmContainerRegistry.outputs.loginServer
