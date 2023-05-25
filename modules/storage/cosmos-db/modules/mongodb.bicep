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
      options: enableServerless ? {} : (config.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: config.performance.throughput } } : { throughput: config.performance.throughput })
    }

    resource mongodbDatabaseCollections 'collections' = [for collection in items(config.?collections ?? {}): {
      name: collection.key
      properties: {
        resource: {
          id: collection.key
          indexes: collection.value.?indexes
          shardKey: collection.value.?shardKey
        }
        options: enableServerless ? {} : (collection.value.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: collection.value.performance.throughput } } : { throughput: collection.value.performance.throughput })
      }
    }]
  }
}
