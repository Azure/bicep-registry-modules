targetScope = 'subscription'

metadata name = 'Deploying with a key vault reference to save secrets'
metadata description = 'This instance deploys the module saving all its secrets in a key vault.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddaskv'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// Pipeline is selecting random regions which dont support all cosmos features and have constraints when creating new cosmos
var enforcedLocation = 'eastus'
var keyVaultName = 'dep-${namePrefix}-kv-${serviceShort}'

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
    keyVaultName: keyVaultName
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
    secretsKeyVaultReference: {
      keyVaultName: keyVaultName
      primaryReadonlyConnectionStringSecretName: 'custom-secret-name'
    }
    locations: [
      {
        failoverPriority: 0
        isZoneRedundant: false
        locationName: enforcedLocation
      }
    ]
  }
}
