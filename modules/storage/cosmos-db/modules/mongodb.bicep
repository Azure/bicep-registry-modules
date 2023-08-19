param cosmosDBAccountName string
param enableServerless bool = false
param database object

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource mongodbDatabase 'mongodbDatabases' = {
    name: database.name
    properties: {
      resource: {
        id: database.name
      }
      options: (enableServerless || database.?performance == null) ? null : (database.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: database.performance.throughput } } : { throughput: database.performance.throughput })
    }
    tags: database.?tags ?? {}

    resource mongodbDatabaseCollections 'collections' = [for collection in database.?collections ?? []: {
      name: collection.name
      properties: {
        resource: {
          id: collection.name
          indexes: collection.?indexes
          shardKey: collection.?shardKey
        }
        options: (enableServerless || collection.?performance == null) ? null : (collection.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: collection.performance.throughput } } : { throughput: collection.performance.throughput })
      }
      tags: collection.?tags ?? {}
    }]
  }
}