metadata name = 'SQL Managed Instance Database Backup Long-Term Retention Policies'
metadata description = 'This module deploys a SQL Managed Instance Database Backup Long-Term Retention Policy.'

@description('Optional. The name of the Long Term Retention backup policy.')
param name string = 'default'

@description('Conditional. The name of the parent managed instance database. Required if the template is used in a standalone deployment.')
param databaseName string

@description('Conditional. The name of the parent managed instance. Required if the template is used in a standalone deployment.')
param managedInstanceName string

@allowed([
  'Archive'
  'Hot'
])
@description('Optional. The BackupStorageAccessTier for the LTR backups.')
param backupStorageAccessTier string = 'Hot'

@description('Optional. The week of year to take the yearly backup in an ISO 8601 format.')
param weekOfYear int = 5

@description('Optional. The weekly retention policy for an LTR backup in an ISO 8601 format.')
param weeklyRetention string = 'P1M'

@description('Optional. The monthly retention policy for an LTR backup in an ISO 8601 format.')
param monthlyRetention string = 'P1Y'

@description('Optional. The yearly retention policy for an LTR backup in an ISO 8601 format.')
param yearlyRetention string = 'P5Y'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.sql-mi-dbbckplongermretpolicy.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' existing = {
  name: managedInstanceName

  resource managedInstaceDatabase 'databases@2024-05-01-preview' existing = {
    name: databaseName
  }
}

resource backupLongTermRetentionPolicy 'Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies@2024-05-01-preview' = {
  name: name
  parent: managedInstance::managedInstaceDatabase
  properties: {
    backupStorageAccessTier: backupStorageAccessTier
    monthlyRetention: monthlyRetention
    weeklyRetention: weeklyRetention
    weekOfYear: weekOfYear
    yearlyRetention: yearlyRetention
  }
}

@description('The name of the deployed database backup long-term retention policy.')
output name string = backupLongTermRetentionPolicy.name

@description('The resource ID of the deployed database backup long-term retention policy.')
output resourceId string = backupLongTermRetentionPolicy.id

@description('The resource group of the deployed database backup long-term retention policy.')
output resourceGroupName string = resourceGroup().name
