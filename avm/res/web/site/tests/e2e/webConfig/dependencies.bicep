@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the api management instance to create.')
param apiManagementName string

@description('Required. The name of the Application Insights instance to create.')
param applicationInsightsName string

@description('Required. The name of the Server Farm to create.')
param serverFarmName string

resource serverFarm 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: serverFarmName
  location: location
  sku: {
    name: 'S1'
    tier: 'Standard'
    size: 'S1'
    family: 'S'
    capacity: 1
  }
  properties: {}
}

resource apiManagement 'Microsoft.ApiManagement/service@2023-05-01-preview' = {
  name: apiManagementName
  location: location
  sku: {
    name: 'Consumption'
    capacity: 0
  }
  properties: {
    publisherEmail: 'noreply@microsoft.com'
    publisherName: 'n/a'
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  kind: ''
  properties: {
    Application_Type: 'web'
  }
}

@description('The resource ID of the created api management.')
output apiManagementResourceId string = apiManagement.id

@description('The resource ID of the created application insights.')
output applicationInsigtsResourceId string = applicationInsights.id

@description('The resource ID of the created Server Farm.')
output serverFarmResourceId string = serverFarm.id
