metadata name = 'Azure Monitoring'
metadata description = 'Creates an Application Insights instance and a Log Analytics workspace.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The resource portal dashboards name.')
param applicationInsightsDashboardName string = ''

@description('Required. The resource insights components name.')
param applicationInsightsName string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. The resource operational insights workspaces name.')
param logAnalyticsName string

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
  name: '46d3xbcp.ptn.operationalinsights-monitoring.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

module logAnalytics 'modules/loganalytics.bicep' = {
  name: 'loganalytics'
  params: {
    name: logAnalyticsName
    location: location
    tags: tags
  }
}

module applicationInsights 'modules/applicationinsights.bicep' = {
  name: 'applicationinsights'
  params: {
    name: applicationInsightsName
    location: location
    tags: tags
    dashboardName: applicationInsightsDashboardName
    logAnalyticsWorkspaceId: logAnalytics.outputs.id
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource group the operational-insights monitoring was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The connection string of the application insights.')
output applicationInsightsConnectionString string = applicationInsights.outputs.connectionString

@description('The resource ID of the application insights.')
output applicationInsightsId string = applicationInsights.outputs.id

@description('The instrumentation key of the application insights.')
output applicationInsightsInstrumentationKey string = applicationInsights.outputs.instrumentationKey

@description('The name of the application insights.')
output applicationInsightsName string = applicationInsights.outputs.name

@description('The resource ID of the loganalytics workspace.')
output logAnalyticsWorkspaceId string = logAnalytics.outputs.id

@description('The name of the loganalytics workspace.')
output logAnalyticsWorkspaceName string = logAnalytics.outputs.name
