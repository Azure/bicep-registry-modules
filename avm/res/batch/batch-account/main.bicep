metadata name = 'Batch Accounts'
metadata description = 'This module deploys a Batch Account.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the Azure Batch.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enables system assigned managed identity on the resource.')
param systemAssignedIdentity bool = false

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Required. The resource ID of the storage account to be used for auto-storage account.')
param storageAccountId string

@allowed([
  'BatchAccountManagedIdentity'
  'StorageKeys'
])
@description('Optional. The authentication mode which the Batch service will use to manage the auto-storage account.')
param storageAuthenticationMode string = 'StorageKeys'

@description('Optional. The resource ID of a user assigned identity assigned to pools which have compute nodes that need access to auto-storage.')
param storageAccessIdentity string = ''

@allowed([
  'BatchService'
  'UserSubscription'
])
@description('Optional. The allocation mode for creating pools in the Batch account. Determines which quota will be used.')
param poolAllocationMode string = 'BatchService'

@description('Conditional. The key vault to associate with the Batch account. Required if the \'poolAllocationMode\' is set to \'UserSubscription\' and requires the service principal \'Microsoft Azure Batch\' to be granted contributor permissions on this key vault.')
param keyVaultReferenceResourceId string = ''

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints array = []

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and networkProfileAllowedIpRanges are not set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@allowed([
  'Allow'
  'Deny'
])
@description('Optional. The network profile default action for endpoint access. It is only applicable when publicNetworkAccess is not explicitly disabled.')
param networkProfileDefaultAction string = 'Deny'

@description('Optional. Array of IP ranges to filter client IP address. It is only applicable when publicNetworkAccess is not explicitly disabled.')
param networkProfileAllowedIpRanges array = []

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@allowed([
  ''
  'CanNotDelete'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = ''

@description('Optional. Tags of the resource.')
param tags object = {}

@allowed([
  'AAD'
  'SharedKey'
  'TaskAuthenticationToken'
])
@description('Optional. List of allowed authentication modes for the Batch account that can be used to authenticate with the data plane.')
param allowedAuthenticationModes array = []

@description('Conditional. The resource ID of a key vault to reference a customer managed key for encryption from. Required if \'cMKKeyName\' is not empty.')
param cMKKeyVaultResourceId string = ''

@description('Optional. The name of the customer managed key to use for encryption.')
param cMKKeyName string = ''

@description('Optional. The version of the customer managed key to reference for encryption. If not provided, the latest key version is used.')
param cMKKeyVersion string = ''

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
@allowed([
  ''
  'allLogs'
  'ServiceLog'
])
param diagnosticLogCategoriesToEnable array = [
  'allLogs'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param diagnosticMetricsToEnable array = [
  'AllMetrics'
]

@description('Optional. The name of the diagnostic setting, if deployed. If left empty, it defaults to "<resourceName>-diagnosticSettings".')
param diagnosticSettingsName string = ''

var diagnosticsLogsSpecified = [for category in filter(diagnosticLogCategoriesToEnable, item => item != 'allLogs' && item != ''): {
  category: category
  enabled: true
}]

var diagnosticsLogs = contains(diagnosticLogCategoriesToEnable, 'allLogs') ? [
  {
    categoryGroup: 'allLogs'
    enabled: true
  }
] : contains(diagnosticLogCategoriesToEnable, '') ? [] : diagnosticsLogsSpecified

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
}]

var identityType = systemAssignedIdentity ? 'SystemAssigned' : !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

var identity = {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
}

var networkProfileIpRules = [for networkProfileAllowedIpRange in networkProfileAllowedIpRanges: {
  action: 'Allow'
  value: networkProfileAllowedIpRange
}]

var nodeIdentityReference = !empty(storageAccessIdentity) ? {
  resourceId: !empty(storageAccessIdentity) ? storageAccessIdentity : null
} : null

var autoStorageConfig = {
  authenticationMode: storageAuthenticationMode
  nodeIdentityReference: nodeIdentityReference
  storageAccountId: storageAccountId
}

var enableReferencedModulesTelemetry = false

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name, location)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource keyVaultReferenceKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(keyVaultReferenceResourceId)) {
  name: last(split(keyVaultReferenceResourceId, '/'))!
  scope: resourceGroup(split(keyVaultReferenceResourceId, '/')[2], split(keyVaultReferenceResourceId, '/')[4])
}

resource cMKKeyVaultKey 'Microsoft.KeyVault/vaults/keys@2021-10-01' existing = if (!empty(cMKKeyVaultResourceId) && !empty(cMKKeyName)) {
  name: '${last(split(cMKKeyVaultResourceId, '/'))}/${cMKKeyName}'
  scope: resourceGroup(split(cMKKeyVaultResourceId, '/')[2], split(cMKKeyVaultResourceId, '/')[4])
}

resource batchAccount 'Microsoft.Batch/batchAccounts@2022-06-01' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    allowedAuthenticationModes: allowedAuthenticationModes
    autoStorage: autoStorageConfig
    encryption: !empty(cMKKeyName) ? {
      keySource: 'Microsoft.KeyVault'
      keyVaultProperties: {
        keyIdentifier: !empty(cMKKeyVersion) ? '${cMKKeyVaultKey.properties.keyUri}/${cMKKeyVersion}' : cMKKeyVaultKey.properties.keyUriWithVersion
      }
    } : null
    keyVaultReference: poolAllocationMode == 'UserSubscription' ? {
      id: keyVaultReferenceResourceId
      url: keyVaultReferenceKeyVault.properties.vaultUri
    } : null
    networkProfile: (publicNetworkAccess == 'Disabled') || empty(networkProfileAllowedIpRanges) ? null : {
      accountAccess: {
        defaultAction: networkProfileDefaultAction
        ipRules: networkProfileIpRules
      }
    }
    poolAllocationMode: poolAllocationMode
    publicNetworkAccess: !empty(publicNetworkAccess) ? any(publicNetworkAccess) : (!empty(privateEndpoints) && empty(networkProfileAllowedIpRanges) ? 'Disabled' : null)
  }
}

resource batchAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock)) {
  name: '${batchAccount.name}-${lock}-lock'
  properties: {
    level: any(lock)
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: batchAccount
}

resource batchAccount_diagnosticSettings 'Microsoft.Insights/diagnosticsettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  name: !empty(diagnosticSettingsName) ? diagnosticSettingsName : '${name}-diagnosticSettings'
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: batchAccount
}

module batchAccount_privateEndpoints '../../network/private-endpoint/main.bicep' = [for (privateEndpoint, index) in privateEndpoints: {
  name: '${uniqueString(deployment().name, location)}-BatchAccount-PrivateEndpoint-${index}'
  params: {
    groupIds: [
      privateEndpoint.service
    ]
    name: contains(privateEndpoint, 'name') ? privateEndpoint.name : 'pe-${last(split(batchAccount.id, '/'))}-${privateEndpoint.service}-${index}'
    serviceResourceId: batchAccount.id
    subnetResourceId: privateEndpoint.subnetResourceId
    enableDefaultTelemetry: enableReferencedModulesTelemetry
    location: contains(privateEndpoint, 'location') ? privateEndpoint.location : reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: contains(privateEndpoint, 'lock') ? privateEndpoint.lock : lock
    privateDnsZoneGroup: contains(privateEndpoint, 'privateDnsZoneGroup') ? privateEndpoint.privateDnsZoneGroup : {}
    roleAssignments: contains(privateEndpoint, 'roleAssignments') ? privateEndpoint.roleAssignments : []
    tags: contains(privateEndpoint, 'tags') ? privateEndpoint.tags : {}
    manualPrivateLinkServiceConnections: contains(privateEndpoint, 'manualPrivateLinkServiceConnections') ? privateEndpoint.manualPrivateLinkServiceConnections : []
    customDnsConfigs: contains(privateEndpoint, 'customDnsConfigs') ? privateEndpoint.customDnsConfigs : []
    ipConfigurations: contains(privateEndpoint, 'ipConfigurations') ? privateEndpoint.ipConfigurations : []
    applicationSecurityGroups: contains(privateEndpoint, 'applicationSecurityGroups') ? privateEndpoint.applicationSecurityGroups : []
    customNetworkInterfaceName: contains(privateEndpoint, 'customNetworkInterfaceName') ? privateEndpoint.customNetworkInterfaceName : ''
  }
}]

@description('The name of the batch account.')
output name string = batchAccount.name

@description('The resource ID of the batch account.')
output resourceId string = batchAccount.id

@description('The resource group the batch account was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = batchAccount.location
