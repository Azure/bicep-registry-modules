metadata name = 'Site Slot Auth Settings V2 Config'
metadata description = 'This module deploys a Site Auth Settings V2 Configuration.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent site resource. Required if the template is used in a standalone deployment.')
param appName string

@description('Required. Slot name to be configured.')
param slotName string

@description('Required. Type of slot to deploy.')
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

  resource slot 'slots' existing = {
    name: slotName
  }
}

resource slotSettings 'Microsoft.Web/sites/slots/config@2022-09-01' = {
  name: 'authsettingsV2'
  kind: kind
  parent: app::slot
  properties: authSettingV2Configuration
}

@description('The name of the slot config.')
output name string = slotSettings.name

@description('The resource ID of the slot config.')
output resourceId string = slotSettings.id

@description('The resource group the slot config was deployed into.')
output resourceGroupName string = resourceGroup().name
