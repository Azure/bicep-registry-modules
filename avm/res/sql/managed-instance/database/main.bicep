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
param sourceDatabaseId string = ''

@description('Conditional. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. Required if createMode is PointInTimeRestore.')
param restorePointInTime string = ''

@description('Optional. The restorable dropped database resource ID to restore when creating this database.')
param restorableDroppedDatabaseId string = ''

@description('Conditional. Specifies the uri of the storage container where backups for this restore are stored. Required if createMode is RestoreExternalBackup.')
param storageContainerUri string = ''

@description('Conditional. Specifies the storage container sas token. Required if createMode is RestoreExternalBackup.')
@secure()
param storageContainerSasToken string = ''

@description('Conditional. The resource identifier of the recoverable database associated with create operation of this database. Required if createMode is Recovery.')
param recoverableDatabaseId string = ''

@description('Conditional. The resource ID of the Long Term Retention backup to be used for restore of this managed database. Required if createMode is RestoreLongTermRetentionBackup.')
param longTermRetentionBackupResourceId string = ''

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The configuration for the backup short term retention policy definition.')
param backupShortTermRetentionPoliciesObj object = {}

@description('Optional. The configuration for the backup long term retention policy definition.')
param backupLongTermRetentionPoliciesObj object = {}

@description('Optional. Tags of the resource.')
param tags object?

resource managedInstance 'Microsoft.Sql/managedInstances@2023-08-01-preview' existing = {
  name: managedInstanceName
}

resource database 'Microsoft.Sql/managedInstances/databases@2023-08-01-preview' = {
  name: name
  parent: managedInstance
  location: location
  tags: tags
  properties: {
    collation: empty(collation) ? null : collation
    restorePointInTime: empty(restorePointInTime) ? null : restorePointInTime
    catalogCollation: empty(catalogCollation) ? null : catalogCollation
    createMode: empty(createMode) ? null : createMode
    storageContainerUri: empty(storageContainerUri) ? null : storageContainerUri
    sourceDatabaseId: empty(sourceDatabaseId) ? null : sourceDatabaseId
    restorableDroppedDatabaseId: empty(restorableDroppedDatabaseId) ? null : restorableDroppedDatabaseId
    storageContainerSasToken: empty(storageContainerSasToken) ? null : storageContainerSasToken
    recoverableDatabaseId: empty(recoverableDatabaseId) ? null : recoverableDatabaseId
    longTermRetentionBackupResourceId: empty(longTermRetentionBackupResourceId)
      ? null
      : longTermRetentionBackupResourceId
  }
}

resource database_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
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

module database_backupShortTermRetentionPolicy 'backup-short-term-retention-policy/main.bicep' = if (!empty(backupShortTermRetentionPoliciesObj)) {
  name: '${deployment().name}-BackupShortTRetPol'
  params: {
    managedInstanceName: managedInstanceName
    databaseName: last(split(database.name, '/'))!
    name: backupShortTermRetentionPoliciesObj.name
    retentionDays: contains(backupShortTermRetentionPoliciesObj, 'retentionDays')
      ? backupShortTermRetentionPoliciesObj.retentionDays
      : 35
  }
}

module database_backupLongTermRetentionPolicy 'backup-long-term-retention-policy/main.bicep' = if (!empty(backupLongTermRetentionPoliciesObj)) {
  name: '${deployment().name}-BackupLongTRetPol'
  params: {
    managedInstanceName: managedInstanceName
    databaseName: last(split(database.name, '/'))!
    name: backupLongTermRetentionPoliciesObj.name
    weekOfYear: contains(backupLongTermRetentionPoliciesObj, 'weekOfYear')
      ? backupLongTermRetentionPoliciesObj.weekOfYear
      : 5
    weeklyRetention: contains(backupLongTermRetentionPoliciesObj, 'weeklyRetention')
      ? backupLongTermRetentionPoliciesObj.weeklyRetention
      : 'P1M'
    monthlyRetention: contains(backupLongTermRetentionPoliciesObj, 'monthlyRetention')
      ? backupLongTermRetentionPoliciesObj.monthlyRetention
      : 'P1Y'
    yearlyRetention: contains(backupLongTermRetentionPoliciesObj, 'yearlyRetention')
      ? backupLongTermRetentionPoliciesObj.yearlyRetention
      : 'P5Y'
  }
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

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to \'\' to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to \'AllLogs\' to collect all logs.')
    categoryGroup: string?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?
