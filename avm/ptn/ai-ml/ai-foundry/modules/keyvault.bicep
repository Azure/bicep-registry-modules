@maxLength(24)
@description('Required. Name of the Key Vault. This is ignored if existingResourceId is provided.')
param name string

@description('Optional. Resource Id of an existing Key Vault. If provided, the module will not create a new Key Vault but will use the existing one.')
param existingResourceId string?

@description('Optional. Specifies the location for all the Azure resources. Defaults to the location of the resource group.')
param location string = resourceGroup().location

@description('Optional. Tags to be applied to the resources.')
param tags resourceInput<'Microsoft.Resources/resourceGroups@2025-04-01'>.tags = {}

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { resourcePrivateNetworkingType } from 'localSharedTypes.bicep'
@description('Optional. Values to establish private networking for the Key Vault. If not provided, public access will be enabled.')
param privateNetworking resourcePrivateNetworkingType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

module parsedResourceId 'parseResourceId.bicep' = if (!empty(existingResourceId)) {
  name: take('${name}-keyvault-parse-resource-id', 64)
  params: {
    resourceIdOrName: existingResourceId!
  }
}

resource existingKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = if (!empty(existingResourceId)) {
  #disable-next-line no-unnecessary-dependson
  dependsOn: [parsedResourceId]
  name: parsedResourceId!.outputs.name
  scope: resourceGroup(parsedResourceId!.outputs.subscriptionId, parsedResourceId!.outputs.resourceGroupName)
}

var networkIsolation = !empty(privateNetworking) && !empty(privateNetworking!.privateDnsZoneId) && !empty(privateNetworking!.privateEndpointSubnetId)

module keyvault 'br/public:avm/res/key-vault/vault:0.13.0' = if (empty(existingResourceId)) {
  name: take('${name}-keyvault-deployment', 64)
  params: {
    name: name
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    publicNetworkAccess: networkIsolation ? 'Disabled' : 'Enabled'
    networkAcls: {
      defaultAction: networkIsolation ? 'Deny' : 'Allow'
    }
    enableVaultForDeployment: true
    enableVaultForDiskEncryption: true
    enableVaultForTemplateDeployment: true
    enablePurgeProtection: false
    enableRbacAuthorization: true
    enableSoftDelete: true
    softDeleteRetentionInDays: 7
    privateEndpoints: networkIsolation
      ? [
          {
            privateDnsZoneGroup: {
              privateDnsZoneGroupConfigs: [
                {
                  privateDnsZoneResourceId: privateNetworking!.privateDnsZoneId
                }
              ]
            }
            service: 'vault'
            subnetResourceId: privateNetworking!.privateEndpointSubnetId
          }
        ]
      : []
    roleAssignments: roleAssignments
  }
}

var outputResourceId = empty(existingResourceId) ? keyvault!.outputs.resourceId : existingKeyVault.id
var outputName = empty(existingResourceId) ? keyvault!.outputs.name : existingKeyVault.name
var outputLocation = empty(existingResourceId) ? keyvault!.outputs.location : existingKeyVault!.location

@description('Resource ID of the Key Vault.')
output resourceId string = outputResourceId

@description('Name of the Key Vault.')
output name string = outputName

@description('Location of the Key Vault.')
output location string = outputLocation
