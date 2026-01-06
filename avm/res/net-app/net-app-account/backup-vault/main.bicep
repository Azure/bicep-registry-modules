metadata name = 'Azure NetApp Files Volume Backup Vault'
metadata description = 'This module deploys a NetApp Files Backup Vault.'

@description('Optional. The name of the backup vault.')
param name string = 'vault'

@description('Optional. Location of the backup vault.')
param location string = resourceGroup().location

@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Optional. The list of backups to create.')
param backups backupType[]?

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2025-01-01' existing = {
  name: netAppAccountName
}

resource backupVault 'Microsoft.NetApp/netAppAccounts/backupVaults@2025-01-01' = {
  name: name
  parent: netAppAccount
  location: location
  properties: {}
}

module backupVault_backups 'backup/main.bicep' = [
  for (backup, index) in (backups ?? []): {
    name: '${uniqueString(deployment().name, location)}-ANF-Backup-${index}'
    params: {
      netAppAccountName: netAppAccount.name
      backupVaultName: backupVault.name
      name: backup.?name
      label: backup.?label
      snapshotName: backup.?snapshotName
      volumeName: backup.volumeName
      capacityPoolName: backup.capacityPoolName
    }
  }
]

@description('The name of the backup vault.')
output name string = backupVault.name

@description('The Resource ID of the backup vault.')
output resourceId string = backupVault.id

@description('The name of the Resource Group the backup vault was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = backupVault.location

// ================ //
// Definitions      //
// ================ //

@export()
@description('The type for a backup.')
type backupType = {
  @description('Optional. The name of the backup.')
  name: string?

  @description('Optional. Label for backup.')
  label: string?

  @description('Optional. The name of the snapshot.')
  snapshotName: string?

  @description('Required. The name of the volume to backup.')
  volumeName: string

  @description('Required. The name of the capacity pool containing the volume.')
  capacityPoolName: string
}
