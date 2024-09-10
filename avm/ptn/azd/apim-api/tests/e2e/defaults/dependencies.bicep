@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the API Management service to create.')
param apimServiceName string

@description('Required. The name of the owner of the API Management service.')
param publisherName string

@description('Required. The name of the App Service to create.')
param appServiceName string

@description('Required. The name of the App Service Plan to create.')
param appServicePlanName string

@description('Required. The name of the Log Analytics Workspace to create.')
param logAnalyticsWorkspaceName string

@description('Required. The name of the Application Insights to create.')
param applicationInsightsName string

module apimService 'br/public:avm/res/api-management/service:0.4.0' = {
  name: 'serviceDeployment'
  params: {
    name: apimServiceName
    publisherEmail: 'apimgmt-noreply@mail.windowsazure.com'
    publisherName: publisherName
    location: location
    loggers: [
      {
        loggerType: 'applicationInsights'
        name: 'app-insights-logger'
        credentials: {
          instrumentationKey: applicationInsights.properties.InstrumentationKey
        }
        resourceId: applicationInsights.id
      }
    ]
  }
}

module app 'br/public:avm/res/web/site:0.6.0' = {
  name: 'siteDeployment'
  params: {
    kind: 'app'
    name: appServiceName
    serverFarmResourceId: appServicePlan.outputs.resourceId
  }
}

module appServicePlan 'br/public:avm/res/web/serverfarm:0.2.2' = {
  name: 'serverDeployment'
  params: {
    name: appServicePlanName
    skuCapacity: 2
    skuName: 'S1'
  }
}

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
  }
}

@description('The default hostname of the site.')
output siteHostName string = 'https://${app.outputs.defaultHostname}'

@description('The name of the API Management service.')
output apimName string = apimService.outputs.name
