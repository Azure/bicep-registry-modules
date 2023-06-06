param cosmosDBAccountName string
param enableServerless bool

param keyspace object
var name = keyspace.key
var config = keyspace.value

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource cassandraKeyspaces 'cassandraKeyspaces' = {
    name: name
    properties: {
      resource: {
        id: name
      }
      options: enableServerless ? null : (config.?performance == null ? null : (config.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: config.performance.throughput } } : { throughput: config.performance.throughput }))
    }
    tags: config.?tags ?? {}

    resource cassandraTables 'tables' = [for table in items(config.?tables ?? {}): {
      name: table.key
      properties: {
        resource: {
          id: table.key
          // analyticalStorageTtl is an invalid propery in current api https://github.com/Azure/azure-rest-api-specs/issues/19695
          defaultTtl: table.value.?defaultTtl
          schema: table.value.?schema
        }
        options: enableServerless ? null : (table.value.?performance == null ? null : (table.value.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: table.value.performance.throughput } } : { throughput: table.value.performance.throughput }))
      }
      tags: table.value.?tags ?? {}
    }]
  }
}