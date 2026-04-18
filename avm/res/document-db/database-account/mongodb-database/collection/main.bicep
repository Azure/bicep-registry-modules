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
param indexes resourceInput<'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2025-04-15'>.properties.resource.indexes

@description('Required. ShardKey for the collection.')
param shardKey resourceInput<'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2025-04-15'>.properties.resource.shardKey

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.doctdb-dbacct-mongodbdbcollection.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

  resource mongodbDatabase 'mongodbDatabases@2025-04-15' existing = {
    name: mongodbDatabaseName
  }
}

resource collection 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2025-04-15' = {
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
