targetScope = 'subscription'

metadata name = 'Deploying with a key vault reference to save secrets'
metadata description = 'This instance deploys the module saving all its secrets in a key vault.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-cache.redis-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'crkvs'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

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
    name: '${namePrefix}kvref'
    secretsExportConfiguration: {
      keyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
      primaryAccessKeyName: 'custom-primaryAccessKey-name'
      primaryConnectionStringName: 'custom-primaryConnectionString-name'
      primaryStackExchangeRedisConnectionStringName: 'custom-primaryStackExchangeRedisConnectionString-name'
      secondaryAccessKeyName: 'custom-secondaryAccessKey-name'
      secondaryConnectionStringName: 'custom-secondaryConnectionString-name'
      secondaryStackExchangeRedisConnectionStringName: 'custom-secondaryStackExchangeRedisConnectionString-name'
    }
  }
}
