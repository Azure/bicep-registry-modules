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
| `Microsoft.Sql/servers/databases` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/databases) |
| `Microsoft.Sql/servers/databases/backupLongTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/servers/databases/backupShortTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/servers/databases/backupShortTermRetentionPolicies) |

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
| [`backupLongTermRetentionPolicy`](#parameter-backuplongtermretentionpolicy) | object | The long term backup retention policy to create for the database. |
| [`backupShortTermRetentionPolicy`](#parameter-backupshorttermretentionpolicy) | object | The short term backup retention policy to create for the database. |
| [`collation`](#parameter-collation) | string | The collation of the database. |
| [`createMode`](#parameter-createmode) | string | Specifies the mode of database creation. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`elasticPoolId`](#parameter-elasticpoolid) | string | The resource ID of the elastic pool containing this database. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`highAvailabilityReplicaCount`](#parameter-highavailabilityreplicacount) | int | The number of readonly secondary replicas associated with the database. |
| [`isLedgerOn`](#parameter-isledgeron) | bool | Whether or not this database is a ledger database, which means all tables in the database are ledger tables. Note: the value of this property cannot be changed after the database has been created. |
| [`licenseType`](#parameter-licensetype) | string | The license type to apply for this database. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`maintenanceConfigurationId`](#parameter-maintenanceconfigurationid) | string | Maintenance configuration ID assigned to the database. This configuration defines the period when the maintenance updates will occur. |
| [`maxSizeBytes`](#parameter-maxsizebytes) | int | The max size of the database expressed in bytes. |
| [`minCapacity`](#parameter-mincapacity) | string | Minimal capacity that database will always have allocated. |
| [`preferredEnclaveType`](#parameter-preferredenclavetype) | string | Type of enclave requested on the database i.e. Default or VBS enclaves. |
| [`readScale`](#parameter-readscale) | string | The state of read-only routing. |
| [`recoveryServicesRecoveryPointResourceId`](#parameter-recoveryservicesrecoverypointresourceid) | string | Resource ID of backup if createMode set to RestoreLongTermRetentionBackup. |
| [`requestedBackupStorageRedundancy`](#parameter-requestedbackupstorageredundancy) | string | The storage account type to be used to store backups for this database. |
| [`restorePointInTime`](#parameter-restorepointintime) | string | Point in time (ISO8601 format) of the source database to restore when createMode set to Restore or PointInTimeRestore. |
| [`sampleName`](#parameter-samplename) | string | The name of the sample schema to apply when creating this database. |
| [`skuCapacity`](#parameter-skucapacity) | int | Capacity of the particular SKU. |
| [`skuFamily`](#parameter-skufamily) | string | If the service has different generations of hardware, for the same SKU, then that can be captured here. |
| [`skuName`](#parameter-skuname) | string | The name of the SKU. |
| [`skuSize`](#parameter-skusize) | string | Size of the particular SKU. |
| [`skuTier`](#parameter-skutier) | string | The skuTier or edition of the particular SKU. |
| [`sourceDatabaseDeletionDate`](#parameter-sourcedatabasedeletiondate) | string | The time that the database was deleted when restoring a deleted database. |
| [`sourceDatabaseResourceId`](#parameter-sourcedatabaseresourceid) | string | Resource ID of database if createMode set to Copy, Secondary, PointInTimeRestore, Recovery or Restore. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`zoneRedundant`](#parameter-zoneredundant) | bool | Whether or not this database is zone redundant. |

### Parameter: `autoPauseDelay`

Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled.
- Required: No
- Type: int
- Default: `0`

### Parameter: `backupLongTermRetentionPolicy`

The long term backup retention policy to create for the database.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `backupShortTermRetentionPolicy`

The short term backup retention policy to create for the database.
- Required: No
- Type: object
- Default: `{}`

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
    'RestoreLongTermRetentionBackup'
    'Secondary'
  ]
  ```

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | No | string | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | No | string | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | No | string | Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | No | array | Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | No | string | Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | No | array | Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`name`](#parameter-diagnosticsettingsname) | No | string | Optional. The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | No | string | Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | No | string | Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed: `[AzureDiagnostics, Dedicated]`

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | No | string | Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | No | string | Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs.

- Required: No
- Type: string


### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | Yes | string | Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to 'AllMetrics' to collect all metrics. |

### Parameter: `diagnosticSettings.metricCategories.category`

Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to 'AllMetrics' to collect all metrics.

- Required: Yes
- Type: string


### Parameter: `diagnosticSettings.name`

Optional. The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `elasticPoolId`

The resource ID of the elastic pool containing this database.
- Required: No
- Type: string
- Default: `''`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

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
- Default: `''`

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `maintenanceConfigurationId`

Maintenance configuration ID assigned to the database. This configuration defines the period when the maintenance updates will occur.
- Required: No
- Type: string
- Default: `''`

### Parameter: `maxSizeBytes`

The max size of the database expressed in bytes.
- Required: No
- Type: int
- Default: `34359738368`

### Parameter: `minCapacity`

Minimal capacity that database will always have allocated.
- Required: No
- Type: string
- Default: `''`

### Parameter: `name`

The name of the database.
- Required: Yes
- Type: string

### Parameter: `preferredEnclaveType`

Type of enclave requested on the database i.e. Default or VBS enclaves.
- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
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

### Parameter: `recoveryServicesRecoveryPointResourceId`

Resource ID of backup if createMode set to RestoreLongTermRetentionBackup.
- Required: No
- Type: string
- Default: `''`

### Parameter: `requestedBackupStorageRedundancy`

The storage account type to be used to store backups for this database.
- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Geo'
    'Local'
    'Zone'
  ]
  ```

### Parameter: `restorePointInTime`

Point in time (ISO8601 format) of the source database to restore when createMode set to Restore or PointInTimeRestore.
- Required: No
- Type: string
- Default: `''`

### Parameter: `sampleName`

The name of the sample schema to apply when creating this database.
- Required: No
- Type: string
- Default: `''`

### Parameter: `serverName`

The name of the parent SQL Server. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string

### Parameter: `skuCapacity`

Capacity of the particular SKU.
- Required: No
- Type: int
- Default: `-1`

### Parameter: `skuFamily`

If the service has different generations of hardware, for the same SKU, then that can be captured here.
- Required: No
- Type: string
- Default: `''`

### Parameter: `skuName`

The name of the SKU.
- Required: No
- Type: string
- Default: `'GP_Gen5_2'`

### Parameter: `skuSize`

Size of the particular SKU.
- Required: No
- Type: string
- Default: `''`

### Parameter: `skuTier`

The skuTier or edition of the particular SKU.
- Required: No
- Type: string
- Default: `'GeneralPurpose'`

### Parameter: `sourceDatabaseDeletionDate`

The time that the database was deleted when restoring a deleted database.
- Required: No
- Type: string
- Default: `''`

### Parameter: `sourceDatabaseResourceId`

Resource ID of database if createMode set to Copy, Secondary, PointInTimeRestore, Recovery or Restore.
- Required: No
- Type: string
- Default: `''`

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object

### Parameter: `zoneRedundant`

Whether or not this database is zone redundant.
- Required: No
- Type: bool
- Default: `False`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed database. |
| `resourceGroupName` | string | The resource group of the deployed database. |
| `resourceId` | string | The resource ID of the deployed database. |

## Cross-referenced modules

_None_
