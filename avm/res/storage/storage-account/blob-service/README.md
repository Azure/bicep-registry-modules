# Storage Account blob Services `[Microsoft.Storage/storageAccounts/blobServices]`

This module deploys a Storage Account Blob Service.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices/containers)</li></ul> |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers_immutabilitypolicies.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/blobServices/containers/immutabilityPolicies)</li></ul> |

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
| [`isVersioningEnabled`](#parameter-isversioningenabled) | bool | Use versioning to automatically maintain previous versions of your blobs. Cannot be enabled for ADLS Gen2 storage accounts. |
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

### Parameter: `containers`

Blob containers to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-containersname) | string | The name of the Storage Container to deploy. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`defaultEncryptionScope`](#parameter-containersdefaultencryptionscope) | string | Default the container to use specified encryption scope for all writes. |
| [`denyEncryptionScopeOverride`](#parameter-containersdenyencryptionscopeoverride) | bool | Block override of encryption scope from the container default. |
| [`enableNfsV3AllSquash`](#parameter-containersenablenfsv3allsquash) | bool | Enable NFSv3 all squash on blob container. |
| [`enableNfsV3RootSquash`](#parameter-containersenablenfsv3rootsquash) | bool | Enable NFSv3 root squash on blob container. |
| [`immutabilityPolicy`](#parameter-containersimmutabilitypolicy) | object | Configure immutability policy. |
| [`immutableStorageWithVersioningEnabled`](#parameter-containersimmutablestoragewithversioningenabled) | bool | This is an immutable property, when set to true it enables object level immutability at the container level. The property is immutable and can only be set to true at the container creation time. Existing containers must undergo a migration process. |
| [`metadata`](#parameter-containersmetadata) | object | A name-value pair to associate with the container as metadata. |
| [`publicAccess`](#parameter-containerspublicaccess) | string | Specifies whether data in the container may be accessed publicly and the level of access. |
| [`roleAssignments`](#parameter-containersroleassignments) | array | Array of role assignments to create. |

### Parameter: `containers.name`

The name of the Storage Container to deploy.

- Required: Yes
- Type: string

### Parameter: `containers.defaultEncryptionScope`

Default the container to use specified encryption scope for all writes.

- Required: No
- Type: string

### Parameter: `containers.denyEncryptionScopeOverride`

Block override of encryption scope from the container default.

- Required: No
- Type: bool

### Parameter: `containers.enableNfsV3AllSquash`

Enable NFSv3 all squash on blob container.

- Required: No
- Type: bool

### Parameter: `containers.enableNfsV3RootSquash`

Enable NFSv3 root squash on blob container.

- Required: No
- Type: bool

### Parameter: `containers.immutabilityPolicy`

Configure immutability policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowProtectedAppendWrites`](#parameter-containersimmutabilitypolicyallowprotectedappendwrites) | bool | This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. Defaults to false. |
| [`allowProtectedAppendWritesAll`](#parameter-containersimmutabilitypolicyallowprotectedappendwritesall) | bool | This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to both "Append and Block Blobs" while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. The "allowProtectedAppendWrites" and "allowProtectedAppendWritesAll" properties are mutually exclusive. Defaults to false. |
| [`immutabilityPeriodSinceCreationInDays`](#parameter-containersimmutabilitypolicyimmutabilityperiodsincecreationindays) | int | The immutability period for the blobs in the container since the policy creation, in days. |

### Parameter: `containers.immutabilityPolicy.allowProtectedAppendWrites`

This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. Defaults to false.

- Required: No
- Type: bool

### Parameter: `containers.immutabilityPolicy.allowProtectedAppendWritesAll`

This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to both "Append and Block Blobs" while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. The "allowProtectedAppendWrites" and "allowProtectedAppendWritesAll" properties are mutually exclusive. Defaults to false.

- Required: No
- Type: bool

### Parameter: `containers.immutabilityPolicy.immutabilityPeriodSinceCreationInDays`

The immutability period for the blobs in the container since the policy creation, in days.

- Required: No
- Type: int

### Parameter: `containers.immutableStorageWithVersioningEnabled`

This is an immutable property, when set to true it enables object level immutability at the container level. The property is immutable and can only be set to true at the container creation time. Existing containers must undergo a migration process.

- Required: No
- Type: bool

### Parameter: `containers.metadata`

A name-value pair to associate with the container as metadata.

- Required: No
- Type: object

### Parameter: `containers.publicAccess`

Specifies whether data in the container may be accessed publicly and the level of access.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Blob'
    'Container'
    'None'
  ]
  ```

### Parameter: `containers.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-containersroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-containersroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-containersroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-containersroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-containersroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-containersroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-containersroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-containersroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `containers.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `containers.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `containers.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `containers.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `containers.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `containers.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `containers.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `containers.roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `corsRules`

The List of CORS rules. You can include up to five CorsRule elements in the request.

- Required: No
- Type: array

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

### Parameter: `corsRules.allowedOrigins`

A list of origin domains that will be allowed via CORS, or "*" to allow all domains.

- Required: Yes
- Type: array

### Parameter: `corsRules.exposedHeaders`

A list of response headers to expose to CORS clients.

- Required: Yes
- Type: array

### Parameter: `corsRules.maxAgeInSeconds`

The number of seconds that the client/browser should cache a preflight response.

- Required: Yes
- Type: int

### Parameter: `defaultServiceVersion`

Indicates the default version to use for requests to the Blob service if an incoming request's version is not specified. Possible values include version 2008-10-27 and all more recent versions.

- Required: No
- Type: string

### Parameter: `deleteRetentionPolicyAllowPermanentDelete`

This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share.

- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `isVersioningEnabled`

Use versioning to automatically maintain previous versions of your blobs. Cannot be enabled for ADLS Gen2 storage accounts.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `lastAccessTimeTrackingPolicyEnabled`

The blob service property to configure last access time based tracking policy. When set to true last access time based tracking is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `restorePolicyDays`

How long this blob can be restored. It should be less than DeleteRetentionPolicy days.

- Required: No
- Type: int
- Default: `7`
- MinValue: 1

### Parameter: `restorePolicyEnabled`

The blob service properties for blob restore policy. If point-in-time restore is enabled, then versioning, change feed, and blob soft delete must also be enabled.

- Required: No
- Type: bool
- Default: `False`

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
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |
