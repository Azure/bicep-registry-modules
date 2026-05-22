metadata name = 'Azure SQL Server Keys'
metadata description = 'This module deploys an Azure SQL Server Key.'

@description('Optional. The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern. Required when using a versionless Key Vault key URI.')
param name string?

@description('Conditional. The name of the parent SQL server. Required if the template is used in a standalone deployment.')
param serverName string

@description('Optional. The server key type.')
@allowed([
  'AzureKeyVault'
  'ServiceManaged'
])
param serverKeyType string = 'ServiceManaged'

@description('Optional. The URI of the server key. If the ServerKeyType is AzureKeyVault, then the URI is required. The AKV URI must be in this format: \'https://YourVaultName.azure.net/keys/YourKeyName/YourKeyVersion\' or \'https://YourVaultName.azure.net/keys/YourKeyName\'.')
param uri string = ''

var splittedKeyUri = split(uri, '/')
var keyVersion = splittedKeyUri[?5]

// if serverManaged, use serverManaged, if uri provided use concated uri value
// MUST match the pattern '<keyVaultName>_<keyName>_<keyVersion>'
var serverKeyName = !empty(name)
  ? name!
  : empty(uri)
      ? 'ServiceManaged'
      : !empty(keyVersion)
          ? '${split(splittedKeyUri[2], '.')[0]}_${splittedKeyUri[4]}_${keyVersion!}'
          : fail('The `name` parameter is required when using a versionless Key Vault key URI.')

resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName
}

resource key 'Microsoft.Sql/servers/keys@2023-08-01' = {
  name: serverKeyName
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
