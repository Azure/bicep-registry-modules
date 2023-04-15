param namespaceName string
param name string
param diagnosticStorageAccountId string
param diagnosticWorkspaceId string
param diagnosticEventHubAuthorizationRuleId string
param diagnosticEventHubName string
param diagnosticsMetrics array
param diagnosticsLogs array

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2021-11-01' existing = {
  name: namespaceName
}

resource namespace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: name
  properties: {
    storageAccountId: (diagnosticStorageAccountId != '') ? diagnosticStorageAccountId: null
    workspaceId:  (diagnosticWorkspaceId != '') ? diagnosticWorkspaceId: null
    eventHubAuthorizationRuleId: (diagnosticEventHubAuthorizationRuleId != '') ? diagnosticEventHubAuthorizationRuleId: null
    eventHubName: (diagnosticEventHubName != '') ? diagnosticEventHubName: null
    metrics: diagnosticsMetrics
    logs: diagnosticsLogs
  }
  scope: eventHubNamespace
}
