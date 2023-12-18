@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Log Analytics Workspace to create.')
param appInsightName string

@description('Required. The name of the Log Analytics Workspace to create.')
param logAnalyticsWorkspaceName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalyticsWorkspaceName
  location: location
}

resource appInsight 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

@description('The resource ID of the created Log Analytics Workspace.')
output appInsightResourceId string = appInsight.id
