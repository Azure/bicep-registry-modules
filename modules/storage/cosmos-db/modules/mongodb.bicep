param cosmosDBAccountName string
param enableServerless bool = false
param database object

var name = database.key
var config = database.value

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource mongodbDatabase 'mongodbDatabases' = {
    name: name
    properties: {
      resource: {
        id: name
      }
      options: enableServerless ? null : (config.?performance == null ? null : (config.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: config.performance.throughput } } : { throughput: config.performance.throughput }))
    }
    tags: toObject(config.?tags ?? [], tag => tag.key, tag => tag.value)

    resource mongodbDatabaseCollections 'collections' = [for collection in items(config.?collections ?? {}): {
      name: collection.key
      properties: {
        resource: {
          id: collection.key
          indexes: collection.value.?indexes
          shardKey: collection.value.?shardKey
        }
        options: enableServerless ? null : (collection.value.?performance == null ? null : (collection.value.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: collection.value.performance.throughput } } : { throughput: collection.value.performance.throughput }))
      }
      tags: toObject(collection.value.?tags ?? [], tag => tag.key, tag => tag.value)
    }]
  }
}