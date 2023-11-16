metadata name = 'Azure SQL Server Database Short Term Backup Retention Policies'
metadata description = 'This module deploys an Azure SQL Server Database Short-Term Backup Retention Policy.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the parent SQL Server.')
param serverName string

@description('Required. The name of the parent database.')
param databaseName string

@description('Optional. Differential backup interval in hours.')
param diffBackupIntervalInHours int = 24

@description('Optional. Poin-in-time retention in days.')
param retentionDays int = 7

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource server 'Microsoft.Sql/servers@2022-05-01-preview' existing = {
  name: serverName
}

resource database 'Microsoft.Sql/servers/databases@2022-05-01-preview' existing = {
  name: databaseName
  parent: server
}

resource backupShortTermRetentionPolicy 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2022-05-01-preview' = {
  name: 'default'
  parent: database
  properties: {
    diffBackupIntervalInHours: diffBackupIntervalInHours
    retentionDays: retentionDays
  }
}

@description('The resource group the short-term policy was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the short-term policy.')
output name string = backupShortTermRetentionPolicy.name

@description('The resource ID of the short-term policy.')
output resourceId string = backupShortTermRetentionPolicy.id
