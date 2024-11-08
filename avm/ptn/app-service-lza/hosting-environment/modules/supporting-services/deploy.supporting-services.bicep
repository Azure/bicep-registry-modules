targetScope = 'resourceGroup'
import { NamingOutput } from '../naming/naming.module.bicep'

// ------------------
//    PARAMETERS
// ------------------

param naming NamingOutput

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

param appServiceManagedIdentityPrincipalId string

// ------------------
// RESOURCES
// ------------------

@description('Azure Key Vault used to hold items like TLS certs and application secrets that your workload will need.')
module keyVault 'modules/key-vault.bicep' = {
  name: 'keyVaultModule-${uniqueString(resourceGroup().id)}'
  params: {
    location: location
    keyVaultName: naming.keyVault.nameUnique
    tags: tags
    enableTelemetry: enableTelemetry
    hubVNetId: hubVNetId
    spokeVNetId: spokeVNetId
    spokePrivateEndpointSubnetName: spokePrivateEndpointSubnetName
    diagnosticWorkspaceId: logAnalyticsWorkspaceId
    appServiceManagedIdentityPrincipalId: appServiceManagedIdentityPrincipalId
  }
}

// ------------------
// OUTPUTS
// ------------------

@description('The resource ID of the Azure Key Vault.')
output keyVaultResourceId string = keyVault.outputs.keyVaultId

@description('The name of the Azure Key Vault.')
output keyVaultName string = keyVault.outputs.keyVaultName
