metadata name = 'Azure Cosmos DB for MongoDB RU collection'
metadata description = 'This module deploys an Azure Cosmos DB for MongoDB RU collection within a database.'

@description('Conditional. The name of the parent Azure Cosmos DB for MongoDB RU account. Required if the template is used in a standalone deployment.')
param ancestorAccountName string

@description('Conditional. The name of the parent database. Required if the template is used in a standalone deployment.')
param parentDatabaseName string

@description('Required. The name of the collection.')
param name string

@description('Optional. Tags for the resource.')
param tags resourceInput<'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2024-11-15'>.tags?

@description('Optional. The provisioned throughput assigned to the collection.')
param throughput int?

@description('Optional. The maximum throughput for the collection when using autoscale.')
param autoscaleMaxThroughput int?

@description('Optional. The set of shard keys to use for the collection.')
param shardKeys shardKeyType[]?

@description('Optional. The indexes to create for the collection.')
param indexes indexType[]?

resource account 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = {
  name: ancestorAccountName
}

resource database 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2024-11-15' existing = {
  name: parentDatabaseName
}

// This checks the edge case where throughput is not specified at the database or container level and the account is not serverless.
var throughputNotSet = (autoscaleMaxThroughput == null && throughput == null && database.properties.options.autoscaleSettings == null && database.properties.options.throughput == null && !contains(
  account.properties.capabilities,
  { name: 'EnableServerless' }
))

resource collection 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2024-11-15' = {
  name: name
  parent: database
  tags: tags
  properties: {
    options: throughputNotSet
      ? {
          autoscaleSettings: {
            maxThroughput: 1000
          }
          // In this special case, we set the throughput to 1,000 RU/s, which is the minimum throughput for autoscale on a collection.
          // With autoscale enabled, the throughput can scale down to as little as 100 RU/s.
          // This is less than the minimum of 400 RU/s for a provisioned collection.
          // For best performance for large production workloads, set dedicated throughput at the collection level.
        }
      : {
          autoscaleSettings: contains(account.properties.capabilities, { name: 'EnableServerless' })
            ? null
            : {
                maxThroughput: autoscaleMaxThroughput
              }
          throughput: contains(account.properties.capabilities, { name: 'EnableServerless' }) ? null : throughput
        }
    resource: {
      id: name
      indexes: indexes != null
        ? map(indexes ?? [], (index) => {
            key: {
              keys: index.keys
            }
            options: {
              expireAfterSeconds: index.ttl
              unique: index.unique
            }
          })
        : null
      shardKey: shardKeys != null
        ? reduce(
            shardKeys ?? [],
            {},
            (current, next) =>
              union(current, {
                '${next.field}': next.type
              })
          )
        : null
    }
  }
}

@description('The name of the mongodb database collection.')
output name string = collection.name

@description('The resource ID of the mongodb database collection.')
output resourceId string = collection.id

@description('The name of the resource group the mongodb database collection was created in.')
output resourceGroupName string = resourceGroup().name

@export()
@description('A shard key specification for the collection.')
type shardKeyType = {
  @description('Required. The field to use for the shard key.')
  field: string

  @description('Required. The type of the shard key. Defaults to "Hash". Note that "Hash" is the only supported type at this time.')
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
