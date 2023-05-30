param cosmosDBAccountName string
param enableServerless bool
param database object
var name = database.key
var config = database.value

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-11-15' = {
  name: name
  parent: cosmosDBAccount
  tags: toObject(config.tags ?? [], tag => tag.key, tag => tag.value)
  properties: {
    resource: {
      id: name
    }
    options: enableServerless ? null : (config.performance == null ? null : (config.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: config.performance.throughput } } : { throughput: config.performance.throughput }))
  }
}

module sqlDatabaseContainers 'sql_containers.bicep' = [for container in items(config.containers ?? {}): {
  dependsOn: [ sqlDatabase ]

  name: container.key
  params: {
    cosmosDBAccountName: cosmosDBAccountName
    databaseName: name
    container: container
    enableServerless: enableServerless
  }
}]