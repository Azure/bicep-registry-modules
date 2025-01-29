metadata name = 'Redis Cache'
metadata description = 'This module deploys a Redis Cache.'

@description('Optional. The location to deploy the Redis cache service.')
param location string = resourceGroup().location

@description('Required. The name of the Redis cache resource.')
param name string

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Disable authentication via access keys.')
param disableAccessKeyAuthentication bool = false

@description('Optional. Specifies whether the non-ssl Redis server port (6379) is enabled.')
param enableNonSslPort bool = false

@allowed([
  '1.0'
  '1.1'
  '1.2'
])
@description('Optional. Requires clients to use a specified TLS version (or higher) to connect.')
param minimumTlsVersion string = '1.2'

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Optional. All Redis Settings. Few possible keys: rdb-backup-enabled,rdb-storage-connection-string,rdb-backup-frequency,maxmemory-delta,maxmemory-policy,notify-keyspace-events,maxmemory-samples,slowlog-log-slower-than,slowlog-max-len,list-max-ziplist-entries,list-max-ziplist-value,hash-max-ziplist-entries,hash-max-ziplist-value,set-max-intset-entries,zset-max-ziplist-entries,zset-max-ziplist-value etc.')
param redisConfiguration object = {}

@allowed([
  '4'
  '6'
])
@description('Optional. Redis version. Only major version will be used in PUT/PATCH request with current valid values: (4, 6).')
param redisVersion string = '6'

@minValue(1)
@description('Optional. The number of replicas to be created per primary.')
param replicasPerMaster int = 3

@minValue(1)
@description('Optional. The number of replicas to be created per primary. Needs to be the same as replicasPerMaster for a Premium Cluster Cache.')
param replicasPerPrimary int = 3

@minValue(1)
@description('Optional. The number of shards to be created on a Premium Cluster Cache.')
param shardCount int = 1

@allowed([
  0
  1
  2
  3
  4
  5
  6
])
@description('Optional. The size of the Redis cache to deploy. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4).')
param capacity int = 1

@allowed([
  'Basic'
  'Premium'
  'Standard'
])
@description('Optional. The type of Redis cache to deploy.')
param skuName string = 'Premium'

@description('Optional. Static IP address. Optionally, may be specified when deploying a Redis cache inside an existing Azure Virtual Network; auto assigned by default.')
param staticIP string = ''

@description('Optional. The full resource ID of a subnet in a virtual network to deploy the Redis cache in.')
param subnetResourceId string = ''

@description('Optional. A dictionary of tenant settings.')
param tenantSettings object = {}

@description('Optional. When true, replicas will be provisioned in availability zones specified in the zones parameter.')
param zoneRedundant bool = true

@description('Optional. If the zoneRedundant parameter is true, replicas will be provisioned in the availability zones specified here. Otherwise, the service will choose where replicas are deployed.')
param zones int[] = [1, 2, 3]

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

@description('Optional. The geo-replication settings of the service. Requires a Premium SKU. Geo-replication is not supported on a cache with multiple replicas per primary. Secondary cache VM Size must be same or higher as compared to the primary cache VM Size. Geo-replication between a vnet and non vnet cache (and vice-a-versa) not supported.')
param geoReplicationObject object = {}

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Array of access policies to create.')
param accessPolicies accessPolicyType[] = []

@description('Optional. Array of access policy assignments.')
param accessPolicyAssignments accessPolicyAssignmentType[] = []

@description('Optional. Key vault reference and secret settings for the module\'s secrets export.')
param secretsExportConfiguration secretsExportConfigurationType?

var availabilityZones = skuName == 'Premium'
  ? zoneRedundant ? !empty(zones) ? zones : pickZones('Microsoft.Cache', 'redis', location, 3) : []
  : []

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.cache-redis.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource redis 'Microsoft.Cache/redis@2024-11-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    disableAccessKeyAuthentication: disableAccessKeyAuthentication
    enableNonSslPort: enableNonSslPort
    minimumTlsVersion: minimumTlsVersion
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? any(publicNetworkAccess)
      : (!empty(privateEndpoints) ? 'Disabled' : null)
    redisConfiguration: !empty(redisConfiguration) ? redisConfiguration : null
    redisVersion: redisVersion
    replicasPerMaster: skuName == 'Premium' ? replicasPerMaster : null
    replicasPerPrimary: skuName == 'Premium' ? replicasPerPrimary : null
    shardCount: skuName == 'Premium' ? shardCount : null // Not supported in free tier
    sku: {
      capacity: capacity
      family: skuName == 'Premium' ? 'P' : 'C'
      name: skuName
    }
    staticIP: !empty(staticIP) ? staticIP : null
    subnetId: !empty(subnetResourceId) ? subnetResourceId : null
    tenantSettings: tenantSettings
  }
  zones: availabilityZones
}

resource redis_accessPolicies 'Microsoft.Cache/redis/accessPolicies@2024-11-01' = [
  for policy in accessPolicies: {
    name: policy.name
    parent: redis
    properties: {
      permissions: policy.permissions
    }
  }
]

resource redis_accessPolicyAssignments 'Microsoft.Cache/redis/accessPolicyAssignments@2024-11-01' = [
  for assignment in accessPolicyAssignments: {
    name: assignment.objectId
    parent: redis
    properties: {
      objectId: assignment.objectId
      objectIdAlias: assignment.objectIdAlias
      accessPolicyName: assignment.accessPolicyName
    }
    dependsOn: [
      redis_accessPolicies
    ]
  }
]

resource redis_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: redis
}

resource redis_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: redis
  }
]

resource redis_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(redis.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: redis
  }
]

module redis_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.10.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-redis-PrivateEndpoint-${index}'
    scope: !empty(privateEndpoint.?resourceGroupResourceId)
      ? resourceGroup(
          split((privateEndpoint.?resourceGroupResourceId ?? '//'), '/')[2],
          split((privateEndpoint.?resourceGroupResourceId ?? '////'), '/')[4]
        )
      : resourceGroup(
          split((privateEndpoint.?subnetResourceId ?? '//'), '/')[2],
          split((privateEndpoint.?subnetResourceId ?? '////'), '/')[4]
        )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(redis.id, '/'))}-${privateEndpoint.?service ?? 'redisCache'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(redis.id, '/'))}-${privateEndpoint.?service ?? 'redisCache'}-${index}'
              properties: {
                privateLinkServiceId: redis.id
                groupIds: [
                  privateEndpoint.?service ?? 'redisCache'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(redis.id, '/'))}-${privateEndpoint.?service ?? 'redisCache'}-${index}'
              properties: {
                privateLinkServiceId: redis.id
                groupIds: [
                  privateEndpoint.?service ?? 'redisCache'
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

module redis_geoReplication 'linked-servers/main.bicep' = if (!empty(geoReplicationObject)) {
  name: '${uniqueString(deployment().name, location)}-redis-LinkedServer'
  params: {
    redisCacheName: redis.name
    name: geoReplicationObject.name
    linkedRedisCacheResourceId: geoReplicationObject.linkedRedisCacheResourceId
    linkedRedisCacheLocation: geoReplicationObject.?linkedRedisCacheLocation
  }
  dependsOn: redis_privateEndpoints
}

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
              name: secretsExportConfiguration!.?primaryAccessKeyName
              value: redis.listKeys().primaryKey
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'primaryConnectionStringName')
        ? [
            {
              name: secretsExportConfiguration!.?primaryConnectionStringName
              value: 'rediss://:${redis.listKeys().primaryKey}@${redis.properties.hostName}:6380'
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'primaryStackExchangeRedisConnectionStringName')
        ? [
            {
              name: secretsExportConfiguration!.?primaryStackExchangeRedisConnectionStringName
              value: '${redis.properties.hostName}:6380,password=${redis.listKeys().primaryKey},ssl=True,abortConnect=False'
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'secondaryAccessKeyName')
        ? [
            {
              name: secretsExportConfiguration!.?secondaryAccessKeyName
              value: redis.listKeys().secondaryKey
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'secondaryConnectionStringName')
        ? [
            {
              name: secretsExportConfiguration!.?secondaryConnectionStringName
              value: 'rediss://:${redis.listKeys().secondaryKey}@${redis.properties.hostName}:6380'
            }
          ]
        : [],
      contains(secretsExportConfiguration!, 'secondaryStackExchangeRedisConnectionStringName')
        ? [
            {
              name: secretsExportConfiguration!.?secondaryStackExchangeRedisConnectionStringName
              value: '${redis.properties.hostName}:6380,password=${redis.listKeys().secondaryKey},ssl=True,abortConnect=False'
            }
          ]
        : []
    )
  }
}

@description('The name of the Redis Cache.')
output name string = redis.name

@description('The resource ID of the Redis Cache.')
output resourceId string = redis.id

@description('The name of the resource group the Redis Cache was created in.')
output resourceGroupName string = resourceGroup().name

@description('Redis hostname.')
output hostName string = redis.properties.hostName

@description('Redis SSL port.')
output sslPort int = redis.properties.sslPort

@description('The full resource ID of a subnet in a virtual network where the Redis Cache was deployed in.')
output subnetResourceId string = !empty(subnetResourceId) ? redis.properties.subnetId : ''

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = redis.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = redis.location

@description('The private endpoints of the Redis Cache.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: redis_privateEndpoints[i].outputs.name
    resourceId: redis_privateEndpoints[i].outputs.resourceId
    groupId: redis_privateEndpoints[i].outputs.?groupId!
    customDnsConfigs: redis_privateEndpoints[i].outputs.customDnsConfigs
    networkInterfaceResourceIds: redis_privateEndpoints[i].outputs.networkInterfaceResourceIds
  }
]

import { secretsOutputType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('A hashtable of references to the secrets exported to the provided Key Vault. The key of each reference is each secret\'s name.')
output exportedSecrets secretsOutputType = (secretsExportConfiguration != null)
  ? toObject(secretsExport.outputs.secretsSet, secret => last(split(secret.secretResourceId, '/')), secret => secret)
  : {}

// =============== //
//   Definitions   //
// =============== //

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

type accessPolicyType = {
  @description('Required. Name of the access policy.')
  name: string
  @description('Required. Permissions associated with the access policy.')
  permissions: string
}

type accessPolicyAssignmentType = {
  @description('Required. Object id to which the access policy will be assigned.')
  objectId: string
  @description('Required. Alias for the target object id.')
  objectIdAlias: string
  @description('Required. Name of the access policy to be assigned.')
  accessPolicyName: string
}

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
