metadata name = 'Application Insights Components'
metadata description = 'Creates an Application Insights instance based on an existing Log Analytics workspace.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The resource insights components name.')
param name string

@description('Required. The resource portal dashboards name.')
param dashboardName string = ''

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('The resource ID of the loganalytics workspace.')
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

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspaceId
  }
}

module applicationInsightsDashboard 'applicationinsights-dashboard.bicep' = if (!empty(dashboardName)) {
  name: 'application-insights-dashboard'
  params: {
    name: dashboardName
    location: location
    applicationInsightsName: applicationInsights.name
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource group the application insights components were deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The connection string of the application insights.')
output connectionString string = applicationInsights.properties.ConnectionString

@description('The resource ID of the application insights.')
output id string = applicationInsights.id

@description('The instrumentation key of the application insights.')
output instrumentationKey string = applicationInsights.properties.InstrumentationKey

@description('The name of the application insights.')
output name string = applicationInsights.name
