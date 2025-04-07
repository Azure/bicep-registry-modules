targetScope = 'resourceGroup'
import { NamingOutput } from '../naming/naming.module.bicep'

// ------------------
//    PARAMETERS
// ------------------
import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'

param naming NamingOutput

@description('The location where the resources will be created. This needs to be the same region as the spoke.')
param location string = resourceGroup().location

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

@description('The name of the existing subnet in the spoke virtual to which the private endpoint will be connected.')
param spokePrivateEndpointSubnetName string

@description('Optional. Resource ID of the diagnostic log analytics workspace. If left empty, no diagnostics settings will be defined.')
param logAnalyticsWorkspaceResourceId string = ''

param appServiceManagedIdentityPrincipalId string

param keyVaultDiagnosticSettings diagnosticSettingFullType[]?

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
    hubVNetResourceId: hubVNetResourceId
    spokeVNetResourceId: spokeVNetResourceId
    spokePrivateEndpointSubnetName: spokePrivateEndpointSubnetName
    diagnosticSettings: !empty(keyVaultDiagnosticSettings)
      ? keyVaultDiagnosticSettings
      : [
          {
            name: 'keyvault-diagnosticSettings'
            workspaceResourceId: logAnalyticsWorkspaceResourceId
            logCategoriesAndGroups: [
              {
                categoryGroup: 'allLogs'
              }
            ]
            metricCategories: [
              {
                category: 'AllMetrics'
              }
            ]
          }
        ]
    appServiceManagedIdentityPrincipalId: appServiceManagedIdentityPrincipalId
  }
}

// ------------------
// OUTPUTS
// ------------------

@description('The resource ID of the Azure Key Vault.')
output keyVaultResourceId string = keyVault.outputs.keyVaultResourceId

@description('The name of the Azure Key Vault.')
output keyVaultName string = keyVault.outputs.keyVaultName
