metadata name = 'DocumentDB Database Account Cassandra Keyspaces'
metadata description = 'This module deploys a Cassandra Keyspace within a CosmosDB Account.'

@description('Required. Name of the Cassandra keyspace.')
param name string

@description('Optional. Tags of the Cassandra keyspace resource.')
param tags resourceInput<'Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces@2024-11-15'>.tags?

@description('Conditional. The name of the parent Cosmos DB account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Optional. Array of Cassandra tables to deploy in the keyspace.')
param tables tableType[] = []

@description('Optional. Array of Cassandra views (materialized views) to deploy in the keyspace.')
param views viewType[] = []

@description('Optional. Maximum autoscale throughput for the keyspace. If not set, autoscale will be disabled. Setting throughput at the keyspace level is only recommended for development/test or when workload across all tables in the shared throughput keyspace is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the table level.')
param autoscaleSettingsMaxThroughput int = 4000

@description('Optional. Request units per second. Cannot be used with autoscaleSettingsMaxThroughput. Setting throughput at the keyspace level is only recommended for development/test or when workload across all tables in the shared throughput keyspace is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the table level.')
param throughput int?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.doctdb-dbacct-cassandrkeyspace.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = {
  name: databaseAccountName
}

var keyspaceOptions = contains(databaseAccount.properties.capabilities, { name: 'EnableServerless' })
  ? {}
  : {
      autoscaleSettings: throughput == null
        ? {
            maxThroughput: autoscaleSettingsMaxThroughput
          }
        : null
      throughput: throughput
    }

resource cassandraKeyspace 'Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces@2024-11-15' = {
  name: name
  tags: tags
  parent: databaseAccount
  properties: {
    options: keyspaceOptions
    resource: {
      id: name
    }
  }
}

var enableReferencedModulesTelemetry = false

module cassandraKeyspace_tables 'table/main.bicep' = [
  for table in tables: {
    name: '${uniqueString(deployment().name, cassandraKeyspace.name)}-cassandradb-${table.name}'
    params: {
      name: table.name
      cassandraKeyspaceName: name
      databaseAccountName: databaseAccountName
      schema: table.schema
      analyticalStorageTtl: table.?analyticalStorageTtl
      throughput: table.?throughput
      autoscaleSettingsMaxThroughput: table.?autoscaleSettingsMaxThroughput
      defaultTtl: table.?defaultTtl
      tags: table.?tags ?? tags
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

module cassandraKeyspace_views 'view/main.bicep' = [
  for view in views: {
    name: '${uniqueString(deployment().name, cassandraKeyspace.name)}-cassandraview-${view.name}'
    params: {
      name: view.name
      cassandraKeyspaceName: name
      databaseAccountName: databaseAccountName
      viewDefinition: view.viewDefinition
      throughput: view.?throughput
      autoscaleSettingsMaxThroughput: view.?autoscaleSettingsMaxThroughput
      tags: view.?tags ?? tags
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

@description('The name of the Cassandra keyspace.')
output name string = cassandraKeyspace.name

@description('The resource ID of the Cassandra keyspace.')
output resourceId string = cassandraKeyspace.id

@description('The name of the resource group the Cassandra keyspace was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
// Definitions     //
// =============== //

@export()
@description('The type of a Cassandra table.')
type tableType = {
  @description('Required. Name of the table.')
  name: string

  @description('Required. Schema definition for the table.')
  schema: resourceInput<'Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/tables@2024-11-15'>.properties.resource.schema

  @description('Optional. Tags for the table.')
  tags: resourceInput<'Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/tables@2024-11-15'>.tags?

  @description('Optional. Default TTL (Time To Live) in seconds for data in the table.')
  defaultTtl: int?

  @description('Optional. Analytical TTL for the table.')
  analyticalStorageTtl: int?

  @description('Optional. Request units per second. Cannot be used with autoscaleSettingsMaxThroughput.')
  throughput: int?

  @description('Optional. Maximum autoscale throughput for the table. Cannot be used with throughput.')
  autoscaleSettingsMaxThroughput: int?
}

@export()
@description('The type of a Cassandra view (materialized view).')
type viewType = {
  @description('Required. Name of the view.')
  name: string

  @description('Required. View definition (CQL statement).')
  viewDefinition: string

  @description('Optional. Tags for the view.')
  tags: resourceInput<'Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/views@2025-05-01-preview'>.tags?

  @description('Optional. Request units per second. Cannot be used with autoscaleSettingsMaxThroughput.')
  throughput: int?

  @description('Optional. Maximum autoscale throughput for the view. Cannot be used with throughput.')
  autoscaleSettingsMaxThroughput: int?
}
