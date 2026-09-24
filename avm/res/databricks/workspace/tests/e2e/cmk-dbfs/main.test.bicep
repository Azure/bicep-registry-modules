targetScope = 'subscription'

metadata name = 'With DBFS root encryption'
metadata description = 'This instance deploys the module with a customer-managed key for the DBFS root storage account. The workspace is first prepared for encryption, which creates the storage account identity, then that identity is granted access to the key, and finally the key is applied.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-databricks.workspaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dwdbfs'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

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
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
  }
}

// The storage account identity only exists once the workspace is prepared for encryption.
module prepareDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}-prepare'
  params: {
    name: '${namePrefix}${serviceShort}001'
    prepareEncryption: true
  }
}

// The storage account identity requires at least 'Key Vault Crypto Service Encryption User' permissions on the key before it is applied.
resource keyVault 'Microsoft.KeyVault/vaults@2025-05-01' existing = {
  name: last(split(nestedDependencies.outputs.keyVaultResourceId, '/'))

  resource key 'keys@2025-05-01' existing = {
    name: nestedDependencies.outputs.keyVaultDbfsKeyName
  }

  scope: resourceGroup
}

module storageAccountIdentityPermissions 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-storageAccountIdentityPermissions'
  scope: resourceGroup
  params: {
    principalId: prepareDeployment.outputs.storageAccountIdentityPrincipalId!
    resourceId: keyVault::key.id
    roleDefinitionId: subscriptionResourceId(
      'Microsoft.Authorization/roleDefinitions',
      'e147488a-f6f5-4113-8e2d-b22465e65bf6'
    ) // Key Vault Crypto Service Encryption User
    principalType: 'ServicePrincipal'
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
      prepareEncryption: true
      customerManagedKeyDbfsRoot: {
        keyName: nestedDependencies.outputs.keyVaultDbfsKeyName
        keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
      }
    }
    dependsOn: [
      storageAccountIdentityPermissions
    ]
  }
]
