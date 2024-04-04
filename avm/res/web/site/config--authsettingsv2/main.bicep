metadata name = 'Site Auth Settings V2 Config'
metadata description = 'This module deploys a Site Auth Settings V2 Configuration.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent site resource. Required if the template is used in a standalone deployment.')
param appName string

@description('Required. Type of site to deploy.')
@allowed([
  'functionapp' // function app windows os
  'functionapp,linux' // function app linux os
  'functionapp,workflowapp' // logic app workflow
  'functionapp,workflowapp,linux' // logic app docker container
  'app,linux' // linux web app
  'app' // normal web app
])
param kind string

@description('Required. The auth settings V2 configuration.')
param authSettingV2Configuration object

resource app 'Microsoft.Web/sites@2022-09-01' existing = {
  name: appName
}

resource appSettings 'Microsoft.Web/sites/config@2022-09-01' = {
  name: 'authsettingsV2'
  kind: kind
  parent: app
  properties: authSettingV2Configuration
}

@description('The name of the site config.')
output name string = appSettings.name

@description('The resource ID of the site config.')
output resourceId string = appSettings.id

@description('The resource group the site config was deployed into.')
output resourceGroupName string = resourceGroup().name
