param cosmosDBAccountName string
param enableServerless bool
param database object
var name = database.key
var config = database.value

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDBAccountName
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-11-15' = {
  name: name
  parent: cosmosDBAccount
  properties: {
    resource: {
      id: name
    }
    options: enableServerless ? {} : (config.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: config.performance.throughput } } : { throughput: config.performance.throughput })
  }
}

@batchSize(1)
module sqlDatabaseContainers 'sql_containers.bicep' = [for container in items(config.?containers ?? {}): {
  dependsOn: [    sqlDatabase  ]

  name: container.key
  params: {
    cosmosDBAccountName: cosmosDBAccountName
    databaseName: name
    container:container
    enableServerless: enableServerless
  }
}]
