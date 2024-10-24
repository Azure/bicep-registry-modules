targetScope = 'subscription'

metadata name = 'API for Table'
metadata description = 'This instance deploys the module for an Azure Cosmos DB for Table account with two example tables.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddatbl'

@description('Optional. A token to inject into the name of each resource. This value can be automatically injected by the CI.')
param namePrefix string = '#_namePrefix_#'

// The default pipeline is selecting random regions which don't have capacity for Azure Cosmos DB or support all Azure Cosmos DB features when creating new accounts.
#disable-next-line no-hardcoded-location
var enforcedLocation = 'eastus2'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: resourceGroupName
  location: enforcedLocation
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
      location: enforcedLocation
      name: '${namePrefix}${serviceShort}001'
      capabilitiesToAdd: [
        'EnableTable'
      ]
      tables: [
        {
          name: 'tbl-dddatableminprov'
          throughput: 400
        }
        {
          name: 'tbl-dddatableminauto'
          maxThroughput: 1000
        }
      ]
    }
  }
]
