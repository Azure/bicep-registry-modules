targetScope = 'subscription'

metadata name = 'With encryption'
metadata description = 'This instance deploys the module with customer-managed keys for encryption, where 2 different keys are hosted in the same vault.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-databricks.workspaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dwenc'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Required. The object id of the AzureDatabricks Enterprise Application. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-AzureDatabricksEnterpriseApplicationObjectId\'.')
@secure()
param azureDatabricksEnterpriseApplicationObjectId string = ''

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
    location: resourceLocation
    databricksApplicationObjectId: azureDatabricksEnterpriseApplicationObjectId
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-avmx-kv-dwenc-vsg' //'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
  }
}

// ============== //
// Test Execution //
// ============== //

// @batchSize(1)
// module testDeployment '../../../main.bicep' = [
//   for iteration in ['init', 'idem']: {
//     scope: resourceGroup
//     name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
//     params: {
//       name: '${namePrefix}${serviceShort}001'
//       customerManagedKey: {
//         keyName: nestedDependencies.outputs.keyVaultKeyName
//         keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
//       }
//       customerManagedKeyManagedDisk: {
//         keyName: nestedDependencies.outputs.keyVaultDiskKeyName
//         keyVaultResourceId: nestedDependencies.outputs.keyVaultDiskResourceId
//       }
//     }
//   }
// ]
