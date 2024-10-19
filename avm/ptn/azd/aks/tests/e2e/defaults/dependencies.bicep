@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the App Service to create.')
param appName string

@description('Required. The name of the App Service Plan to create.')
param appServicePlanName string

@description('Required. The name of the Log Analytics Workspace to create.')
param logAnalyticsWorkspaceName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    retentionInDays: 30
    features: {
      searchVersion: 1
    }
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: 'B3'
  }
  properties: {
    reserved: true
  }
}

resource app 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'dotnetcore|8.0'
      alwaysOn: true
    }
  }
  identity: { type: 'SystemAssigned' }
}

@description('The app identity Principal Id.')
output identityPrincipalId string = app.identity.principalId

@description('The resource ID of the created Log Analytics Workspace.')
output logAnalyticsWorkspaceResourceId string = logAnalyticsWorkspace.name
