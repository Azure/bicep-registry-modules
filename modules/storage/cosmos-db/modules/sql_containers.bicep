param cosmosDBAccountName string
param databaseName string
param enableServerless bool
param container object

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: cosmosDBAccountName

  resource sqlDatabase 'sqlDatabases' existing = {
    name: databaseName

    resource databaseContainers 'Containers' = {
      name: container.name
      tags: container.?tags ?? {}
      properties: {
        resource: {
          id: container.name
          // analyticalStorageTtl is an invalid propery in current api https://github.com/Azure/azure-rest-api-specs/issues/19695
          defaultTtl: container.?defaultTtl
          conflictResolutionPolicy: container.?conflictResolutionPolicy
          uniqueKeyPolicy: container.?uniqueKeyPolicy
          indexingPolicy: container.?indexingPolicy
          partitionKey: container.?partitionKey
        }

        options: (enableServerless || container.?performance == null) ? null : (container.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: container.performance.throughput } } : { throughput: container.performance.throughput })
      }

      resource databaseContainersStoredProcedures 'storedProcedures' = [for procedure in container.?storedProcedures ?? []: {
        name: procedure.name
        tags: procedure.?tags ?? {}
        properties: {
          resource: {
            id: procedure.name
            body: procedure.body
          }
          options: (enableServerless || procedure.?performance == null) ? null : (procedure.performance.enableAutoScale ? { autoscaleSettings: { maxThroughput: procedure.performance.throughput } } : { throughput: procedure.performance.throughput })
        }
      }]

      resource databaseContainersUserDefinedFunction 'userDefinedFunctions' = [for function in container.?userDefinedFunctions ?? []: {
        name: function.name
        tags: function.?tags ?? {}
        properties: {
          resource: {
            id: function.name
            body: function.body
          }
        }
      }]

      resource databaseContainersTriggers 'triggers' = [for trigger in container.?triggers ?? []: {
        name: trigger.name
        tags: trigger.?tags ?? {}
        properties: {
          resource: {
            id: trigger.name
            body: trigger.body
            triggerOperation: trigger.?triggerOperation
            triggerType: trigger.?triggerType
          }
        }
      }]
    }
  }
}