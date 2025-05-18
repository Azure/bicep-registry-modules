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
      mongodbDatabases: [
        {
          name: '${namePrefix}-mdb-${serviceShort}-001'
          manualThroughput: 600
          collections: [
            {
              name: 'car_collection'
              shardKeys: [
                {
                  field: 'car_id'
                  type: 'Hash'
                }
              ]
              manualThroughput: 400
              indexes: [
                {
                  keys: [
                    '_id'
                  ]
                }
                {
                  keys: [
                    '$**'
                  ]
                }
                {
                  keys: [
                    'car_id'
                    'car_model'
                  ]
                  unique: true
                }
                {
                  keys: [
                    '_ts'
                  ]
                  ttl: 2629746
                }
              ]
            }
            {
              name: 'truck_collection'
              shardKeys: [
                {
                  field: 'truck_id'
                  type: 'Hash'
                }
              ]
              indexes: [
                {
                  keys: [
                    '_id'
                  ]
                }
                {
                  keys: [
                    '$**'
                  ]
                }
                {
                  keys: [
                    'truck_id'
                    'truck_model'
                  ]
                  unique: true
                }
                {
                  keys: [
                    '_ts'
                  ]
                  ttl: 2629746
                }
              ]
            }
          ]
        }
        {
          name: '${namePrefix}-mdb-${serviceShort}-002'
          collections: [
            {
              name: 'bike_collection'
              manualThroughput: 400
              shardKeys: [
                {
                  field: 'bike_id'
                  type: 'Hash'
                }
              ]
              indexes: [
                {
                  keys: [
                    '_id'
                  ]
                }
                {
                  keys: [
                    '$**'
                  ]
                }
                {
                  keys: [
                    'bike_id'
                    'bike_model'
                  ]
                  unique: true
                }
                {
                  keys: [
                    '_ts'
                  ]
                  ttl: 2629746
                }
              ]
            }
            {
              name: 'bicycle_collection'
              autoscaleMaxThroughput: 1000
              shardKeys: [
                {
                  field: 'bicycle_id'
                  type: 'Hash'
                }
              ]
              indexes: [
                {
                  keys: [
                    '_id'
                  ]
                }
                {
                  keys: [
                    '$**'
                  ]
                }
                {
                  keys: [
                    'bicycle_id'
                    'bicycle_model'
                  ]
                  unique: true
                }
                {
                  keys: [
                    '_ts'
                  ]
                  ttl: 2629746
                }
              ]
            }
          ]
        }
        {
          name: '${namePrefix}-mdb-${serviceShort}-003'
          autoscaleMaxThroughput: 1000
          collections: [
            {
              name: 'wheel_collection'
              autoscaleMaxThroughput: 1000
              shardKeys: [
                {
                  field: 'wheel_id'
                  type: 'Hash'
                }
              ]
              indexes: [
                {
                  keys: [
                    '_id'
                  ]
                }
                {
                  keys: [
                    '$**'
                  ]
                }
                {
                  keys: [
                    'wheel_id'
                    'wheel_model'
                  ]
                  unique: true
                }
                {
                  keys: [
                    '_ts'
                  ]
                  ttl: 2629746
                }
              ]
            }
          ]
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
