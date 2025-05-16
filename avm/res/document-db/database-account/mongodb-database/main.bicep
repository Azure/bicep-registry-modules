metadata name = 'Azure Cosmos DB for MongoDB RU database'
metadata description = 'This module deploys an Azure Cosmos DB for MongoDB RU database within an account.'

@description('Conditional. The name of the parent Azure Cosmos DB for MongoDB RU account. Required if the template is used in a standalone deployment.')
param parentAccountName string

@description('Required. The name of the database.')
param name string

@description('Optional. Tags for the resource.')
param tags resourceInput<'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2024-11-15'>.tags?

@description('Optional. The provisioned throughput assigned to the database.')
param throughput int?

@description('Optional. The maximum throughput for the database when using autoscale.')
param autoscaleMaxThroughput int?

@description('Optional. The set of collections within the database.')
param collections mongodbCollectionType[]?

resource account 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = {
  name: parentAccountName
}

resource database 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2024-11-15' = {
  name: name
  parent: account
  tags: tags
  properties: {
    resource: {
      id: name
    }
    options: {
      autoscaleSettings: contains(account.properties.capabilities, { name: 'EnableServerless' })
        ? null
        : {
            maxThroughput: autoscaleMaxThroughput
          }
      throughput: contains(account.properties.capabilities, { name: 'EnableServerless' }) ? null : throughput
    }
  }
}

module mongodbDatabase_collections 'collection/main.bicep' = [
  for collection in (collections ?? []): {
    name: '${uniqueString(deployment().name, database.name)}-collection-${collection.name}'
    params: {
      ancestorAccountName: account.name
      parentDatabaseName: name
      name: collection.name
      tags: collection.?tags ?? tags
      throughput: collection.throughput
      autoscaleMaxThroughput: collection.autoscaleMaxThroughput
      shardKeys: collection.shardKeys
      indexes: collection.indexes
    }
  }
]

@description('The name of the MongoDB database.')
output name string = database.name

@description('The resource ID of the MongoDB database.')
output resourceId string = database.id

@description('The name of the resource group the MongoDB database was created in.')
output resourceGroupName string = resourceGroup().name

import { shardKeyType } from 'collection/main.bicep'
import { indexType } from 'collection/main.bicep'
@export()
@description('A collection within the database.')
type mongodbCollectionType = {
  @description('Required. The name of the collection.')
  name: string

  @description('Optional. Tags for the resource.')
  tags: object?

  @description('Optional. The provisioned throughput assigned to the collection.')
  throughput: int?

  @description('Optional. The maximum throughput for the collection when using autoscale.')
  autoscaleMaxThroughput: int?

  @description('Optional. The set of shard keys to use for the collection.')
  shardKeys: shardKeyType[]?

  @description('Optional. The indexes to create for the collection.')
  indexes: indexType[]?
}
