metadata name = 'Azure NetApp Files Backup Policy'
metadata description = 'This module deploys a Backup Policy for Azure NetApp File.'

@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Optional. The name of the backup policy.')
param backupPolicyName string = 'backupPolicy'

@description('Required. The location of the backup policy. Required if the template is used in a standalone deployment.')
param backupPolicyLocation string

@description('Required. The daily backups to keep.')
param dailyBackupsToKeep int

@description('Required. The monthly backups to keep.')
param monthlyBackupsToKeep int

@description('Required. The weekly backups to keep.')
param weeklyBackupsToKeep int

@description('Optional. Indicates whether the backup policy is enabled.')
param backupEnabled bool = false

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2024-03-01' existing = {
  name: netAppAccountName
}

resource backupPolicies 'Microsoft.NetApp/netAppAccounts/backupPolicies@2024-03-01' = {
  name: backupPolicyName
  parent: netAppAccount
  location: backupPolicyLocation
  properties: {
    dailyBackupsToKeep: dailyBackupsToKeep
    enabled: backupEnabled
    monthlyBackupsToKeep: monthlyBackupsToKeep
    weeklyBackupsToKeep: weeklyBackupsToKeep
  }
}
@description('The resource IDs of the backup Policy created within volume.')
output resourceId string = backupPolicies.id

@description('The name of the Backup Policy.')
output name string = backupPolicies.name

@description('The name of the Resource Group the Backup Policy was created in.')
output resourceGroupName string = resourceGroup().name
