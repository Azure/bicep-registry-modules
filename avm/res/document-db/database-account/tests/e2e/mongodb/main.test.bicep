targetScope = 'subscription'

metadata name = 'Mongo Database'
metadata description = 'This instance deploys the module with a Mongo Database.'

// ========== //
// Parameters //
// ========== //

@description('Optional. The name of the resource group to deploy for testing purposes.')
@maxLength(90)
param resourceGroupName string = 'dep-${namePrefix}-documentdb.databaseaccounts-${serviceShort}-rg'

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints.')
param serviceShort string = 'dddamng'

@description('Optional. A token to inject into the name of each resource.')
param namePrefix string = '#_namePrefix_#'

// The default pipeline is selecting random regions which don't have capacity for Azure Cosmos DB or support all Azure Cosmos DB features when creating new accounts.
#disable-next-line no-hardcoded-location
var enforcedLocation = 'spaincentral'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2022-09-01' = {
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
      name: '${namePrefix}${serviceShort}001'
      location: enforcedLocation
      mongodbDatabases: [
        {
          collections: [
            {
              indexes: [
                {
                  key: {
                    keys: [
                      '_id'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      '$**'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      'car_id'
                      'car_model'
                    ]
                  }
                  options: {
                    unique: true
                  }
                }
                {
                  key: {
                    keys: [
                      '_ts'
                    ]
                  }
                  options: {
                    expireAfterSeconds: 2629746
                  }
                }
              ]
              name: 'car_collection'
              shardKey: {
                car_id: 'Hash'
              }
              throughput: 600
            }
            {
              indexes: [
                {
                  key: {
                    keys: [
                      '_id'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      '$**'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      'truck_id'
                      'truck_model'
                    ]
                  }
                  options: {
                    unique: true
                  }
                }
                {
                  key: {
                    keys: [
                      '_ts'
                    ]
                  }
                  options: {
                    expireAfterSeconds: 2629746
                  }
                }
              ]
              name: 'truck_collection'
              shardKey: {
                truck_id: 'Hash'
              }
            }
          ]
          name: '${namePrefix}-mdb-${serviceShort}-001'
          throughput: 800
        }
        {
          collections: [
            {
              indexes: [
                {
                  key: {
                    keys: [
                      '_id'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      '$**'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      'bike_id'
                      'bike_model'
                    ]
                  }
                  options: {
                    unique: true
                  }
                }
                {
                  key: {
                    keys: [
                      '_ts'
                    ]
                  }
                  options: {
                    expireAfterSeconds: 2629746
                  }
                }
              ]
              name: 'bike_collection'
              shardKey: {
                bike_id: 'Hash'
              }
            }
            {
              indexes: [
                {
                  key: {
                    keys: [
                      '_id'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      '$**'
                    ]
                  }
                }
                {
                  key: {
                    keys: [
                      'bicycle_id'
                      'bicycle_model'
                    ]
                  }
                  options: {
                    unique: true
                  }
                }
                {
                  key: {
                    keys: [
                      '_ts'
                    ]
                  }
                  options: {
                    expireAfterSeconds: 2629746
                  }
                }
              ]
              name: 'bicycle_collection'
              shardKey: {
                bicycle_id: 'Hash'
              }
            }
          ]
          name: '${namePrefix}-mdb-${serviceShort}-002'
        }
      ]
    }
  }
]
