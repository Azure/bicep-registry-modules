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

resource sqlServer 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: sqlServerName
}

resource encryptionProtector 'Microsoft.Sql/servers/encryptionProtector@2023-08-01-preview' = {
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
