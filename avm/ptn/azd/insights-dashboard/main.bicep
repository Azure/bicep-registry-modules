metadata name = 'Application Insights Components'
metadata description = 'Creates an Application Insights instance based on an existing Log Analytics workspace.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The resource insights components name.')
param name string

@description('Required. The resource portal dashboards name.')
param dashboardName string = ''

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. The resource ID of the loganalytics workspace.')
param logAnalyticsWorkspaceId string

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
  name: '46d3xbcp.ptn.azd-insightsdashboard.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

// ============== //
// Resources      //
// ============== //

module applicationInsights 'br/public:avm/res/insights/component:0.4.1' = {
  name: '${uniqueString(deployment().name, location)}-appinsights'
  params: {
    name: name
    location: location
    tags: tags
    kind: 'web'
    applicationType: 'web'
    workspaceResourceId: logAnalyticsWorkspaceId
  }
}

module applicationInsightsDashboard 'modules/applicationinsights-dashboard.bicep' = if (!empty(dashboardName)) {
  name: 'application-insights-dashboard'
  params: {
    name: dashboardName
    location: location
    applicationInsightsName: applicationInsights.outputs.name
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource group the application insights components were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The connection string of the application insights.')
output connectionString string = applicationInsights.outputs.connectionString

@description('The resource ID of the application insights.')
output id string = applicationInsights.outputs.resourceId

@description('The instrumentation key of the application insights.')
output instrumentationKey string = applicationInsights.outputs.instrumentationKey

@description('The name of the application insights.')
output name string = applicationInsights.outputs.name
