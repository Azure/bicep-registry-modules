metadata name = 'Azd Azure Monitoring'
metadata description = '''Creates an Application Insights instance and a Log Analytics workspace.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.'''

@description('Required. The resource operational insights workspaces name.')
param logAnalyticsName string

@description('Required. The resource insights components name.')
param applicationInsightsName string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The resource portal dashboards name.')
param applicationInsightsDashboardName string = ''

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
@metadata({
  example: '''
  {
      "key1": "value1"
      "key2": "value2"
  }
  '''
})
param tags object?

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.ptn.azd-monitoring.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module logAnalytics 'br/public:avm/res/operational-insights/workspace:0.7.0' = {
  name: 'loganalytics'
  params: {
    name: logAnalyticsName
    location: location
    tags: tags
    dataRetention: 30
    enableTelemetry: enableTelemetry
  }
}

module applicationInsights 'br/public:avm/ptn/azd/insights-dashboard:0.1.0' = {
  name: 'applicationinsights'
  params: {
    logAnalyticsWorkspaceResourceId: logAnalytics.outputs.resourceId
    name: applicationInsightsName
    location: location
    tags: tags
    dashboardName: applicationInsightsDashboardName
    enableTelemetry: enableTelemetry
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource group the operational-insights monitoring was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The connection string of the application insights.')
output applicationInsightsConnectionString string = applicationInsights.outputs.applicationInsightsConnectionString

@description('The resource ID of the application insights.')
output applicationInsightsResourceId string = applicationInsights.outputs.applicationInsightsResourceId

@description('The instrumentation key for the application insights.')
output applicationInsightsInstrumentationKey string = applicationInsights.outputs.applicationInsightsInstrumentationKey

@description('The name of the application insights.')
output applicationInsightsName string = applicationInsights.outputs.applicationInsightsName

@description('The resource ID of the loganalytics workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalytics.outputs.resourceId

@description('The name of the log analytics workspace.')
output logAnalyticsWorkspaceName string = logAnalytics.outputs.name
