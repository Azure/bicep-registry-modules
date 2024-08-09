# SQL Managed Instance Databases `[Microsoft.Sql/managedInstances/databases]`

This module deploys a SQL Managed Instance Database.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Sql/managedInstances/databases` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/managedInstances/databases) |
| `Microsoft.Sql/managedInstances/databases/backupLongTermRetentionPolicies` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/databases/backupLongTermRetentionPolicies) |
| `Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/managedInstances/databases/backupShortTermRetentionPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the SQL managed instance database. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`longTermRetentionBackupResourceId`](#parameter-longtermretentionbackupresourceid) | string | The resource ID of the Long Term Retention backup to be used for restore of this managed database. Required if createMode is RestoreLongTermRetentionBackup. |
| [`managedInstanceName`](#parameter-managedinstancename) | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |
| [`recoverableDatabaseId`](#parameter-recoverabledatabaseid) | string | The resource identifier of the recoverable database associated with create operation of this database. Required if createMode is Recovery. |
| [`restorePointInTime`](#parameter-restorepointintime) | string | Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. Required if createMode is PointInTimeRestore. |
| [`sourceDatabaseId`](#parameter-sourcedatabaseid) | string | The resource identifier of the source database associated with create operation of this database. Required if createMode is PointInTimeRestore. |
| [`storageContainerSasToken`](#parameter-storagecontainersastoken) | securestring | Specifies the storage container sas token. Required if createMode is RestoreExternalBackup. |
| [`storageContainerUri`](#parameter-storagecontaineruri) | string | Specifies the uri of the storage container where backups for this restore are stored. Required if createMode is RestoreExternalBackup. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupLongTermRetentionPoliciesObj`](#parameter-backuplongtermretentionpoliciesobj) | object | The configuration for the backup long term retention policy definition. |
| [`backupShortTermRetentionPoliciesObj`](#parameter-backupshorttermretentionpoliciesobj) | object | The configuration for the backup short term retention policy definition. |
| [`catalogCollation`](#parameter-catalogcollation) | string | Collation of the managed instance. |
| [`collation`](#parameter-collation) | string | Collation of the managed instance database. |
| [`createMode`](#parameter-createmode) | string | Managed database create mode. PointInTimeRestore: Create a database by restoring a point in time backup of an existing database. SourceDatabaseName, SourceManagedInstanceName and PointInTime must be specified. RestoreExternalBackup: Create a database by restoring from external backup files. Collation, StorageContainerUri and StorageContainerSasToken must be specified. Recovery: Creates a database by restoring a geo-replicated backup. RecoverableDatabaseId must be specified as the recoverable database resource ID to restore. RestoreLongTermRetentionBackup: Create a database by restoring from a long term retention backup (longTermRetentionBackupResourceId required). |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`restorableDroppedDatabaseId`](#parameter-restorabledroppeddatabaseid) | string | The restorable dropped database resource ID to restore when creating this database. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

The name of the SQL managed instance database.

- Required: Yes
- Type: string

### Parameter: `longTermRetentionBackupResourceId`

The resource ID of the Long Term Retention backup to be used for restore of this managed database. Required if createMode is RestoreLongTermRetentionBackup.

- Required: No
- Type: string
- Default: `''`

### Parameter: `managedInstanceName`

The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `recoverableDatabaseId`

The resource identifier of the recoverable database associated with create operation of this database. Required if createMode is Recovery.

- Required: No
- Type: string
- Default: `''`

### Parameter: `restorePointInTime`

Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database. Required if createMode is PointInTimeRestore.

- Required: No
- Type: string
- Default: `''`

### Parameter: `sourceDatabaseId`

The resource identifier of the source database associated with create operation of this database. Required if createMode is PointInTimeRestore.

- Required: No
- Type: string
- Default: `''`

### Parameter: `storageContainerSasToken`

Specifies the storage container sas token. Required if createMode is RestoreExternalBackup.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `storageContainerUri`

Specifies the uri of the storage container where backups for this restore are stored. Required if createMode is RestoreExternalBackup.

- Required: No
- Type: string
- Default: `''`

### Parameter: `backupLongTermRetentionPoliciesObj`

The configuration for the backup long term retention policy definition.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `backupShortTermRetentionPoliciesObj`

The configuration for the backup short term retention policy definition.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `catalogCollation`

Collation of the managed instance.

- Required: No
- Type: string
- Default: `'SQL_Latin1_General_CP1_CI_AS'`

### Parameter: `collation`

Collation of the managed instance database.

- Required: No
- Type: string
- Default: `'SQL_Latin1_General_CP1_CI_AS'`

### Parameter: `createMode`

Managed database create mode. PointInTimeRestore: Create a database by restoring a point in time backup of an existing database. SourceDatabaseName, SourceManagedInstanceName and PointInTime must be specified. RestoreExternalBackup: Create a database by restoring from external backup files. Collation, StorageContainerUri and StorageContainerSasToken must be specified. Recovery: Creates a database by restoring a geo-replicated backup. RecoverableDatabaseId must be specified as the recoverable database resource ID to restore. RestoreLongTermRetentionBackup: Create a database by restoring from a long term retention backup (longTermRetentionBackupResourceId required).

- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Default'
    'PointInTimeRestore'
    'Recovery'
    'RestoreExternalBackup'
    'RestoreLongTermRetentionBackup'
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
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
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

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to 'AllLogs' to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.name`

The name of diagnostic setting.

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

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `restorableDroppedDatabaseId`

The restorable dropped database resource ID to restore when creating this database.

- Required: No
- Type: string
- Default: `''`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed database. |
| `resourceGroupName` | string | The resource group the database was deployed into. |
| `resourceId` | string | The resource ID of the deployed database. |
