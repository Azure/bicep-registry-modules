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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.appconfig-configstore-keyvalue.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2025-02-01-preview' existing = {
  name: appConfigurationName
}

resource keyValues 'Microsoft.AppConfiguration/configurationStores/keyValues@2025-02-01-preview' = {
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
