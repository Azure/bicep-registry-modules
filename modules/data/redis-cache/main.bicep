@description('Optional. The prefix of the Redis cache resource name.')
param prefix string = 'redis-'

@description('Optional. The name of the Redis cache resource.')
param name string = '${prefix}${uniqueString(resourceGroup().id, location)}'

@description('Required. The location to deploy the Redis cache service.')
param location string

@description('Optional. Tags of the resource.')
param tags object = {}

@allowed([ 'Basic', 'Premium', 'Standard' ])
@description('Optional. The type of Redis cache to deploy.')
param skuName string = 'Basic'

@description('Optional. Specifies whether the non-ssl Redis server port (6379) is enabled.')
param enableNonSslPort bool = false

@allowed([ '1.0', '1.1', '1.2' ])
@description('Optional. Requires clients to use a specified TLS version (or higher) to connect.')
param minimumTlsVersion string = '1.2'

@description('Optional. Whether or not public network access is allowed for this resource.')
@allowed([ '', 'Enabled', 'Disabled' ])
param publicNetworkAccess string = ''

@description('Optional. All Redis Settings. Few possible keys: rdb-backup-enabled,rdb-storage-connection-string,rdb-backup-frequency,maxmemory-delta,maxmemory-policy,notify-keyspace-events,maxmemory-samples,slowlog-log-slower-than,slowlog-max-len,list-max-ziplist-entries,list-max-ziplist-value,hash-max-ziplist-entries,hash-max-ziplist-value,set-max-intset-entries,zset-max-ziplist-entries,zset-max-ziplist-value etc.')
param redisConfiguration object = {}

@allowed([ '4.0', '6.0' ])
@description('Optional. Redis version. Only major version will be used in PUT/PATCH request with current valid values: (4, 6).')
param redisVersion string = '6.0'

@allowed([ 0, 1, 2, 3, 4, 5, 6 ])
@description('Optional. The size of the Redis cache to deploy. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4).')
param capacity int = 1

@minValue(1)
@description('Optional. The number of shards to be created on a Premium Cluster Cache.')
param shardCount int = 1

@minValue(1)
@description('Optional. Amount of replicas to create per master for this Redis Cache.')
param replicasPerMaster int = 1

@minValue(1)
@description('Optional. Amount of replicas to create per primary for this Redis Cache.')
param replicasPerPrimary int = 1


@description('Optional. Static IP address. Optionally, may be specified when deploying a Redis cache inside an existing Azure Virtual Network; auto assigned by default.')
param staticIP string = ''

@description('Optional. The full resource ID of a subnet in a virtual network to deploy the Redis cache in. Example format: /subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/Microsoft.{Network|ClassicNetwork}/VirtualNetworks/vnet1/subnets/subnet1.')
param subnetId string = ''

@description('Optional. A dictionary of tenant settings.')
param tenantSettings object = {}

@description('Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('The name of logs that will be streamed.')
@allowed([
  'ConnectedClientList'
])
param logsToEnable array = [
  'ConnectedClientList'
]

@description('The name of metrics that will be streamed.')
@allowed([ 'AllMetrics' ])
param metricsToEnable array = [
  'AllMetrics'
]

@description('Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID')
param roleAssignments array = []

@description('Optional.  Firewall rule for the redis cache')
param redisFirewallRules object = {}

@description('Define Private Endpoints that should be created for Azure Redis Cache.')
param privateEndpoints array = []

@description('Toggle if Private Endpoints manual approval for Azure Redis Cache should be enabled.')
param privateEndpointsApprovalEnabled bool = false

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsMetrics = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var varRedisFirewallRules = [for redisFirewallRule in items(redisFirewallRules): {
  redisCacheFirewallRuleName: redisFirewallRule.key
  startIP: redisFirewallRule.value.startIP
  endIP: redisFirewallRule.value.endIP
}]

var varPrivateEndpoints = [for privateEndpoint in privateEndpoints: {
  name: '${privateEndpoint.name}-${redisCache.name}'
  privateLinkServiceId: redisCache.id
  groupIds: [
    'redisCache'
  ]
  subnetId: privateEndpoint.subnetId
  privateDnsZones: contains(privateEndpoint, 'privateDnsZoneId') ? [
    {
      name: 'default'
      zoneId: privateEndpoint.privateDnsZoneId
    }
  ] : []
}]

var isPremium = skuName == 'Premium'

resource redisCache 'Microsoft.Cache/redis@2022-06-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    enableNonSslPort: enableNonSslPort
    minimumTlsVersion: minimumTlsVersion
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(publicNetworkAccess) ? 'Disabled' : null)
    redisConfiguration: !empty(redisConfiguration) ? redisConfiguration : null
    redisVersion: redisVersion
    shardCount: isPremium  ? shardCount : null
    replicasPerMaster: isPremium  ? replicasPerMaster : null
    replicasPerPrimary: isPremium  ? replicasPerPrimary : null
    sku: {
      capacity: capacity
      family: isPremium  ? 'P' : 'C'
      name: skuName
    }
    staticIP: !empty(staticIP) ? staticIP : null
    subnetId: !empty(subnetId) ? subnetId : null
    tenantSettings: tenantSettings
  }
  zones: isPremium  ? pickZones('Microsoft.Cache', 'redis', location, 1) : null
}

resource redis_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: '${redisCache.name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: redisCache
}

resource redis_firewall 'Microsoft.Cache/redis/firewallRules@2022-06-01' = [ for varRedisFirewallRule in varRedisFirewallRules:  if (!empty(redisFirewallRules)) {
  name: varRedisFirewallRule.redisCacheFirewallRuleName
  parent: redisCache
  properties: {
    endIP: varRedisFirewallRule.endIP
    startIP: varRedisFirewallRule.startIP
  }
}]

module redis_rbac 'modules/roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${uniqueString(deployment().name, location)}-acr-rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    resourceId: redisCache.id
  }
}]

module redisCache_privateEndpoint 'modules/privateEndpoint.bicep' = {
  name: '${uniqueString(deployment().name, location)}-redis-private-endpoints'
  params: {
    location: location
    privateEndpoints: varPrivateEndpoints
    tags: tags
    manualApprovalEnabled: privateEndpointsApprovalEnabled
  }
}

@description('The resource name.')
output name string = name

@description('The resource ID.')
output resourceId string = redisCache.id

@description('The name of the resource group the Redis cache was created in.')
output resourceGroupName string = resourceGroup().name

@description('Redis hostname.')
output hostName string = redisCache.properties.hostName

@description('Redis SSL port.')
output sslPort int = redisCache.properties.sslPort

@description('The location the resource was deployed into.')
output location string = redisCache.location
