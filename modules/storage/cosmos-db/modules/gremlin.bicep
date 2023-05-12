param autoscaleMaxThroughput int
param cosmosDBAccountName string
param enableServerless bool
param databaseGraphs array
param databaseName string
param manualProvisionedThroughput int

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDBAccountName

  resource gremlinDatabase 'gremlinDatabases@2022-11-15' = {
    name: databaseName
    properties: {
      resource: {
        id: databaseName
      }
      options: enableServerless ? {} : (autoscaleMaxThroughput != 0 ? {
        autoscaleSettings: {
          maxThroughput: autoscaleMaxThroughput
        }
      } : (manualProvisionedThroughput != 0 ? {
        throughput: manualProvisionedThroughput
      } : {}))
    }

    resource gremlinDatabaseGraphs 'graphs' = [for graph in databaseGraphs: {
      name: graph.name
      properties: {
        resource: {
          id: graph.name
          // https://github.com/Azure/azure-rest-api-specs/issues/19695
          // analyticalStorageTtl: contains(graph, 'analyticalStorageTtl') ? graph.analyticalStorageTtl : -1
          conflictResolutionPolicy: graph.?conflictResolutionPolicy ?? {}
          defaultTtl: graph.?defaultTtl ?? -1
          indexingPolicy: graph.?indexingPolicy ?? {}
          partitionKey: graph.?partitionKey ?? {}
          uniqueKeyPolicy: graph.?uniqueKeyPolicy ?? {}
        }
        options: enableServerless ? {} : (contains(graph, 'autoscaleMaxThroughput') ? {
          autoscaleSettings: {
            maxThroughput: graph.autoscaleMaxThroughput
          }
        } : (contains(graph, 'manualProvisionedThroughput') ? {
          throughput: graph.manualProvisionedThroughput
        } : {}))
      }
    }]
  }
}
