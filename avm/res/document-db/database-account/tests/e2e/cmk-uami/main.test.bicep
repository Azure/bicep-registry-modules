targetScope = 'subscription'

metadata name = 'Using encryption with Customer-Managed-Key'
metadata description = 'This instance deploys the module using Customer-Managed-Keys using a User-Assigned Identity to access the Customer-Managed-Key secret.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddaenc'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = 'uniq'

// The default pipeline is selecting random regions which don't have capacity for Azure Cosmos DB or support all Azure Cosmos DB features when creating new accounts.
#disable-next-line no-hardcoded-location
var enforcedLocation = 'eastus2'
var keyVaultName = 'dep-${namePrefix}-kv-${serviceShort}'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    // Adding base time to make the name unique as purge protection must be enabled (but may not be longer than 24 characters total)
    keyVaultName: keyVaultName
    managedIdentityName: 'dep-${namePrefix}-msi-${serviceShort}'
  }
}

// ============== //
// Test Execution //
// ============== //

module initDeployment '../../../main.small.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-base'
  params: {
    name: '${namePrefix}${serviceShort}001'
    zoneRedundant: false
    managedIdentities: {
      userAssignedResourceIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
    // Explicit 1
    networkRestrictions: {
      publicNetworkAccess: 'Enabled'
    }
    // Explicit 2
    disableKeyBasedMetadataWriteAccess: false
  }
}

module testDeployment '../../../main.small.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-cmk'
  params: {
    name: '${namePrefix}${serviceShort}001'
    zoneRedundant: false
    customerManagedKey: {
      keyName: nestedDependencies.outputs.keyVaultEncryptionKeyName
      keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
    }
    defaultIdentity: {
      name: 'UserAssignedIdentity'
      resourceId: nestedDependencies.outputs.managedIdentityResourceId
    }
    managedIdentities: {
      userAssignedResourceIds: [
        nestedDependencies.outputs.managedIdentityResourceId
      ]
    }
    // Explicit 1
    networkRestrictions: {
      publicNetworkAccess: 'Enabled'
    }
    // Explicit 2
    disableKeyBasedMetadataWriteAccess: false
  }
}
