targetScope = 'subscription'

metadata name = 'Deploying with a key vault reference to save secrets'
metadata description = 'This instance deploys the module saving its secrets in a key vault.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddaskvs'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

@description('Optional. The password to leverage for the login.')
@secure()
param password string = newGuid()

// ============== //
// General resources
// ============== //
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}'
    location: resourceLocation
  }
}

// ============== //
// Test Execution //
// ============== //

module testDeployment '../../../main.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-test-${serviceShort}'
  params: {
    location: resourceLocation
    name: '${namePrefix}-kv-ref'
    secretsExportConfiguration: {
      keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
      connectionStringSecretName: 'connectionString'
    }
    administratorLogin: 'Admin002'
    administratorLoginPassword: password
    nodeCount: 2
    sku: 'M30'
    storage: 256
  }
}

// Output usage examples
output specificSecret string = testDeployment.outputs.exportedSecrets.connectionString.secretResourceId
output allEportedSecrets object = testDeployment.outputs.exportedSecrets
output allExportedSecretResourceIds array = map(
  items(testDeployment.outputs.exportedSecrets),
  item => item.value.secretResourceId
)
