metadata name = 'App Configuration Stores Key Values'
metadata description = 'This module deploys an App Configuration Store Key Value.'

@description('Required. Name of the key.')
param name string

@description('Required. The value of the key-value.')
param value string

@description('Conditional. The name of the parent app configuration store. Required if the template is used in a standalone deployment.')
param appConfigurationName string

@description('Optional. The content type of the key-values value. Providing a proper content-type can enable transformations of values when they are retrieved by applications.')
param contentType string?

@description('Optional. Tags of the resource.')
param tags object?

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2024-05-01' existing = {
  name: appConfigurationName
}

resource keyValues 'Microsoft.AppConfiguration/configurationStores/keyValues@2024-05-01' = {
  name: name
  parent: appConfiguration
  properties: {
    contentType: contentType
    tags: tags
    value: value
  }
}
@description('The name of the key values.')
output name string = keyValues.name

@description('The resource ID of the key values.')
output resourceId string = keyValues.id

@description('The resource group the batch account was deployed into.')
output resourceGroupName string = resourceGroup().name
