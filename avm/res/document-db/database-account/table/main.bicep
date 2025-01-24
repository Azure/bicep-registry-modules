metadata name = 'Azure Cosmos DB account tables'
metadata description = 'This module deploys a table within an Azure Cosmos DB Account.'

@description('Required. Name of the table.')
param name string

@description('Optional. Tags for the table.')
param tags object?

@description('Conditional. The name of the parent Azure Cosmos DB account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Optional. Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored.')
param maxThroughput int = 4000

@description('Optional. Request Units per second (for example 10000). Cannot be set together with `maxThroughput`.')
param throughput int?

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: databaseAccountName
}

var tableOptions = contains(databaseAccount.properties.capabilities, { name: 'EnableServerless' })
  ? {}
  : {
      autoscaleSettings: throughput == null
        ? {
            maxThroughput: maxThroughput
          }
        : null
      throughput: throughput
    }

resource table 'Microsoft.DocumentDB/databaseAccounts/tables@2023-04-15' = {
  name: name
  tags: tags
  parent: databaseAccount
  properties: {
    options: tableOptions
    resource: {
      id: name
    }
  }
}

@description('The name of the table.')
output name string = table.name

@description('The resource ID of the table.')
output resourceId string = table.id

@description('The name of the resource group the table was created in.')
output resourceGroupName string = resourceGroup().name
