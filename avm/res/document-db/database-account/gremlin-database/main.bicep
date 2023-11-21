metadata name = 'DocumentDB Database Account Gremlin Databases'
metadata description = 'This module deploys a Gremlin Database within a CosmosDB Account.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Gremlin database.')
param name string

@description('Optional. Tags of the Gremlin database resource.')
param tags object?

@description('Conditional. The name of the parent Gremlin database. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Optional. Array of graphs to deploy in the Gremlin database.')
param graphs array = []

@description('Optional. Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored.')
param maxThroughput int = 4000

@description('Optional. Request Units per second (for example 10000). Cannot be set together with `maxThroughput`.')
param throughput int = -1

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var enableReferencedModulesTelemetry = false

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
}

var databaseOptions = contains(databaseAccount.properties.capabilities, { name: 'EnableServerless' }) ? {} : {
  autoscaleSettings: throughput == -1 ? {
    maxThroughput: maxThroughput
  } : null
  throughput: throughput != -1 ? throughput : null
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

module gremlinDatabase_gremlinGraphs 'graph/main.bicep' = [for graph in graphs: {
  name: '${uniqueString(deployment().name, gremlinDatabase.name)}-gremlindb-${graph.name}'
  params: {
    name: graph.name
    gremlinDatabaseName: name
    databaseAccountName: databaseAccountName
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    indexingPolicy: contains(graph, 'indexingPolicy') ? graph.indexingPolicy : true
    partitionKeyPaths: !empty(graph.partitionKeyPaths) ? graph.partitionKeyPaths : []
  }
}]

@description('The name of the Gremlin database.')
output name string = gremlinDatabase.name

@description('The resource ID of the Gremlin database.')
output resourceId string = gremlinDatabase.id

@description('The name of the resource group the Gremlin database was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]?
}?
