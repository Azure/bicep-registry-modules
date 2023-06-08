param cosmosDBAccountName string
param enableServerless bool
param database object

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-11-15' = {
  name: database.name
  parent: cosmosDBAccount
  tags: database.?tags ?? {}
  properties: {
    resource: {
      id: database.name
    }
    options: (enableServerless || database.?performance == null) ? null : (database.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: database.performance.throughput } } : { throughput: database.performance.throughput })
  }
}

module sqlDatabaseContainers 'sql_containers.bicep' = [for container in database.?containers ?? []: {
  name: uniqueString(cosmosDBAccount.id, sqlDatabase.id, container.name)
  params: {
    cosmosDBAccountName: cosmosDBAccountName
    databaseName: database.name
    container: container
    enableServerless: enableServerless
  }
}]