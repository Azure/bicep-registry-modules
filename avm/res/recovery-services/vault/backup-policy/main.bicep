metadata name = 'Recovery Services Vault Backup Policies'
metadata description = 'This module deploys a Recovery Services Vault Backup Policy.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.')
param recoveryVaultName string

@description('Required. Name of the Azure Recovery Service Vault Backup Policy.')
param name string

@description('Required. Configuration of the Azure Recovery Service Vault Backup Policy.')
param properties object

resource rsv 'Microsoft.RecoveryServices/vaults@2023-01-01' existing = {
  name: recoveryVaultName
}

resource backupPolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2023-01-01' = {
  name: name
  parent: rsv
  properties: properties
}

@description('The name of the backup policy.')
output name string = backupPolicy.name

@description('The resource ID of the backup policy.')
output resourceId string = backupPolicy.id

@description('The name of the resource group the backup policy was created in.')
output resourceGroupName string = resourceGroup().name
