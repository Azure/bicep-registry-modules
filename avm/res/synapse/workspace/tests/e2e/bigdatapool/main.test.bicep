targetScope = 'subscription'

metadata name = 'Using Big Data Pool'
metadata description = 'This instance deploys the module with the configuration of Big Data Pool.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-synapse.workspaces-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'swbdp'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

#disable-next-line no-hardcoded-location
var enforcedLocation = 'northeurope'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
  name: resourceGroupName
  location: enforcedLocation
}

module nestedDependencies 'dependencies.bicep' = {
  scope: resourceGroup
  name: '${uniqueString(deployment().name, enforcedLocation)}-nestedDependencies'
  params: {
    location: enforcedLocation
    storageAccountName: 'dep${namePrefix}sa${serviceShort}01'
  }
}

// ============== //
// Test Execution //
// ============== //

@batchSize(1)
module testDeployment '../../../main.bicep' = [
  for iteration in ['init', 'idem']: {
    scope: resourceGroup
    name: '${uniqueString(deployment().name, enforcedLocation)}-test-${serviceShort}-${iteration}'
    params: {
      name: '${namePrefix}${serviceShort}001'
      defaultDataLakeStorageAccountResourceId: nestedDependencies.outputs.storageAccountResourceId
      defaultDataLakeStorageFilesystem: nestedDependencies.outputs.storageContainerName
      sqlAdministratorLogin: 'synwsadmin'
      bigDataPools: [
        {
          name: 'dep${namePrefix}bdp01'
          nodeSizeFamily: 'MemoryOptimized'
          nodeSize: 'Small'
          autoScale: {
            minNodeCount: 3
            maxNodeCount: 5
          }
          dynamicExecutorAllocation: {
            minExecutors: 1
            maxExecutors: 4
          }
          autoPauseDelayInMinutes: 10
          sessionLevelPackagesEnabled: true
          cacheSize: 50
          autotuneEnabled: true
        }
        {
          name: 'dep${namePrefix}bdp02'
          nodeSizeFamily: 'MemoryOptimized'
          nodeSize: 'Small'
        }
      ]
    }
  }
]
