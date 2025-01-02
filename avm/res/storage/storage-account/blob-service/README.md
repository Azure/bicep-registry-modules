# Storage Account blob Services `[Microsoft.Storage/storageAccounts/blobServices]`

This module deploys a Storage Account Blob Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Storage/storageAccounts/blobServices` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices) |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAccountName`](#parameter-storageaccountname) | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automaticSnapshotPolicyEnabled`](#parameter-automaticsnapshotpolicyenabled) | bool | Automatic Snapshot is enabled if set to true. |
| [`changeFeedEnabled`](#parameter-changefeedenabled) | bool | The blob service properties for change feed events. Indicates whether change feed event logging is enabled for the Blob service. |
| [`changeFeedRetentionInDays`](#parameter-changefeedretentionindays) | int | Indicates whether change feed event logging is enabled for the Blob service. Indicates the duration of changeFeed retention in days. If left blank, it indicates an infinite retention of the change feed. |
| [`containerDeleteRetentionPolicyAllowPermanentDelete`](#parameter-containerdeleteretentionpolicyallowpermanentdelete) | bool | This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share. |
| [`containerDeleteRetentionPolicyDays`](#parameter-containerdeleteretentionpolicydays) | int | Indicates the number of days that the deleted item should be retained. |
| [`containerDeleteRetentionPolicyEnabled`](#parameter-containerdeleteretentionpolicyenabled) | bool | The blob service properties for container soft delete. Indicates whether DeleteRetentionPolicy is enabled. |
| [`containers`](#parameter-containers) | array | Blob containers to create. |
| [`corsRules`](#parameter-corsrules) | array | The List of CORS rules. You can include up to five CorsRule elements in the request. |
| [`defaultServiceVersion`](#parameter-defaultserviceversion) | string | Indicates the default version to use for requests to the Blob service if an incoming request's version is not specified. Possible values include version 2008-10-27 and all more recent versions. |
| [`deleteRetentionPolicyAllowPermanentDelete`](#parameter-deleteretentionpolicyallowpermanentdelete) | bool | This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share. |
| [`deleteRetentionPolicyDays`](#parameter-deleteretentionpolicydays) | int | Indicates the number of days that the deleted blob should be retained. |
| [`deleteRetentionPolicyEnabled`](#parameter-deleteretentionpolicyenabled) | bool | The blob service properties for blob soft delete. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`isVersioningEnabled`](#parameter-isversioningenabled) | bool | Use versioning to automatically maintain previous versions of your blobs. |
| [`lastAccessTimeTrackingPolicyEnabled`](#parameter-lastaccesstimetrackingpolicyenabled) | bool | The blob service property to configure last access time based tracking policy. When set to true last access time based tracking is enabled. |
| [`restorePolicyDays`](#parameter-restorepolicydays) | int | How long this blob can be restored. It should be less than DeleteRetentionPolicy days. |
| [`restorePolicyEnabled`](#parameter-restorepolicyenabled) | bool | The blob service properties for blob restore policy. If point-in-time restore is enabled, then versioning, change feed, and blob soft delete must also be enabled. |

### Parameter: `storageAccountName`

The name of the parent Storage Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `automaticSnapshotPolicyEnabled`

Automatic Snapshot is enabled if set to true.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `changeFeedEnabled`

The blob service properties for change feed events. Indicates whether change feed event logging is enabled for the Blob service.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `changeFeedRetentionInDays`

Indicates whether change feed event logging is enabled for the Blob service. Indicates the duration of changeFeed retention in days. If left blank, it indicates an infinite retention of the change feed.

- Required: No
- Type: int
- MinValue: 1
- MaxValue: 146000

### Parameter: `containerDeleteRetentionPolicyAllowPermanentDelete`

This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 1
- MaxValue: 146000

### Parameter: `containerDeleteRetentionPolicyDays`

Indicates the number of days that the deleted item should be retained.

- Required: No
- Type: int
- MinValue: 1
- MaxValue: 365

### Parameter: `containerDeleteRetentionPolicyEnabled`

The blob service properties for container soft delete. Indicates whether DeleteRetentionPolicy is enabled.

- Required: No
- Type: bool
- Default: `True`
- MinValue: 1
- MaxValue: 365

### Parameter: `containers`

Blob containers to create.

- Required: No
- Type: array
- MinValue: 1
- MaxValue: 365

### Parameter: `corsRules`

The List of CORS rules. You can include up to five CorsRule elements in the request.

- Required: No
- Type: array
- MinValue: 1
- MaxValue: 365

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowedHeaders`](#parameter-corsrulesallowedheaders) | array | A list of headers allowed to be part of the cross-origin request. |
| [`allowedMethods`](#parameter-corsrulesallowedmethods) | array | A list of HTTP methods that are allowed to be executed by the origin. |
| [`allowedOrigins`](#parameter-corsrulesallowedorigins) | array | A list of origin domains that will be allowed via CORS, or "*" to allow all domains. |
| [`exposedHeaders`](#parameter-corsrulesexposedheaders) | array | A list of response headers to expose to CORS clients. |
| [`maxAgeInSeconds`](#parameter-corsrulesmaxageinseconds) | int | The number of seconds that the client/browser should cache a preflight response. |

### Parameter: `corsRules.allowedHeaders`

A list of headers allowed to be part of the cross-origin request.

- Required: Yes
- Type: array
- MinValue: 1
- MaxValue: 365

### Parameter: `corsRules.allowedMethods`

A list of HTTP methods that are allowed to be executed by the origin.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'CONNECT'
    'DELETE'
    'GET'
    'HEAD'
    'MERGE'
    'OPTIONS'
    'PATCH'
    'POST'
    'PUT'
    'TRACE'
  ]
  ```
- MinValue: 1
- MaxValue: 365

### Parameter: `corsRules.allowedOrigins`

A list of origin domains that will be allowed via CORS, or "*" to allow all domains.

- Required: Yes
- Type: array
- MinValue: 1
- MaxValue: 365

### Parameter: `corsRules.exposedHeaders`

A list of response headers to expose to CORS clients.

- Required: Yes
- Type: array
- MinValue: 1
- MaxValue: 365

### Parameter: `corsRules.maxAgeInSeconds`

The number of seconds that the client/browser should cache a preflight response.

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 365

### Parameter: `defaultServiceVersion`

Indicates the default version to use for requests to the Blob service if an incoming request's version is not specified. Possible values include version 2008-10-27 and all more recent versions.

- Required: No
- Type: string
- Default: `''`
- MinValue: 1
- MaxValue: 365

### Parameter: `deleteRetentionPolicyAllowPermanentDelete`

This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 1
- MaxValue: 365

### Parameter: `deleteRetentionPolicyDays`

Indicates the number of days that the deleted blob should be retained.

- Required: No
- Type: int
- Default: `7`
- MinValue: 1
- MaxValue: 365

### Parameter: `deleteRetentionPolicyEnabled`

The blob service properties for blob soft delete.

- Required: No
- Type: bool
- Default: `True`
- MinValue: 1
- MaxValue: 365

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array
- MinValue: 1
- MaxValue: 365

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
- MinValue: 1
- MaxValue: 365

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string
- MinValue: 1
- MaxValue: 365

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
- MinValue: 1
- MaxValue: 365

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array
- MinValue: 1
- MaxValue: 365

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
- MinValue: 1
- MaxValue: 365

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string
- MinValue: 1
- MaxValue: 365

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool
- MinValue: 1
- MaxValue: 365

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string
- MinValue: 1
- MaxValue: 365

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array
- MinValue: 1
- MaxValue: 365

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
- MinValue: 1
- MaxValue: 365

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool
- MinValue: 1
- MaxValue: 365

### Parameter: `diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string
- MinValue: 1
- MaxValue: 365

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string
- MinValue: 1
- MaxValue: 365

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string
- MinValue: 1
- MaxValue: 365

### Parameter: `isVersioningEnabled`

Use versioning to automatically maintain previous versions of your blobs.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 1
- MaxValue: 365

### Parameter: `lastAccessTimeTrackingPolicyEnabled`

The blob service property to configure last access time based tracking policy. When set to true last access time based tracking is enabled.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 1
- MaxValue: 365

### Parameter: `restorePolicyDays`

How long this blob can be restored. It should be less than DeleteRetentionPolicy days.

- Required: No
- Type: int
- Default: `6`
- MinValue: 1
- MaxValue: 365

### Parameter: `restorePolicyEnabled`

The blob service properties for blob restore policy. If point-in-time restore is enabled, then versioning, change feed, and blob soft delete must also be enabled.

- Required: No
- Type: bool
- Default: `False`
- MinValue: 1
- MaxValue: 365

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed blob service. |
| `resourceGroupName` | string | The name of the deployed blob service. |
| `resourceId` | string | The resource ID of the deployed blob service. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.4.0` | Remote reference |
