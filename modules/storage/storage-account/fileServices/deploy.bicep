@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. The name of the file service')
param name string = 'default'

@description('Optional. Protocol settings for file service')
param protocolSettings object = {}

@description('Optional. The service properties for soft delete.')
param shareDeleteRetentionPolicy object = {
  enabled: true
  days: 7
}

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of a log analytics workspace.')
param diagnosticWorkspaceId string = ''

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param diagnosticEventHubAuthorizationRuleId string = ''

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param diagnosticEventHubName string = ''

@description('Optional. File shares to create.')
param shares array = []

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'StorageRead'
  'StorageWrite'
  'StorageDelete'
])
param diagnosticLogCategoriesToEnable array = [
  'StorageRead'
  'StorageWrite'
  'StorageDelete'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'Transaction'
])
param diagnosticMetricsToEnable array = [
  'Transaction'
]

@description('Optional. The name of the diagnostic setting, if deployed.')
param diagnosticSettingsName string = '${name}-diagnosticSettings'

var diagnosticsLogs = [for category in diagnosticLogCategoriesToEnable: {
  category: category
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsMetrics = [for metric in diagnosticMetricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName
}

resource fileServices 'Microsoft.Storage/storageAccounts/fileServices@2021-04-01' = {
  name: name
  parent: storageAccount
  properties: {
    protocolSettings: protocolSettings
    shareDeleteRetentionPolicy: shareDeleteRetentionPolicy
  }
}

resource fileServices_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if ((!empty(diagnosticStorageAccountId)) || (!empty(diagnosticWorkspaceId)) || (!empty(diagnosticEventHubAuthorizationRuleId)) || (!empty(diagnosticEventHubName))) {
  scope: fileServices
  name: diagnosticSettingsName
  properties: {
    storageAccountId: !empty(diagnosticStorageAccountId) ? diagnosticStorageAccountId : null
    workspaceId: !empty(diagnosticWorkspaceId) ? diagnosticWorkspaceId : null
    eventHubAuthorizationRuleId: !empty(diagnosticEventHubAuthorizationRuleId) ? diagnosticEventHubAuthorizationRuleId : null
    eventHubName: !empty(diagnosticEventHubName) ? diagnosticEventHubName : null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
}

module fileServices_shares 'shares/deploy.bicep' = [for (share, index) in shares: {
  name: '${deployment().name}-shares-${index}'
  params: {
    storageAccountName: storageAccount.name
    fileServicesName: fileServices.name
    name: share.name
    enabledProtocols: contains(share, 'enabledProtocols') ? share.enabledProtocols : 'SMB'
    rootSquash: contains(share, 'rootSquash') ? share.rootSquash : 'NoRootSquash'
    sharedQuota: contains(share, 'sharedQuota') ? share.sharedQuota : 5120
    roleAssignments: contains(share, 'roleAssignments') ? share.roleAssignments : []
  }
}]

@description('The name of the deployed file share service')
output name string = fileServices.name

@description('The resource ID of the deployed file share service')
output resourceId string = fileServices.id

@description('The resource group of the deployed file share service')
output resourceGroupName string = resourceGroup().name
