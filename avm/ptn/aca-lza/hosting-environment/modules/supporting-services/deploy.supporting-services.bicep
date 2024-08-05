targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

@description('The name of the workload that is being deployed. Up to 10 characters long.')
@minLength(2)
@maxLength(10)
param workloadName string

@description('The name of the environment (e.g. "dev", "test", "prod", "uat", "dr", "qa"). Up to 8 characters long.')
@maxLength(8)
param environment string

@description('The location where the resources will be created. This needs to be the same region as the spoke.')
param location string = resourceGroup().location

@description('Optional. The tags to be assigned to the created resources.')
param tags object = {}

@description('Required. Whether to enable deployment telemetry.')
param enableTelemetry bool

// Hub
@description('The resource ID of the existing hub virtual network.')
param hubVNetId string

// Spoke
@description('The resource ID of the existing spoke virtual network to which the private endpoint will be connected.')
param spokeVNetId string

@description('The name of the existing subnet in the spoke virtual to which the private endpoint will be connected.')
param spokePrivateEndpointSubnetName string

@description('Optional. Resource ID of the diagnostic log analytics workspace. If left empty, no diagnostics settings will be defined.')
param logAnalyticsWorkspaceId string = ''

@description('Optional, default value is true. If true, any resources that support AZ will be deployed in all three AZ. However if the selected region is not supporting AZ, this parameter needs to be set to false.')
param deployZoneRedundantResources bool = true

// ------------------
// RESOURCES
// ------------------

@description('User-configured naming rules')
module naming '../naming/naming.module.bicep' = {
  name: take('supportingServicesNamingDeployment-${deployment().name}', 64)
  params: {
    uniqueId: uniqueString(resourceGroup().id)
    environment: environment
    workloadName: workloadName
    location: location
  }
}

@description('Azure Container Registry, where all workload images should be pulled from.')
module containerRegistry 'modules/container-registry.module.bicep' = {
  name: 'containerRegistryModule-${uniqueString(resourceGroup().id)}'
  params: {
    containerRegistryName: naming.outputs.resourcesNames.containerRegistry
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    spokeVNetId: spokeVNetId
    hubVNetId: hubVNetId
    spokePrivateEndpointSubnetName: spokePrivateEndpointSubnetName
    containerRegistryPrivateEndpointName: naming.outputs.resourcesNames.containerRegistryPep
    containerRegistryUserAssignedIdentityName: naming.outputs.resourcesNames.containerRegistryUserAssignedIdentity
    diagnosticWorkspaceId: logAnalyticsWorkspaceId
    deployZoneRedundantResources: deployZoneRedundantResources
  }
}

@description('Azure Key Vault used to hold items like TLS certs and application secrets that your workload will need.')
module keyVault 'modules/key-vault.bicep' = {
  name: 'keyVault-${uniqueString(resourceGroup().id)}'
  params: {
    keyVaultName: naming.outputs.resourcesNames.keyVault
    location: location
    tags: tags
    enableTelemetry: enableTelemetry
    spokeVNetId: spokeVNetId
    hubVNetId: hubVNetId
    spokePrivateEndpointSubnetName: spokePrivateEndpointSubnetName
    keyVaultPrivateEndpointName: naming.outputs.resourcesNames.keyVaultPep
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

@description('The resource ID of the user-assigned managed identity for the Azure Container Registry to be able to pull images from it.')
output containerRegistryUserAssignedIdentityId string = containerRegistry.outputs.containerRegistryUserAssignedIdentityId

@description('The resource ID of the Azure Key Vault.')
output keyVaultResourceId string = keyVault.outputs.keyVaultId

@description('The name of the Azure Key Vault.')
output keyVaultName string = keyVault.outputs.keyVaultName
