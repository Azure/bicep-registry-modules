metadata name = 'Site Api Management Config'
metadata description = 'This module deploys a Site Api Management Configuration.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the parent site resource.')
param appName string

@description('Required. The web settings api management configuration.')
param apiManagementConfiguration object?

resource app 'Microsoft.Web/sites@2022-09-01' existing = {
  name: appName
}

resource webSettings 'Microsoft.Web/sites/config@2022-09-01' = {
  name: 'web'
  kind: 'string'
  parent: app
  properties: apiManagementConfiguration
}

@description('The name of the site config.')
output name string = webSettings.name

@description('The resource ID of the site config.')
output resourceId string = webSettings.id

@description('The resource group the site config was deployed into.')
output resourceGroupName string = resourceGroup().name
