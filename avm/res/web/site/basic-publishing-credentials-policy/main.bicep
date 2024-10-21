metadata name = 'Web Site Basic Publishing Credentials Policies'
metadata description = 'This module deploys a Web Site Basic Publishing Credentials Policy.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the resource.')
@allowed([
  'scm'
  'ftp'
])
param name string

@description('Optional. Set to true to enable or false to disable a publishing method.')
param allow bool = true

@description('Conditional. The name of the parent web site. Required if the template is used in a standalone deployment.')
param webAppName string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

resource webApp 'Microsoft.Web/sites@2023-12-01' existing = {
  name: webAppName
}

resource basicPublishingCredentialsPolicy 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2023-12-01' = {
  #disable-next-line BCP225 // False-positive. Value is required.
  name: name
  location: location
  parent: webApp
  properties: {
    allow: allow
  }
}

@description('The name of the basic publishing credential policy.')
output name string = basicPublishingCredentialsPolicy.name

@description('The resource ID of the basic publishing credential policy.')
output resourceId string = basicPublishingCredentialsPolicy.id

@description('The name of the resource group the basic publishing credential policy was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = basicPublishingCredentialsPolicy.location
