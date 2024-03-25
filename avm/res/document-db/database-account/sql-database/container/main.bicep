metadata name = 'DocumentDB Database Account SQL Database Containers'
metadata description = 'This module deploys a SQL Database Container in a CosmosDB Account.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Database Account. Required if the template is used in a standalone deployment.')
param databaseAccountName string

@description('Conditional. The name of the parent SQL Database. Required if the template is used in a standalone deployment.')
param sqlDatabaseName string

@description('Required. Name of the container.')
param name string

@description('Optional. Default to 0. Indicates how long data should be retained in the analytical store, for a container. Analytical store is enabled when ATTL is set with a value other than 0. If the value is set to -1, the analytical store retains all historical data, irrespective of the retention of the data in the transactional store.')
param analyticalStorageTtl int = 0

@description('Optional. The conflict resolution policy for the container. Conflicts and conflict resolution policies are applicable if the Azure Cosmos DB account is configured with multiple write regions.')
param conflictResolutionPolicy object = {}

@maxValue(2147483647)
@minValue(-1)
@description('Optional. Default to -1. Default time to live (in seconds). With Time to Live or TTL, Azure Cosmos DB provides the ability to delete items automatically from a container after a certain time period. If the value is set to "-1", it is equal to infinity, and items don\'t expire by default.')
param defaultTtl int = -1

@description('Optional. Default to 400. Request Units per second. Will be ignored if autoscaleSettingsMaxThroughput is used.')
param throughput int = 400

@maxValue(1000000)
@description('Optional. Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled.')
param autoscaleSettingsMaxThroughput int?

@description('Optional. Tags of the SQL Database resource.')
param tags object?

@maxLength(3)
@minLength(1)
@description('Required. List of paths using which data within the container can be partitioned. For kind=MultiHash it can be up to 3. For anything else it needs to be exactly 1.')
param paths string[]

@description('Optional. Indexing policy of the container.')
param indexingPolicy object = {}

@description('Optional. The unique key policy configuration containing a list of unique keys that enforces uniqueness constraint on documents in the collection in the Azure Cosmos DB service.')
param uniqueKeyPolicyKeys array = []

@description('Optional. Default to Hash. Indicates the kind of algorithm used for partitioning.')
@allowed([
  'Hash'
  'MultiHash'
  'Range'
])
param kind string = 'Hash'

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' existing = {
  name: databaseAccountName

  resource sqlDatabase 'sqlDatabases@2023-04-15' existing = {
    name: sqlDatabaseName
  }
}

resource container 'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers@2023-04-15' = {
  name: name
  parent: databaseAccount::sqlDatabase
  tags: tags
  properties: {
    resource: {
      analyticalStorageTtl: analyticalStorageTtl // please note that this property is not idempotent
      conflictResolutionPolicy: conflictResolutionPolicy
      defaultTtl: defaultTtl
      id: name
      indexingPolicy: !empty(indexingPolicy) ? indexingPolicy : null
      partitionKey: {
        paths: [for path in paths: startsWith(path, '/') ? path : '/${path}']
        kind: kind
        version: kind == 'MultiHash' ? 2 : 1
      }
      uniqueKeyPolicy: !empty(uniqueKeyPolicyKeys) ? {
        uniqueKeys: uniqueKeyPolicyKeys
      } : null
    }
    options: contains(databaseAccount.properties.capabilities, { name: 'EnableServerless' }) ? null : {
      throughput: autoscaleSettingsMaxThroughput == null && throughput != -1 ? throughput : null
      autoscaleSettings: autoscaleSettingsMaxThroughput != null ? {
        maxThroughput: autoscaleSettingsMaxThroughput
      } : null
    }
  }
}

@description('The name of the container.')
output name string = container.name

@description('The resource ID of the container.')
output resourceId string = container.id

@description('The name of the resource group the container was created in.')
output resourceGroupName string = resourceGroup().name
