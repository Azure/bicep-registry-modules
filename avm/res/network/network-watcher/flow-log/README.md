# NSG Flow Logs `[Microsoft.Network/networkWatchers/flowLogs]`

This module controls the Network Security Group Flow Logs and analytics settings.
**Note: this module must be run on the Resource Group where Network Watcher is deployed**

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkWatchers/flowLogs` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkWatchers/flowLogs) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageId`](#parameter-storageid) | string | Resource ID of the diagnostic storage account. |
| [`targetResourceId`](#parameter-targetresourceid) | string | Resource ID of the NSG that must be enabled for Flow Logs. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-enabled) | bool | If the flow log should be enabled. |
| [`formatVersion`](#parameter-formatversion) | int | The flow log format version. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`name`](#parameter-name) | string | Name of the resource. |
| [`networkWatcherName`](#parameter-networkwatchername) | string | Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG. |
| [`retentionInDays`](#parameter-retentionindays) | int | Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`trafficAnalyticsInterval`](#parameter-trafficanalyticsinterval) | int | The interval in minutes which would decide how frequently TA service should do flow analytics. |
| [`workspaceResourceId`](#parameter-workspaceresourceid) | string | Specify the Log Analytics Workspace Resource ID. |

### Parameter: `storageId`

Resource ID of the diagnostic storage account.

- Required: Yes
- Type: string

### Parameter: `targetResourceId`

Resource ID of the NSG that must be enabled for Flow Logs.

- Required: Yes
- Type: string

### Parameter: `enabled`

If the flow log should be enabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `formatVersion`

The flow log format version.

- Required: No
- Type: int
- Default: `2`
- Allowed:
  ```Bicep
  [
    1
    2
  ]
  ```

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `name`

Name of the resource.

- Required: No
- Type: string
- Default: `[format('{0}-{1}-flowlog', last(split(parameters('targetResourceId'), '/')), split(parameters('targetResourceId'), '/')[4])]`

### Parameter: `networkWatcherName`

Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG.

- Required: No
- Type: string
- Default: `[format('NetworkWatcher_{0}', resourceGroup().location)]`

### Parameter: `retentionInDays`

Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.

- Required: No
- Type: int
- Default: `365`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `trafficAnalyticsInterval`

The interval in minutes which would decide how frequently TA service should do flow analytics.

- Required: No
- Type: int
- Default: `60`
- Allowed:
  ```Bicep
  [
    10
    60
  ]
  ```

### Parameter: `workspaceResourceId`

Specify the Log Analytics Workspace Resource ID.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the flow log. |
| `resourceGroupName` | string | The resource group the flow log was deployed into. |
| `resourceId` | string | The resource ID of the flow log. |
