metadata name = 'Azure SQL Server Keys'
metadata description = 'This module deploys an Azure SQL Server Key.'

@description('Optional. The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern for versioned URIs or [<keyVaultName>_<keyName>] for versionless URIs.')
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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var splittedKeyUri = split(uri, '/')
var keyVersion = splittedKeyUri[?5]

// If service-managed, use ServiceManaged. Otherwise derive a name that matches the key identifier shape.
var serverKeyName = !empty(name)
  ? name!
  : empty(uri)
      ? 'ServiceManaged'
      : !empty(keyVersion)
          ? '${split(splittedKeyUri[2], '.')[0]}_${splittedKeyUri[4]}_${keyVersion!}'
          : '${split(splittedKeyUri[2], '.')[0]}_${splittedKeyUri[4]}'

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.sql-server-key.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource server 'Microsoft.Sql/servers@2025-01-01' existing = {
  name: serverName
}

resource key 'Microsoft.Sql/servers/keys@2025-01-01' = {
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
