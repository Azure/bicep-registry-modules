param autoscaleMaxThroughput int
param cosmosDBAccountName string
param enableServerless bool
param gremlinDatabaseGraphs array
param gremlinDatabaseName string
param manualProvisionedThroughput int

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDBAccountName
}

resource cosmosDBAccount_gremlinDatabase 'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases@2022-11-15' = {
  name: gremlinDatabaseName
  parent: cosmosDBAccount
  properties: {
    resource: {
      id: gremlinDatabaseName
    }
    options: enableServerless ? {} : (autoscaleMaxThroughput != 0 ? {
      autoscaleSettings: {
        maxThroughput: autoscaleMaxThroughput
      }
    } : (manualProvisionedThroughput != 0 ? {
      throughput: manualProvisionedThroughput
    } : {}))
  }

  resource cosmosDBAccount_gremlinDatabaseGraphs 'graphs' = [for graph in gremlinDatabaseGraphs: {
    name: graph.name
    properties: {
      resource: {
        id: graph.name
        // https://github.com/Azure/azure-rest-api-specs/issues/19695
        // analyticalStorageTtl: contains(graph, 'analyticalStorageTtl') ? graph.analyticalStorageTtl : -1
        conflictResolutionPolicy: contains(graph, 'conflictResolutionPolicy') ? graph.conflictResolutionPolicy : {}
        defaultTtl: contains(graph, 'defaultTtl') ? graph.defaultTtl : -1
        indexingPolicy: contains(graph, 'indexingPolicy') ? graph.indexingPolicy : {}
        partitionKey: contains(graph, 'partitionKey') ? graph.partitionKey : {}
        uniqueKeyPolicy: contains(graph, 'uniqueKeyPolicy') ? graph.uniqueKeyPolicy : {}
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
