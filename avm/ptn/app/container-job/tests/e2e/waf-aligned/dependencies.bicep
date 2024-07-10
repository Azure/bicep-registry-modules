@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Log Analytics Workspace.')
param lawName string

@description('Required. The name of the Application Insights service.')
param appInsightsName string

@description('Required. The name of the User Assigned Identity.')
param userIdentityName string

resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: '${lawName}-law'
  location: location
}

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: appInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: law.id
    RetentionInDays: 30
  }
}

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: userIdentityName
  location: location
}

@description('The name of the created Azure Container Registry.')
output logAnalyticsResourceId string = law.id

@description('The name of the created Application Insights instance.')
output appInsightsConnectionString string = appInsights.properties.ConnectionString

output userIdentityName string = userAssignedIdentity.name
