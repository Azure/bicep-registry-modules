targetScope = 'subscription'

metadata name = 'Creating Azure ML managed feature store'
metadata description = 'This instance deploys an Azure ML managed feature store.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-machinelearningservices.workspaces-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mlswfs'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, resourceLocation)}-nestedDependencies'
  params: {
    keyVaultName: 'dep-${namePrefix}-kv-${serviceShort}-${substring(uniqueString(baseTime), 0, 3)}'
    applicationInsightsName: 'dep-${namePrefix}-appI-${serviceShort}'
    storageAccountName: 'dep${namePrefix}st${serviceShort}'
    location: resourceLocation
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
      location: resourceLocation
      associatedApplicationInsightsResourceId: nestedDependencies.outputs.applicationInsightsResourceId
      associatedKeyVaultResourceId: nestedDependencies.outputs.keyVaultResourceId
      associatedStorageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
      sku: 'Basic'
      kind: 'FeatureStore'
      featureStoreSettings: {
        computeRuntime: {
          sparkRuntimeVersion: '3.3'
        }
      }
    }
  }
]
