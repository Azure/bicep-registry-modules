metadata name = 'SQL Server Database'
metadata description = 'This module deploys an Azure SQL Server Database.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the database.')
param name string

@description('Conditional. The name of the parent SQL Server. Required if the template is used in a standalone deployment.')
param serverName string

@description('Optional. The collation of the database.')
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Optional. The skuTier or edition of the particular SKU.')
param skuTier string = 'GeneralPurpose'

@description('Optional. The name of the SKU.')
param skuName string = 'GP_Gen5_2'

@description('Optional. Capacity of the particular SKU.')
param skuCapacity int?

@description('Optional. Type of enclave requested on the database i.e. Default or VBS enclaves.')
@allowed([
  ''
  'Default'
  'VBS'
])
param preferredEnclaveType string = ''

@description('Optional. If the service has different generations of hardware, for the same SKU, then that can be captured here.')
param skuFamily string = ''

@description('Optional. Size of the particular SKU.')
param skuSize string = ''

@description('Optional. The max size of the database expressed in bytes.')
param maxSizeBytes int = 34359738368

@description('Optional. The name of the sample schema to apply when creating this database.')
param sampleName string = ''

@description('Optional. Whether or not this database is zone redundant.')
param zoneRedundant bool = true

@description('Optional. The license type to apply for this database.')
param licenseType string = ''

@description('Optional. The state of read-only routing.')
@allowed([
  'Enabled'
  'Disabled'
])
param readScale string = 'Disabled'

@description('Optional. The number of readonly secondary replicas associated with the database.')
param highAvailabilityReplicaCount int = 0

@description('Optional. Minimal capacity that database will always have allocated.')
param minCapacity string = ''

@description('Optional. Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled.')
param autoPauseDelay int = 0

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The resource ID of the elastic pool containing this database.')
param elasticPoolId string = ''

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Specifies the mode of database creation.')
@allowed([
  'Default'
  'Copy'
  'OnlineSecondary'
  'PointInTimeRestore'
  'Recovery'
  'Restore'
  'RestoreLongTermRetentionBackup'
  'Secondary'
])
param createMode string = 'Default'

@description('Optional. Resource ID of database if createMode set to Copy, Secondary, PointInTimeRestore, Recovery or Restore.')
param sourceDatabaseResourceId string = ''

@description('Optional. The time that the database was deleted when restoring a deleted database.')
param sourceDatabaseDeletionDate string = ''

@description('Optional. Resource ID of backup if createMode set to RestoreLongTermRetentionBackup.')
param recoveryServicesRecoveryPointResourceId string = ''

@description('Optional. Point in time (ISO8601 format) of the source database to restore when createMode set to Restore or PointInTimeRestore.')
param restorePointInTime string = ''

@description('Optional. The storage account type to be used to store backups for this database.')
@allowed([
  'Geo'
  'Local'
  'Zone'
  ''
])
param requestedBackupStorageRedundancy string = ''

@description('Optional. Whether or not this database is a ledger database, which means all tables in the database are ledger tables. Note: the value of this property cannot be changed after the database has been created.')
param isLedgerOn bool = false

@description('Optional. Maintenance configuration ID assigned to the database. This configuration defines the period when the maintenance updates will occur.')
param maintenanceConfigurationId string = ''

@description('Optional. The short term backup retention policy to create for the database.')
param backupShortTermRetentionPolicy object = {}

@description('Optional. The long term backup retention policy to create for the database.')
param backupLongTermRetentionPolicy object = {}

// The SKU object must be built in a variable
// The alternative, 'null' as default values, leads to non-terminating deployments
var skuVar = union(
  {
    name: skuName
    tier: skuTier
  },
  (skuCapacity != null)
    ? {
        capacity: skuCapacity
      }
    : !empty(skuFamily)
        ? {
            family: skuFamily
          }
        : !empty(skuSize)
            ? {
                size: skuSize
              }
            : {}
)

resource server 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: serverName
}

resource database 'Microsoft.Sql/servers/databases@2023-08-01-preview' = {
  name: name
  parent: server
  location: location
  tags: tags
  properties: {
    preferredEnclaveType: !empty(preferredEnclaveType) ? preferredEnclaveType : null
    collation: collation
    maxSizeBytes: maxSizeBytes
    sampleName: sampleName
    zoneRedundant: zoneRedundant
    licenseType: licenseType
    readScale: readScale
    minCapacity: !empty(minCapacity) ? json(minCapacity) : 0 // The json() function is used to allow specifying a decimal value.
    autoPauseDelay: autoPauseDelay
    highAvailabilityReplicaCount: highAvailabilityReplicaCount
    requestedBackupStorageRedundancy: any(requestedBackupStorageRedundancy)
    isLedgerOn: isLedgerOn
    maintenanceConfigurationId: !empty(maintenanceConfigurationId) ? maintenanceConfigurationId : null
    elasticPoolId: elasticPoolId
    createMode: createMode
    sourceDatabaseId: !empty(sourceDatabaseResourceId) ? sourceDatabaseResourceId : null
    sourceDatabaseDeletionDate: !empty(sourceDatabaseDeletionDate) ? sourceDatabaseDeletionDate : null
    recoveryServicesRecoveryPointId: !empty(recoveryServicesRecoveryPointResourceId)
      ? recoveryServicesRecoveryPointResourceId
      : null
    restorePointInTime: !empty(restorePointInTime) ? restorePointInTime : null
  }
  sku: skuVar
}

resource database_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
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

module database_backupShortTermRetentionPolicy 'backup-short-term-retention-policy/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-${name}-shBakRetPol'
  params: {
    serverName: serverName
    databaseName: database.name
    diffBackupIntervalInHours: contains(backupShortTermRetentionPolicy, 'diffBackupIntervalInHours')
      ? backupShortTermRetentionPolicy.diffBackupIntervalInHours
      : 24
    retentionDays: contains(backupShortTermRetentionPolicy, 'retentionDays')
      ? backupShortTermRetentionPolicy.retentionDays
      : 7
  }
}

module database_backupLongTermRetentionPolicy 'backup-long-term-retention-policy/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-${name}-lgBakRetPol'
  params: {
    serverName: serverName
    databaseName: database.name
    weeklyRetention: contains(backupLongTermRetentionPolicy, 'weeklyRetention')
      ? backupLongTermRetentionPolicy.weeklyRetention
      : ''
    monthlyRetention: contains(backupLongTermRetentionPolicy, 'monthlyRetention')
      ? backupLongTermRetentionPolicy.monthlyRetention
      : ''
    yearlyRetention: contains(backupLongTermRetentionPolicy, 'yearlyRetention')
      ? backupLongTermRetentionPolicy.yearlyRetention
      : ''
    weekOfYear: contains(backupLongTermRetentionPolicy, 'weekOfYear') ? backupLongTermRetentionPolicy.weekOfYear : 1
  }
}

@description('The name of the deployed database.')
output name string = database.name

@description('The resource ID of the deployed database.')
output resourceId string = database.id

@description('The resource group of the deployed database.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = database.location

// =============== //
//   Definitions   //
// =============== //

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
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
