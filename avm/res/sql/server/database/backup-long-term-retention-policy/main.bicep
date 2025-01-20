metadata name = 'SQL Server Database Long Term Backup Retention Policies'
metadata description = 'This module deploys an Azure SQL Server Database Long-Term Backup Retention Policy.'

@description('Required. The name of the parent SQL Server.')
param serverName string

@description('Required. The name of the parent database.')
param databaseName string

@description('Optional. The BackupStorageAccessTier for the LTR backups.')
param backupStorageAccessTier 'Archive' | 'Hot'?

@description('Optional. The setting whether to make LTR backups immutable.')
param makeBackupsImmutable bool?

@description('Optional. Monthly retention in ISO 8601 duration format.')
param monthlyRetention string?

@description('Optional. Weekly retention in ISO 8601 duration format.')
param weeklyRetention string?

@description('Optional. Week of year backup to keep for yearly retention.')
param weekOfYear int = 1

@description('Optional. Yearly retention in ISO 8601 duration format.')
param yearlyRetention string?

resource server 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: serverName

  resource database 'databases@2023-08-01-preview' existing = {
    name: databaseName
  }
}

resource backupLongTermRetentionPolicy 'Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies@2023-05-01-preview' = {
  name: 'default'
  parent: server::database
  properties: {
    backupStorageAccessTier: backupStorageAccessTier
    makeBackupsImmutable: makeBackupsImmutable
    monthlyRetention: monthlyRetention
    weeklyRetention: weeklyRetention
    weekOfYear: weekOfYear
    yearlyRetention: yearlyRetention
  }
}

@description('The resource group the long-term policy was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the long-term policy.')
output name string = backupLongTermRetentionPolicy.name

@description('The resource ID of the long-term policy.')
output resourceId string = backupLongTermRetentionPolicy.id
