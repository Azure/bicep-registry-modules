metadata name = 'Azure Cache for Redis'
metadata description = 'This module deploys Azure Cache for Redis(Microsoft.Cache/redis) and optionally available integrations.'
metadata owner = 'sumit-salunke'

@description('Optional. The prefix of the Redis cache resource name.')
param prefix string = 'redis-'

@description('Optional. The name of the Redis cache resource.')
param name string = take('${prefix}${uniqueString(resourceGroup().id, location)}', 44)

@description('Optional. Override the name of the server.')
param serverName string = name

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

@description('Optional. All Redis Settings.')
param redisConfiguration redisConfigurationType = {}

@allowed([ '4.0', '6.0' ])
@description('Optional. Redis version. Only major version will be used in PUT/PATCH request with current valid values: (4, 6).')
param redisVersion string = '6.0'

@allowed([ 0, 1, 2, 3, 4, 5, 6 ])
@description('Optional. The size of the Redis cache to deploy. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4).')
param capacity int = 1

@description('Optional. The number of shards to be created on a Premium Cluster Cache. Set 0 to disable this feature.')
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

@description('Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID')
param roleAssignments array = []

@description('Optional. List of firewall rules to create on server.')
param firewallRules firewallRulesType[] = []

@description('Should Zone Redundancy be enabled for this Redis Cache? The target Region must support availability zones, therefore even if this is set true, it will only activate zone redudancy in a supported region. Set this false to disable zone redundancy completely, regardless if a region supports availability zones.')
param zoneRedundancyEnabled bool = true

@description('The number of logical zones to enable for the Redis Cache. The default is 3. The number must be a positive integer from 1 to 3. Use 1 for single-zoned resources. For multi-zoned resources, the value must be less than or equal to the number of supported zones.')
param numberOfZones int = 3

@description('The offset from the starting logical availability zone. An error will be returned if zoneOffset plus numberOfZones exceeds the number of supported zones in the target Region.')
param zoneOffset int = 0

@description('Define Private Endpoints that should be created for Azure Redis Cache.')
param privateEndpoints array = []

@description('Toggle if Private Endpoints manual approval for Azure Redis Cache should be enabled.')
param privateEndpointsApprovalEnabled bool = false

@description(
'''
The predefined schedule for patching redis server. The Patch Window lasts for 5 hours from the start_hour_utc.
If schedule is not specified, the update can happen at any time. See https://docs.microsoft.com/en-us/azure/azure-cache-for-redis/cache-administration#schedule-updates-faq
''')
param redisPatchSchedule redisPatchScheduleType[] = []

@description('Provide mysql diagnostic settings properties.')
param diagnosticSettingsProperties diagnosticSettingsPropertiesType = {}

@description('Enable mysql diagnostic settings resource.')
var enableMysqlDiagnosticSettings  = (empty(diagnosticSettingsProperties.?diagnosticReceivers.?workspaceId) && empty(diagnosticSettingsProperties.?diagnosticReceivers.?eventHub) && empty(diagnosticSettingsProperties.?diagnosticReceivers.?storageAccountId) && empty(diagnosticSettingsProperties.?diagnosticReceivers.?marketplacePartnerId)) ? false : true


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

// Validate the the correct SKU is being used for AZ support and that the user has not disabled zone redundancy
var isZoneRedundant = isPremium && zoneRedundancyEnabled

// Get the number of zones supported in the Region, based on the users supplied configuration
var varZones = isZoneRedundant ? pickZones('Microsoft.Cache', 'redis', location, numberOfZones, zoneOffset) : []

resource redisCache 'Microsoft.Cache/redis@2022-06-01' = {
  name: serverName
  location: location
  tags: tags
  properties: {
    enableNonSslPort: enableNonSslPort
    minimumTlsVersion: minimumTlsVersion
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(publicNetworkAccess) ? 'Disabled' : null)
    redisConfiguration: !empty(redisConfiguration) ? redisConfiguration : null
    redisVersion: redisVersion
    shardCount: isPremium && shardCount >= 1 ? shardCount : null
    replicasPerMaster: isPremium ? replicasPerMaster : null
    replicasPerPrimary: isPremium ? replicasPerPrimary : null
    sku: {
      capacity: capacity
      family: isPremium ? 'P' : 'C'
      name: skuName
    }
    staticIP: !empty(staticIP) ? staticIP : null
    subnetId: !empty(subnetId) ? subnetId : null
    tenantSettings: tenantSettings
  }
  zones: length(varZones) > 0 ? varZones : null
}

// ------ Diagnostics settings -----
resource redisDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enableMysqlDiagnosticSettings) {
  name: '${serverName}-diagnosticSettings'
  properties: {
    eventHubAuthorizationRuleId: diagnosticSettingsProperties.diagnosticReceivers.?eventHub.?eventHubAuthorizationRuleId
    eventHubName:  diagnosticSettingsProperties.diagnosticReceivers.?eventHub.?eventHubName
    logAnalyticsDestinationType: diagnosticSettingsProperties.diagnosticReceivers.?logAnalyticsDestinationType
    logs: diagnosticSettingsProperties.?logs
    marketplacePartnerId: diagnosticSettingsProperties.diagnosticReceivers.?marketplacePartnerId
    metrics: diagnosticSettingsProperties.?metrics
    serviceBusRuleId: diagnosticSettingsProperties.?serviceBusRuleId
    storageAccountId: diagnosticSettingsProperties.diagnosticReceivers.?storageAccountId
    workspaceId: diagnosticSettingsProperties.diagnosticReceivers.?workspaceId
  }
  scope: redisCache
}

@batchSize(1)
resource redisFirewall 'Microsoft.Cache/redis/firewallRules@2022-06-01' = [ for firewallRule in firewallRules:  if (!empty(firewallRules)) {
  name: firewallRule.name
  parent: redisCache
  properties: {
    endIP: firewallRule.endIpAddress
    startIP: firewallRule.startIpAddress
  }
}]

module redisRbac 'modules/roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${serverName}-acr-rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    resourceId: redisCache.id
  }
}]

module redisCachePrivateEndpoint 'modules/privateEndpoint.bicep' = if (!empty(varPrivateEndpoints)) {
  name: '${uniqueString(deployment().name, location)}-redis-private-endpoints'
  params: {
    location: location
    privateEndpoints: varPrivateEndpoints
    tags: tags
    manualApprovalEnabled: privateEndpointsApprovalEnabled
  }
}

module redisCachePatchSchedule 'modules/patch-schedule.bicep' = if (!empty(redisPatchSchedule)) {
  name: '${uniqueString(deployment().name, location)}-redis-patch-schedule'
  params: {
    redisCacheName: redisCache.name
    redisPatchSchedule: redisPatchSchedule
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


// user defined type
type redisConfigurationType = {
  @description(
  '''
  If set to true, Redis will not require AUTH to connect.
  NOTE: authNotRequired can only be set to false if a subnet_id is specified;
  and only works if there aren't existing instances within the subnet with enable_authentication set to true.
  ''')
  authNotRequired: string? // Default true
  @description(
  '''
  The maximum memory a Redis instance can use, specified as a percentage of total available memory. Valid values range from 0 to 100.
  Defaults depend on SKU; Basic is 2, Standard is 50, Premium is 200.
  ''')
  'maxmemory-delta': string? // Default null
  @description(
  '''
  How Redis will select what to remove when maxmemory is reached.
  Default is volatile-lru. Available policies are volatile-lru, allkeys-lru, volatile-random, allkeys-random, volatile-ttl, noeviction.
  ''')
  'maxmemory-policy': string? // Default null
  @description(
  '''
  Value in megabytes reserved for non-cache usage e.g. failover.
  Defaults depend on SKU; Basic is 2, Standard is 50, Premium is 200.
  ''')
  'maxmemory-reserved': string? // Default null
  @description(
  '''
  Value in megabytes reserved to accommodate for memory fragmentation.
  Defaults depend on SKU; Basic is 2, Standard is 50, Premium is 200.
  ''')
  'maxfragmentationmemory-reserved': string? // Default null
  @description('Only available when using the Premium SKU. Is Backup Enabled? Default to false.')
  'rdb-backup-enabled': string? // Default 'Disabled'
  @description(
  '''
  Optional but required when rdbBackupEnabled is true
  The Backup Frequency in Minutes.
  Possible values are: 15, 30, 60, 360, 720 and 1440.
  ''')
  'rdb-backup-frequency': string? // Default null
  @description(
  '''
  (Optional but required when rdbBackupEnabled is true)
  The maximum number of snapshots to create as a backup.
  ''')
  'rdb-backup-max-snapshot-count': string? // Default null
  @description('''
  (Optional but required when rdbBackupEnabled is true)
  The Connection String to the Storage Account.  In the format: DefaultEndpointsProtocol=https;BlobEndpoint=my_primary_blob_endpoint;AccountName=my_sa_name;AccountKey=my_primary_access_key.
  The maximum number of snapshots to retain on disk.
  ''')
  'rdb-storage-connection-string': string? // Default null
}

type redisPatchScheduleType = {
  @description('The day of the week when a cache can be patched. Possible values are Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday.')
  dayOfWeek: string
  @description('The start hour after which cache patching can start.')
  startHourUtc: int
  @description('ISO8601 timespan specifying how much time cache patching can take.')
  maintenanceWindow: int?
}


@description('The retention policy for this log or metric.')
type diagnosticSettingsRetentionPolicyType = {
  @description('the number of days for the retention in days. A value of 0 will retain the events indefinitely.')
  days: int
  @description('a value indicating whether the retention policy is enabled.')
  enabled: bool
}

@description('The list of log settings.')
type diagnosticSettingsLogsType = {
  @description('Name of a Diagnostic Log category for a resource type this setting is applied to. e.g. \'ConnectedClientList\'')
  category: string?
  @description('Create firewall rule before the virtual network has vnet service endpoint enabled.')
  categoryGroup: string?
  @description('A value indicating whether this log is enabled.')
  enabled: bool
  retentionPolicy: diagnosticSettingsRetentionPolicyType?
}

@description('The list of metric settings.')
type diagnosticSettingsMetricsType = {
  @description('Name of a Diagnostic Metric category for a resource type this setting is applied to. \'AllMetrics\'')
  category: string?
  @description('A value indicating whether this metric is enabled.')
  enabled: bool
  retentionPolicy: diagnosticSettingsRetentionPolicyType?
  @description('the timegrain of the metric in ISO8601 format.')
  timeGrain: string?
}

@description('The settings required to use EventHub.')
type diagnosticSettingsEventHubType = {
  @description('The resource Id for the event hub authorization rule.')
  eventHubAuthorizationRuleId: string
  @description('The name of the event hub.')
  eventHubName: string
}

@description('Destiantion options.')
type diagnosticSettingsReceiversType = {
  eventHub: diagnosticSettingsEventHubType?
  @description('A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or a target type created as follows: {normalized service identity}_{normalized category name}.')
  logAnalyticsDestinationType: string?
  @description('The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerId: string?
  @description('The resource ID of the storage account to which you would like to send Diagnostic Logs.')
  storageAccountId: string?
  @description('The full ARM resource ID of the Log Analytics workspace to which you would like to send Diagnostic Logs.')
  workspaceId: string?
}

type diagnosticSettingsPropertiesType = {
  logs: diagnosticSettingsLogsType[]?
  metrics: diagnosticSettingsMetricsType[]?
  @description('The service bus rule Id of the diagnostic setting. This is here to maintain backwards compatibility.')
  serviceBusRuleId: string?
  diagnosticReceivers: diagnosticSettingsReceiversType?
}

type firewallRulesType = {
  @minLength(1)
  @maxLength(128)
  @description('The resource name.')
  name: string
  @description('The start IP address of the server firewall rule. Must be IPv4 format.')
  startIpAddress: string
  @description('The end IP address of the server firewall rule. Must be IPv4 format.')
  endIpAddress: string
}
