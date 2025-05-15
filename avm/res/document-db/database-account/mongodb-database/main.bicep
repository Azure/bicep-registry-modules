metadata name = 'DocumentDB Database Account MongoDB Databases'
metadata description = 'This module deploys a MongoDB Database within a CosmosDB Account.'

@description('Conditional. The name of the parent Cosmos DB database account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Required. Name of the MongoDB database.')
param name string

@description('Optional. Request Units per second. Setting throughput at the database level is only recommended for development/test or when workload across all collections in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the collection level and not at the database level.')
param throughput int = 400

@description('Optional. Collections in the MongoDB database.')
param collections collectionType[]?

@description('Optional. Tags of the resource.')
param tags object?

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = {
  name: databaseAccountName
}

resource mongodbDatabase 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2024-11-15' = {
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
      shardKey: collection.?shardKeys
      throughput: collection.?throughput
    }
  }
]

@description('The name of the MongoDB database.')
output name string = mongodbDatabase.name

@description('The resource ID of the MongoDB database.')
output resourceId string = mongodbDatabase.id

@description('The name of the resource group the MongoDB database was created in.')
output resourceGroupName string = resourceGroup().name

@export()
@description('A collection within the MongoDB database.')
type collectionType = {
  @description('Required. The name of the collection.')
  name: string

  @description('Optional. The provisioned throughput assigned to the collection.')
  thoughput: int?

  @description('Optional. The set of shard keys to use for the collection.')
  shardKeys: shardKeyType[]?

  @description('Optional. The indexes to create for the collection.')
  indexes: indexType[]?
}

@export()
@description('A shard key specification for the collection.')
type shardKeyType = {
  @description('Required. The field to use for the shard key.')
  field: string

  @description('Required. The type of the shard key. Defaults to "Hash".')
  type: 'Hash'
}

@export()
@description('An index specification for the collection.')
type indexType = {
  @description('Required. The fields to use for the index.')
  keys: string[]

  @description('Optional. Indicator for whether the index is unique.')
  unique: bool?

  @description('Optional. The time-to-live (TTL) for documents in the index, in seconds.')
  ttl: int?
}
