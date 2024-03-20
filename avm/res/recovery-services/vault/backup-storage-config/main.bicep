metadata name = 'Recovery Services Vault Backup Storage Config'
metadata description = 'This module deploys a Recovery Service Vault Backup Storage Configuration.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.')
param recoveryVaultName string

@description('Optional. The name of the backup storage config.')
param name string = 'vaultstorageconfig'

@description('Optional. Change Vault Storage Type (Works if vault has not registered any backup instance).')
@allowed([
  'GeoRedundant'
  'LocallyRedundant'
  'ReadAccessGeoZoneRedundant'
  'ZoneRedundant'
])
param storageModelType string = 'GeoRedundant'

@description('Optional. Opt in details of Cross Region Restore feature.')
param crossRegionRestoreFlag bool = true

resource rsv 'Microsoft.RecoveryServices/vaults@2023-01-01' existing = {
  name: recoveryVaultName
}

resource backupStorageConfig 'Microsoft.RecoveryServices/vaults/backupstorageconfig@2023-01-01' = {
  name: name
  parent: rsv
  properties: {
    storageModelType: storageModelType
    crossRegionRestoreFlag: crossRegionRestoreFlag
  }
}

@description('The name of the backup storage config.')
output name string = backupStorageConfig.name

@description('The resource ID of the backup storage config.')
output resourceId string = backupStorageConfig.id

@description('The name of the Resource Group the backup storage configuration was created in.')
output resourceGroupName string = resourceGroup().name
