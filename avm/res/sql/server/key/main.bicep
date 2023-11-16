metadata name = 'Azure SQL Server Keys'
metadata description = 'This module deploys an Azure SQL Server Key.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern.')
param name string

@description('Conditional. The name of the parent SQL server. Required if the template is used in a standalone deployment.')
param serverName string

@description('Optional. The encryption protector type like "ServiceManaged", "AzureKeyVault".')
@allowed([
  'AzureKeyVault'
  'ServiceManaged'
])
param serverKeyType string = 'ServiceManaged'

@description('Optional. The URI of the key. If the ServerKeyType is AzureKeyVault, then either the URI or the keyVaultName/keyName combination is required.')
param uri string = ''

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

var splittedKeyUri = split(uri, '/')

// if serverManaged, use serverManaged, if uri provided use concated uri value
// MUST match the pattern '<keyVaultName>_<keyName>_<keyVersion>'
var serverKeyName = empty(uri) ? 'ServiceManaged' : '${split(splittedKeyUri[2], '.')[0]}_${splittedKeyUri[4]}_${splittedKeyUri[5]}'

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

resource server 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
  name: serverName
}

resource key 'Microsoft.Sql/servers/keys@2022-05-01-preview' = {
  name: !empty(name) ? name : serverKeyName
  parent: server
  properties: {
    serverKeyType: serverKeyType
    uri: uri
  }
}

@description('The name of the deployed server key.')
output name string = key.name

@description('The resource ID of the deployed server key.')
output resourceId string = key.id

@description('The resource group of the deployed server key.')
output resourceGroupName string = resourceGroup().name
