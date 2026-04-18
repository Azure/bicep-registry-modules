metadata name = 'DocumentDB Database Accounts Gremlin Databases Graphs'
metadata description = 'This module deploys a DocumentDB Database Accounts Gremlin Database Graph.'

@description('Required. Name of the graph.')
param name string

@description('Optional. Tags of the Gremlin graph resource.')
param tags resourceInput<'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs@2025-04-15'>.tags?

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Conditional. The name of the parent Gremlin Database. Required if the template is used in a standalone deployment.')
param gremlinDatabaseName string

@description('Optional. Indexing policy of the graph.')
param indexingPolicy resourceInput<'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs@2025-04-15'>.properties.resource.indexingPolicy?

@description('Optional. List of paths using which data within the container can be partitioned.')
param partitionKeyPaths resourceInput<'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs@2025-04-15'>.properties.resource.partitionKey.paths?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.doctdb-dbacct-gremlindbgraph.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2025-04-15' existing = {
  name: databaseAccountName

  resource gremlinDatabase 'gremlinDatabases@2025-04-15' existing = {
    name: gremlinDatabaseName
  }
}

resource gremlinGraph 'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases/graphs@2025-04-15' = {
  name: name
  tags: tags
  parent: databaseAccount::gremlinDatabase
  properties: {
    resource: {
      id: name
      indexingPolicy: indexingPolicy
      partitionKey: {
        paths: partitionKeyPaths
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
