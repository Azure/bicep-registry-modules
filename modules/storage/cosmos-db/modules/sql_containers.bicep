param cosmosDBAccountName string
param databaseName string
param enableServerless bool
param container object
var name = container.key
var config = container.value

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource sqlDatabase 'sqlDatabases' existing = {
    name: databaseName

    resource databaseContainers 'Containers' = {
      name: name
      tags: config.?tags ?? {}
      properties: {
        resource: {
          id: name
          // analyticalStorageTtl is an invalid propery in current api https://github.com/Azure/azure-rest-api-specs/issues/19695
          defaultTtl: config.?defaultTtl
          conflictResolutionPolicy: config.?conflictResolutionPolicy
          uniqueKeyPolicy: config.?uniqueKeyPolicy
          indexingPolicy: config.?indexingPolicy
          partitionKey: config.?partitionKey
        }

        options: enableServerless ? null : (config.?performance == null ? null : (config.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: config.performance.throughput } } : { throughput: config.performance.throughput }))
      }

      resource databaseContainersStoredProcedures 'storedProcedures' = [for procedure in items(config.?storedProcedures ?? {}): {
        name: procedure.key
        tags: procedure.value.?tags ?? {}
        properties: {
          resource: {
            id: procedure.key
            body: procedure.value.body
          }
          options: enableServerless ? null : (procedure.value.?performance == null ? null : (procedure.value.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: procedure.value.performance.throughput } } : { throughput: procedure.value.performance.throughput }))
        }
      }]

      resource databaseContainersUserDefinedFunction 'userDefinedFunctions' = [for function in items(config.?userDefinedFunctions ?? {}): {
        name: function.key
        tags: function.value.?tags ?? {}
        properties: {
          resource: {
            id: function.key
            body: function.value.body
          }
        }
      }]

      resource databaseContainersTriggers 'triggers' = [for trigger in items(config.?triggers ?? {}): {
        name: trigger.key
        tags: trigger.value.?tags ?? {}
        properties: {
          resource: {
            id: trigger.key
            body: trigger.value.body
            triggerOperation: trigger.value.?triggerOperation
            triggerType: trigger.value.?triggerType
          }
        }
      }]
    }
  }
}