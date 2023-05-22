@description('Optional.  The location into which your Azure resources should be deployed.')
param location string = resourceGroup().location

@description('Optional. Prefix of postgres resource name. Not used if name is provided.')
param prefix string = 'postgres'

@description('Optional. The name of the Postgresql DB resources. Character limit: 3-44, valid characters: lowercase letters, numbers, and hyphens. It must me unique across Azure.')
param name string = take('${prefix}-${uniqueString(resourceGroup().id, location)}', 44)

@minLength(3)
@maxLength(63)
// Must contain only lowercase letters, hyphens and numbers
// Must contain at least 3 through 63 characters
// Can't start or end with hyphen
@description('Optional. Override the name of the server.')
param serverName string = name

@description('Optional. Deployment tags.')
param tags object = {}

@description('Required. The administrator username of the server. Can only be specified when createMode is \'Default\'.')
// The user name for the admin user can't be azure_superuser, admin, administrator, root, guest, or public
param administratorLogin string

@secure()
@minLength(8)
@maxLength(128)
@description('Required. The administrator login password for the SQL server. Can only be specified when the server is being created.')
param administratorLoginPassword string

@description('Optional. The number of days a backup is retained.')
@minValue(7)
@maxValue(35)
param backupRetentionDays int = 35

@description('Optional. The mode to create a new server.')
@allowed(['Default', 'GeoRestore', 'PointInTimeRestore', 'Replica'])
param createMode string = 'Default'

@description('Optional. List of databases to create on server.')
param databases databaseType[] = []

@description('Optional. List of firewall rules to create on server.')
param firewallRules firewallRulesType[] = []

@description('Optional. List of virtualNetworkRules to create on postgres server.')
param virtualNetworkRules virtualNetworkRuleType[] = []

@description('Optional. Status showing whether the server enabled infrastructure encryption.')
@allowed(['Enabled', 'Disabled'])
param infrastructureEncryption string = 'Disabled'

@description('Optional. Enforce a minimal Tls version for the server.')
@allowed(['TLS1_0', 'TLS1_1', 'TLS1_2', 'TLSEnforcementDisabled'])
param minimalTlsVersion string = 'TLS1_2'

var sslEnforcement = (minimalTlsVersion == 'TLSEnforcementDisabled') ? 'Disabled' : 'Enabled'

@description('Optional. Whether or not public network access is allowed for this server.')
@allowed(['Enabled','Disabled'])
param publicNetworkAccess string = 'Disabled'

@description('Optional. The version of the PostgreSQL server.')
@allowed(['9.5', '9.6', '10', '10.0', '10.2', '11'])
param version string = '11'

@description('Optional. List of privateEndpoints to create on postgres server.')
param privateEndpoints array = []

@description('Optional. Enable or disable geo-redundant backups. It requires at least a GeneralPurpose or MemoryOptimized skuTier.')
@allowed(['Enabled','Disabled'])
param geoRedundantBackup string = 'Disabled'

@description('Optional. Restore point creation time (ISO8601 format), specifying the time to restore from.')
param restorePointInTime string = ''

@description('Optional. List of server configurations to create on server.')
param serverConfigurations array = []

@description('Optional. The name of the sku, typically, tier + family + cores, e.g. B_Gen4_1, GP_Gen5_8.')
param skuName string = 'GP_Gen5_2'

@description('Optional. Azure database for Postgres compute capacity in vCores (2,4,8,16,32)')
param skuCapacity int = 2

@description('Optional. Azure database for Postgres Sku Size ')
param SkuSizeMB int = 5120

@description('Optional. Azure database for Postgres pricing tier')
@allowed(['Basic', 'GeneralPurpose', 'MemoryOptimized'])
param SkuTier string = 'GeneralPurpose'

@description('Optional. Azure database for Postgres sku family')
param skuFamily string = 'Gen5'

@description('Optional. Storage size for Postgresql Single Server. Expressed in Mebibytes. Cannot be scaled down.')
param storageSizeGB int = 32

@description('Optional. The source server resource id to restore from. It\'s required when "createMode" is "GeoRestore" or "Replica" or "PointInTimeRestore".')
param sourceServerResourceId string = ''

@description('Optional. Auto grow of storage.')
param enableStorageAutogrow bool = true

@description('Validate input parameter for storageAutogrow')
var validStorageAutogrow = createMode == 'Replica' ? '' : (enableStorageAutogrow ? 'Enabled' : 'Disabled')

@description('Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11"')
param roleAssignments array = []

var varPrivateEndpoints = [for endpoint in privateEndpoints: {
  name: '${postgresServer.name}-${endpoint.name}'
  privateLinkServiceId: postgresServer.id
  groupIds: [
    endpoint.groupId
  ]
  subnetId: endpoint.subnetId
  privateDnsZoneConfigs: endpoint.?privateDnsZoneConfigs ?? []
  customNetworkInterfaceName: endpoint.?customNetworkInterfaceName ?? null
  manualApprovalEnabled: endpoint.?manualApprovalEnabled ?? false
}]

resource postgresServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: serverName
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: SkuTier
    capacity: skuCapacity
    size: '${SkuSizeMB}'  //a string is expected here but a int for the storageProfile...
    family: skuFamily
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    createMode: createMode
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: version
    sslEnforcement: sslEnforcement
    minimalTlsVersion: minimalTlsVersion
    infrastructureEncryption: infrastructureEncryption
    storageProfile: {
      storageMB: storageSizeGB * 1024
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
      enableStorageAutogrow: validStorageAutogrow ?? null
    }
    publicNetworkAccess: publicNetworkAccess
    sourceServerId: createMode != 'Default' ? sourceServerResourceId : null
    restorePointInTime: createMode == 'PointInTimeRestore' ? restorePointInTime : null
  }
}

@batchSize(1)
resource postgresServerFirewallRules 'Microsoft.DBforPostgreSQL/servers/firewallRules@2017-12-01' = [for firewallRule in firewallRules: {
  name: firewallRule.name
  parent: postgresServer

  properties: {
    startIpAddress: firewallRule.startIpAddress
    endIpAddress: firewallRule.endIpAddress
  }
}]

resource postgresServerVirtualNetworkRules 'Microsoft.DBforPostgreSQL/servers/virtualNetworkRules@2017-12-01' = [for virtualNetworkRule in virtualNetworkRules: {
  name: virtualNetworkRule.name
  properties: {
    ignoreMissingVnetServiceEndpoint: virtualNetworkRule.ignoreMissingVnetServiceEndpoint
    virtualNetworkSubnetId: virtualNetworkRule.virtualNetworkSubnetId
  }
}]

@batchSize(1)
resource postgresServerDatabases 'Microsoft.DBforPostgreSQL/servers/databases@2017-12-01' = [for database in databases: {
  name: database.name
  parent: postgresServer

  properties: {
    charset: database.?charset ?? 'utf32'
    collation: database.?collation ?? 'utf32_general_ci'
  }
}]

@batchSize(1)
resource postgresServerConfig 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = [for configuration in serverConfigurations: {
  name: configuration.name
  dependsOn: [
    postgresServerFirewallRules
  ]
  parent: postgresServer

  properties: {
    value: configuration.value
    source: 'user-override'
  }
}]

@batchSize(1)
module postgresServerRBAC 'modules/rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  dependsOn: [
    postgresServer
  ]
  name: '${serverName}-rbac-${index}'
  params: {
    description: roleAssignment.?description ?? ''
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: roleAssignment.?principalType ?? ''
    serverName: serverName
  }
}]

module postgresServerPrivateEndpoint 'modules/privateEndpoint.bicep' = {
  name: '${serverName}-private-endpoints'
  params: {
    location: location
    privateEndpoints: varPrivateEndpoints
    tags: tags
  }
}

// ------ Diagnostics settings ------
// May the diagnosticSettings become a module? How can I share the type cross module?
@description('Provide postgres diagnostic settings properties.')
param diagnosticSettingsProperties diagnosticSettingsPropertiesType = {}

@description('Enable postgres diagnostic settings resource.')
var enablePostgresDiagnosticSettings  = (empty(diagnosticSettingsProperties.?diagnosticReceivers.?workspaceId) && empty(diagnosticSettingsProperties.?diagnosticReceivers.?eventHub) && empty(diagnosticSettingsProperties.?diagnosticReceivers.?storageAccountId) && empty(diagnosticSettingsProperties.?diagnosticReceivers.?marketplacePartnerId)) ? false : true

resource postgresDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (enablePostgresDiagnosticSettings) {
  name: '${serverName}-diagnostic-settings'
  properties: {
    eventHubAuthorizationRuleId: diagnosticSettingsProperties.diagnosticReceivers.?eventHub.?EventHubAuthorizationRuleId
    eventHubName:  diagnosticSettingsProperties.diagnosticReceivers.?eventHub.?EventHubName
    logAnalyticsDestinationType: diagnosticSettingsProperties.diagnosticReceivers.?logAnalyticsDestinationType
    logs: diagnosticSettingsProperties.?logs
    marketplacePartnerId: diagnosticSettingsProperties.diagnosticReceivers.?marketplacePartnerId
    metrics: diagnosticSettingsProperties.?metrics
    serviceBusRuleId: diagnosticSettingsProperties.?serviceBusRuleId
    storageAccountId: diagnosticSettingsProperties.diagnosticReceivers.?storageAccountId
    workspaceId: diagnosticSettingsProperties.diagnosticReceivers.?workspaceId
  }
  scope: postgresServer
}

@description('The resource group the Postgresql Single Server was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('FQDN of the generated Postgresql Single Server')
output fqdn string = createMode != 'Replica' ? postgresServer.properties.fullyQualifiedDomainName : ''

@description('The resource ID of the Postgresql Single Server.')
output id string = postgresServer.id



// user-defined types
@description('The retention policy for this log or metric.')
type diagnosticSettingsRetentionPolicyType = {
  @description('the number of days for the retention in days. A value of 0 will retain the events indefinitely.')
  days: int
  @description('a value indicating whether the retention policy is enabled.')
  enabled: bool
}

@description('The list of logs settings.')
type diagnosticSettingsLogsType = {
  @description('Name of a Diagnostic Log category for a resource type this setting is applied to.')
  category: string?
  @description('Create firewall rule before the virtual network has vnet service endpoint enabled.')
  categoryGroup: string?
  @description('A value indicating whether this log is enabled.')
  enabled: bool
  @description('The retention policy for this log.')
  retentionPolicy: diagnosticSettingsRetentionPolicyType?
}

@description('The list of metrics settings.')
type diagnosticSettingsMetricsType = {
  @description('Name of a Diagnostic Metric category for a resource type this setting is applied to.')
  category: string?
  @description('A value indicating whether this metric is enabled.')
  enabled: bool
  @description('The retention policy for metric.')
  retentionPolicy: diagnosticSettingsRetentionPolicyType?
  @description('the timegrain of the metric in ISO8601 format.')
  timeGrain: string?
}

@description('The settings required to use EventHub as destination.')
type diagnosticSettingsEventHubType = {
  @description('The resource Id for the event hub authorization rule.')
  EventHubAuthorizationRuleId: string
  @description('The name of the event hub.')
  EventHubName: string
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

type virtualNetworkRuleType = {
  @minLength(1)
  @maxLength(128)
  @description('The resource name.')
  name: string
  @description('Create firewall rule before the virtual network has vnet service endpoint enabled.')
  ignoreMissingVnetServiceEndpoint: bool
  @description('The ARM resource id of the virtual network subnet.')
  virtualNetworkSubnetId: string
}

@description('Optional. Database definition in the postrges instance.')
type databaseType = {
  name: string
  charset: string?
  collation: string?
}
