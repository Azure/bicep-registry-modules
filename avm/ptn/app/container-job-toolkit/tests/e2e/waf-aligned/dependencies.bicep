@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Log Analytics Workspace.')
param lawName string

@description('Required. The name of the Application Insights service.')
param appInsightsName string

@description('Required. The name of the User Assigned Identity.')
param userIdentityName string

resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: lawName
  location: location
}

module appInsights 'br/public:avm/res/insights/component:0.4.2' = {
  name: '${uniqueString(deployment().name, location)}-appInsights'
  params: {
    name: appInsightsName
    location: location
    kind: 'web'
    applicationType: 'web'
    retentionInDays: 30
    workspaceResourceId: law.id
  }
}

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: userIdentityName
  location: location
}

@description('The name of the created Azure Container Registry.')
output logAnalyticsResourceId string = law.id

@description('The name of the created Application Insights instance.')
output appInsightsConnectionString string = appInsights.outputs.connectionString

@description('The ResourceId of the created User Assigned Identity.')
output userIdentityResourceId string = userAssignedIdentity.id
