metadata name = 'SQL Managed Instance Database Backup Short-Term Retention Policies'
metadata description = 'This module deploys a SQL Managed Instance Database Backup Short-Term Retention Policy.'

@description('Required. The name of the Short Term Retention backup policy. For example "default".')
param name string

@description('Conditional. The name of the parent SQL managed instance database. Required if the template is used in a standalone deployment.')
param databaseName string

@description('Conditional. The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.')
param managedInstanceName string

@description('Optional. The backup retention period in days. This is how many days Point-in-Time Restore will be supported.')
param retentionDays int = 35

resource managedInstance 'Microsoft.Sql/managedInstances@2023-08-01-preview' existing = {
  name: managedInstanceName

  resource managedInstaceDatabase 'databases@2023-08-01-preview' existing = {
    name: databaseName
  }
}

resource backupShortTermRetentionPolicy 'Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies@2023-08-01-preview' = {
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
