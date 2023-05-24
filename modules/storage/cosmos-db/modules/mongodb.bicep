param cosmosDBAccountName string
param enableServerless bool = false
param database object

var databaseName = database.key
var databaseConfig = database.value

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource mongodbDatabase 'mongodbDatabases' = {
    name: databaseName
    properties: {
      resource: {
        id: databaseName
      }
      options: enableServerless ? {} : (databaseConfig.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: databaseConfig.performance.throughput } } : { throughput: databaseConfig.performance.throughput })
    }

    resource mongodbDatabaseCollections 'collections' = [for collection in items(databaseConfig.?collections ?? {}): {
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
