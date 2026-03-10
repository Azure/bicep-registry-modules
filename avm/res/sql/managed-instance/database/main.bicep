metadata name = 'SQL Managed Instance Databases'
metadata description = 'This module deploys a SQL Managed Instance Database.'

@description('Required. The name of the SQL managed instance database.')
param name string

@description('Conditional. The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.')
param managedInstanceName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Collation of the managed instance database.')
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Optional. Collation of the managed instance.')
param catalogCollation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Optional. Managed database create mode. PointInTimeRestore: Create a database by restoring a point in time backup of an existing database. SourceDatabaseName, SourceManagedInstanceName and PointInTime must be specified. RestoreExternalBackup: Create a database by restoring from external backup files. Collation, StorageContainerUri and StorageContainerSasToken must be specified. Recovery: Creates a database by restoring a geo-replicated backup. RecoverableDatabaseId must be specified as the recoverable database resource ID to restore. RestoreLongTermRetentionBackup: Create a database by restoring from a long term retention backup (longTermRetentionBackupResourceId required).')
@allowed([
  'Default'
  'RestoreExternalBackup'
  'PointInTimeRestore'
  'Recovery'
  'RestoreLongTermRetentionBackup'
])
param createMode string = 'Default'

@description('Conditional. The resource identifier of the source database associated with create operation of this database. Required if createMode is PointInTimeRestore.')
param sourceDatabaseId string?

@description('Conditional. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. Required if createMode is PointInTimeRestore.')
param restorePointInTime string?

@description('Optional. The restorable dropped database resource ID to restore when creating this database.')
param restorableDroppedDatabaseId string?

@description('Conditional. Specifies the uri of the storage container where backups for this restore are stored. Required if createMode is RestoreExternalBackup.')
param storageContainerUri string?

@description('Conditional. Specifies the storage container sas token. Required if createMode is RestoreExternalBackup.')
@secure()
param storageContainerSasToken string?

@description('Conditional. The resource identifier of the recoverable database associated with create operation of this database. Required if createMode is Recovery.')
param recoverableDatabaseId string?

@description('Conditional. The resource ID of the Long Term Retention backup to be used for restore of this managed database. Required if createMode is RestoreLongTermRetentionBackup.')
param longTermRetentionBackupResourceId string?

import { diagnosticSettingLogsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The database-level diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingLogsOnlyType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. The configuration for the backup short term retention policy definition.')
param backupShortTermRetentionPolicy managedInstanceShortTermRetentionPolicyType?

@description('Optional. The configuration for the backup long term retention policy definition.')
param backupLongTermRetentionPolicy managedInstanceLongTermRetentionPolicyType?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Sql/managedInstances/databases@2023-08-01'>.tags?

resource managedInstance 'Microsoft.Sql/managedInstances@2024-05-01-preview' existing = {
  name: managedInstanceName
}

resource database 'Microsoft.Sql/managedInstances/databases@2024-05-01-preview' = {
  name: name
  parent: managedInstance
  location: location
  tags: tags
  properties: {
    collation: collation
    restorePointInTime: restorePointInTime
    catalogCollation: catalogCollation
    createMode: createMode
    storageContainerUri: storageContainerUri
    sourceDatabaseId: sourceDatabaseId
    restorableDroppedDatabaseId: restorableDroppedDatabaseId
    storageContainerSasToken: storageContainerSasToken
    recoverableDatabaseId: recoverableDatabaseId
    longTermRetentionBackupResourceId: longTermRetentionBackupResourceId
  }
}

resource database_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: database
}

resource database_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: database
  }
]

module database_backupShortTermRetentionPolicy 'backup-short-term-retention-policy/main.bicep' = if (!empty(backupShortTermRetentionPolicy)) {
  name: '${deployment().name}-BackupShortTRetPol'
  params: {
    managedInstanceName: managedInstanceName
    databaseName: last(split(database.name, '/'))!
    name: backupShortTermRetentionPolicy.?name
    retentionDays: backupShortTermRetentionPolicy.?retentionDays
  }
}

module database_backupLongTermRetentionPolicy 'backup-long-term-retention-policy/main.bicep' = if (!empty(backupLongTermRetentionPolicy)) {
  name: '${deployment().name}-BackupLongTRetPol'
  params: {
    managedInstanceName: managedInstanceName
    databaseName: last(split(database.name, '/'))!
    name: backupLongTermRetentionPolicy.?name
    weekOfYear: backupLongTermRetentionPolicy.?weekOfYear
    weeklyRetention: backupLongTermRetentionPolicy.?weeklyRetention
    monthlyRetention: backupLongTermRetentionPolicy.?monthlyRetention
    yearlyRetention: backupLongTermRetentionPolicy.?yearlyRetention
  }
  dependsOn: [
    database_backupShortTermRetentionPolicy
  ]
}

@description('The name of the deployed database.')
output name string = database.name

@description('The resource ID of the deployed database.')
output resourceId string = database.id

@description('The resource group the database was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = database.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for the long term backup retention policy.')
type managedInstanceLongTermRetentionPolicyType = {
  @description('Optional. The name of the long term retention policy. If not specified, \'default\' name will be used.')
  name: string?

  @description('Optional. The BackupStorageAccessTier for the LTR backups.')
  backupStorageAccessTier: 'Archive' | 'Hot'?

  @description('Optional. The monthly retention policy for an LTR backup in an ISO 8601 format.')
  monthlyRetention: string?

  @description('Optional. The weekly retention policy for an LTR backup in an ISO 8601 format.')
  weeklyRetention: string?

  @description('Optional. The week of year to take the yearly backup in an ISO 8601 format.')
  weekOfYear: int?

  @description('Optional. The yearly retention policy for an LTR backup in an ISO 8601 format.')
  yearlyRetention: string?
}

@export()
@description('The type for the short term backup retention policy.')
type managedInstanceShortTermRetentionPolicyType = {
  @description('Optional. The name of the short term retention policy. If not specified, \'default\' name will be used.')
  name: string?

  @description('Optional. The backup retention period in days. This is how many days Point-in-Time Restore will be supported. If not specified, the default value is 35 days.')
  retentionDays: int?
}
