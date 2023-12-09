metadata name = 'API Management Service Named Values'
metadata description = 'This module deploys an API Management Service Named Value.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Required. Unique name of NamedValue. It may contain only letters, digits, period, dash, and underscore characters.')
param displayName string

@description('Optional. KeyVault location details of the namedValue.')
param keyVault object = {}

@description('Required. Named value Name.')
param name string

@description('Optional. Tags that when provided can be used to filter the NamedValue list. - string.')
param tags array?

@description('Optional. Determines whether the value is a secret and should be encrypted or not. Default value is false.')
#disable-next-line secure-secrets-in-params // Not a secret
param secret bool = false

@description('Optional. Value of the NamedValue. Can contain policy expressions. It may not be empty or consist only of whitespace. This property will not be filled on \'GET\' operations! Use \'/listSecrets\' POST request to get the value.')
param value string = newGuid()

var keyVaultEmpty = empty(keyVault)

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

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource namedValue 'Microsoft.ApiManagement/service/namedValues@2021-08-01' = {
  name: name
  parent: service
  properties: {
    tags: tags
    secret: secret
    displayName: displayName
    value: keyVaultEmpty ? value : null
    keyVault: !keyVaultEmpty ? keyVault : null
  }
}

@description('The resource ID of the named value.')
output resourceId string = namedValue.id

@description('The name of the named value.')
output name string = namedValue.name

@description('The resource group the named value was deployed into.')
output resourceGroupName string = resourceGroup().name
