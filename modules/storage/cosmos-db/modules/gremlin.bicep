param cosmosDBAccountName string
param enableServerless bool
param database object

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource gremlinDatabase 'gremlinDatabases' = {
    name: database.name
    properties: {
      resource: {
        id: database.name
      }
      options: (enableServerless || database.?performance == null) ? null : (database.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: database.performance.throughput } } : { throughput: database.performance.throughput })
    }
    tags: database.?tags ?? {}

    resource gremlinDatabaseGraphs 'graphs' = [for graph in database.?graphs ?? []: {
      name: graph.name
      properties: {
        resource: {
          id: graph.name
          // analyticalStorageTtl is an invalid propery in current api https://github.com/Azure/azure-rest-api-specs/issues/19695
          defaultTtl: graph.?defaultTtl
          indexingPolicy: graph.?indexingPolicy
          partitionKey: graph.?partitionKey
          uniqueKeyPolicy: graph.?uniqueKeyPolicy
        }
        options: (enableServerless || graph.?performance == null) ? null : (graph.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: graph.performance.throughput } } : { throughput: graph.performance.throughput })
      }
      tags: graph.?tags ?? {}
    }]
  }
}