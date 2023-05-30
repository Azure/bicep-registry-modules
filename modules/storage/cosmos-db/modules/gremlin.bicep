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
      options: enableServerless ? null : (config.performance == null ? null : (config.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: config.performance.throughput } } : { throughput: config.performance.throughput }))
    }
    tags: toObject(config.tags ?? [], tag => tag.key, tag => tag.value)

    resource gremlinDatabaseGraphs 'graphs' = [for graph in config.?graphs ?? {}: {
      name: graph.key
      properties: {
        resource: {
          id: graph.key
          //TODO: check if https://github.com/Azure/azure-rest-api-specs/issues/19695 is till an issue
          analyticalStorageTtl: graph.value.?analyticalStorageTtl
          conflictResolutionPolicy: graph.value.?conflictResolutionPolicy
          defaultTtl: graph.value.?defaultTtl
          indexingPolicy: graph.value.?indexingPolicy
          partitionKey: graph.value.?partitionKey
          uniqueKeyPolicy: graph.value.?uniqueKeyPolicy
        }
        options: enableServerless ? null : (graph.value.performance == null ? null : (graph.value.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: graph.value.performance.throughput } } : { throughput: graph.value.performance.throughput }))
      }
      tags: toObject(graph.value.tags ?? [], tag => tag.key, tag => tag.value)
    }]
  }
}