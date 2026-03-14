# Storage Account File Share Services `[Microsoft.Storage/storageAccounts/fileServices]`

This module deploys a Storage Account File Share Service.

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
| `Microsoft.Storage/storageAccounts/fileServices` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-06-01/storageAccounts/fileServices)</li></ul> |
| `Microsoft.Storage/storageAccounts/fileServices/shares` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_fileservices_shares.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2025-01-01/storageAccounts/fileServices/shares)</li></ul> |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAccountName`](#parameter-storageaccountname) | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`corsRules`](#parameter-corsrules) | array | The List of CORS rules. You can include up to five CorsRule elements in the request. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`name`](#parameter-name) | string | The name of the file service. |
| [`protocolSettings`](#parameter-protocolsettings) | object | Protocol settings for file service. |
| [`shareDeleteRetentionPolicy`](#parameter-sharedeleteretentionpolicy) | object | The service properties for soft delete. |
| [`shares`](#parameter-shares) | array | File shares to create. |

### Parameter: `storageAccountName`

The name of the parent Storage Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

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

### Parameter: `name`

The name of the file service.

- Required: No
- Type: string
- Default: `'default'`

### Parameter: `protocolSettings`

Protocol settings for file service.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `shareDeleteRetentionPolicy`

The service properties for soft delete.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      days: 7
      enabled: true
  }
  ```

### Parameter: `shares`

File shares to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-sharesname) | string | The name of the file share. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessTier`](#parameter-sharesaccesstier) | string | Access tier for specific share. Required if the Storage Account kind is set to FileStorage (should be set to "Premium"). GpV2 account can choose between TransactionOptimized (default), Hot, and Cool. |
| [`enabledProtocols`](#parameter-sharesenabledprotocols) | string | The authentication protocol that is used for the file share. Can only be specified when creating a share. |
| [`provisionedBandwidthMibps`](#parameter-sharesprovisionedbandwidthmibps) | int | The provisioned bandwidth of the share, in mebibytes per second. Only applicable to FileStorage storage accounts (premium file shares). Must be between 0 and 10340. |
| [`provisionedIops`](#parameter-sharesprovisionediops) | int | The provisioned IOPS of the share. Only applicable to FileStorage storage accounts (premium file shares). Must be between 0 and 102400. |
| [`roleAssignments`](#parameter-sharesroleassignments) | array | Array of role assignments to create. |
| [`rootSquash`](#parameter-sharesrootsquash) | string | Permissions for NFS file shares are enforced by the client OS rather than the Azure Files service. Toggling the root squash behavior reduces the rights of the root user for NFS shares. |
| [`shareQuota`](#parameter-sharessharequota) | int | The maximum size of the share, in gigabytes. Must be greater than 0, and less than or equal to 5120 (5TB). For Large File Shares, the maximum size is 102400 (100TB). |

### Parameter: `shares.name`

The name of the file share.

- Required: Yes
- Type: string

### Parameter: `shares.accessTier`

Access tier for specific share. Required if the Storage Account kind is set to FileStorage (should be set to "Premium"). GpV2 account can choose between TransactionOptimized (default), Hot, and Cool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Cool'
    'Hot'
    'Premium'
    'TransactionOptimized'
  ]
  ```

### Parameter: `shares.enabledProtocols`

The authentication protocol that is used for the file share. Can only be specified when creating a share.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'NFS'
    'SMB'
  ]
  ```

### Parameter: `shares.provisionedBandwidthMibps`

The provisioned bandwidth of the share, in mebibytes per second. Only applicable to FileStorage storage accounts (premium file shares). Must be between 0 and 10340.

- Required: No
- Type: int
- MaxValue: 10340

### Parameter: `shares.provisionedIops`

The provisioned IOPS of the share. Only applicable to FileStorage storage accounts (premium file shares). Must be between 0 and 102400.

- Required: No
- Type: int
- MaxValue: 102400

### Parameter: `shares.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-sharesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-sharesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-sharesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-sharesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-sharesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-sharesroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-sharesroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-sharesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `shares.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `shares.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `shares.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `shares.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `shares.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `shares.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `shares.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `shares.roleAssignments.principalType`

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

### Parameter: `shares.rootSquash`

Permissions for NFS file shares are enforced by the client OS rather than the Azure Files service. Toggling the root squash behavior reduces the rights of the root user for NFS shares.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AllSquash'
    'NoRootSquash'
    'RootSquash'
  ]
  ```

### Parameter: `shares.shareQuota`

The maximum size of the share, in gigabytes. Must be greater than 0, and less than or equal to 5120 (5TB). For Large File Shares, the maximum size is 102400 (100TB).

- Required: No
- Type: int

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed file share service. |
| `resourceGroupName` | string | The resource group of the deployed file share service. |
| `resourceId` | string | The resource ID of the deployed file share service. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |
