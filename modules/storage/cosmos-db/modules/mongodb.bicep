param cosmosDBAccountName string
param enableServerless bool = false
param databaseName string
param databaseCollections array
param autoscaleMaxThroughput int
param manualProvisionedThroughput int

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDBAccountName

  resource mongodbDatabase 'mongodbDatabases@2022-11-15' = {
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

    resource mongodbDatabaseCollections 'collections' = [for collection in databaseCollections: {
      name: collection.name
      properties: {
        resource: {
          id: collection.name
          indexes: collection.?indexes ?? []
          shardKey: collection.?shardKey ?? {}
        }
        options: enableServerless ? {} : (contains(collection, 'autoscaleMaxThroughput') ? {
          autoscaleSettings: {
            maxThroughput: collection.autoscaleMaxThroughput
          }
        } : (contains(collection, 'manualProvisionedThroughput') ? {
          throughput: collection.manualProvisionedThroughput
        } : {}))
      }
    }]
  }
}
