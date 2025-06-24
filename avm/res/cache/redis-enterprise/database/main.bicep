metadata name = 'Redis database'
metadata description = 'This module deploys a Redis database in a Redis Enterprise or Azure Managed Redis cluster.'

@description('Conditional. The name of the parent Redis Enterprise or Azure Managed Redis resource. Required if the template is used in a standalone deployment.')
param redisClusterName string

@allowed([
  'default'
])
@description('Optional. Name of the database.')
param name string = 'default'

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Allow authentication via access keys. Only supported on Azure Managed Redis SKUs: Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized.')
param accessKeysAuthentication string = 'Enabled'

@allowed([
  'Encrypted'
  'Plaintext'
])
@description('Optional. Specifies whether Redis clients can connect using TLS-encrypted or plaintext Redis protocols.')
param clientProtocol string = 'Encrypted'

@allowed([
  'EnterpriseCluster'
  'NoCluster'
  'OSSCluster'
])
@description('Optional. Redis clustering policy. [Learn more](https://learn.microsoft.com/azure/redis/architecture#cluster-policies).')
param clusteringPolicy string = 'OSSCluster'

@allowed([
  'Deferred'
  'NotDeferred'
])
@description('Optional. Specifies whether to defer future Redis major version upgrades by up to 90 days. [Learn more](https://aka.ms/redisversionupgrade#defer-upgrades).')
param deferUpgrade string = 'NotDeferred'

@allowed([
  'AllKeysLFU'
  'AllKeysLRU'
  'AllKeysRandom'
  'NoEviction'
  'VolatileLFU'
  'VolatileLRU'
  'VolatileRandom'
  'VolatileTTL'
])
@description('Optional. Specifies the eviction policy for the Redis resource.')
param evictionPolicy string = 'VolatileLRU'

@description('Optional. The active geo-replication settings of the service. All caches within a geo-replication group must have the same configuration.')
param geoReplication geoReplicationType?

@description('Optional. Redis modules to enable. Restrictions may apply based on SKU and configuration. [Learn more](https://aka.ms/redis/enterprise/modules).')
param modules moduleType[] = []

@description('Optional. TCP port of the database endpoint.')
@minValue(10000)
@maxValue(10000)
param port int = 10000

@description('Optional. The persistence settings of the service. THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/azure/redis/how-to-persistence) FOR CLARIFICATION.')
param persistence persistenceType = {
  type: 'disabled'
}

@description('Optional. Access policy assignments for Microsoft Entra authentication. Only supported on Azure Managed Redis SKUs: Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized.')
param accessPolicyAssignments accessPolicyAssignmentType[]?

@description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
param secretsExportConfiguration secretsExportConfigurationType?

import { diagnosticSettingLogsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The database-level diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingLogsOnlyType[]?

// ============== //
// Resources      //
// ============== //

resource redisCluster 'Microsoft.Cache/redisEnterprise@2025-05-01-preview' existing = {
  name: redisClusterName
}

var clusterSku = redisCluster.sku.name
var isAmr = startsWith(clusterSku, 'Balanced') || startsWith(clusterSku, 'ComputeOptimized') || startsWith(
  clusterSku,
  'FlashOptimized'
) || startsWith(clusterSku, 'MemoryOptimized')

resource redisDatabase 'Microsoft.Cache/redisEnterprise/databases@2025-05-01-preview' = {
  parent: redisCluster
  name: name
  properties: {
    accessKeysAuthentication: isAmr ? accessKeysAuthentication : null
    clientProtocol: clientProtocol
    clusteringPolicy: clusteringPolicy
    deferUpgrade: deferUpgrade
    evictionPolicy: evictionPolicy
    geoReplication: !empty(geoReplication) ? geoReplication : null
    modules: modules
    port: port
    persistence: persistence.type != 'disabled'
      ? {
          aofEnabled: persistence.type == 'aof'
          rdbEnabled: persistence.type == 'rdb'
          aofFrequency: persistence.type == 'aof' ? persistence.frequency : null
          rdbFrequency: persistence.type == 'rdb' ? persistence.frequency : null
        }
      : null
  }
}

module database_accessPolicyAssignments 'access-policy-assignment/main.bicep' = [
  for (assignment, index) in (accessPolicyAssignments ?? []): {
    name: '${uniqueString(deployment().name)}-redis-apa-${index}'
    params: {
      name: assignment.name
      clusterName: redisCluster.name
      databaseName: redisDatabase.name
      accessPolicyName: assignment.?accessPolicyName
      userObjectId: assignment.userObjectId
    }
  }
]

resource database_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: redisDatabase
  }
]

module secretsExport 'modules/keyVaultExport.bicep' = if (secretsExportConfiguration != null) {
  name: '${uniqueString(deployment().name)}-secrets-kv'
  scope: resourceGroup(
    split(secretsExportConfiguration.?keyVaultResourceId!, '/')[2],
    split(secretsExportConfiguration.?keyVaultResourceId!, '/')[4]
  )
  params: {
    keyVaultName: last(split(secretsExportConfiguration.?keyVaultResourceId!, '/'))
    secretsToSet: union(
      [],
      contains(secretsExportConfiguration!, 'primaryAccessKeyName')
        ? [
            {
              name: secretsExportConfiguration!.?primaryAccessKeyName
              value: redisDatabase.listKeys().primaryKey
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'primaryConnectionStringName')
        ? [
            {
              name: secretsExportConfiguration!.?primaryConnectionStringName
              value: '${redisDatabase.properties.clientProtocol == 'Plaintext' ? 'redis://' : 'rediss://' }:${redisDatabase.listKeys().primaryKey}@${redisCluster.properties.hostName}:${redisDatabase.properties.port}'
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'primaryStackExchangeRedisConnectionStringName')
        ? [
            {
              name: secretsExportConfiguration!.?primaryStackExchangeRedisConnectionStringName
              value: '${redisCluster.properties.hostName}:${redisDatabase.properties.port},password=${redisDatabase.listKeys().primaryKey},ssl=${redisDatabase.properties.clientProtocol == 'Plaintext' ? 'False' : 'True'},abortConnect=False'
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'secondaryAccessKeyName')
        ? [
            {
              name: secretsExportConfiguration!.?secondaryAccessKeyName
              value: redisDatabase.listKeys().secondaryKey
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'secondaryConnectionStringName')
        ? [
            {
              name: secretsExportConfiguration!.?secondaryConnectionStringName
              value: '${redisDatabase.properties.clientProtocol == 'Plaintext' ? 'redis://' : 'rediss://' }:${redisDatabase.listKeys().secondaryKey}@${redisCluster.properties.hostName}:${redisDatabase.properties.port}'
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'secondaryStackExchangeRedisConnectionStringName')
        ? [
            {
              name: secretsExportConfiguration!.?secondaryStackExchangeRedisConnectionStringName
              value: '${redisCluster.properties.hostName}:${redisDatabase.properties.port},password=${redisDatabase.listKeys().secondaryKey},ssl=${redisDatabase.properties.clientProtocol == 'Plaintext' ? 'False' : 'True'},abortConnect=False'
            }
          ]
        : []
    )
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the Redis database.')
output name string = redisDatabase.name

@description('The resource ID of the database.')
output resourceId string = redisDatabase.id

@description('The name of the resource group the Redis resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The Redis database port.')
output port int = redisDatabase.properties.port

@description('The Redis host name.')
output hostname string = redisCluster.properties.hostName

@description('The Redis endpoint.')
output endpoint string = '${redisCluster.properties.hostName}:${redisDatabase.properties.port}'

import { secretsOutputType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret\'s name.')
output exportedSecrets secretsOutputType = (secretsExportConfiguration != null)
  ? toObject(secretsExport.outputs.secretsSet, secret => last(split(secret.secretResourceId, '/')), secret => secret)
  : {}

// =============== //
//   Definitions   //
// =============== //

@export()
type secretsExportConfigurationType = {
  @description('Required. The resource ID of the key vault where to store the secrets of this module.')
  keyVaultResourceId: string

  @description('Optional. The primaryAccessKey secret name to create.')
  primaryAccessKeyName: string?

  @description('Optional. The primaryConnectionString secret name to create.')
  primaryConnectionStringName: string?

  @description('Optional. The primaryStackExchangeRedisConnectionString secret name to create.')
  primaryStackExchangeRedisConnectionStringName: string?

  @description('Optional. The secondaryAccessKey secret name to create.')
  secondaryAccessKeyName: string?

  @description('Optional. The secondaryConnectionString secret name to create.')
  secondaryConnectionStringName: string?

  @description('Optional. The secondaryStackExchangeRedisConnectionString secret name to create.')
  secondaryStackExchangeRedisConnectionStringName: string?
}

@export()
type disabledPersistenceType = {
  @description('Required. Disabled persistence type.')
  type: 'disabled'
}

@export()
type aofPersistenceType = {
  @description('Required. AOF persistence type.')
  type: 'aof'

  @description('Required. The frequency at which data is written to disk.')
  frequency: '1s'
}

@export()
type rdbPersistenceType = {
  @description('Required. RDB persistence type.')
  type: 'rdb'

  @description('Required. The frequency at which an RDB snapshot of the database is created.')
  frequency: '1h' | '6h' | '12h'
}

@export()
@discriminator('type')
type persistenceType = disabledPersistenceType | aofPersistenceType | rdbPersistenceType

@export()
type moduleType = {
  @description('Required. The name of the module.')
  name: ('RedisBloom' | 'RedisTimeSeries' | 'RedisJSON' | 'RediSearch')

  @description('Optional. Additional module arguments.')
  args: string?
}

@export()
type geoReplicationType = {
  @description('Required. The name of the geo-replication group.')
  groupNickname: string

  @description('Required. List of database resources to link with this database, including itself.')
  linkedDatabases: linkedDatabaseType[]
}

@export()
type linkedDatabaseType = {
  @description('Required. Resource ID of linked database. Should be in the form: `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cache/redisEnterprise/{redisName}/databases/default`.')
  id: string
}

@export()
type accessPolicyAssignmentType = {
  @description('Optional. Name of the access policy assignment.')
  name: string?

  @description('Required. Object ID to which the access policy will be assigned.')
  userObjectId: string

  @description('Optional. Name of the access policy to be assigned. The current only allowed name is \'default\'.')
  accessPolicyName: ('default')?
}
