targetScope = 'subscription'

metadata name = 'With encryption'
metadata description = 'This instance deploys the module with customer-managed keys for encryption, where 2 different keys are hosted in the same vault and the AzureDatabricks Enterprise Application is used to pull the keys.'

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
    location: resourceLocation
    databricksApplicationObjectId: azureDatabricksEnterpriseApplicationObjectId
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      customerManagedKey: {
        keyName: nestedDependencies.outputs.keyVaultKeyName
        keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
      }
      customerManagedKeyManagedDisk: {
        keyName: nestedDependencies.outputs.keyVaultDiskKeyName
        keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
      }
    }
  }
]

// =============== //
// Post-Deployment //
// =============== //
// The managed-disk's disk-encryption-set requires its identity to have at least 'Key Vault Crypto Service Encryption User' permissions on the used key.
resource keyVault 'Microsoft.KeyVault/vaults@2025-05-01' existing = {
  name: last(split(nestedDependencies.outputs.keyVaultResourceId, '/'))

  resource key 'keys@2025-05-01' existing = {
    name: nestedDependencies.outputs.keyVaultDiskKeyName
  }

  scope: resourceGroup
}

module managedDiskEncryptionSetPermissions 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-managedDiskEncryptionSetPermissions'
  scope: resourceGroup
  params: {
    principalId: testDeployment[1].outputs.managedDiskIdentityPrincipalId!
    resourceId: keyVault::key.id
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e147488a-f6f5-4113-8e2d-b22465e65bf6'
    ) // Key Vault Crypto Service Encryption User
    principalType: 'ServicePrincipal'
  }
}
