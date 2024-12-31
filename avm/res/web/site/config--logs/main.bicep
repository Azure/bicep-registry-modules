metadata name = 'Site logs Config'
metadata description = 'This module deploys a Site logs Configuration.'

@description('Required. The name of the parent site resource.')
param appName string

@description('Optional. The logs settings configuration.')
param logsConfiguration object?

resource app 'Microsoft.Web/sites@2024-04-01' existing = {
  name: appName
}

resource webSettings 'Microsoft.Web/sites/config@2024-04-01' = {
  name: 'logs'
  kind: 'string'
  parent: app
  properties: logsConfiguration
}

@description('The name of the site config.')
output name string = webSettings.name

@description('The resource ID of the site config.')
output resourceId string = webSettings.id

@description('The resource group the site config was deployed into.')
output resourceGroupName string = resourceGroup().name
