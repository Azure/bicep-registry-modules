param cosmosDBAccountName string
param enableServerless bool = false
param keyspaceName string
param cassandraTables array
param autoscaleMaxThroughput int
param manualProvisionedThroughput int

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-03-15' existing = {
  name: cosmosDBAccountName
}

resource cosmosDBAccount_cassandraKeyspaces 'Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces@2023-03-15' = {
  name: keyspaceName
  parent: cosmosDBAccount
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

  resource cosmosDBAccount_cassandraTables 'tables' = [for table in cassandraTables: {
    name: table.name
    properties: {
      resource: {
        id: table.name
        // https://github.com/Azure/azure-rest-api-specs/issues/19695
        // analyticalStorageTtl: contains(table, 'analyticalStorageTtl') ? table.analyticalStorageTtl : null
        defaultTtl: contains(table, 'defaultTtl') ? table.defaultTtl : null
        schema: {
          columns: contains(table, 'schemaColumns') ? table.schemaColumns : []
          partitionKeys: contains(table, 'schemaPartitionKeys') ? table.schemaPartitionKeys : []
          clusterKeys: contains(table, 'schemaClusteringKeys') ? table.schemaClusteringKeys : []
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
