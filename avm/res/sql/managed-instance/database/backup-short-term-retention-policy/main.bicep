metadata name = 'SQL Managed Instance Database Backup Short-Term Retention Policies'
metadata description = 'This module deploys a SQL Managed Instance Database Backup Short-Term Retention Policy.'

@description('Optional. The name of the Short Term Retention backup policy.')
param name string = 'default'

@description('Conditional. The name of the parent SQL managed instance database. Required if the template is used in a standalone deployment.')
param databaseName string

@description('Conditional. The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.')
param managedInstanceName string

@description('Optional. The backup retention period in days. This is how many days Point-in-Time Restore will be supported.')
param retentionDays int = 35

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.sql-mi-dbbckpshortermretpolicy.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource backupShortTermRetentionPolicy 'Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies@2024-05-01-preview' = {
  name: name
  parent: managedInstance::managedInstaceDatabase
  properties: {
    retentionDays: retentionDays
  }
}

@description('The name of the deployed database backup short-term retention policy.')
output name string = backupShortTermRetentionPolicy.name

@description('The resource ID of the deployed database backup short-term retention policy.')
output resourceId string = backupShortTermRetentionPolicy.id

@description('The resource group of the deployed database backup short-term retention policy.')
output resourceGroupName string = resourceGroup().name
