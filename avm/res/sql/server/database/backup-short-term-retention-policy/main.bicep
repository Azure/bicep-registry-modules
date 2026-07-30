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

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource server 'Microsoft.Sql/servers@2025-01-01' existing = {
  name: serverName

  resource database 'databases@2025-01-01' existing = {
    name: databaseName
  }
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.sql-server-dbbckpshorttermretpolicy.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource backupShortTermRetentionPolicy 'Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies@2025-01-01' = {
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
