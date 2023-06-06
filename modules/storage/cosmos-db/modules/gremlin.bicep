param cosmosDBAccountName string
param enableServerless bool
param database object

var name = database.key
var config = database.value

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource gremlinDatabase 'gremlinDatabases' = {
    name: name
    properties: {
      resource: {
        id: name
      }
      options: enableServerless ? null : (config.?performance == null ? null : (config.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: config.performance.throughput } } : { throughput: config.performance.throughput }))
    }
    tags: config.?tags ?? {}

    resource gremlinDatabaseGraphs 'graphs' = [for graph in items(config.?graphs ?? {}): {
      name: graph.key
      properties: {
        resource: {
          id: graph.key
          // analyticalStorageTtl is an invalid propery in current api https://github.com/Azure/azure-rest-api-specs/issues/19695
          defaultTtl: graph.value.?defaultTtl
          indexingPolicy: graph.value.?indexingPolicy
          partitionKey: graph.value.?partitionKey
          uniqueKeyPolicy: graph.value.?uniqueKeyPolicy
        }
        options: enableServerless ? null : (graph.value.?performance == null ? null : (graph.value.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: graph.value.performance.throughput } } : { throughput: graph.value.performance.throughput }))
      }
      tags: graph.value.?tags ?? {}
    }]
  }
}