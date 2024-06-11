@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the App Service to create.')
param appName string

@description('Required. The name of the App Service Plan to create.')
param appServicePlanName string

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
