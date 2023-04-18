param cosmosDBAccountName string
param enableServerless bool = false
param mongodbDatabaseName string
param mongodbDatabaseCollections array
param autoscaleMaxThroughput int
param manualProvisionedThroughput int

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDBAccountName
}

resource cosmosDBAccount_mongodbDatabase 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2022-11-15' = {
  name: mongodbDatabaseName
  parent: cosmosDBAccount
  properties: {
    resource: {
      id: mongodbDatabaseName
    }
    options: enableServerless ? {} : (autoscaleMaxThroughput != 0 ? {
      autoscaleSettings: {
        maxThroughput: autoscaleMaxThroughput
      }
    } : (manualProvisionedThroughput != 0 ? {
      throughput: manualProvisionedThroughput
    } : {}))
  }

  resource cosmosDBAccount_mongodbDatabaseCollections 'collections' = [for collection in mongodbDatabaseCollections: {
    name: collection.name
    properties: {
      resource: {
        id: collection.name
        indexes: contains(collection, 'indexes') ? collection.indexes : []
        shardKey: contains(collection, 'shardKey') ? collection.shardKey : {}
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
