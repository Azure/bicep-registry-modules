param cosmosDBAccountName string
param enableServerless bool
type objectOfString = {
  *: string
}
type casandrakeyspace ={
  enableThroughputAutoScale: bool
  @maxValue(100000)
  @minValue(400)
  throughput: int
  tables: {}
  tags: objectOfString
}
param keyspaceConfig casandrakeyspace
param keyspaceName string

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource cassandraKeyspaces 'cassandraKeyspaces' = {
    name: keyspaceName
    properties: {
      resource: {
        id: keyspaceName
      }
      options: enableServerless ? {} : (keyspaceConfig.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: keyspaceConfig.throughput } } :  { throughput: keyspaceConfig.throughput } )
    }

    resource cassandraTables 'tables' = [for table in tables: {
      name: table.name
      properties: {
        resource: {
          id: table.name
          // https://github.com/Azure/azure-rest-api-specs/issues/19695
          // analyticalStorageTtl: contains(table, 'analyticalStorageTtl') ? table.analyticalStorageTtl : null
          defaultTtl: table.?defaultTtl ?? null
          schema: {
            columns: table.?schemaColumns ?? []
            partitionKeys: table.?schemaPartitionKeys ?? []
            clusterKeys: table.?schemaClusteringKeys ?? []
          }
        }
        options: !enableServerless ? (contains(table, 'autoscaleMaxThroughput') ? {
          autoscaleSettings: {
            maxThroughput: table.autoscaleMaxThroughput
          }
        } : contains(table, 'manualProvisionedThroughput') ? {
          throughput: table.manualProvisionedThroughput
        } : {}) : {}
      }
    }]
  }
}
