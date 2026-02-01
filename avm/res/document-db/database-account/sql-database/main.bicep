metadata name = 'DocumentDB Database Account SQL Databases'
metadata description = 'This module deploys a SQL Database in a CosmosDB Account.'

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Required. Name of the SQL database .')
param name string

@description('Optional. Array of containers to deploy in the SQL database.')
param containers containerType[]?

@description('Optional. Request units per second. Will be ignored if autoscaleSettingsMaxThroughput is used. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level.')
param throughput int?

@description('Optional. Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level.')
param autoscaleSettingsMaxThroughput int?

@description('Optional. Tags of the SQL database resource.')
param tags resourceInput<'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2025-04-15'>.tags?

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2025-04-15' existing = {
  name: databaseAccountName
}

resource sqlDatabase 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2025-04-15' = {
  name: name
  parent: databaseAccount
  tags: tags
  properties: {
    resource: {
      id: name
    }
    options: contains(databaseAccount.properties.capabilities, { name: 'EnableServerless' })
      ? null
      : {
          throughput: autoscaleSettingsMaxThroughput == null ? throughput : null
          autoscaleSettings: autoscaleSettingsMaxThroughput != null
            ? {
                maxThroughput: autoscaleSettingsMaxThroughput
              }
            : null
        }
  }
}

module container 'container/main.bicep' = [
  for container in (containers ?? []): {
    name: '${uniqueString(deployment().name, sqlDatabase.name)}-sqldb-${container.name}'
    params: {
      databaseAccountName: databaseAccountName
      sqlDatabaseName: name
      name: container.name
      analyticalStorageTtl: container.?analyticalStorageTtl
      autoscaleSettingsMaxThroughput: container.?autoscaleSettingsMaxThroughput
      conflictResolutionPolicy: container.?conflictResolutionPolicy
      defaultTtl: container.?defaultTtl
      indexingPolicy: container.?indexingPolicy
      kind: container.?kind
      version: container.?version
      paths: container.?paths
      throughput: (throughput != null || autoscaleSettingsMaxThroughput != null) && container.?throughput == null
        ? -1
        : container.?throughput
      uniqueKeyPolicyKeys: container.?uniqueKeyPolicyKeys
    }
  }
]

@description('The name of the SQL database.')
output name string = sqlDatabase.name

@description('The resource ID of the SQL database.')
output resourceId string = sqlDatabase.id

@description('The name of the resource group the SQL database was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of a container.')
type containerType = {
  @description('Required. Name of the container.')
  name: string

  @description('Optional. Default to 0. Indicates how long data should be retained in the analytical store, for a container. Analytical store is enabled when ATTL is set with a value other than 0. If the value is set to -1, the analytical store retains all historical data, irrespective of the retention of the data in the transactional store.')
  analyticalStorageTtl: int?

  @description('Optional. The conflict resolution policy for the container. Conflicts and conflict resolution policies are applicable if the Azure Cosmos DB account is configured with multiple write regions.')
  conflictResolutionPolicy: resourceInput<'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2025-04-15'>.properties.resource.conflictResolutionPolicy?

  @maxValue(2147483647)
  @minValue(-1)
  @description('Optional. Default to -1. Default time to live (in seconds). With Time to Live or TTL, Azure Cosmos DB provides the ability to delete items automatically from a container after a certain time period. If the value is set to "-1", it is equal to infinity, and items don\'t expire by default.')
  defaultTtl: int?

  @description('Optional. Default to 400. Request Units per second. Will be ignored if autoscaleSettingsMaxThroughput is used. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level.')
  throughput: int?

  @maxValue(1000000)
  @description('Optional. Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level.')
  autoscaleSettingsMaxThroughput: int?

  @description('Optional. Tags of the SQL Database resource.')
  tags: resourceInput<'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2025-04-15'>.tags?

  @maxLength(3)
  @minLength(1)
  @description('Required. List of paths using which data within the container can be partitioned. For kind=MultiHash it can be up to 3. For anything else it needs to be exactly 1.')
  paths: string[]

  @description('Optional. Indexing policy of the container.')
  indexingPolicy: resourceInput<'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2025-04-15'>.properties.resource.indexingPolicy?

  @description('Optional. The unique key policy configuration containing a list of unique keys that enforces uniqueness constraint on documents in the collection in the Azure Cosmos DB service.')
  uniqueKeyPolicyKeys: resourceInput<'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2025-04-15'>.properties.resource.uniqueKeyPolicy.uniqueKeys?

  @description('Optional. Default to Hash. Indicates the kind of algorithm used for partitioning.')
  kind: ('Hash' | 'MultiHash')?

  @description('Optional. Default to 1 for Hash and 2 for MultiHash - 1 is not allowed for MultiHash. Version of the partition key definition.')
  version: (1 | 2)?
}
