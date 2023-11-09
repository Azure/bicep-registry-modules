# Log Analytics Workspace Data Exports `[Microsoft.OperationalInsights/workspaces/dataExports]`

This module deploys a Log Analytics Workspace Data Export.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/dataExports` | [2020-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2020-08-01/workspaces/dataExports) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The data export rule name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent workspaces. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-destination) | object | Destination properties. |
| [`enable`](#parameter-enable) | bool | Active when enabled. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| [`tableNames`](#parameter-tablenames) | array | An array of tables to export, for example: ['Heartbeat', 'SecurityEvent']. |

### Parameter: `destination`

Destination properties.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `enable`

Active when enabled.
- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableDefaultTelemetry`

Enable telemetry via the Customer Usage Attribution ID (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `name`

The data export rule name.
- Required: Yes
- Type: string

### Parameter: `tableNames`

An array of tables to export, for example: ['Heartbeat', 'SecurityEvent'].
- Required: No
- Type: array
- Default: `[]`

### Parameter: `workspaceName`

The name of the parent workspaces. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the data export. |
| `resourceGroupName` | string | The name of the resource group the data export was created in. |
| `resourceId` | string | The resource ID of the data export. |

## Cross-referenced modules

_None_
