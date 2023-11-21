metadata name = 'DocumentDB Database Account MongoDB Database Collections'
metadata description = 'This module deploys a MongoDB Database Collection.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Cosmos DB database account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Conditional. The name of the parent mongodb database. Required if the template is used in a standalone deployment.')
param mongodbDatabaseName string

@description('Required. Name of the collection.')
param name string

@description('Optional. Name of the mongodb database.')
param throughput int = 400

@description('Required. Indexes for the collection.')
param indexes array

@description('Required. ShardKey for the collection.')
param shardKey object

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2022-09-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

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
    options: contains(databaseAccount.properties.capabilities, { name: 'EnableServerless' }) ? null : {
      throughput: throughput
    }
    resource: {
      id: name
      indexes: indexes
      shardKey: shardKey
    }
  }
}

@description('The name of the mongodb database.')
output name string = collection.name

@description('The resource ID of the mongodb database.')
output resourceId string = collection.id

@description('The name of the resource group the mongodb database was created in.')
output resourceGroupName string = resourceGroup().name
