param cosmosDBAccountName string
param enableServerless bool = false
param databaseName string
param databaseContainers array
param autoscaleMaxThroughput int
param manualProvisionedThroughput int

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
    options: enableServerless ? {} : (autoscaleMaxThroughput != 0 ? {
      autoscaleSettings: {
        maxThroughput: autoscaleMaxThroughput
      }
    } : (manualProvisionedThroughput != 0 ? {
      throughput: manualProvisionedThroughput
    } : {}))
  }
}

@batchSize(1)
module sqlDatabaseContainers 'sql_containers.bicep' = [for databaseContainer in databaseContainers: {
  name: databaseContainer.name
  dependsOn: [
    sqlDatabase
  ]
  params: {
    cosmosDBAccountName: cosmosDBAccountName
    databaseName: databaseName
    databaseContainer: databaseContainer
    enableServerless: enableServerless
  }
}]
