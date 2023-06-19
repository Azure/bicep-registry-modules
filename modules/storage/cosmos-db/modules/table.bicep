param cosmosDBAccountName string
param enableServerless bool
param table object

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource tables 'tables' = {
    name: table.name
    tags: table.?tags ?? {}
    properties: {
      resource: {
        id: table.name
      }
      options: (enableServerless || table.?performance == null) ? null : (table.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: table.performance.throughput } } : { throughput: table.performance.throughput })
    }
  }
}