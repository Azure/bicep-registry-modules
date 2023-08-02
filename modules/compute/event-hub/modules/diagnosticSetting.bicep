param namespaceName string
param name string
param storageAccountId string
param workspaceId string
param eventHubAuthorizationRuleId string
param eventHubName string
param metricsSettings array
param logsSettings array

resource namespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' existing = {
  name: namespaceName
}

resource namespace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: name
  properties: {
    storageAccountId: !empty(storageAccountId) ? storageAccountId : null
    workspaceId: !empty(workspaceId) ? workspaceId : null
    eventHubAuthorizationRuleId: !empty(eventHubAuthorizationRuleId) ? eventHubAuthorizationRuleId : null
    eventHubName: !empty(eventHubName) ? eventHubName : null
    metrics: metricsSettings
    logs: logsSettings
  }
  scope: namespace
}
