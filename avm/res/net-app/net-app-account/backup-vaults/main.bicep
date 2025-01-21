@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Optional. The name of the backup vault.')
param backupVaultName string

@description('Optional. The location of the backup vault.')
param backupVaultLocation string = resourceGroup().location

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2024-03-01' existing = {
  name: netAppAccountName
}

resource backupVaults 'Microsoft.NetApp/netAppAccounts/backupVaults@2024-03-01' = {
  name: backupVaultName
  parent: netAppAccount
  location: backupVaultLocation
  properties: {}
}

@description('The resource IDs of the backup Policy created within volume.')
output resourceId string = backupVaults.id

@description('The name of the Backup Policy.')
output name string = backupVaults.name

@description('The name of the Resource Group the Backup Policy was created in.')
output resourceGroupName string = resourceGroup().name
