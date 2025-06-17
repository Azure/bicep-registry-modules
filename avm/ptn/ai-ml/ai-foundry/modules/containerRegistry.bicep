@minLength(5)
@description('Name of the Container Registry.')
param name string

@description('Specifies the location for all the Azure resources.')
param location string

@description('Optional. Tags to be applied to the resources.')
param tags object = {}

@description('Resource ID of the virtual network to link the private DNS zones.')
param virtualNetworkResourceId string

@description('Resource ID of the subnet for the private endpoint.')
param virtualNetworkSubnetResourceId string

@description('Specifies whether network isolation is enabled. This will create a private endpoint for the Container Registry and link the private DNS zone.')
param networkIsolation bool = toLower(aiFoundryType) == 'standardprivate'

@description('Specifies the AI Foundry deployment type. Allowed values are Basic, StandardPublic, and StandardPrivate.')
param aiFoundryType string

module privateDnsZone 'br/public:avm/res/network/private-dns-zone:0.7.1' = if (networkIsolation) {
  name: 'private-dns-acr-deployment'
  params: {
    name: 'privatelink.${toLower(environment().name) == 'azureusgovernment' ? 'azurecr.us' : 'azurecr.io'}'
    virtualNetworkLinks: [
      {
        virtualNetworkResourceId: virtualNetworkResourceId
      }
    ]
    tags: tags
  }
}

var nameFormatted = take(toLower(name), 50)

module containerRegistry 'br/public:avm/res/container-registry/registry:0.9.1' = {
  name: take('${nameFormatted}-container-registry-deployment', 64)
  params: {
    name: nameFormatted
    location: location
    tags: tags
    acrSku: 'Premium'
    acrAdminUserEnabled: false
    anonymousPullEnabled: false
    dataEndpointEnabled: false
    networkRuleBypassOptions: 'AzureServices'
    networkRuleSetDefaultAction: toLower(aiFoundryType) == 'standardprivate' ? 'Deny' : 'Allow'
    exportPolicyStatus: toLower(aiFoundryType) == 'standardprivate' ? 'disabled' : 'enabled'
    publicNetworkAccess: toLower(aiFoundryType) == 'standardprivate' ? 'Disabled' : 'Enabled'
    zoneRedundancy: 'Disabled'
    managedIdentities: {
      systemAssigned: true
    }
    diagnosticSettings: [
      {}
    ]
    privateEndpoints: networkIsolation
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: privateDnsZone.outputs.resourceId
                }
              ]
            }
            subnetResourceId: virtualNetworkSubnetResourceId
          }
        ]
      : []
  }
}

output resourceId string = containerRegistry.outputs.resourceId
output loginServer string = containerRegistry.outputs.loginServer
output name string = containerRegistry.outputs.name
