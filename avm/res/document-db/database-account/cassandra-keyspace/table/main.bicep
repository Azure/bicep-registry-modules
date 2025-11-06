metadata name = 'DocumentDB Database Account Cassandra Keyspaces Tables'
metadata description = 'This module deploys a Cassandra Table within a Cassandra Keyspace in a CosmosDB Account.'

@description('Required. Name of the Cassandra table.')
param name string

@description('Optional. Tags of the Cassandra table resource.')
param tags resourceInput<'Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/tables@2024-11-15'>.tags?

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Conditional. The name of the parent Cassandra Keyspace. Required if the template is used in a standalone deployment.')
param cassandraKeyspaceName string

@description('Required. Schema definition for the Cassandra table.')
param schema resourceInput<'Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/tables@2024-11-15'>.properties.resource.schema

@description('Optional. Analytical TTL for the table. Default to 0 (disabled). Analytical store is enabled when set to a value other than 0. If set to -1, analytical store retains all historical data.')
param analyticalStorageTtl int = 0

@description('Optional. Request units per second. Cannot be used with autoscaleSettingsMaxThroughput. If not specified, the table will inherit throughput from the keyspace.')
param throughput int?

@description('Optional. Maximum autoscale throughput for the table. Cannot be used with throughput. If not specified, the table will inherit throughput from the keyspace.')
param autoscaleSettingsMaxThroughput int?

@description('Optional. Default time to live in seconds. Default to 0 (disabled). If set to -1, items do not expire.')
param defaultTtl int = 0

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2024-11-15' existing = {
  name: databaseAccountName

  resource cassandraKeyspace 'cassandraKeyspaces@2024-11-15' existing = {
    name: cassandraKeyspaceName
  }
}

var tableOptions = contains(databaseAccount.properties.capabilities, { name: 'EnableServerless' })
  ? {}
  : {
      autoscaleSettings: throughput == null && autoscaleSettingsMaxThroughput != null
        ? {
            maxThroughput: autoscaleSettingsMaxThroughput
          }
        : null
      throughput: throughput
    }

resource cassandraTable 'Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces/tables@2024-11-15' = {
  name: name
  tags: tags
  parent: databaseAccount::cassandraKeyspace
  properties: {
    resource: {
      id: name
      schema: schema
      defaultTtl: defaultTtl
      analyticalStorageTtl: analyticalStorageTtl
    }
    options: tableOptions
  }
}

@description('The name of the Cassandra table.')
output name string = cassandraTable.name

@description('The resource ID of the Cassandra table.')
output resourceId string = cassandraTable.id

@description('The name of the resource group the Cassandra table was created in.')
output resourceGroupName string = resourceGroup().name
