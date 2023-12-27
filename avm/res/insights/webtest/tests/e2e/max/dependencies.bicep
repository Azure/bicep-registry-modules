@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Log Analytics Workspace to create.')
param appInsightName string

@description('Required. The name of the Log Analytics Workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the managed identity to create.')
param managedIdentityName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: logAnalyticsWorkspaceName
  location: location
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
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

@description('The principal ID of the created managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
