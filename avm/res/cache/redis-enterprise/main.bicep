metadata name = 'Redis Enterprise and Azure Managed Redis'
metadata description = 'This module deploys a Redis Enterprise or Azure Managed Redis cache.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The name of the cache resource.')
param name string

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

import { managedIdentityOnlyUserAssignedType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Conditional. The managed identity definition for this resource. Required if \'customerManagedKey\' is not empty.')
param managedIdentities managedIdentityOnlyUserAssignedType?

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The customer managed key definition to use for the managed service.')
param customerManagedKey customerManagedKeyType?

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Specifies whether to enable data replication for high availability. Used only with Azure Managed Redis SKUs: Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized.')
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
@description('Optional. The size of the cluster. Only supported on Redis Enterprise SKUs: Enterprise, EnterpriseFlash. Valid values are (2, 4, 6, 8, 10) for Enterprise SKUs and (3, 9) for EnterpriseFlash SKUs. [Learn more](https://learn.microsoft.com/azure/azure-cache-for-redis/cache-best-practices-enterprise-tiers#sharding-and-cpu-utilization).')
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
@description('Optional. The type of cluster to deploy. Some Azure Managed Redis SKUs ARE IN PREVIEW, MICROSOFT MAY NOT PROVIDE SUPPORT FOR THIS, PLEASE CHECK THE [PRODUCT DOCS](https://learn.microsoft.com/azure/redis/overview#choosing-the-right-tier) FOR CLARIFICATION.')
param skuName string = 'Balanced_B5'

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
@description('Optional. Database configuration.')
param database databaseType?

// ============ //
// Other params //
// ============ //

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

import { diagnosticSettingMetricsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The cluster-level diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingMetricsOnlyType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var enableReferencedModulesTelemetry = false

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
  name: last(split(customerManagedKey.?keyVaultResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName!
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[2],
    split(customerManagedKey.?userAssignedIdentityResourceId!, '/')[4]
  )
}

resource redisCluster 'Microsoft.Cache/redisEnterprise@2025-05-01-preview' = {
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
              ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.?keyVersion}'
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

module redisCluster_database 'database/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-redis-database'
  params: {
    name: database.?name
    redisClusterName: redisCluster.name
    accessKeysAuthentication: isAmr ? database.?accessKeysAuthentication : null
    accessPolicyAssignments: isAmr ? database.?accessPolicyAssignments : null
    clientProtocol: database.?clientProtocol
    clusteringPolicy: database.?clusteringPolicy
    deferUpgrade: database.?deferUpgrade
    evictionPolicy: database.?evictionPolicy
    geoReplication: database.?geoReplication
    modules: database.?modules
    port: database.?port
    persistence: database.?persistence
    secretsExportConfiguration: database.?secretsExportConfiguration
    diagnosticSettings: database.?diagnosticSettings
  }
}

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
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
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

module redisEnterprise_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.11.0' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-redis-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
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
      enableTelemetry: enableReferencedModulesTelemetry
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

// ============ //
// Outputs      //
// ============ //

@description('The name of the Redis cluster.')
output name string = redisCluster.name

@description('The resource ID of the Redis cluster.')
output resourceId string = redisCluster.id

@description('The name of the Redis database.')
output databaseName string = redisCluster_database.outputs.name

@description('The resource ID of the database.')
output databaseResourceId string = redisCluster_database.outputs.resourceId

@description('The name of the resource group the Redis resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The Redis host name.')
output hostName string = redisCluster.properties.hostName

@description('The Redis port.')
output port int = redisCluster_database.outputs.port

@description('The Redis endpoint.')
output endpoint string = redisCluster_database.outputs.endpoint

@description('The location the resource was deployed into.')
output location string = redisCluster.location

@description('The private endpoints of the Redis resource.')
output privateEndpoints privateEndpointOutputType[] = [
  for (pe, index) in (privateEndpoints ?? []): {
    name: redisEnterprise_privateEndpoints[index].outputs.name
    resourceId: redisEnterprise_privateEndpoints[index].outputs.resourceId
    groupId: redisEnterprise_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: redisEnterprise_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: redisEnterprise_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

import { secretsOutputType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret\'s name.')
output exportedSecrets secretsOutputType = redisCluster_database.outputs.exportedSecrets

// =============== //
//   Definitions   //
// =============== //

import { diagnosticSettingLogsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
import { geoReplicationType, moduleType, persistenceType, accessPolicyAssignmentType, secretsExportConfigurationType } from 'database/main.bicep'

@export()
type databaseType = {
  @description('Optional. Name of the database.')
  name: ('default')?

  @description('Optional. Allow authentication via access keys.')
  accessKeysAuthentication: ('Disabled' | 'Enabled')?

  @description('Optional. Specifies whether Redis clients can connect using TLS-encrypted or plaintext Redis protocols.')
  clientProtocol: ('Encrypted' | 'Plaintext')?

  @description('Optional. Redis clustering policy. [Learn more](https://aka.ms/redis/enterprise/clustering).')
  clusteringPolicy: ('EnterpriseCluster' | 'NoCluster' | 'OSSCluster')?

  @description('Optional. Specifies whether to defer future Redis major version upgrades by up to 90 days. [Learn more](https://aka.ms/redisversionupgrade#defer-upgrades).')
  deferUpgrade: ('Deferred' | 'NotDeferred')?

  @description('Optional. Specifies the eviction policy for the Redis resource.')
  evictionPolicy: (
    | 'AllKeysLFU'
    | 'AllKeysLRU'
    | 'AllKeysRandom'
    | 'NoEviction'
    | 'VolatileLFU'
    | 'VolatileLRU'
    | 'VolatileRandom'
    | 'VolatileTTL')?

  @description('Optional. The active geo-replication settings of the service. All caches within a geo-replication group must have the same configuration.')
  geoReplication: geoReplicationType?

  @description('Optional. Redis modules to enable. Restrictions may apply based on SKU and configuration. [Learn more](https://aka.ms/redis/enterprise/modules).')
  modules: moduleType[]?

  @description('Optional. TCP port of the database endpoint.')
  @minValue(10000)
  @maxValue(10000)
  port: int?

  @description('Optional. The persistence settings of the service.')
  persistence: persistenceType?

  @description('Optional. Access policy assignments for Microsoft Entra authentication. Only supported on Azure Managed Redis SKUs: Balanced, ComputeOptimized, FlashOptimized, and MemoryOptimized.')
  accessPolicyAssignments: accessPolicyAssignmentType[]?

  @description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
  secretsExportConfiguration: secretsExportConfigurationType?

  @description('Optional. The database-level diagnostic settings of the service.')
  diagnosticSettings: diagnosticSettingLogsOnlyType[]?
}

@export()
type privateEndpointOutputType = {
  @description('The name of the private endpoint.')
  name: string

  @description('The resource ID of the private endpoint.')
  resourceId: string

  @description('The group Id for the private endpoint Group.')
  groupId: string?

  @description('The custom DNS configurations of the private endpoint.')
  customDnsConfigs: {
    @description('FQDN that resolves to private endpoint IP address.')
    fqdn: string?

    @description('A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]

  @description('The IDs of the network interfaces associated with the private endpoint.')
  networkInterfaceResourceIds: string[]
}
