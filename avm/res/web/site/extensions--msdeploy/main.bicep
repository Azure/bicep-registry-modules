metadata name = 'Site Deployment Extension '
metadata description = 'This module deploys a Site extension for MSDeploy.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the parent site resource.')
param appName string

@description('Required. Sets the MSDeployment Properties.')
param msDeployConfiguration object?

resource app 'Microsoft.Web/sites@2022-09-01' existing = {
  name: appName
}
resource msdeploy 'Microsoft.Web/sites/extensions@2023-12-01' = {
  name: 'MSDeploy'
  kind: 'MSDeploy'
  parent: app
  properties: msDeployConfiguration
}

@description('The name of the MSDeploy Package.')
output name string = msdeploy.name

@description('The resource ID of the Site Extension.')
output resourceId string = msdeploy.id

@description('The resource group the site config was deployed into.')
output resourceGroupName string = resourceGroup().name
