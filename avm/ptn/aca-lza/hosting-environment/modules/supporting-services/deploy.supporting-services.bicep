targetScope = 'subscription'

// ------------------
//    PARAMETERS
// ------------------

@description('Required. The resource names definition')
param resourcesNames object

@description('The location where the resources will be created. This needs to be the same region as the spoke.')
param location string

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Whether to enable deployment telemetry.')
param enableTelemetry bool

// Hub
@description('The resource ID of the existing hub virtual network.')
param hubVNetResourceId string

// Spoke
@description('The resource ID of the existing spoke virtual network to which the private endpoint will be connected.')
param spokeVNetResourceId string

@description('The resource id of the existing subnet in the spoke virtual network to which the private endpoint will be connected.')
param spokePrivateEndpointSubnetResourceId string

@description('Optional. Resource ID of the diagnostic log analytics workspace. If left empty, no diagnostics settings will be defined.')
param logAnalyticsWorkspaceId string = ''

@description('Optional, default value is true. If true, any resources that support AZ will be deployed in all three AZ. However if the selected region is not supporting AZ, this parameter needs to be set to false.')
param deployZoneRedundantResources bool = true

// ------------------
// RESOURCES
// ------------------
@description('Azure Container Registry, where all workload images should be pulled from.')
module containerRegistry 'modules/container-registry.module.bicep' = {
  name: 'containerRegistryModule-${uniqueString(resourcesNames.resourceGroup)}'
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    containerRegistryName: resourcesNames.containerRegistry
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    spokeVNetResourceId: spokeVNetResourceId
    hubVNetResourceId: hubVNetResourceId
    spokePrivateEndpointSubnetResourceId: spokePrivateEndpointSubnetResourceId
    containerRegistryPrivateEndpointName: resourcesNames.containerRegistryPep
    containerRegistryUserAssignedIdentityName: resourcesNames.containerRegistryUserAssignedIdentity
    diagnosticWorkspaceId: logAnalyticsWorkspaceId
    deployZoneRedundantResources: deployZoneRedundantResources
  }
}

@description('Azure Key Vault used to hold items like TLS certs and application secrets that your workload will need.')
module keyVault 'modules/key-vault.bicep' = {
  name: 'keyVault-${uniqueString(resourcesNames.resourceGroup)}'
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    keyVaultName: resourcesNames.keyVault
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    spokeVNetResourceId: spokeVNetResourceId
    hubVNetResourceId: hubVNetResourceId
    spokePrivateEndpointSubnetResourceId: spokePrivateEndpointSubnetResourceId
    keyVaultPrivateEndpointName: resourcesNames.keyVaultPep
    diagnosticWorkspaceId: logAnalyticsWorkspaceId
  }
}

module storage 'modules/storage.bicep' = {
  name: 'storage-${uniqueString(resourcesNames.resourceGroup)}'
  scope: resourceGroup(resourcesNames.resourceGroup)
  params: {
    location: location
    storageAccountName: resourcesNames.storageAccount
    tags: tags
    enableTelemetry: enableTelemetry
    hubVNetResourceId: hubVNetResourceId
    keyVaultResourceId: keyVault.outputs.keyVaultResourceId
    spokeVNetResourceId: spokeVNetResourceId
    spokePrivateEndpointSubnetResourceId: spokePrivateEndpointSubnetResourceId
    diagnosticWorkspaceId: logAnalyticsWorkspaceId
  }
}

// ------------------
// OUTPUTS
// ------------------

@description('The resource ID of the Azure Container Registry.')
output containerRegistryId string = containerRegistry.outputs.containerRegistryId

@description('The name of the Azure Container Registry.')
output containerRegistryName string = containerRegistry.outputs.containerRegistryName

@description('The name of the container registry login server.')
output containerRegistryLoginServer string = containerRegistry.outputs.containerRegistryLoginServer

@description('The name of the internal agent pool for the container registry.')
output containerRegistryAgentPoolName string = containerRegistry.outputs.containerRegistryAgentPoolName

@description('The resource ID of the user-assigned managed identity for the Azure Container Registry to be able to pull images from it.')
output containerRegistryUserAssignedIdentityId string = containerRegistry.outputs.containerRegistryUserAssignedIdentityId

@description('The resource ID of the Azure Key Vault.')
output keyVaultResourceId string = keyVault.outputs.keyVaultResourceId

@description('The name of the Azure Key Vault.')
output keyVaultName string = keyVault.outputs.keyVaultName

@description('The account name of the storage account.')
output storageAccountName string = storage.outputs.storageAccountName

@description('The resource ID of the storage account.')
output storageAccountResourceId string = storage.outputs.storageAccountResourceId
