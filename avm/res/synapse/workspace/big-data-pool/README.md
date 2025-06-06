# Synapse Workspaces Big Data Pools `[Microsoft.Synapse/workspaces/bigDataPools]`

This module deploys a Synapse Workspaces Big Data Pool.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Synapse/workspaces/bigDataPools` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/bigDataPools) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Big Data Pool. |
| [`nodeSize`](#parameter-nodesize) | string | The level of compute power that each node in the Big Data pool has. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoPauseDelayInMinutes`](#parameter-autopausedelayinminutes) | int | Synapse workspace Big Data Pools Auto-pausing delay in minutes (5-10080). Disabled if value not provided. |
| [`autoScale`](#parameter-autoscale) | object | Auto-scaling properties. |
| [`autotuneEnabled`](#parameter-autotuneenabled) | bool | Whether Auto-tune is Enabled or not. Disabled if value not provided. |
| [`cacheSize`](#parameter-cachesize) | int | The cache size. |
| [`computeIsolationEnabled`](#parameter-computeisolationenabled) | bool | Whether Compute Isolation is enabled or not. Disabled if value not provided. |
| [`defaultSparkLogFolder`](#parameter-defaultsparklogfolder) | string | The default folder where Spark logs will be written. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`dynamicExecutorAllocation`](#parameter-dynamicexecutorallocation) | object | Dynamic Executor Allocation. |
| [`location`](#parameter-location) | string | The geo-location where the resource lives. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`nodeCount`](#parameter-nodecount) | int | The number of nodes in the Big Data pool if Auto-scaling is disabled. |
| [`nodeSizeFamily`](#parameter-nodesizefamily) | string | The kind of nodes that the Big Data pool provides. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sessionLevelPackagesEnabled`](#parameter-sessionlevelpackagesenabled) | bool | Whether session level packages enabled. Disabled if value not provided. |
| [`sparkConfigProperties`](#parameter-sparkconfigproperties) | object | Spark configuration file to specify additional properties. |
| [`sparkEventsFolder`](#parameter-sparkeventsfolder) | string | The Spark events folder. |
| [`sparkVersion`](#parameter-sparkversion) | string | The Apache Spark version. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

The name of the Big Data Pool.

- Required: Yes
- Type: string

### Parameter: `nodeSize`

The level of compute power that each node in the Big Data pool has.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Large'
    'Medium'
    'None'
    'Small'
    'XLarge'
    'XXLarge'
    'XXXLarge'
  ]
  ```

### Parameter: `workspaceName`

The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `autoPauseDelayInMinutes`

Synapse workspace Big Data Pools Auto-pausing delay in minutes (5-10080). Disabled if value not provided.

- Required: No
- Type: int
- Default: `-1`
- MinValue: -1
- MaxValue: 10080

### Parameter: `autoScale`

Auto-scaling properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maxNodeCount`](#parameter-autoscalemaxnodecount) | int | Synapse workspace Big Data Pools Auto-scaling maximum node count. |
| [`minNodeCount`](#parameter-autoscaleminnodecount) | int | Synapse workspace Big Data Pools Auto-scaling minimum node count. |

### Parameter: `autoScale.maxNodeCount`

Synapse workspace Big Data Pools Auto-scaling maximum node count.

- Required: Yes
- Type: int
- MinValue: 3
- MaxValue: 200

### Parameter: `autoScale.minNodeCount`

Synapse workspace Big Data Pools Auto-scaling minimum node count.

- Required: Yes
- Type: int
- MinValue: 3
- MaxValue: 200

### Parameter: `autotuneEnabled`

Whether Auto-tune is Enabled or not. Disabled if value not provided.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `cacheSize`

The cache size.

- Required: No
- Type: int
- Default: `50`
- MinValue: 0
- MaxValue: 100

### Parameter: `computeIsolationEnabled`

Whether Compute Isolation is enabled or not. Disabled if value not provided.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `defaultSparkLogFolder`

The default folder where Spark logs will be written.

- Required: No
- Type: string

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

### Parameter: `dynamicExecutorAllocation`

Dynamic Executor Allocation.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`maxExecutors`](#parameter-dynamicexecutorallocationmaxexecutors) | int | Synapse workspace Big Data Pools Dynamic Executor Allocation maximum executors (maxNodeCount-1). |
| [`minExecutors`](#parameter-dynamicexecutorallocationminexecutors) | int | Synapse workspace Big Data Pools Dynamic Executor Allocation minimum executors. |

### Parameter: `dynamicExecutorAllocation.maxExecutors`

Synapse workspace Big Data Pools Dynamic Executor Allocation maximum executors (maxNodeCount-1).

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 10

### Parameter: `dynamicExecutorAllocation.minExecutors`

Synapse workspace Big Data Pools Dynamic Executor Allocation minimum executors.

- Required: Yes
- Type: int
- MinValue: 1
- MaxValue: 10

### Parameter: `location`

The geo-location where the resource lives.

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

### Parameter: `nodeCount`

The number of nodes in the Big Data pool if Auto-scaling is disabled.

- Required: No
- Type: int
- Default: `3`
- MinValue: 3
- MaxValue: 200

### Parameter: `nodeSizeFamily`

The kind of nodes that the Big Data pool provides.

- Required: No
- Type: string
- Default: `'MemoryOptimized'`
- Allowed:
  ```Bicep
  [
    'HardwareAcceleratedFPGA'
    'HardwareAcceleratedGPU'
    'MemoryOptimized'
    'None'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

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

### Parameter: `sessionLevelPackagesEnabled`

Whether session level packages enabled. Disabled if value not provided.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `sparkConfigProperties`

Spark configuration file to specify additional properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`configurationType`](#parameter-sparkconfigpropertiesconfigurationtype) | string | The configuration type. |
| [`content`](#parameter-sparkconfigpropertiescontent) | string | The configuration content. |
| [`filename`](#parameter-sparkconfigpropertiesfilename) | string | The configuration filename. |

### Parameter: `sparkConfigProperties.configurationType`

The configuration type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Artifact'
    'File'
  ]
  ```

### Parameter: `sparkConfigProperties.content`

The configuration content.

- Required: Yes
- Type: string

### Parameter: `sparkConfigProperties.filename`

The configuration filename.

- Required: Yes
- Type: string

### Parameter: `sparkEventsFolder`

The Spark events folder.

- Required: No
- Type: string

### Parameter: `sparkVersion`

The Apache Spark version.

- Required: No
- Type: string
- Default: `'3.4'`
- Allowed:
  ```Bicep
  [
    '3.4'
    '3.5'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed Big Data Pool. |
| `resourceGroupName` | string | The resource group of the deployed Big Data Pool. |
| `resourceId` | string | The resource ID of the deployed Big Data Pool. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
