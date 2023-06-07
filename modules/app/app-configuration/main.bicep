@description('Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.. Default is the location of the resource group.')
param location string = resourceGroup().location

@description('Prefix of appconf resource name. Not used if name is provided.')
param prefix string = 'appconf'

@minLength(5)
@maxLength(50)
@description('Specifies the name of the App Configuration instance. Changing this forces a new resource to be created. It must me unique across Azure. Valid characters: Alphanumerics,underscores, and hyphens.')
param name string = '${prefix}-${uniqueString(resourceGroup().id, subscription().id)}'

@description('The SKU name of the configuration store.')
@allowed(['Free', 'Standard'])
param skuName string = 'Free'

@description('Indicates whether the configuration store need to be recovered.')
@allowed(['Default', 'Recover'])
param createMode string = 'Default'

@minValue(1)
@maxValue(7)
@description('The amount of time in days that the configuration store will be retained when it is soft deleted.  This field only works for "Standard" sku.')
param softDeleteRetentionInDays int = 7

@description('The Public Network Access setting of the App Configuration store. When Disabled, only requests from Private Endpoints can access the App Configuration store.')
@allowed(['Enabled', 'Disabled'])
param publicNetworkAccess string = 'Enabled'

@description('Disables all authentication methods other than AAD authentication.')
param disableLocalAuth bool = false

@description('Enables the purge protection feature for the configuration store.  This field only works for "Standard" sku.')
param enablePurgeProtection bool = false

@description('List of key-value pair to add in the appConfiguration.')
param appConfigurationStoreKeyValues appConfigurationStoreKeyValueType[] = []

@description('The configuration used to encrypt the data in the configuration store.')
param appConfigEncryption keyVaultPropertiesType = {}

@description('The list of replicas for the configuration store with "name" and "location" parameters.')
param replicas array = []

@description('The key-value pair tags to associate with the resource.')
param tags object = {}

@description('TSpecifies the type of Managed Service Identity that should be configured on this App Configuration. The type "SystemAssigned, UserAssigned" includes both an implicitly created identity and a set of user-assigned identities.')
@allowed(['None', 'SystemAssigned', 'SystemAssigned,UserAssigned', 'UserAssigned'])
param identityType string = 'None'

@description('The list of user-assigned managed identities. The user identity dictionary key references will be ARM resource ids in the form: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}"')
param userAssignedIdentities object = {}

@description('Specify the type of lock on app conf resource.')
@allowed(['CanNotDelete', 'NotSpecified', 'ReadOnly'])
param lock string = 'NotSpecified'

@description('Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11"')
param roleAssignments roleAssignmentsType[] = []

@description('Private Endpoints that should be created for app conf.')
param privateEndpoints array = []

var varPrivateEndpoints = [for endpoint in privateEndpoints: {
  name: '${appConfiguration.name}-${endpoint.name}'
  privateLinkServiceId: appConfiguration.id
  groupIds: [
    'configurationStores'
  ]
  subnetId: endpoint.subnetId
  privateDnsZoneConfigs: endpoint.?privateDnsZoneConfigs ?? []
  customNetworkInterfaceName: endpoint.?customNetworkInterfaceName
  manualApprovalEnabled: endpoint.?manualApprovalEnabled ?? false
}]

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2023-03-01' = {
  name: name
  location: location
  sku: {
    name: skuName
  }
  properties: {
    createMode: createMode
    publicNetworkAccess: publicNetworkAccess
    disableLocalAuth: disableLocalAuth
    enablePurgeProtection: (skuName == 'Standard' && enablePurgeProtection) ? true : false
    encryption: {
      keyVaultProperties: {
        keyIdentifier: appConfigEncryption.?keyIdentifier
        identityClientId: appConfigEncryption.?identityClientId
      }
    }
    softDeleteRetentionInDays: (skuName == 'Standard') ? softDeleteRetentionInDays : null
  }
  tags: tags
  identity: contains(identityType, 'UserAssigned') ? {
    type: identityType
    userAssignedIdentities: contains(identityType, 'UserAssigned') ? userAssignedIdentities : {}
  } : { type: identityType }
}

@batchSize(1)
resource appConfigurationReplicas 'Microsoft.AppConfiguration/configurationStores/replicas@2023-03-01' = [for replica in replicas: {
  name: replica.name
  parent: appConfiguration
  location: replica.location
}]

resource appConfigurationStoreKeyValue 'Microsoft.AppConfiguration/configurationStores/keyValues@2023-03-01' = [ for appConfig in appConfigurationStoreKeyValues: {
  name: appConfig.name
  parent: appConfiguration
  properties: {
    contentType: appConfig.?contentType
    tags: appConfig.?tags
    value: appConfig.?value
  }
}]

// diagnostic settings
@description('Provide appConfiguration diagnostic settings properties.')
param diagnosticSettingsProperties diagnosticSettingsPropertiesType = {}

@description('Enable appConfiguration diagnostic settings resource.')
var enableAppConfigurationDiagnosticSettings  = (empty(diagnosticSettingsProperties.?diagnosticReceivers.?workspaceId) && empty(diagnosticSettingsProperties.?diagnosticReceivers.?eventHub) && empty(diagnosticSettingsProperties.?diagnosticReceivers.?storageAccountId) && empty(diagnosticSettingsProperties.?diagnosticReceivers.?marketplacePartnerId)) ? false : true

resource appConfigurationDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if  (enableAppConfigurationDiagnosticSettings) {
  name: '${name}-diagnostic-settings'
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
  scope: appConfiguration
}

module appConfigurationRbac 'modules/rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${name}-rbac-${index}'
  params: {
    description: roleAssignment.?description ?? ''
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: roleAssignment.?principalType ?? ''
    resourceId: appConfiguration.id
  }
}]

module appConfigurationPrivateEndpoint 'modules/privateEndpoint.bicep' = {
  name: '${name}-private-endpoints'
  params: {
    location: location
    privateEndpoints: varPrivateEndpoints
    tags: tags
  }
}

resource appConfigurationLock 'Microsoft.Authorization/locks@2020-05-01' = if (lock != 'NotSpecified') {
  name: '${name}-lock'
  scope: appConfiguration
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
}

@description('The resource id of the App Configuration instance.')
output id string = appConfiguration.id

@description('The name of the App Configuration instance.')
output name string = appConfiguration.name

@description('Object Id of system assigned managed identity for app configuration (if enabled).')
output systemAssignedIdentityPrincipalId string = contains(identityType, 'SystemAssigned') ? appConfiguration.identity.principalId : ''


// user defined types
@description('Create a key-value pair in appConfiguration.')
type appConfigurationStoreKeyValueType = {
  name: string
  @description('See as examples: https://learn.microsoft.com/en-us/azure/azure-app-configuration/howto-leverage-json-content-type#valid-json-content-type')
  contentType: string?
  value: string?
  tags: object?
}

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

@description('Database definition in the postrges instance.')
type databaseType = {
  name: string
  charset: string?
  collation: string?
}

@description('Define role Assignment for appConfiguration')
type roleAssignmentsType = {
  description: string?
  principalIds: array
  roleDefinitionIdOrName: string
  principalType: string?
}

@description('The key vault configuration used to encrypt the data in the configuration store.')
type keyVaultPropertiesType = {
  keyIdentifier: string?
  identityClientId: string?
}
