metadata name = 'DocumentDB Database Accounts Gremlin Databases Graphs'
metadata description = 'This module deploys a DocumentDB Database Accounts Gremlin Database Graph.'

@description('Required. Name of the graph.')
param name string

@description('Optional. Tags of the Gremlin graph resource.')
param tags object?

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Conditional. The name of the parent Gremlin Database. Required if the template is used in a standalone deployment.')
param gremlinDatabaseName string

@description('Optional. Indexing policy of the graph.')
param indexingPolicy object = {}

@description('Optional. List of paths using which data within the container can be partitioned.')
param partitionKeyPaths array = []

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: databaseAccountName

  resource gremlinDatabase 'gremlinDatabases@2023-04-15' existing = {
    name: gremlinDatabaseName
  }
}

resource gremlinGraph 'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs@2023-04-15' = {
  name: name
  tags: tags
  parent: databaseAccount::gremlinDatabase
  properties: {
    resource: {
      id: name
      indexingPolicy: !empty(indexingPolicy) ? indexingPolicy : null
      partitionKey: {
        paths: !empty(partitionKeyPaths) ? partitionKeyPaths : null
      }
    }
  }
}

@description('The name of the graph.')
output name string = gremlinGraph.name

@description('The resource ID of the graph.')
output resourceId string = gremlinGraph.id

@description('The name of the resource group the graph was created in.')
output resourceGroupName string = resourceGroup().name
