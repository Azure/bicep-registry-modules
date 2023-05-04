@description('Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created.. Default is the location of the resource group.')
param location string = resourceGroup().location

@minLength(5)
@maxLength(50)
@description('Specifies the name of the App Configuration instance. Changing this forces a new resource to be created. It must me unique across Azure. Valid characters: Alphanumerics,underscores, and hyphens.')
param name string = 'appconf-${uniqueString(resourceGroup().id, subscription().id)}'

@description('The SKU name of the configuration store.')
@allowed([ 'Free', 'Standard' ])
param skuName string = 'Free'

@minValue(1)
@maxValue(7)
@description('The amount of time in days that the configuration store will be retained when it is soft deleted.  This field only works for "Standard" sku.')
param softDeleteRetentionInDays int = 7

@description('The Public Network Access setting of the App Configuration store. When Disabled, only requests from Private Endpoints can access the App Configuration store.')
@allowed([ 'Enabled', 'Disabled' ])
param publicNetworkAccess string = 'Enabled'

@description('Disables all authentication methods other than AAD authentication.')
param disableLocalAuth bool = false

@description('Enables the purge protection feature for the configuration store.  This field only works for "Standard" sku.')
param enablePurgeProtection bool = false

@description('The client id of the identity which will be used to access key vault.')
param identityClientId string = ''

@description('The resource URI of the key vault key used to encrypt the data in the configuration store.')
param keyVaultKeyIdentifier string = ''

@description('The list of replicas for the configuration store with "name" and "location" parameters.')
param replicas array = []

@description('The key-value pair tags to associate with the resource.')
param tags object = {}

@description('TSpecifies the type of Managed Service Identity that should be configured on this App Configuration. The type "SystemAssigned, UserAssigned" includes both an implicitly created identity and a set of user-assigned identities. The type "None" will remove any identities from the Cosmos DB account.')
@allowed([ 'None', 'SystemAssigned', 'SystemAssigned,UserAssigned', 'UserAssigned' ])
param identityType string = 'None'

@description('The list of user-assigned managed identities. The user identity dictionary key references will be ARM resource ids in the form: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}"')
param userAssignedIdentities object = {}

@description('Specify the type of lock on Cosmos DB account resource.')
@allowed([ 'CanNotDelete', 'NotSpecified', 'ReadOnly' ])
param lock string = 'NotSpecified'

@description('Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11"')
param roleAssignments array = []

@description('Private Endpoints that should be created for Azure Cosmos DB account.')
param privateEndpoints array = []

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
  'HttpRequest'
  'Audit'
])
param logsToEnable array = [
  'HttpRequest'
  'Audit'
]

@description('The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param metricsToEnable array = [
  'AllMetrics'
]

var diagnosticsLogsWithDefaults = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: diagnosticLogsRetentionInDays != 0 ? true : false
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsMetricsWithDefaults = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: diagnosticLogsRetentionInDays != 0 ? true : false
    days: diagnosticLogsRetentionInDays
  }
}]

var privateEndpointsWithDefaults = [for endpoint in privateEndpoints: {
  name: '${appConfiguration.name}-${endpoint.name}'
  privateLinkServiceId: appConfiguration.id
  groupIds: [
    'configurationStores'
  ]
  subnetId: endpoint.subnetId
  privateDnsZones: contains(endpoint, 'privateDnsZoneId') ? [
    {
      name: 'default'
      zoneId: endpoint.privateDnsZoneId
    }
  ] : []
  manualApprovalEnabled: contains(endpoint, 'manualApprovalEnabled') ? endpoint.manualApprovalEnabled : false
}]

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2023-03-01' = {
  name: name
  location: location
  sku: {
    name: skuName
  }
  properties: {
    publicNetworkAccess: publicNetworkAccess
    disableLocalAuth: disableLocalAuth
    enablePurgeProtection: (skuName == 'Standard') ? enablePurgeProtection : null
    encryption: !empty(keyVaultKeyIdentifier) && !empty(identityClientId) ? {
      keyVaultProperties: {
        keyIdentifier: keyVaultKeyIdentifier
        identityClientId: identityClientId
      }
    } : null
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

resource appConfigurationDiagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(diagnosticWorkspaceId) || !empty(diagnosticEventHubAuthorizationRuleId) || !empty(diagnosticEventHubName)) {
  name: '${appConfiguration.name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetricsWithDefaults
    logs: diagnosticsLogsWithDefaults
  }
  scope: appConfiguration
}

module appConfiguration_rbac 'modules/rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'cosmosdb-rbac-${uniqueString(deployment().name, location)}-${index}'
  params: {
    description: roleAssignment.?description ?? ''
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: roleAssignment.?principalType ?? ''
    resourceId: appConfiguration.id
  }
}]

module appConfiguration_privateEndpoint 'modules/privateEndpoint.bicep' = {
  name: '${name}-${uniqueString(deployment().name, location)}-private-endpoints'
  params: {
    location: location
    privateEndpoints: privateEndpointsWithDefaults
    tags: tags
  }
}

resource appConfiguration_lock 'Microsoft.Authorization/locks@2020-05-01' = if (lock != 'NotSpecified') {
  name: '${appConfiguration.name}-${toLower(lock)}-lock'
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

@description('Object Id of system assigned managed identity for Cosmos DB account (if enabled).')
output systemAssignedIdentityPrincipalId string = contains(identityType, 'SystemAssigned') ? appConfiguration.identity.principalId : ''
