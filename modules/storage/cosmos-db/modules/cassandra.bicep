param cosmosDBAccountName string
param enableServerless bool = false
param keyspaceName string
param tables array
param autoscaleMaxThroughput int
param manualProvisionedThroughput int

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDBAccountName

  resource cassandraKeyspaces 'cassandraKeyspaces@2022-11-15' = {
    name: keyspaceName
    properties: {
      resource: {
        id: keyspaceName
      }
      options: !enableServerless ? (autoscaleMaxThroughput != 0 ? {
        autoscaleSettings: {
          maxThroughput: autoscaleMaxThroughput
        }
      } : manualProvisionedThroughput != 0 ? {
        throughput: manualProvisionedThroughput
      } : {}) : {}
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
