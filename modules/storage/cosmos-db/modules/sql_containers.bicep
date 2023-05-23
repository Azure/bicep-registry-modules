param cosmosDBAccountName string
param databaseName string
param enableServerless bool
param container object
var containerName = container.key
var containerConfig = container.value

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource sqlDatabase 'sqlDatabases' existing = {
    name: databaseName

    resource databaseContainers 'Containers' = {
      name: containerName
      properties: {
        resource: {
          id: containerName
          // TODO: check if https://github.com/Azure/azure-rest-api-specs/issues/19695 is still relevant
          analyticalStorageTtl: containerConfig.?analyticalStorageTtl
          defaultTtl: containerConfig.?defaultTtl
          clientEncryptionPolicy: containerConfig.?clientEncryptionPolicy
          conflictResolutionPolicy: containerConfig.?conflictResolutionPolicy
          uniqueKeyPolicy: containerConfig.?uniqueKeyPolicy
          indexingPolicy: containerConfig.?indexingPolicy
          partitionKey: containerConfig.?partitionKey
        }

        options: enableServerless ? {} : (containerConfig.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: containerConfig.performance.throughput } } : { throughput: containerConfig.performance.throughput })
      }

      resource databaseContainersStoredProcedures 'storedProcedures' = [for procedure in items(containerConfig.?storedProcedures ??{}): {
        name: procedure.key
        properties: {
          resource: {
            id: procedure.key
            body: procedure.value.body
          }
          options:enableServerless ? {} : (procedure.value.performance.enableThroughputAutoScale ? { autoscaleSettings: { maxThroughput: procedure.value.performance.throughput } } : { throughput: procedure.value.performance.throughput })
        }
      }]

      resource databaseContainersUserDefinedFunction 'userDefinedFunctions' = [for function in items(containerConfig.?userDefinedFunctions ??{}): {
        name: function.key
        properties: {
          resource: {
            id: function.key
            body: function.value.body
          }
        }
      }]

      resource databaseContainersTriggers 'triggers' = [for trigger in items(containerConfig.?triggers ??{}): {
        name: trigger.key
        properties: {
          resource: {
            id: trigger.key
            body: trigger.value.body
            triggerOperation: trigger.value.triggerOperation
            triggerType: trigger.value.triggerType
          }
        }
      }]
    }
  }
}
