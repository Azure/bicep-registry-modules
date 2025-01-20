metadata name = 'Data Protection Backup Vault Backup Policies'
metadata description = 'This module deploys a Data Protection Backup Vault Backup Policy.'

@description('Required. The name of the backup vault.')
param backupVaultName string

@description('Optional. The name of the backup policy.')
param name string = 'DefaultPolicy'

@description('Optional. The properties of the backup policy.')
param properties object = {}

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
