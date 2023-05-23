param cosmosDBAccountName string
param enableServerless bool

param keyspace object
var keyspaceName = keyspace.key
var keyspaceConfig = keyspace.value

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource cassandraKeyspaces 'cassandraKeyspaces' = {
    name: keyspaceName
    properties: {
      resource: {
        id: keyspaceName
      }
      options: enableServerless ? {} : (keyspaceConfig.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: keyspaceConfig.performance.throughput } } : { throughput: keyspaceConfig.performance.throughput })
    }
    tags: keyspaceConfig.tags

    resource cassandraTables 'tables' = [for table in items(keyspaceConfig.?tables ?? {}): {
      name: table.key
      properties: {
        resource: {
          id: table.key
          //TODO: check if https://github.com/Azure/azure-rest-api-specs/issues/19695 is still relevant
          analyticalStorageTtl: table.value.?analyticalStorageTtl
          defaultTtl: table.value.?defaultTtl
          schema: {
            columns: table.?value.?schema.?columns
            partitionKeys: table.?value.?schema.?partitionKeys
            clusterKeys: table.?value.?schema.?clusterKeys
          }
        }
        options: enableServerless ? {} : (table.value.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: table.value.performance.throughput } } : { throughput: table.value.performance.throughput })
      }
      tags: table.value.tags
    }]
  }
}
