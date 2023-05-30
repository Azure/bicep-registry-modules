targetScope = 'resourceGroup'

// ========== //
// Parameters //
// ========== //

param location string = resourceGroup().location
param serviceShort string = 'cosmosdb'
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)

// ============ //
// Dependencies //
// ============ //

module dependencies 'prereq.test.bicep' = {
  name: 'test-dependencies'
  params: {
    name: serviceShort
    location: location
    prefix: uniqueName
  }
}

// ===== //
// Tests //
// ===== //

// Test 01 -  Basic Deployment - Minimal Parameters
module test01 '../main.bicep' = {
  name: 'test01-${uniqueName}'
  params: {}
}

// Test 02 - Cassandra with Multiple locations - RoleAssignments and Zone redundancy.
module test02 '../main.bicep' = {
  name: 'test02-${uniqueName}'
  params: {
    name: 'test02-${uniqueName}'
    backendApi: 'cassandra'
    locations: [
      {
        name: 'westus2'
        isZoneRedundant: true
      }
      {
        name: 'eastus2'
        isZoneRedundant: true
      }
    ]
    sqlRoleDefinitions: {
      CosmosBackupOperator: {
        roleType: 'BuiltInRole'
        assisgnments: [ {
            principalId: dependencies.outputs.identityPrincipalIds[0]
          } ]
      }
      // DocumentDB Account Contributor
      '5bd9cd88-fe45-4216-938b-f97437e15450': {
        roleType: 'BuiltInRole'
        assisgnments: [ {
            principalId: dependencies.outputs.identityPrincipalIds[1]
          } ]
      }
    }
    cassandraKeyspaces: {
      keyspace1: {
        performance: {
          enableAutoScale: true
          throughput: 4000
        }
        tables: {
          table1: {
            defaultTtl: 86400
            analyticalStorageTtl: 86400
            schema: [ {
                name: 'id'
                type: 'text'
              } ]
            partitionKeys: [ {
                name: 'id'
              } ]
            clusteringKeys: [ {
                name: 'data'
                orderBy: 'Desc'
              } ]
          }
          table2: {}
        }
      }
    }
  }
}

// Test 03 - SQL DB with containers - totalThroughputLimit & BoundedStaleness as defaultConsistencyLevel.
module test03 '../main.bicep' = {
  name: 'test03-${uniqueName}'
  params: {
    name: 'test03-${uniqueName}'
    consistencyPolicy: {
      defaultConsistencyLevel: 'BoundedStaleness'
      maxIntervalInSeconds: 10000
      maxStalenessPrefix: 100000
    }
    locations: [
      {
        name: 'canadacentral'
        isZoneRedundant: true
      }
      {
        name: 'centralus'
        isZoneRedundant: true
      }
      {
        name: 'eastus'
      }
    ]
    totalThroughputLimit: 10000
    enableMultipleWriteLocations: false
    sqlDatabases: {
      testdb1: {
        containers: {
          container1: {
            performance: {
              enableAutoScale: true
              throughput: 4000
            }
            defaultTtl: 3600
            partitionKey: {
              paths: [ '/id' ]
              kind: 'Hash'
              version: 1
            }
          }
          container2: {
            performance: {
              enableAutoScale: false
              throughput: 4000
            }
            defaultTtl: 86400
            partitionKey: {
              paths: [
                '/id'
              ]
              kind: 'Hash'
              version: 1
            }
            indexingPolicy: {
              indexingMode: 'consistent'
              automatic: true
              includedPaths: [ { path: '/*' } ]
              excludedPaths: [ { path: '/"_etag"/?' } ]
            }
            conflictResolutionPolicy: {
              mode: 'LastWriterWins'
              conflictResolutionPath: '/_ts'
            }
            triggers: {
              trigger1: {
                triggerType: 'Pre'
                triggerOperation: [ 'Create', 'Delete', 'Replace', 'Update' ]
                body: 'function() { var context = getContext(); var response = context.getResponse(); response.setBody("Pre-trigger body."); }'
              }
            }
            storedProcedures: {
              storedProcedure1: {
                body: 'function() { var context = getContext(); var response = context.getResponse(); response.setBody("Stored procedure body."); }'
              }
            }
            userDefinedFunctions: {
              userDefinedFunction1: {
                body: 'function() { var context = getContext(); var response = context.getResponse(); response.setBody("User defined function body."); }'
              }
            }
          }
        }
      }
    }
  }
}

// Test 04 - MongodbDatabases with collections - CORS policies, SystemAssigned Managed Identity & extra Capabilities.
module test04 '../main.bicep' = {
  name: 'test04-${uniqueName}'
  params: {
    name: 'test04-${uniqueName}'
    locations: [ { name: location } ]
    backendApi: 'mongodb'
    extraCapabilities: [
      'EnableMongoRetryableWrites'
      'EnableAggregationPipeline'
    ]
    identityType: 'SystemAssigned'
    cors: [
      {
        allowedOrigins: 'https://www.bing.com'
        allowedMethods: 'POST,GET'
        maxAgeInSeconds: 60
      }
    ]
    mongodbDatabases: {
      testdb1: {
        performance: {
          enableAutoScale: true
          throughput: 4000
        }
        collections: {
          collection1: {
            performance: {
              enableAutoScale: false
              throughput: 400
            }
            indexes: [
              {
                key: { keys: [ '_id' ] }
                options: {}
              }
              {
                key: { keys: [ '$**' ] }
                options: {
                  unique: true
                }
              }
            ]
            shardKey: {
              user_id: 'Hash'
            }
          }
        }
      }
    }
  }
}

// Test 05 - Cosmos DB Table - Serverless & Network Rules
module test05 '../main.bicep' = {
  name: 'test05-${uniqueName}'
  params: {
    name: 'test05-${uniqueName}'
    locations: [
      {
        name: 'canadacentral'
        isZoneRedundant: true
      }
      {
        name: 'centralus'
        isZoneRedundant: true
      }
      {
        name: 'eastus'
        isZoneRedundant: true
      }
    ]
    backendApi: 'table'
    enableServerless: true
    enableAnalyticalStorage: true
    tables: {
      table1: {}
      table2: {}
    }
    ipRules: [
      '1.2.3.4'
      '1.2.3.4/24'
    ]
    virtualNetworkRules: [
      {
        id: dependencies.outputs.subnetIds[0]
        ignoreMissingVNetServiceEndpoint: true
      }
    ]
  }
}

// Test 06 - Gremlin Database with Graphs - Private endpoints
module test06 '../main.bicep' = {
  name: 'test06-${uniqueName}'
  params: {
    name: 'test06-${uniqueName}'
    locations: [ { name: location } ]
    backendApi: 'gremlin'
    gremlinDatabases: {
      testdb01: {
        performance: {
          enableAutoScale: false
          throughput: 500
        }
        graphs: {
          graph1: {
            performance: {
              enableAutoScale: true
              throughput: 4000
            }
            defaultTtl: 3600
            partitionKey: {
              paths: [ '/address' ]
              kind: 'Hash'
              version: 1
            }
          }
        }
      }
    }
    enablePublicNetworkAccess: false
    privateEndpoints: {
      endpoint1: {
        subnetId: dependencies.outputs.subnetIds[0]
        isManualApproval: true
        groupId: 'Sql'
      }
      endpoint2: {
        subnetId: dependencies.outputs.subnetIds[1]
        privateDnsZoneId: dependencies.outputs.privateDNSZoneId
        groupId: 'Gremlin'
      }
    }
  }
}

// Test 07 - SQL DB with sql role definitions
module test07 '../main.bicep' = {
  name: 'test07-${uniqueName}'
  params: {
    name: 'test07-${uniqueName}'
    locations: [ { name: location } ]
    backendApi: 'sql'
    sqlDatabases: {
      testdb1: {
        containers: {
          container1: {
            performance: {
              enableAutoScale: true
              throughput: 4000
            }
            defaultTtl: 3600
            partitionKey: {
              paths: [ '/id' ]
              kind: 'Hash'
              version: 1
            }
          }
        }
      }
    }
    sqlRoleDefinitions: {
      testReadWriteRole1: {
        roleType: 'CustomRole'
        permissions: [
          {
            dataActions: [
              'Microsoft.DocumentDB/databaseAccounts/readMetadata'
              'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
              'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
            ]
          }
        ]
        assisgnments: [
          {
            principalId: dependencies.outputs.identityPrincipalIds[0]
            scope: '/'
          }
          {
            principalId: dependencies.outputs.identityPrincipalIds[1]
            scope: '/dbs/testdb1'
          }
        ]
      }
    }
  }
}

output sqlIds array = test07.outputs.sqlRoleDefinitionIds