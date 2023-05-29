param cosmosDBAccountName string
param enableServerless bool
param table object

var name = table.key
var config = table.value

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource tables 'tables' = {
    name: name
    tags: toObject(config.tags, tag => tag.key, tag => tag.value)
    properties: {
      resource: {
        id: name
      }
      options: enableServerless ? {} : (config.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: config.performance.throughput } } : { throughput: config.performance.throughput })
    }
  }
}