metadata name = 'App Configuration Stores Key Values'
metadata description = 'This module deploys an App Configuration Store Key Value.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the key.')
param name string

@description('Required. Name of the value.')
param value string

@description('Conditional. The name of the parent app configuration store. Required if the template is used in a standalone deployment.')
param appConfigurationName string

@description('Optional. The content type of the key-values value. Providing a proper content-type can enable transformations of values when they are retrieved by applications.')
param contentType string = ''

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).') // update all the descriptions
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2023-03-01' existing = {
  name: appConfigurationName
}

resource keyValues 'Microsoft.AppConfiguration/configurationStores/keyValues@2023-03-01' = {
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
