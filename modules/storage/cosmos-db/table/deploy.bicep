param cosmosDBAccountName string
param enableServerless bool = false
param tableName string
param autoscaleMaxThroughput int
param manualProvisionedThroughput int

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDBAccountName
}

resource cosmosDBAccount_tables 'Microsoft.DocumentDB/databaseAccounts/tables@2022-11-15' = {
  name: tableName
  parent: cosmosDBAccount
  properties: {
    resource: {
      id: tableName
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
