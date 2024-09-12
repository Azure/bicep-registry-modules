targetScope = 'subscription'

metadata name = 'Using large parameter set'
metadata description = 'This instance deploys the module using large parameters.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-azd-ml-hub-dependencies-${serviceShort}-rg'

@description('Optional. The location to deploy resources to.')
param resourceLocation string = deployment().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'mhdpmax'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

@description('Generated. Used as a basis for unique resource names.')
param baseTime string = utcNow('u')

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: resourceLocation
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
      cognitiveServicesName: '${namePrefix}cs6${serviceShort}'
      keyVaultName: '${namePrefix}kv6${serviceShort}'
      storageAccountName: '${namePrefix}sa6${serviceShort}'
      applicationInsightsDashboardName: '${namePrefix}aid6${serviceShort}'
      applicationInsightsName: '${namePrefix}ai6${serviceShort}'
      logAnalyticsName: '${namePrefix}log6${serviceShort}'
      containerRegistryName: '${namePrefix}cr6${serviceShort}'
      searchServiceName: '${namePrefix}sea6${serviceShort}'
    }
  }
]
