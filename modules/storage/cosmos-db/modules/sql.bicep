param cosmosDBAccountName string
param enableServerless bool = false
param sqlDatabaseName string
param sqlDatabaseContainers array
param autoscaleMaxThroughput int
param manualProvisionedThroughput int

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDBAccountName
}

resource cosmosDBAccount_sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-11-15' = {
  name: sqlDatabaseName
  parent: cosmosDBAccount
  properties: {
    resource: {
      id: sqlDatabaseName
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
module cosmosDBAccount_sqlDatabaseContainers 'sql_containers.bicep' = [for sqlDatabaseContainer in sqlDatabaseContainers: {
  name: sqlDatabaseContainer.name
  dependsOn: [
    cosmosDBAccount_sqlDatabase
  ]
  params: {
    cosmosDBAccountName: cosmosDBAccountName
    sqlDatabaseName: sqlDatabaseName
    sqlDatabaseContainer: sqlDatabaseContainer
    enableServerless: enableServerless
  }
}]
