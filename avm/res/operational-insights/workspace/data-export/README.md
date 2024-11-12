# Log Analytics Workspace Data Exports `[Microsoft.OperationalInsights/workspaces/dataExports]`

This module deploys a Log Analytics Workspace Data Export.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataExports) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The data export rule name. |
| [`tableNames`](#parameter-tablenames) | array | An array of tables to export, for example: ['Heartbeat', 'SecurityEvent']. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent workspaces. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-destination) | object | Destination properties. |
| [`enable`](#parameter-enable) | bool | Active when enabled. |

### Parameter: `name`

The data export rule name.

- Required: Yes
- Type: string

### Parameter: `tableNames`

An array of tables to export, for example: ['Heartbeat', 'SecurityEvent'].

- Required: Yes
- Type: array

### Parameter: `workspaceName`

The name of the parent workspaces. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `destination`

Destination properties.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-destinationresourceid) | string | The destination resource ID. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metaData`](#parameter-destinationmetadata) | object | The destination metadata. |

### Parameter: `destination.resourceId`

The destination resource ID.

- Required: Yes
- Type: string

### Parameter: `destination.metaData`

The destination metadata.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubName`](#parameter-destinationmetadataeventhubname) | string | Allows to define an Event Hub name. Not applicable when destination is Storage Account. |

### Parameter: `destination.metaData.eventHubName`

Allows to define an Event Hub name. Not applicable when destination is Storage Account.

- Required: No
- Type: string

### Parameter: `enable`

Active when enabled.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the data export. |
| `resourceGroupName` | string | The name of the resource group the data export was created in. |
| `resourceId` | string | The resource ID of the data export. |
