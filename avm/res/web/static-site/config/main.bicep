metadata name = 'Static Web App Site Config'
metadata description = 'This module deploys a Static Web App Site Config.'

@allowed([
  'appsettings'
  'functionappsettings'
])
@description('Required. Type of settings to apply.')
param kind string

@description('Required. App settings.')
param properties object

@description('Conditional. The name of the parent Static Web App. Required if the template is used in a standalone deployment.')
param staticSiteName string

resource staticSite 'Microsoft.Web/staticSites@2022-03-01' existing = {
  name: staticSiteName
}

resource config 'Microsoft.Web/staticSites/config@2022-03-01' = {
  #disable-next-line BCP225 // Disables incorrect error that `name` cannot be determined at compile time.
  name: kind
  parent: staticSite
  properties: properties
}

@description('The name of the config.')
output name string = config.name

@description('The resource ID of the config.')
output resourceId string = config.id

@description('The name of the resource group the config was created in.')
output resourceGroupName string = resourceGroup().name
