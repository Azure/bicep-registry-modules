metadata name = 'Azure NetApp Files Backup Policy'
metadata description = 'This module deploys a Backup Policy for Azure NetApp File.'

@description('Conditional. The name of the parent NetApp account. Required if the template is used in a standalone deployment.')
param netAppAccountName string

@description('Optional. The name of the backup policy.')
param name string = 'backupPolicy'

@description('Optional. The location of the backup policy.')
param location string = resourceGroup().location

@description('Optional. The daily backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter\'s max).')
@minValue(2)
@maxValue(1019)
param dailyBackupsToKeep int = 2

@description('Optional. The monthly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter\'s max).')
@minValue(0)
@maxValue(1019)
param monthlyBackupsToKeep int = 0

@description('Optional. The weekly backups to keep. Note, the maximum hourly, daily, weekly, and monthly backup retention counts _combined_ is 1019 (this parameter\'s max).')
@minValue(0)
@maxValue(1019)
param weeklyBackupsToKeep int = 0

@description('Optional. Indicates whether the backup policy is enabled.')
param enabled bool = true

resource netAppAccount 'Microsoft.NetApp/netAppAccounts@2025-01-01' existing = {
  name: netAppAccountName
}

resource backupPolicies 'Microsoft.NetApp/netAppAccounts/backupPolicies@2025-01-01' = {
  name: name
  parent: netAppAccount
  location: location
  properties: {
    enabled: enabled
    dailyBackupsToKeep: dailyBackupsToKeep
    weeklyBackupsToKeep: weeklyBackupsToKeep
    monthlyBackupsToKeep: monthlyBackupsToKeep
  }
}
@description('The resource IDs of the backup Policy created within volume.')
output resourceId string = backupPolicies.id

@description('The name of the Backup Policy.')
output name string = backupPolicies.name

@description('The name of the Resource Group the Backup Policy was created in.')
output resourceGroupName string = resourceGroup().name
