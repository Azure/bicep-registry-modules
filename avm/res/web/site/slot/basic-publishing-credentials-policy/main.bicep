metadata name = 'Web Site Slot Basic Publishing Credentials Policies'
metadata description = 'This module deploys a Web Site Slot Basic Publishing Credentials Policy.'
metadata owner = 'Azure/module-maintainers'

@sys.description('Required. The name of the resource.')
@allowed([
  'scm'
  'ftp'
])
param name string

@sys.description('Optional. Set to true to enable or false to disable a publishing method.')
param allow bool = true

@sys.description('Conditional. The name of the parent web site. Required if the template is used in a standalone deployment.')
param appName string

@sys.description('Conditional. The name of the parent web site slot. Required if the template is used in a standalone deployment.')
param slotName string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

resource app 'Microsoft.Web/sites@2022-09-01' existing = {
  name: appName

  resource slot 'slots' existing = {
    name: slotName
  }
}

resource basicPublishingCredentialsPolicy 'Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies@2022-09-01' = {
  name: name
  location: location
  parent: app::slot
  properties: {
    allow: allow
  }
}

@sys.description('The name of the basic publishing credential policy.')
output name string = basicPublishingCredentialsPolicy.name

@sys.description('The resource ID of the basic publishing credential policy.')
output resourceId string = basicPublishingCredentialsPolicy.id

@sys.description('The name of the resource group the basic publishing credential policy was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The location the resource was deployed into.')
output location string = basicPublishingCredentialsPolicy.location
