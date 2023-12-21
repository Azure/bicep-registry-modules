metadata name = 'Data Protection Backup Vault Backup Policies'
metadata description = 'This module deploys a Data Protection Backup Vault Backup Policy.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the backup vault.')
param backupVaultName string

@description('Optional. The name of the backup policy.')
param name string = 'DefaultPolicy'

@description('Optional. The properties of the backup policy.')
param properties object = {}

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
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

resource backupVault 'Microsoft.DataProtection/backupVaults@2023-05-01' existing = {
  name: backupVaultName
}

resource backupPolicy 'Microsoft.DataProtection/backupVaults/backupPolicies@2023-05-01' = {
  name: name
  parent: backupVault
  properties: properties
}

@description('The name of the backup policy.')
output name string = backupPolicy.name

@description('The resource ID of the backup policy.')
output resourceId string = backupPolicy.id

@description('The name of the resource group the backup policy was created in.')
output resourceGroupName string = resourceGroup().name
