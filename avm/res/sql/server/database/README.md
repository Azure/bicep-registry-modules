# SQL Server Database `[Microsoft.Sql/servers/databases]`

This module deploys an Azure SQL Server Database.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Sql/servers/databases` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/databases) |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | [2023-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-05-01-preview/servers/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the database. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverName`](#parameter-servername) | string | The name of the parent SQL Server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoPauseDelay`](#parameter-autopausedelay) | int | Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled. |
| [`availabilityZone`](#parameter-availabilityzone) | string | Specifies the availability zone the database is pinned to. |
| [`backupLongTermRetentionPolicy`](#parameter-backuplongtermretentionpolicy) | object | The long term backup retention policy to create for the database. |
| [`backupShortTermRetentionPolicy`](#parameter-backupshorttermretentionpolicy) | object | The short term backup retention policy to create for the database. |
| [`catalogCollation`](#parameter-catalogcollation) | string | Collation of the metadata catalog. |
| [`collation`](#parameter-collation) | string | The collation of the database. |
| [`createMode`](#parameter-createmode) | string | Specifies the mode of database creation. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`elasticPoolResourceId`](#parameter-elasticpoolresourceid) | string | The resource ID of the elastic pool containing this database. |
| [`encryptionProtector`](#parameter-encryptionprotector) | string | The azure key vault URI of the database if it's configured with per Database Customer Managed Keys. |
| [`encryptionProtectorAutoRotation`](#parameter-encryptionprotectorautorotation) | bool | The flag to enable or disable auto rotation of database encryption protector AKV key. |
| [`federatedClientId`](#parameter-federatedclientid) | string | The Client id used for cross tenant per database CMK scenario. |
| [`freeLimitExhaustionBehavior`](#parameter-freelimitexhaustionbehavior) | string | Specifies the behavior when monthly free limits are exhausted for the free database. |
| [`highAvailabilityReplicaCount`](#parameter-highavailabilityreplicacount) | int | The number of readonly secondary replicas associated with the database. |
| [`isLedgerOn`](#parameter-isledgeron) | bool | Whether or not this database is a ledger database, which means all tables in the database are ledger tables. Note: the value of this property cannot be changed after the database has been created. |
| [`licenseType`](#parameter-licensetype) | string | The license type to apply for this database. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`longTermRetentionBackupResourceId`](#parameter-longtermretentionbackupresourceid) | string | The resource identifier of the long term retention backup associated with create operation of this database. |
| [`maintenanceConfigurationId`](#parameter-maintenanceconfigurationid) | string | Maintenance configuration ID assigned to the database. This configuration defines the period when the maintenance updates will occur. |
| [`manualCutover`](#parameter-manualcutover) | bool | Whether or not customer controlled manual cutover needs to be done during Update Database operation to Hyperscale tier. |
| [`maxSizeBytes`](#parameter-maxsizebytes) | int | The max size of the database expressed in bytes. |
| [`minCapacity`](#parameter-mincapacity) | string | Minimal capacity that database will always have allocated. |
| [`performCutover`](#parameter-performcutover) | bool | To trigger customer controlled manual cutover during the wait state while Scaling operation is in progress. |
| [`preferredEnclaveType`](#parameter-preferredenclavetype) | string | Type of enclave requested on the database i.e. Default or VBS enclaves. |
| [`readScale`](#parameter-readscale) | string | The state of read-only routing. |
| [`recoverableDatabaseResourceId`](#parameter-recoverabledatabaseresourceid) | string | The resource identifier of the recoverable database associated with create operation of this database. |
| [`recoveryServicesRecoveryPointResourceId`](#parameter-recoveryservicesrecoverypointresourceid) | string | The resource identifier of the recovery point associated with create operation of this database. |
| [`requestedBackupStorageRedundancy`](#parameter-requestedbackupstorageredundancy) | string | The storage account type to be used to store backups for this database. |
| [`restorableDroppedDatabaseResourceId`](#parameter-restorabledroppeddatabaseresourceid) | string | The resource identifier of the restorable dropped database associated with create operation of this database. |
| [`restorePointInTime`](#parameter-restorepointintime) | string | Point in time (ISO8601 format) of the source database to restore when createMode set to Restore or PointInTimeRestore. |
| [`sampleName`](#parameter-samplename) | string | The name of the sample schema to apply when creating this database. |
| [`secondaryType`](#parameter-secondarytype) | string | The secondary type of the database if it is a secondary. |
| [`sku`](#parameter-sku) | object | The database SKU. |
| [`sourceDatabaseDeletionDate`](#parameter-sourcedatabasedeletiondate) | string | The time that the database was deleted when restoring a deleted database. |
| [`sourceDatabaseResourceId`](#parameter-sourcedatabaseresourceid) | string | The resource identifier of the source database associated with create operation of this database. |
| [`sourceResourceId`](#parameter-sourceresourceid) | string | The resource identifier of the source associated with the create operation of this database. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`useFreeLimit`](#parameter-usefreelimit) | bool | Whether or not the database uses free monthly limits. Allowed on one database in a subscription. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Whether or not this database is zone redundant. |

### Parameter: `name`

The name of the database.

- Required: Yes
- Type: string

### Parameter: `serverName`

The name of the parent SQL Server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `autoPauseDelay`

Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled.

- Required: No
- Type: int
- Default: `-1`

### Parameter: `availabilityZone`

Specifies the availability zone the database is pinned to.

- Required: No
- Type: string
- Default: `'NoPreference'`
- Allowed:
  ```Bicep
  [
    '1'
    '2'
    '3'
    'NoPreference'
  ]
  ```

### Parameter: `backupLongTermRetentionPolicy`

The long term backup retention policy to create for the database.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupStorageAccessTier`](#parameter-backuplongtermretentionpolicybackupstorageaccesstier) | string | The BackupStorageAccessTier for the LTR backups. |
| [`makeBackupsImmutable`](#parameter-backuplongtermretentionpolicymakebackupsimmutable) | bool | The setting whether to make LTR backups immutable. |
| [`monthlyRetention`](#parameter-backuplongtermretentionpolicymonthlyretention) | string | Monthly retention in ISO 8601 duration format. |
| [`weeklyRetention`](#parameter-backuplongtermretentionpolicyweeklyretention) | string | Weekly retention in ISO 8601 duration format. |
| [`weekOfYear`](#parameter-backuplongtermretentionpolicyweekofyear) | int | Week of year backup to keep for yearly retention. |
| [`yearlyRetention`](#parameter-backuplongtermretentionpolicyyearlyretention) | string | Yearly retention in ISO 8601 duration format. |

### Parameter: `backupLongTermRetentionPolicy.backupStorageAccessTier`

The BackupStorageAccessTier for the LTR backups.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Archive'
    'Hot'
  ]
  ```

### Parameter: `backupLongTermRetentionPolicy.makeBackupsImmutable`

The setting whether to make LTR backups immutable.

- Required: No
- Type: bool

### Parameter: `backupLongTermRetentionPolicy.monthlyRetention`

Monthly retention in ISO 8601 duration format.

- Required: No
- Type: string

### Parameter: `backupLongTermRetentionPolicy.weeklyRetention`

Weekly retention in ISO 8601 duration format.

- Required: No
- Type: string

### Parameter: `backupLongTermRetentionPolicy.weekOfYear`

Week of year backup to keep for yearly retention.

- Required: No
- Type: int

### Parameter: `backupLongTermRetentionPolicy.yearlyRetention`

Yearly retention in ISO 8601 duration format.

- Required: No
- Type: string

### Parameter: `backupShortTermRetentionPolicy`

The short term backup retention policy to create for the database.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diffBackupIntervalInHours`](#parameter-backupshorttermretentionpolicydiffbackupintervalinhours) | int | Differential backup interval in hours. For Hyperscale tiers this value will be ignored. |
| [`retentionDays`](#parameter-backupshorttermretentionpolicyretentiondays) | int | Point-in-time retention in days. |

### Parameter: `backupShortTermRetentionPolicy.diffBackupIntervalInHours`

Differential backup interval in hours. For Hyperscale tiers this value will be ignored.

- Required: No
- Type: int

### Parameter: `backupShortTermRetentionPolicy.retentionDays`

Point-in-time retention in days.

- Required: No
- Type: int

### Parameter: `catalogCollation`

Collation of the metadata catalog.

- Required: No
- Type: string
- Default: `'DATABASE_DEFAULT'`

### Parameter: `collation`

The collation of the database.

- Required: No
- Type: string
- Default: `'SQL_Latin1_General_CP1_CI_AS'`

### Parameter: `createMode`

Specifies the mode of database creation.

- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Copy'
    'Default'
    'OnlineSecondary'
    'PointInTimeRestore'
    'Recovery'
    'Restore'
    'RestoreExternalBackup'
    'RestoreExternalBackupSecondary'
    'RestoreLongTermRetentionBackup'
    'Secondary'
  ]
  ```

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `elasticPoolResourceId`

The resource ID of the elastic pool containing this database.

- Required: No
- Type: string

### Parameter: `encryptionProtector`

The azure key vault URI of the database if it's configured with per Database Customer Managed Keys.

- Required: No
- Type: string

### Parameter: `encryptionProtectorAutoRotation`

The flag to enable or disable auto rotation of database encryption protector AKV key.

- Required: No
- Type: bool

### Parameter: `federatedClientId`

The Client id used for cross tenant per database CMK scenario.

- Required: No
- Type: string

### Parameter: `freeLimitExhaustionBehavior`

Specifies the behavior when monthly free limits are exhausted for the free database.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AutoPause'
    'BillOverUsage'
  ]
  ```

### Parameter: `highAvailabilityReplicaCount`

The number of readonly secondary replicas associated with the database.

- Required: No
- Type: int
- Default: `0`

### Parameter: `isLedgerOn`

Whether or not this database is a ledger database, which means all tables in the database are ledger tables. Note: the value of this property cannot be changed after the database has been created.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `licenseType`

The license type to apply for this database.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'BasePrice'
    'LicenseIncluded'
  ]
  ```

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `longTermRetentionBackupResourceId`

The resource identifier of the long term retention backup associated with create operation of this database.

- Required: No
- Type: string

### Parameter: `maintenanceConfigurationId`

Maintenance configuration ID assigned to the database. This configuration defines the period when the maintenance updates will occur.

- Required: No
- Type: string

### Parameter: `manualCutover`

Whether or not customer controlled manual cutover needs to be done during Update Database operation to Hyperscale tier.

- Required: No
- Type: bool

### Parameter: `maxSizeBytes`

The max size of the database expressed in bytes.

- Required: No
- Type: int
- Default: `34359738368`

### Parameter: `minCapacity`

Minimal capacity that database will always have allocated.

- Required: No
- Type: string
- Default: `'0'`

### Parameter: `performCutover`

To trigger customer controlled manual cutover during the wait state while Scaling operation is in progress.

- Required: No
- Type: bool

### Parameter: `preferredEnclaveType`

Type of enclave requested on the database i.e. Default or VBS enclaves.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Default'
    'VBS'
  ]
  ```

### Parameter: `readScale`

The state of read-only routing.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `recoverableDatabaseResourceId`

The resource identifier of the recoverable database associated with create operation of this database.

- Required: No
- Type: string

### Parameter: `recoveryServicesRecoveryPointResourceId`

The resource identifier of the recovery point associated with create operation of this database.

- Required: No
- Type: string

### Parameter: `requestedBackupStorageRedundancy`

The storage account type to be used to store backups for this database.

- Required: No
- Type: string
- Default: `'Local'`
- Allowed:
  ```Bicep
  [
    'Geo'
    'GeoZone'
    'Local'
    'Zone'
  ]
  ```

### Parameter: `restorableDroppedDatabaseResourceId`

The resource identifier of the restorable dropped database associated with create operation of this database.

- Required: No
- Type: string

### Parameter: `restorePointInTime`

Point in time (ISO8601 format) of the source database to restore when createMode set to Restore or PointInTimeRestore.

- Required: No
- Type: string

### Parameter: `sampleName`

The name of the sample schema to apply when creating this database.

- Required: No
- Type: string
- Default: `''`

### Parameter: `secondaryType`

The secondary type of the database if it is a secondary.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Geo'
    'Named'
    'Standby'
  ]
  ```

### Parameter: `sku`

The database SKU.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      name: 'GP_Gen5_2'
      tier: 'GeneralPurpose'
  }
  ```

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-skuname) | string | The name of the SKU, typically, a letter + Number code, e.g. P3. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`capacity`](#parameter-skucapacity) | int | The capacity of the particular SKU. |
| [`family`](#parameter-skufamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. |
| [`size`](#parameter-skusize) | string | Size of the particular SKU. |
| [`tier`](#parameter-skutier) | string | The tier or edition of the particular SKU, e.g. Basic, Premium. |

### Parameter: `sku.name`

The name of the SKU, typically, a letter + Number code, e.g. P3.

- Required: Yes
- Type: string

### Parameter: `sku.capacity`

The capacity of the particular SKU.

- Required: No
- Type: int

### Parameter: `sku.family`

If the service has different generations of hardware, for the same SKU, then that can be captured here.

- Required: No
- Type: string

### Parameter: `sku.size`

Size of the particular SKU.

- Required: No
- Type: string

### Parameter: `sku.tier`

The tier or edition of the particular SKU, e.g. Basic, Premium.

- Required: No
- Type: string

### Parameter: `sourceDatabaseDeletionDate`

The time that the database was deleted when restoring a deleted database.

- Required: No
- Type: string

### Parameter: `sourceDatabaseResourceId`

The resource identifier of the source database associated with create operation of this database.

- Required: No
- Type: string

### Parameter: `sourceResourceId`

The resource identifier of the source associated with the create operation of this database.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `useFreeLimit`

Whether or not the database uses free monthly limits. Allowed on one database in a subscription.

- Required: No
- Type: bool

### Parameter: `zoneRedundant`

Whether or not this database is zone redundant.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed database. |
| `resourceGroupName` | string | The resource group of the deployed database. |
| `resourceId` | string | The resource ID of the deployed database. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.2.1` | Remote reference |
