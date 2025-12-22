metadata name = 'API Management Service Named Values'
metadata description = 'This module deploys an API Management Service Named Value.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@minLength(1)
@maxLength(256)
@description('Required. Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.')
param displayName string

@description('Optional. KeyVault location details of the namedValue.')
param keyVault resourceInput<'Microsoft.ApiManagement/service/namedValues@2024-05-01'>.properties.keyVault?

@description('Required. The name of the named value.')
param name string

@description('Optional. Tags that when provided can be used to filter the NamedValue list.')
param tags resourceInput<'Microsoft.ApiManagement/service/namedValues@2024-05-01'>.properties.tags?

@description('Optional. Determines whether the value is a secret and should be encrypted or not.')
param secret bool = false

@description('Optional. Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on \'GET\' operations! Use \'/listSecrets\' POST request to get the value.')
@secure()
@maxLength(4096)
param value string = newGuid()

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.apimgmt-namedvalue.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource namedValue 'Microsoft.ApiManagement/service/namedValues@2024-05-01' = {
  name: name
  parent: service
  properties: {
    tags: tags
    secret: secret
    displayName: displayName
    value: empty(keyVault) ? value : null
    keyVault: keyVault
  }
}

@description('The resource ID of the named value.')
output resourceId string = namedValue.id

@description('The name of the named value.')
output name string = namedValue.name

@description('The resource group the named value was deployed into.')
output resourceGroupName string = resourceGroup().name
