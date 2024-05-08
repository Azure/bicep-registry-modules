targetScope = 'subscription'

metadata name = 'Deploying with a key vault reference to save secrets'
metadata description = 'This instance deploys the module saving all its secrets in a key vault.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddaskvs'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Pipeline is selecting random regions which dont support all cosmos features and have constraints when creating new cosmos
#disable-next-line no-hardcoded-location
var enforcedLocation = 'eastasia'

// ============== //
// General resources
// ============== //
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    location: enforcedLocation
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}'
  params: {
    location: enforcedLocation
    name: '${namePrefix}-kv-ref'
    secretsKeyVault: {
      keyVaultName: nestedDependencies.outputs.keyVaultName
      primaryReadonlyConnectionStringSecretName: 'custom-secret-name'
    }
  }
}
