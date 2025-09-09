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
var enforcedLocation = 'westus3'

// ============ //
// Dependencies //
// ============ //

// General resources
// =================
resource resourceGroup 'Microsoft.Resources/resourceGroups@2025-04-01' = {
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
      zoneRedundant: false
    }
  }
]

@secure()
output primaryReadOnlyKey string = testDeployment[0].outputs.primaryReadOnlyKey

@secure()
output primaryReadWriteKey string = testDeployment[0].outputs.primaryReadWriteKey

@secure()
output primaryReadOnlyConnectionString string = testDeployment[0].outputs.primaryReadOnlyConnectionString

@secure()
output primaryReadWriteConnectionString string = testDeployment[0].outputs.primaryReadWriteConnectionString

@secure()
output secondaryReadOnlyKey string = testDeployment[1].outputs.secondaryReadOnlyKey

@secure()
output secondaryReadWriteKey string = testDeployment[1].outputs.secondaryReadWriteKey

@secure()
output secondaryReadOnlyConnectionString string = testDeployment[1].outputs.secondaryReadOnlyConnectionString

@secure()
output secondaryReadWriteConnectionString string = testDeployment[1].outputs.secondaryReadWriteConnectionString
