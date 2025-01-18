metadata name = 'DocumentDB Database Account Gremlin Databases'
metadata description = 'This module deploys a Gremlin Database within a CosmosDB Account.'

@description('Required. Name of the Gremlin database.')
param name string

@description('Optional. Tags of the Gremlin database resource.')
param tags object?

@description('Conditional. The name of the parent Gremlin database. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Optional. Array of graphs to deploy in the Gremlin database.')
param graphs array = []

@description('Optional. Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored. Setting throughput at the database level is only recommended for development/test or when workload across all graphs in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the graph level and not at the database level.')
param maxThroughput int = 4000

@description('Optional. Request Units per second (for example 10000). Cannot be set together with `maxThroughput`. Setting throughput at the database level is only recommended for development/test or when workload across all graphs in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the graph level and not at the database level.')
param throughput int?

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: databaseAccountName
}

var databaseOptions = contains(databaseAccount.properties.capabilities, { name: 'EnableServerless' })
  ? {}
  : {
      autoscaleSettings: throughput == null
        ? {
            maxThroughput: maxThroughput
          }
        : null
      throughput: throughput
    }

resource gremlinDatabase 'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases@2023-04-15' = {
  name: name
  tags: tags
  parent: databaseAccount
  properties: {
    options: databaseOptions
    resource: {
      id: name
    }
  }
}

module gremlinDatabase_gremlinGraphs 'graph/main.bicep' = [
  for graph in graphs: {
    name: '${uniqueString(deployment().name, gremlinDatabase.name)}-gremlindb-${graph.name}'
    params: {
      name: graph.name
      gremlinDatabaseName: name
      databaseAccountName: databaseAccountName
      indexingPolicy: graph.?indexingPolicy
      partitionKeyPaths: !empty(graph.partitionKeyPaths) ? graph.partitionKeyPaths : []
    }
  }
]

@description('The name of the Gremlin database.')
output name string = gremlinDatabase.name

@description('The resource ID of the Gremlin database.')
output resourceId string = gremlinDatabase.id

@description('The name of the resource group the Gremlin database was created in.')
output resourceGroupName string = resourceGroup().name
