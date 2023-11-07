param cosmosDBAccountName string
param enableServerless bool

param keyspace object

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource cassandraKeyspaces 'cassandraKeyspaces' = {
    name: keyspace.name
    properties: {
      resource: {
        id: keyspace.name
      }
      options: (enableServerless || keyspace.?performance == null) ? null : (keyspace.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: keyspace.performance.throughput } } : { throughput: keyspace.performance.throughput })
    }
    tags: keyspace.?tags ?? {}

    resource cassandraTables 'tables' = [for table in keyspace.?tables ?? []: {
      name: table.name
      properties: {
        resource: {
          id: table.name
          // analyticalStorageTtl is an invalid propery in current api https://github.com/Azure/azure-rest-api-specs/issues/19695
          defaultTtl: table.?defaultTtl
          schema: table.?schema
        }
        options: (enableServerless || table.?performance == null) ? null : (table.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: table.performance.throughput } } : { throughput: table.performance.throughput })
      }
      tags: table.?tags ?? {}
    }]
  }
}