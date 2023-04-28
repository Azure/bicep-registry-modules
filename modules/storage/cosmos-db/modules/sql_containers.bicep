param cosmosDBAccountName string
param enableServerless bool = false
param databaseName string
param databaseContainer object

var varStoredProcedures = databaseContainer.?storedProcedures ?? []
var varTriggers = databaseContainer.?triggers ?? []
var varUserDefinedFunctions = databaseContainer.?userDefinedFunctions ?? []

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' existing = {
  name: cosmosDBAccountName

  resource sqlDatabase 'sqlDatabases@2022-11-15' existing = {
    name: databaseName

    resource databaseContainers 'Containers@2022-11-15' = {
      name: databaseContainer.name
      properties: {
        resource: {
          id: databaseContainer.name
          // https://github.com/Azure/azure-rest-api-specs/issues/19695
          // analyticalStorageTtl: (contains(databaseContainer, 'analyticalStorageTtl') ? databaseContainer.analyticalStorageTtl : -1
          defaultTtl: databaseContainer.?defaultTtl ?? -1
          conflictResolutionPolicy: databaseContainer.?conflictResolutionPolicy ?? null
          uniqueKeyPolicy: databaseContainer.?uniqueKeyPolicy ?? null
          indexingPolicy: databaseContainer.?indexingPolicy ?? null
          partitionKey: databaseContainer.?partitionKey ?? null
        }

        options: enableServerless ? {} : (contains(databaseContainer, 'autoscaleMaxThroughput') ? {
          autoscaleSettings: {
            maxThroughput: databaseContainer.autoscaleMaxThroughput
          }
        } : (contains(databaseContainer, 'manualProvisionedThroughput') ? {
          throughput: databaseContainer.manualProvisionedThroughput
        } : {}))
      }

      resource databaseContainersStoredProcedures 'storedProcedures' = [for storedProcedure in varStoredProcedures: {
        name: storedProcedure.name
        properties: {
          resource: {
            id: storedProcedure.name
            body: storedProcedure.body
          }
        }
      }]

      resource databaseContainersUserDefinedFunction 'userDefinedFunctions' = [for userDefinedFunction in varUserDefinedFunctions: {
        name: userDefinedFunction.name
        properties: {
          resource: {
            id: userDefinedFunction.name
            body: userDefinedFunction.body
          }
        }
      }]

      resource databaseContainersTriggers 'triggers' = [for trigger in varTriggers: {
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
  }
}
