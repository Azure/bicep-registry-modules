metadata name = 'DocumentDB Database Account MongoDB Databases'
metadata description = 'This module deploys a MongoDB Database within a CosmosDB Account.'

@description('Conditional. The name of the parent Cosmos DB database account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Required. Name of the mongodb database.')
param name string

@description('Optional. Request Units per second. Setting throughput at the database level is only recommended for development/test or when workload across all collections in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the collection level and not at the database level.')
param throughput int = 400

@description('Optional. Collections in the mongodb database.')
param collections collectionType[]?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2025-04-15'>.tags?

@description('Optional. Specifies the Autoscale settings. Note: Either throughput or autoscaleSettings is required, but not both.')
param autoscaleSettings resourceInput<'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2025-04-15'>.properties.options.autoscaleSettings?

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2025-04-15' existing = {
  name: databaseAccountName
}

resource mongodbDatabase 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2025-04-15' = {
  name: name
  parent: databaseAccount
  tags: tags
  properties: {
    resource: {
      id: name
    }
    options: contains(databaseAccount.properties.capabilities, { name: 'EnableServerless' })
      ? null
      : {
          throughput: throughput
          autoscaleSettings: autoscaleSettings
        }
  }
}

module mongodbDatabase_collections 'collection/main.bicep' = [
  for collection in (collections ?? []): {
    name: '${uniqueString(deployment().name, mongodbDatabase.name)}-collection-${collection.name}'
    params: {
      databaseAccountName: databaseAccountName
      mongodbDatabaseName: name
      name: collection.name
      indexes: collection.indexes
      shardKey: collection.shardKey
      throughput: collection.?throughput
    }
  }
]

@description('The name of the mongodb database.')
output name string = mongodbDatabase.name

@description('The resource ID of the mongodb database.')
output resourceId string = mongodbDatabase.id

@description('The name of the resource group the mongodb database was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of a collection.')
type collectionType = {
  @description('Required. Name of the collection.')
  name: string

  @description('Optional. Request Units per second. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the collection level and not at the database level.')
  throughput: int?

  @description('Required. Indexes for the collection.')
  indexes: resourceInput<'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2025-04-15'>.properties.resource.indexes

  @description('Required. ShardKey for the collection.')
  shardKey: resourceInput<'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2025-04-15'>.properties.resource.shardKey
}
