metadata name = 'Redis Enterprise and Azure Managed Redis (Preview)'
metadata description = 'This module deploys a Redis Enterprise or Azure Managed Redis (Preview) cache.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The name of the cache resource.')
param name string

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

import { managedIdentityOnlyUserAssignedType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Conditional. The managed identity definition for this resource. Required if \'customerManagedKey\' is not empty.')
param managedIdentities managedIdentityOnlyUserAssignedType?

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. The customer managed key definition to use for the managed service.')
param customerManagedKey customerManagedKeyType?

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Specifies whether to enable data replication for high availability. Used only with Azure Managed Redis (Preview) SKUs: Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized. HIGH AVAILABILITY IS A PARAMETER USED FOR A PREVIEW FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/azure/azure-cache-for-redis/managed-redis/managed-redis-high-availability) FOR CLARIFICATION.')
param highAvailability string = 'Enabled'

@allowed([
  '1.2'
])
@description('Optional. The minimum TLS version for the Redis cluster to support.')
param minimumTlsVersion string = '1.2'

@allowed([
  2
  3
  4
  6
  8
  9
  10
])
@description('Optional. Determines the size of the cluster, used only with Enterprise and EnterpriseFlash SKUs. Valid values are (2, 4, 6, 8, 10) for Enterprise SKUs and (3, 9) for EnterpriseFlash SKUs. [Learn more](https://learn.microsoft.com/azure/azure-cache-for-redis/cache-best-practices-enterprise-tiers#sharding-and-cpu-utilization).')
param capacity int = 2

@allowed([
  'Balanced_B0'
  'Balanced_B1'
  'Balanced_B3'
  'Balanced_B5'
  'Balanced_B10'
  'Balanced_B20'
  'Balanced_B50'
  'Balanced_B100'
  'Balanced_B150'
  'Balanced_B250'
  'Balanced_B350'
  'Balanced_B500'
  'Balanced_B700'
  'Balanced_B1000'
  'ComputeOptimized_X3'
  'ComputeOptimized_X5'
  'ComputeOptimized_X10'
  'ComputeOptimized_X20'
  'ComputeOptimized_X50'
  'ComputeOptimized_X100'
  'ComputeOptimized_X150'
  'ComputeOptimized_X250'
  'ComputeOptimized_X350'
  'ComputeOptimized_X500'
  'ComputeOptimized_X700'
  'Enterprise_E1'
  'Enterprise_E5'
  'Enterprise_E10'
  'Enterprise_E20'
  'Enterprise_E50'
  'Enterprise_E100'
  'Enterprise_E200'
  'Enterprise_E400'
  'EnterpriseFlash_F300'
  'EnterpriseFlash_F700'
  'EnterpriseFlash_F1500'
  'FlashOptimized_A250'
  'FlashOptimized_A500'
  'FlashOptimized_A700'
  'FlashOptimized_A1000'
  'FlashOptimized_A1500'
  'FlashOptimized_A2000'
  'FlashOptimized_A4500'
  'MemoryOptimized_M10'
  'MemoryOptimized_M20'
  'MemoryOptimized_M50'
  'MemoryOptimized_M100'
  'MemoryOptimized_M150'
  'MemoryOptimized_M250'
  'MemoryOptimized_M350'
  'MemoryOptimized_M500'
  'MemoryOptimized_M700'
  'MemoryOptimized_M1000'
  'MemoryOptimized_M1500'
  'MemoryOptimized_M2000'
])
@description('Optional. The type of cluster to deploy. Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized SKUs ARE IN PREVIEW, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/azure/azure-cache-for-redis/managed-redis/managed-redis-overview#tiers-and-skus-at-a-glance) FOR CLARIFICATION.')
param skuName string = 'Enterprise_E5'

@allowed([
  1
  2
  3
])
@description('Optional. The Availability Zones to place the resources in. Currently only supported on Enterprise and EnterpriseFlash SKUs.')
param zones int[] = [
  1
  2
  3
]

// ================ //
// Database params  //
// ================ //

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Allow authentication via access keys. THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/azure/azure-cache-for-redis/managed-redis/managed-redis-entra-for-authentication#disable-access-key-authentication-on-your-cache) FOR CLARIFICATION.')
param accessKeysAuthentication string = 'Enabled'

@allowed([
  'Encrypted'
  'Plaintext'
])
@description('Optional. Specifies whether Redis clients can connect using TLS-encrypted or plaintext Redis protocols.')
param clientProtocol string = 'Encrypted'

@allowed([
  'EnterpriseCluster'
  'OSSCluster'
])
@description('Optional. Redis clustering policy. [Learn more](https://aka.ms/redis/enterprise/clustering).')
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
param evictionPolicy string = 'NoEviction'

@description('Optional. The active geo-replication settings of the service. All caches within a geo-replication group must have the same configuration.')
param geoReplication geoReplicationType?

@description('Optional. Redis modules to enable. Restrictions may apply based on SKU and configuration. [Learn more](https://aka.ms/redis/enterprise/modules).')
param modules moduleType[] = []

@description('Optional. The persistence settings of the service.')
param persistence persistenceType = {
  type: 'disabled'
}

// ============ //
// Other params //
// ============ //

@description('Optional. Array of access policy assignments. THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/azure/azure-cache-for-redis/managed-redis/managed-redis-entra-for-authentication) FOR CLARIFICATION.')
param accessPolicyAssignments accessPolicyAssignmentType[] = []

@description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
param secretsExportConfiguration secretsExportConfigurationType?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

import { diagnosticSettingLogsOnlyType, diagnosticSettingMetricsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. The cluster-level diagnostic settings of the service.')
param diagnosticSettingsCluster diagnosticSettingMetricsOnlyType[]?

@description('Optional. The database-level diagnostic settings of the service.')
param diagnosticSettingsDatabase diagnosticSettingLogsOnlyType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var isAmr = startsWith(skuName, 'Balanced') || startsWith(skuName, 'ComputeOptimized') || startsWith(
  skuName,
  'FlashOptimized'
) || startsWith(skuName, 'MemoryOptimized')
var isEnterprise = startsWith(skuName, 'Enterprise') || startsWith(skuName, 'EnterpriseFlash')

var availabilityZones = isEnterprise ? map(zones, zone => string(zone)) : []

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: !empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None'
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Redis Cache Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'e0f68234-74aa-48ed-b826-c38b57376e17'
  )
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.cache-redisenterprise.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId ?? 'dummyMsi', '/'))
  scope: resourceGroup(
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '////'), '/')[4]
  )
}

resource redisCluster 'Microsoft.Cache/redisEnterprise@2024-09-01-preview' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    encryption: !empty(customerManagedKey)
      ? {
          customerManagedKeyEncryption: {
            keyEncryptionKeyIdentity: !empty(customerManagedKey.?userAssignedIdentityResourceId)
              ? {
                  identityType: 'userAssignedIdentity'
                  userAssignedIdentityResourceId: cMKUserAssignedIdentity.id
                }
              : null
            keyEncryptionKeyUrl: !empty(customerManagedKey.?keyVersion ?? '')
              ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.keyVersion}'
              : cMKKeyVault::cMKKey.properties.keyUriWithVersion
          }
        }
      : null
    highAvailability: isAmr ? highAvailability : null
    minimumTlsVersion: minimumTlsVersion
  }
  sku: {
    capacity: isEnterprise ? capacity : null
    name: skuName
  }
  zones: !empty(availabilityZones) ? availabilityZones : null
}

resource redisDatabase 'Microsoft.Cache/redisEnterprise/databases@2024-09-01-preview' = {
  parent: redisCluster
  name: 'default'
  properties: {
    accessKeysAuthentication: isAmr ? accessKeysAuthentication : null
    clientProtocol: clientProtocol
    clusteringPolicy: clusteringPolicy
    deferUpgrade: deferUpgrade
    evictionPolicy: evictionPolicy
    geoReplication: !empty(geoReplication) ? geoReplication : null
    modules: modules
    port: 10000
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

resource redisDatabase_accessPolicyAssignments 'Microsoft.Cache/redisEnterprise/databases/accessPolicyAssignments@2024-09-01-preview' = [
  for assignment in (isAmr ? accessPolicyAssignments : []): {
    name: assignment.objectId
    parent: redisDatabase
    properties: {
      user: {
        objectId: assignment.objectId
      }
      accessPolicyName: assignment.accessPolicyName
    }
  }
]

resource redisCluster_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: redisCluster
}

resource redisCluster_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettingsCluster ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: redisCluster
  }
]

resource redisDatabase_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettingsDatabase ?? []): {
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

resource redisCluster_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(redisCluster.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: redisCluster
  }
]

module redisEnterprise_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.9.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-redisEnterprise-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(redisCluster.id, '/'))}-${privateEndpoint.?service ?? 'redisEnterprise'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(redisCluster.id, '/'))}-${privateEndpoint.?service ?? 'redisEnterprise'}-${index}'
              properties: {
                privateLinkServiceId: redisCluster.id
                groupIds: [
                  privateEndpoint.?service ?? 'redisEnterprise'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(redisCluster.id, '/'))}-${privateEndpoint.?service ?? 'redisEnterprise'}-${index}'
              properties: {
                privateLinkServiceId: redisCluster.id
                groupIds: [
                  privateEndpoint.?service ?? 'redisEnterprise'
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: privateEndpoint.?enableTelemetry ?? enableTelemetry
      location: privateEndpoint.?location ?? reference(
        split(privateEndpoint.subnetResourceId, '/subnets/')[0],
        '2020-06-01',
        'Full'
      ).location
      lock: privateEndpoint.?lock ?? lock
      privateDnsZoneGroup: privateEndpoint.?privateDnsZoneGroup
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

module secretsExport 'modules/keyVaultExport.bicep' = if (secretsExportConfiguration != null) {
  name: '${uniqueString(deployment().name, location)}-secrets-kv'
  scope: resourceGroup(
    split((secretsExportConfiguration.?keyVaultResourceId ?? '//'), '/')[2],
    split((secretsExportConfiguration.?keyVaultResourceId ?? '////'), '/')[4]
  )
  params: {
    keyVaultName: last(split(secretsExportConfiguration.?keyVaultResourceId ?? '//', '/'))
    secretsToSet: union(
      [],
      contains(secretsExportConfiguration!, 'primaryAccessKeyName')
        ? [
            {
              name: secretsExportConfiguration!.primaryAccessKeyName
              value: redisDatabase.listKeys().primaryKey
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'primaryConnectionStringName')
        ? [
            {
              name: secretsExportConfiguration!.primaryConnectionStringName
              value: '${redisDatabase.properties.clientProtocol == 'Plaintext' ? 'redis://' : 'rediss://' }:${redisDatabase.listKeys().primaryKey}@${redisCluster.properties.hostName}:${redisDatabase.properties.port}'
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'secondaryAccessKeyName')
        ? [
            {
              name: secretsExportConfiguration!.secondaryAccessKeyName
              value: redisDatabase.listKeys().secondaryKey
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'secondaryConnectionStringName')
        ? [
            {
              name: secretsExportConfiguration!.secondaryConnectionStringName
              value: '${redisDatabase.properties.clientProtocol == 'Plaintext' ? 'redis://' : 'rediss://' }:${redisDatabase.listKeys().secondaryKey}@${redisCluster.properties.hostName}:${redisDatabase.properties.port}'
            }
          ]
        : []
    )
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The name of the Redis cluster.')
output name string = redisCluster.name

@description('The resource ID of the Redis cluster.')
output resourceId string = redisCluster.id

@description('The name of the Redis database.')
output dbName string = redisDatabase.name

@description('The resource ID of the database.')
output dbResourceId string = redisDatabase.id

@description('The name of the resource group the Redis resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The Redis endpoint.')
output endpoint string = '${redisCluster.properties.hostName}:${redisDatabase.properties.port}'

@description('The location the resource was deployed into.')
output location string = redisCluster.location

@description('The private endpoints of the Redis resource.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: redisEnterprise_privateEndpoints[i].outputs.name
    resourceId: redisEnterprise_privateEndpoints[i].outputs.resourceId
    groupId: redisEnterprise_privateEndpoints[i].outputs.groupId
    customDnsConfig: redisEnterprise_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceResourceIds: redisEnterprise_privateEndpoints[i].outputs.networkInterfaceResourceIds
  }
]

import { secretsOutputType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret\'s name.')
output exportedSecrets secretsOutputType = (secretsExportConfiguration != null)
  ? toObject(secretsExport.outputs.secretsSet, secret => last(split(secret.secretResourceId, '/')), secret => secret)
  : {}

// =============== //
//   Definitions   //
// =============== //

type disabledPersistenceType = {
  type: 'disabled'
}

type aofPersistenceType = {
  type: 'aof'
  frequency: '1s' | 'always'
}

type rdbPersistenceType = {
  type: 'rdb'
  frequency: '1h' | '6h' | '12h'
}

@discriminator('type')
type persistenceType = disabledPersistenceType | aofPersistenceType | rdbPersistenceType

type moduleType = {
  @description('Required. The name of the module.')
  name: ('RedisBloom' | 'RedisTimeSeries' | 'RedisJSON' | 'RediSearch')

  @description('Optional. Additional module arguments.')
  args: string?
}

type geoReplicationType = {
  @description('Required. The name of the geo-replication group.')
  groupNickname: string
  @description('Required. List of database resources to link with this database, including itself.')
  linkedDatabases: linkedDatabaseType[]
}

type linkedDatabaseType = {
  @description('Required. Resource ID of linked database. Should be in the form: `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Cache/redisEnterprise/{redisName}/databases/default`.')
  id: string
}

type accessPolicyType = {
  @description('Required. Name of the access policy.')
  name: string
  @description('Required. Permissions associated with the access policy.')
  permissions: string
}

type accessPolicyAssignmentType = {
  @description('Required. Object id to which the access policy will be assigned.')
  objectId: string
  @description('Required. Name of the access policy to be assigned. The current only allowed name is \'default\'.')
  accessPolicyName: ('default')
}

@export()
type secretsExportConfigurationType = {
  @description('Required. The resource ID of the key vault where to store the secrets of this module.')
  keyVaultResourceId: string

  @description('Optional. The primaryAccessKey secret name to create.')
  primaryAccessKeyName: string?

  @description('Optional. The primaryConnectionString secret name to create.')
  primaryConnectionStringName: string?

  @description('Optional. The secondaryAccessKey secret name to create.')
  secondaryAccessKeyName: string?

  @description('Optional. The secondaryConnectionString secret name to create.')
  secondaryConnectionStringName: string?
}
