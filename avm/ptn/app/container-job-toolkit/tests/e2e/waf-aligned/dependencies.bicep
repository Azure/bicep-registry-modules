@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Log Analytics Workspace.')
param lawName string

@description('Required. The name of the Application Insights service.')
param appInsightsName string

@description('Required. The name of the User Assigned Identity.')
param userIdentityName string

module law 'br/public:avm/res/operational-insights/workspace:0.7.0' = {
  name: '${uniqueString(deployment().name, location)}-law'
  params: {
    name: lawName
    location: location
  }
}

module appInsights 'br/public:avm/res/insights/component:0.4.1' = {
  name: '${uniqueString(deployment().name, location)}-appInsights'
  params: {
    name: appInsightsName
    location: location
    kind: 'web'
    applicationType: 'web'
    retentionInDays: 30
    workspaceResourceId: law.outputs.resourceId
  }
}

module userAssignedIdentity 'br/public:avm/res/managed-identity/user-assigned-identity:0.4.0' = {
  name: '${uniqueString(deployment().name, location)}-userAssignedIdentity'
  params: {
    name: userIdentityName
    location: location
  }
}

@description('The name of the created Azure Container Registry.')
output logAnalyticsResourceId string = law.outputs.resourceId

@description('The name of the created Application Insights instance.')
output appInsightsConnectionString string = appInsights.outputs.connectionString

@description('The ResourceId of the created User Assigned Identity.')
output userIdentityResourceId string = userAssignedIdentity.outputs.resourceId
