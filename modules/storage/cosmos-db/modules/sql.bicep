param cosmosDBAccountName string
param enableServerless bool
param database object
var databaseName = database.key
var databaseConfig = database.value

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDBAccountName
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-11-15' = {
  name: databaseName
  parent: cosmosDBAccount
  properties: {
    resource: {
      id: databaseName
    }
    options: enableServerless ? {} : (databaseConfig.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: databaseConfig.performance.throughput } } : { throughput: databaseConfig.performance.throughput })
  }
}

@batchSize(1)
module sqlDatabaseContainers 'sql_containers.bicep' = [for container in items(databaseConfig.?containers ?? {}): {
  dependsOn: [    sqlDatabase  ]

  name: container.key
  params: {
    cosmosDBAccountName: cosmosDBAccountName
    databaseName: databaseName
    container:container
    enableServerless: enableServerless
  }
}]
