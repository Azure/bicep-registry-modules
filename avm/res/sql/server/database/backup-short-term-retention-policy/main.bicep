metadata name = 'Azure SQL Server Database Short Term Backup Retention Policies'
metadata description = 'This module deploys an Azure SQL Server Database Short-Term Backup Retention Policy.'

@description('Required. The name of the parent SQL Server.')
param serverName string

@description('Required. The name of the parent database.')
param databaseName string

@description('Optional. Differential backup interval in hours. For Hyperscal tiers this value will be ignored.')
param diffBackupIntervalInHours int = 24

@description('Optional. Poin-in-time retention in days.')
param retentionDays int = 7

resource server 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: serverName

  resource database 'databases@2023-08-01-preview' existing = {
    name: databaseName
  }
}

resource backupShortTermRetentionPolicy 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2023-08-01-preview' = {
  name: 'default'
  parent: server::database
  properties: {
    diffBackupIntervalInHours: server::database.sku.tier == 'Hyperscale' ? null : diffBackupIntervalInHours
    retentionDays: retentionDays
  }
}

@description('The resource group the short-term policy was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the short-term policy.')
output name string = backupShortTermRetentionPolicy.name

@description('The resource ID of the short-term policy.')
output resourceId string = backupShortTermRetentionPolicy.id
