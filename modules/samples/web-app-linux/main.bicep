@description('Generate unique String for web app name')
param webAppName string = uniqueString(resourceGroup().id)

@description('The SKU of App Service Plan')
param sku string = 'S1'

@description('The runtime stack of web app')
param linuxFxVersion string = 'php|7.4'

@description('Location for all resources')
param location string = resourceGroup().location

var appServicePlanName = toLower('AppServicePlan-${webAppName}')
var webSiteName = toLower('wapp-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2020-06-01' = {
  name: appServicePlanName
  location: location
  sku: {
    name: sku
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2020-06-01' = {
  name: webSiteName
  location: location
  kind: 'app'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: linuxFxVersion
    }
  }
}
