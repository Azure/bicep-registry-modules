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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var enableReferencedModulesTelemetry = false

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.netapp-netappaccount-backupvault.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
      enableTelemetry: enableReferencedModulesTelemetry
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
