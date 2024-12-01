@description('Optional. The name of the backup.')
param name string = 'backup'

@description('Conditional. The name of the parent backup vault. Required if the template is used in a standalone deployment.')
param backupVaultName string

@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Optional. Label for backup.')
param label string?

@description('Optional. The name of the snapshot.')
param snapshotName string = 'snapshot'

@description('Optional. Manual backup an already existing snapshot. This will always be false for scheduled backups and true/false for manual backups.')
param useExistingSnapshot bool = false

@description('Required. The name used to identify the volume.')
param volumeName string

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2024-03-01' existing = {
  name: netAppAccountName

  resource backupVault 'backupVaults@2024-03-01' existing = {
    name: backupVaultName
  }
}

resource remoteVolume 'Microsoft.NetApp/netAppAccounts/capacityPools/volumes@2024-07-01' existing = {
  name: volumeName
}

resource backup 'Microsoft.NetApp/netAppAccounts/backupVaults/backups@2024-03-01' = {
  name: name
  parent: netAppAccount::backupVault
  properties: {
    label: label
    snapshotName: snapshotName
    useExistingSnapshot: useExistingSnapshot
    volumeResourceId: remoteVolume.name
  }
}

@description('The name of the backup.')
output name string = backup.name

@description('The Resource ID of the backup.')
output resourceId string = backup.id

@description('The name of the Resource Group the backup was created in.')
output resourceGroupName string = resourceGroup().name
