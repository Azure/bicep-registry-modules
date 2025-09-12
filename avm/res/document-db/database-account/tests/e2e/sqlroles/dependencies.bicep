@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the App Service to create.')
param appName string

@description('Required. The name of the App Service Plan to create.')
param appServicePlanName string

resource plan 'Microsoft.Web/serverfarms@2024-11-01' = {
  name: appServicePlanName
  location: location
  kind: 'linux'
  properties: {
    reserved: true
  }
  sku: {
    name: 'B1'
  }
}

resource app 'Microsoft.Web/sites@2024-11-01' = {
  name: appName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|9.0'
    }
  }
}

@description('The app identity Principal Id.')
output identityPrincipalId string = app.identity.principalId
