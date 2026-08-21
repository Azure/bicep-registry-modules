metadata name = 'Azure SQL Server Encryption Protector'
metadata description = 'This module deploys an Azure SQL Server Encryption Protector.'

@description('Conditional. The name of the sql server. Required if the template is used in a standalone deployment.')
param sqlServerName string

@description('Required. The name of the server key.')
param serverKeyName string

@description('Optional. Key auto rotation opt-in flag.')
param autoRotationEnabled bool = true

@description('Optional. The encryption protector type.')
@allowed([
  'AzureKeyVault'
  'ServiceManaged'
])
param serverKeyType string = 'ServiceManaged'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.sql-server-encryptionprotector.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource sqlServer 'Microsoft.Sql/servers@2025-01-01' existing = {
  name: sqlServerName
}

resource encryptionProtector 'Microsoft.Sql/servers/encryptionProtector@2025-01-01' = {
  name: 'current'
  parent: sqlServer
  properties: {
    serverKeyType: serverKeyType
    autoRotationEnabled: autoRotationEnabled
    serverKeyName: serverKeyName
  }
}

@description('The name of the deployed encryption protector.')
output name string = encryptionProtector.name

@description('The resource ID of the encryption protector.')
output resourceId string = encryptionProtector.id

@description('The resource group of the deployed encryption protector.')
output resourceGroupName string = resourceGroup().name
