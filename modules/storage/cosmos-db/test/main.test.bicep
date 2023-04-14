targetScope = 'resourceGroup'

// ========== //
// Parameters //
// ========== //

param location string = 'eastus'
param serviceShort string = 'cosmosdb'
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)

// ============ //
// Dependencies //
// ============ //

module dependencies 'dependencies.test.bicep' = {
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
    location: location
    name: 'test01-${uniqueName}'
  }
}

// Test 02 - Cassandra with Multiple locations - RoleAssignments and Zone redundancy.
module test02 '../main.bicep' = {
  name: 'test02-${uniqueName}'
  params: {
    location: location
    name: 'test02-${uniqueName}'
    secondaryLocations: [
      {
        locationName: 'westus'
      }
      {
        locationName: 'centralus'
        isZoneRedundant: true
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'CosmosBackupOperator'
        principalIds: [ dependencies.outputs.identityPrincipalIds[0] ]
      }
      {
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '5bd9cd88-fe45-4216-938b-f97437e15450') // DocumentDB Account Contributor
        principalIds: [ dependencies.outputs.identityPrincipalIds[1] ]
      }
    ]
    cassandraKeyspaces: [
      {
        name: 'keyspace1'
        autoscaleMaxThroughput: 1000
        tables: [
          {
            name: 'table1'
            defaultTtl: 86400
            schemaColumns: [
              {
                name: 'id'
                type: 'text'
              }
              {
                name: 'data'
                type: 'blob'
              }
            ]
            schemaPartitionKeys: [
              {
                name: 'id'
              }
            ]
            schemaClusteringKeys: [
              {
                name: 'data'
                orderBy: 'Desc'
              }
            ]
          }
          {
            name: 'table2'
            manualProvisionedThroughput: 400
            schemaColumns: [
              {
                name: 'id'
                type: 'text'
              }
            ]
            schemaPartitionKeys: [
              {
                name: 'id'
              }
            ]
          }
        ]
      }
    ]
  }
}

// Test 03 - SQL DB with containers - totalThroughputLimit & BoundedStaleness as defaultConsistencyLevel.
module test03 '../main.bicep' = {
  name: 'test03-${uniqueName}'
  params: {
    location: location
    backendApi: 'sql'
    name: 'test03-${uniqueName}'
    defaultConsistencyLevel: 'BoundedStaleness'
    maxIntervalInSeconds: 10000
    maxStalenessPrefix: 100000
    totalThroughputLimit: 10000
    sqlDatabases: [
      {
        name: 'testdb1'
        containers: [
          {
            name: 'container1'
            autoscaleMaxThroughput: 4000
            defaultTtl: 3600
            partitionKey: {
              paths: [
                '/id'
              ]
              kind: 'Hash'
              version: 1
            }
          }
          {
            name: 'container2'
            manualProvisionedThroughput: 400
            defaultTtl: 86400
            partitionKey: {
              paths: [
                '/id'
              ]
              kind: 'Hash'
              version: 1
            }
            indexingPolicy: {
              indexingMode: 'Consistent'
              automatic: true
              includedPaths: [
                {
                  path: '/*'
                }
              ]
              excludedPaths: [
                {
                  path: '/"_etag"/?'
                }
              ]
            }
            uniqueKeyPolicy: {
              uniqueKeys: []
            }
            conflictResolutionPolicy: {
              mode: 'LastWriterWins'
              conflictResolutionPath: '/_ts'
            }
            triggers: [
              {
                name: 'trigger1'
                type: 'Pre'
                operation: 'All'
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

// Test 04 - MongodbDatabases with collections - CORS policies, SystemAssigned Managed Identity & extra Capabilities.
module test04 '../main.bicep' = {
  name: 'test04-${uniqueName}'
  params: {
    location: location
    backendApi: 'mongodb'
    name: 'test04-${uniqueName}'
    capabilities: [
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
        autoscaleMaxThroughput: 4000
        collections: [
          {
            name: 'collection1'
            manualProvisionedThroughput: 400
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
            ]
            shardkey: {
              user_id: 'Hash'
            }
          }
        ]
      }
    ]
  }
}

// Test 05 - Cosmos DB Table - Serverless & Network Rules
module test05 '../main.bicep' = {
  name: 'test05-${uniqueName}'
  params: {
    location: location
    backendApi: 'table'
    name: 'test05-2-${uniqueName}'
    enableServerless: true
    defaultConsistencyLevel: 'BoundedStaleness'
    maxIntervalInSeconds: 10000
    maxStalenessPrefix: 100000
    tables: [
      {
        name: 'table1'
      }
      {
        name: 'table2'
      }
    ]

    ipRules: [
      '20.112.52.29'
      '20.53.0.0/31'
    ]
    isVirtualNetworkFilterEnabled: true
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
    location: location
    backendApi: 'gremlin'
    name: 'test06-${uniqueName}'
    gremlinDatabases: [
      {
        name: 'testdb01'
        manualProvisionedThroughput: 500
        graphs: [
          {
            name: 'graph1'
            autoscaleMaxThroughput: 1000
            defaultTtl: 3600
            partitionKey: {
              paths: [
                '/address'
              ]
              kind: 'Hash'
              version: 1
            }
            indexingPolicy: {}
            uniqueKeyPolicy: {}
          }
        ]
      }
    ]
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: dependencies.outputs.subnetIds[0]
        manualApprovalEnabled: true
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
