targetScope = 'resourceGroup'

// ========== //
// Parameters //
// ========== //

param location string = 'East US'
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
  params: {
    name: 'test01-${uniqueName}'
    location: location
  }
}

// Test 02 - Cassandra with Multiple locations - RoleAssignments and Zone redundancy.
module test02 '../main.bicep' = {
  name: 'test02-${uniqueName}'
  params: {
    name: 'test02-${uniqueName}'
    backendApi: 'cassandra'
    location: location
    isZoneRedundant: false
    additionalLocations: [
      {
        name: 'Norway West'
        isZoneRedundant: false
      }
      {
        name: 'North Europe'
      }
    ]
    roleAssignments: [
      {
        roleDefinitionId: 'db7b14f2-5adf-42da-9f96-f2ee17bab5cb'
        principalId: dependencies.outputs.identityPrincipalIds[0]
      }
      {
        roleDefinitionId: '5bd9cd88-fe45-4216-938b-f97437e15450'
        principalId: dependencies.outputs.identityPrincipalIds[1]
      }
    ]
    cassandraKeyspaces: [
      {
        name: 'keyspace1'
        performance: {
          enableAutoScale: true
          throughput: 4000
        }
        tables: [
          {
            name: 'table1'
            defaultTtl: 86400
            schema: {
              columns: [ {
                  name: 'test1'
                  type: 'int'
                } ]
              partitionKeys: [ {
                  name: 'test1'
                } ]
            }
          }
          {
            name: 'table2'
            schema: {
              columns: [ {
                  name: 'test2'
                  type: 'int'
                } ]
              partitionKeys: [ {
                  name: 'test2'
                } ]
            }
          }
        ]
      }
    ]
  }
}

// // Test 03 - SQL DB with containers - totalThroughputLimit & BoundedStaleness as defaultConsistencyLevel.
module test03 '../main.bicep' = {
  name: 'test03-${uniqueName}'
  params: {
    name: 'test03-${uniqueName}'
    location: location
    consistencyPolicy: {
      defaultConsistencyLevel: 'BoundedStaleness'
      maxIntervalInSeconds: 10000
      maxStalenessPrefix: 100000
    }
    additionalLocations: [
      {
        name: 'Canada Central'
        isZoneRedundant: false
      }
      {
        name: 'Brazil South'
        isZoneRedundant: true
      }
    ]
    totalThroughputLimit: 100000
    enableMultipleWriteLocations: true
    sqlDatabases: [
      {
        name: 'testdb1'
        containers: [
          {
            name: 'container1'
            performance: {
              enableAutoScale: true
              throughput: 4000
            }
            defaultTtl: 3600
            partitionKey: {
              paths: [ '/definition/id' ]
              kind: 'Hash'
            }
            indexingPolicy: {
              indexingMode: 'consistent'
              automatic: true
              includedPaths: [ { path: '/*' } ]
              excludedPaths: [ { path: '/"_etag"/?' } ]
            }
          }
          {
            name: 'container2'
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
            triggers: [
              {
                name: 'trigger1'
                triggerType: 'Pre'
                triggerOperation: 'All'
                body: 'function() { var context = getContext(); var response = context.getResponse(); response.setBody("Pre-trigger body."); }'
              }
            ]
            storedProcedures: [
              {
                name: 'storedProcedure1'
                body: 'function() { var context = getContext(); var response = context.getResponse(); response.setBody("Stored procedure body."); }'
              }
            ]
            userDefinedFunctions: [
              {
                name: 'userDefinedFunction1'
                body: 'function() { var context = getContext(); var response = context.getResponse(); response.setBody("User defined function body."); }'
              }
            ]
          }
        ]
      }
    ]
  }
}

// // Test 04 - MongodbDatabases with collections - CORS policies, SystemAssigned Managed Identity & extra Capabilities.
module test04 '../main.bicep' = {
  name: 'test04-${uniqueName}'
  params: {
    name: 'test04-${uniqueName}'
    location: location
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
    mongodbDatabases: [
      {
        name: 'testdb1'
        performance: {
          enableAutoScale: true
          throughput: 4000
        }
        collections: [
          {
            name: 'collection1'
            performance: {
              enableAutoScale: false
              throughput: 400
            }
            indexes: [
              {
                key: { keys: [ '_id' ] }
                options: {
                  unique: true
                }
              }
              {
                key: { keys: [ '$**' ] }
                options: {}
              }
            ]
            shardKey: {
              user_id: 'Hash'
            }
          }
        ]
      }
    ]
  }
}

// // Test 05 - Cosmos DB Table - Serverless & Network Rules
module test05 '../main.bicep' = {
  name: 'test05-${uniqueName}'
  params: {
    name: 'test05-${uniqueName}'
    location: location
    additionalLocations: [
      {
        name: 'canadacentral'
        isZoneRedundant: true
      }
      {
        name: 'South Central US'
      }
      {
        name: 'West US 3'
      }
    ]
    backendApi: 'table'
    enableServerless: true
    enableAnalyticalStorage: true
    tables: [
      {
        name: 'table1'
      }
      {
        name: 'table2'
      }
    ]
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

// // Test 06 - Gremlin Database with Graphs - Private endpoints
module test06 '../main.bicep' = {
  name: 'test06-${uniqueName}'
  params: {
    name: 'test06-${uniqueName}'
    location: location
    backendApi: 'gremlin'
    gremlinDatabases: [
      {
        name: 'testdb01'
        performance: {
          enableAutoScale: false
          throughput: 500
        }
        graphs: [
          {
            name: 'graph1'
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
        ]
      }
    ]
    enablePublicNetworkAccess: false
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: dependencies.outputs.subnetIds[0]
        isManualApproval: true
        groupId: 'Sql'
      }
      {
        name: 'endpoint2'
        subnetId: dependencies.outputs.subnetIds[1]
        privateDnsZoneId: dependencies.outputs.privateDNSZoneId
        groupId: 'Gremlin'
      }
    ]
  }
}

// // Test 07 - SQL DB with sql role definitions
module test07 '../main.bicep' = {
  name: 'test07-${uniqueName}'
  params: {
    name: 'test07-${uniqueName}'
    location: location
    backendApi: 'sql'
    sqlDatabases: [
      {
        name: 'testdb1'
        containers: [
          {
            name: 'container1'
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
        ]
      }
    ]
    sqlCustomRoleDefinitions: [
      {
        name: 'testReadWriteRole1'
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
          }
          {
            principalId: dependencies.outputs.identityPrincipalIds[1]
            scope: '/dbs/testdb1'
          }
        ]
      }
    ]
    sqlBuiltinRoleAssignments: [
      {
        builtinRoleId: '00000000-0000-0000-0000-000000000001'
        principalId: dependencies.outputs.identityPrincipalIds[0]
        scope: '/dbs/testdb1'
      }
    ]

  }
}

output sqlIds array = test07.outputs.sqlRoleDefinitionIds