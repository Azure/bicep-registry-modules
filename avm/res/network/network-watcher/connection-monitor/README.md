# Network Watchers Connection Monitors `[Microsoft.Network/networkWatchers/connectionMonitors]`

This module deploys a Network Watcher Connection Monitor.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/networkWatchers/connectionMonitors` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/networkWatchers/connectionMonitors) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endpoints`](#parameter-endpoints) | array | List of connection monitor endpoints. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`networkWatcherName`](#parameter-networkwatchername) | string | Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`testConfigurations`](#parameter-testconfigurations) | array | List of connection monitor test configurations. |
| [`testGroups`](#parameter-testgroups) | array | List of connection monitor test groups. |
| [`workspaceResourceId`](#parameter-workspaceresourceid) | string | Specify the Log Analytics Workspace Resource ID. |

### Parameter: `name`

Name of the resource.

- Required: Yes
- Type: string
- Nullable: No

### Parameter: `endpoints`

List of connection monitor endpoints.

- Required: No
- Type: array
- Nullable: No
- Default: `[]`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Nullable: No
- Default: `[resourceGroup().location]`

### Parameter: `networkWatcherName`

Name of the network watcher resource. Must be in the resource group where the Flow log will be created and same region as the NSG.

- Required: No
- Type: string
- Nullable: No
- Default: `[format('NetworkWatcher_{0}', resourceGroup().location)]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object
- Nullable: Yes

### Parameter: `testConfigurations`

List of connection monitor test configurations.

- Required: No
- Type: array
- Nullable: No
- Default: `[]`

### Parameter: `testGroups`

List of connection monitor test groups.

- Required: No
- Type: array
- Nullable: No
- Default: `[]`

### Parameter: `workspaceResourceId`

Specify the Log Analytics Workspace Resource ID.

- Required: No
- Type: string
- Nullable: No
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed connection monitor. |
| `resourceGroupName` | string | The resource group the connection monitor was deployed into. |
| `resourceId` | string | The resource ID of the deployed connection monitor. |
