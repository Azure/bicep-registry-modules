metadata name = 'SQL Managed Instance Encryption Protector'
metadata description = 'This module deploys a SQL Managed Instance Encryption Protector.'

@description('Conditional. The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.')
param managedInstanceName string

@description('Required. The name of the SQL managed instance key.')
param serverKeyName string

@description('Optional. The encryption protector type like "ServiceManaged", "AzureKeyVault".')
@allowed([
  'AzureKeyVault'
  'ServiceManaged'
])
param serverKeyType string = 'ServiceManaged'

@description('Optional. Key auto rotation opt-in flag.')
param autoRotationEnabled bool = false

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.sql-mi-encryptionprotecor.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' existing = {
  name: managedInstanceName
}

resource encryptionProtector 'Microsoft.Sql/managedInstances/encryptionProtector@2024-05-01-preview' = {
  name: 'current'
  parent: managedInstance
  properties: {
    autoRotationEnabled: autoRotationEnabled
    serverKeyName: serverKeyName
    serverKeyType: serverKeyType
  }
}

@description('The name of the deployed managed instance encryption protector.')
output name string = encryptionProtector.name

@description('The resource ID of the deployed managed instance encryption protector.')
output resourceId string = encryptionProtector.id

@description('The resource group of the deployed managed instance encryption protector.')
output resourceGroupName string = resourceGroup().name
