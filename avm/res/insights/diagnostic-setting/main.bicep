metadata name = 'Diagnostic Settings (Activity Logs) for Azure Subscriptions'
metadata description = 'This module deploys a Subscription wide export of the Activity Log.'

targetScope = 'subscription'

@description('Optional. Name of the Diagnostic settings.')
@minLength(1)
@maxLength(260)
param name string = '${uniqueString(subscription().id)}-diagnosticSettings'

@description('Optional. Resource ID of the diagnostic storage account.')
param storageAccountResourceId string?

@description('Optional. Resource ID of the diagnostic log analytics workspace.')
param workspaceResourceId string?

@description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param eventHubAuthorizationRuleResourceId string?

@description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param eventHubName string?

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
param logCategoriesAndGroups logCategoriesAndGroupsType

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
param metricCategories metricCategoriesType?

@description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
@allowed([
  ''
  'Dedicated'
  'AzureDiagnostics'
])
param logAnalyticsDestinationType string = ''

@description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
param marketplacePartnerResourceId string?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location deployment metadata.')
param location string = deployment().location

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.insights-diagnosticsetting.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  location: location
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

resource diagnosticSetting 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: name
  properties: {
    storageAccountId: storageAccountResourceId
    workspaceId: workspaceResourceId
    eventHubAuthorizationRuleId: eventHubAuthorizationRuleResourceId
    eventHubName: eventHubName
    logAnalyticsDestinationType: !empty(logAnalyticsDestinationType) ? logAnalyticsDestinationType : null
    marketplacePartnerId: marketplacePartnerResourceId
    logs: [
      for group in (logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
        categoryGroup: group.?categoryGroup
        category: group.?category
        enabled: group.?enabled ?? true
      }
    ]
    metrics: [
      for group in (metricCategories ?? [{ category: 'AllMetrics' }]): {
        category: group.category
        enabled: group.?enabled ?? true
        timeGrain: null
      }
    ]
  }
}

@description('The name of the diagnostic settings.')
output name string = diagnosticSetting.name

@description('The resource ID of the diagnostic settings.')
output resourceId string = diagnosticSetting.id

@description('The name of the subscription to deploy into.')
output subscriptionName string = subscription().displayName

// =============== //
//   Definitions   //
// =============== //

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
type logCategoriesAndGroupsType = {
  @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
  category: string?

  @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `AllLogs` to collect all logs.')
  categoryGroup: string?

  @description('Optional. Enable or disable the category explicitly. Default is `true`.')
  enabled: bool?
}[]?

@description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
type metricCategoriesType = {
  @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
  category: string

  @description('Optional. Enable or disable the category explicitly. Default is `true`.')
  enabled: bool?
}[]?
