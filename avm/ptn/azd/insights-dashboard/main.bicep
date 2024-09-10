metadata name = 'Application Insights Components'
metadata description = '''Creates an Application Insights instance based on an existing Log Analytics workspace.

**Note:** This module is not intended for broad, generic use, as it was designed to cater for the requirements of the AZD CLI product. Feature requests and bug fix requests are welcome if they support the development of the AZD CLI but may not be incorporated if they aim to make this module more generic than what it needs to be for its primary use case.'''
metadata owner = 'Azure/module-maintainers'

@description('Required. The resource insights components name.')
param name string

@description('Optional. The resource portal dashboards name.')
param dashboardName string = ''

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. The resource ID of the loganalytics workspace.')
param logAnalyticsWorkspaceResourceId string

@description('Optional. The kind of application that this component refers to, used to customize UI. This value is a freeform string, values should typically be one of the following: web, ios, other, store, java, phone.')
param kind string = 'web'

@description('Optional. Application type.')
@allowed([
  'web'
  'other'
])
param applicationType string = 'web'

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

module applicationInsights 'br/public:avm/res/insights/component:0.4.1' = {
  name: '${uniqueString(deployment().name, location)}-appinsights'
  params: {
    name: name
    location: location
    tags: tags
    kind: kind
    applicationType: applicationType
    workspaceResourceId: logAnalyticsWorkspaceResourceId
  }
}

module applicationInsightsDashboard 'modules/applicationinsights-dashboard.bicep' = if (!empty(dashboardName)) {
  name: 'application-insights-dashboard'
  params: {
    name: dashboardName
    location: location
    applicationInsightsName: applicationInsights.outputs.name
    applicationInsightsResourceId: applicationInsights.outputs.resourceId
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource group the application insights components were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the application insights.')
output applicationInsightsName string = applicationInsights.outputs.name

@description('The resource name of the dashboard.')
output dashboardName string = !empty(dashboardName) ? applicationInsightsDashboard.outputs.dashboardName : ''

@description('The resource ID of the application insights.')
output applicationInsightsResourceId string = applicationInsights.outputs.resourceId

@description('The resource ID of the dashboard.')
output dashboardResourceId string = !empty(dashboardName) ? applicationInsightsDashboard.outputs.dashboardResourceId : ''

@description('The connection string of the application insights.')
output applicationInsightsConnectionString string = applicationInsights.outputs.connectionString

@description('The instrumentation key of the application insights.')
output applicationInsightsInstrumentationKey string = applicationInsights.outputs.instrumentationKey
