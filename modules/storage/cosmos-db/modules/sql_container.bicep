param cosmosDBAccountName string
param enableServerless bool = false
param sqlDatabaseName string
param sqlDatabaseContainer object

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDBAccountName
}

resource cosmosDBAccountSqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2022-11-15' existing = {
  name: sqlDatabaseName
  parent: cosmosDBAccount
}

var varStoredProcedures = contains(sqlDatabaseContainer, 'storedProcedures') ? sqlDatabaseContainer.storedProcedures : []
var varTriggers = contains(sqlDatabaseContainer, 'triggers') ? sqlDatabaseContainer.triggers : []
var varUserDefinedFunctions = contains(sqlDatabaseContainer, 'userDefinedFunctions') ? sqlDatabaseContainer.userDefinedFunctions : []

resource cosmosDBAccount_sqlDatabasesqlDatabaseContainers 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/Containers@2022-11-15' = {
  name: sqlDatabaseContainer.name
  parent: cosmosDBAccountSqlDatabase
  properties: {
    resource: {
      id: sqlDatabaseContainer.name
      // https://github.com/Azure/azure-rest-api-specs/issues/19695
      // analyticalStorageTtl: (contains(sqlDatabaseContainer, 'analyticalStorageTtl') ? sqlDatabaseContainer.analyticalStorageTtl : -1
      defaultTtl: contains(sqlDatabaseContainer, 'defaultTtl') ? sqlDatabaseContainer.defaultTtl : -1
      conflictResolutionPolicy: contains(sqlDatabaseContainer, 'conflictResolutionPolicy') ? sqlDatabaseContainer.conflictResolutionPolicy : null
      uniqueKeyPolicy: contains(sqlDatabaseContainer, 'uniqueKeyPolicy') ? sqlDatabaseContainer.uniqueKeyPolicy : null
      indexingPolicy: contains(sqlDatabaseContainer, 'indexingPolicy') ? sqlDatabaseContainer.indexingPolicy : null
      partitionKey: contains(sqlDatabaseContainer, 'partitionKey') ? sqlDatabaseContainer.partitionKey : null
    }

    options: enableServerless ? {} : (contains(sqlDatabaseContainer, 'autoscaleMaxThroughput') ? {
      autoscaleSettings: {
        maxThroughput: sqlDatabaseContainer.autoscaleMaxThroughput
      }
    } : (contains(sqlDatabaseContainer, 'manualProvisionedThroughput') ? {
      throughput: sqlDatabaseContainer.manualProvisionedThroughput
    } : {}))
  }

  resource cosmosDBAccount_sqlDatabasessqlDatabaseContainersStoredProcedures 'storedProcedures' = [for storedProcedure in varStoredProcedures: {
    name: storedProcedure.name
    properties: {
      resource: {
        id: storedProcedure.name
        body: storedProcedure.body
      }
    }
  }]

  resource cosmosDBAccount_sqlDatabasessqlDatabaseContainersUserDefinedFunction 'userDefinedFunctions' = [for userDefinedFunction in varUserDefinedFunctions: {
    name: userDefinedFunction.name
    properties: {
      resource: {
        id: userDefinedFunction.name
        body: userDefinedFunction.body
      }
    }
  }]

  resource cosmosDBAccount_sqlDatabasessqlDatabaseContainersTriggers 'triggers' = [for trigger in varTriggers: {
    name: trigger.name
    properties: {
      resource: {
        id: trigger.name
        body: trigger.body
        triggerOperation: trigger.operation
        triggerType: trigger.type
      }
    }
  }]
}
