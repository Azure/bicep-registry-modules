metadata name = 'DocumentDB Database Account MongoDB Database Collections'
metadata description = 'This module deploys a MongoDB Database Collection.'

@description('Conditional. The name of the parent Cosmos DB database account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Conditional. The name of the parent mongodb database. Required if the template is used in a standalone deployment.')
param mongodbDatabaseName string

@description('Required. Name of the collection.')
param name string

@description('Optional. Request Units per second. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the collection level and not at the database level.')
param throughput int = 400

@description('Required. Indexes for the collection.')
param indexes array

@description('Required. ShardKey for the collection.')
param shardKey object

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: databaseAccountName

  resource mongodbDatabase 'mongodbDatabases@2023-04-15' existing = {
    name: mongodbDatabaseName
  }
}

resource collection 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2023-04-15' = {
  name: name
  parent: databaseAccount::mongodbDatabase
  properties: {
    options: contains(databaseAccount.properties.capabilities, { name: 'EnableServerless' })
      ? null
      : {
          throughput: throughput
        }
    resource: {
      id: name
      indexes: indexes
      shardKey: shardKey
    }
  }
}

@description('The name of the mongodb database collection.')
output name string = collection.name

@description('The resource ID of the mongodb database collection.')
output resourceId string = collection.id

@description('The name of the resource group the mongodb database collection was created in.')
output resourceGroupName string = resourceGroup().name
