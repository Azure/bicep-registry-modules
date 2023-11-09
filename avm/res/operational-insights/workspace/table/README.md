# Log Analytics Workspace Tables `[Microsoft.OperationalInsights/workspaces/tables]`

This module deploys a Log Analytics Workspace Table.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.OperationalInsights/workspaces/tables` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.OperationalInsights/2022-10-01/workspaces/tables) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the table. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent workspaces. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| [`plan`](#parameter-plan) | string | Instruct the system how to handle and charge the logs ingested to this table. |
| [`restoredLogs`](#parameter-restoredlogs) | object | Restore parameters. |
| [`retentionInDays`](#parameter-retentionindays) | int | The table retention in days, between 4 and 730. Setting this property to -1 will default to the workspace retention. |
| [`schema`](#parameter-schema) | object | Table's schema. |
| [`searchResults`](#parameter-searchresults) | object | Parameters of the search job that initiated this table. |
| [`totalRetentionInDays`](#parameter-totalretentionindays) | int | The table total retention in days, between 4 and 2555. Setting this property to -1 will default to table retention. |

### Parameter: `enableDefaultTelemetry`

Enable telemetry via the Customer Usage Attribution ID (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `name`

The name of the table.
- Required: Yes
- Type: string

### Parameter: `plan`

Instruct the system how to handle and charge the logs ingested to this table.
- Required: No
- Type: string
- Default: `'Analytics'`
- Allowed:
  ```Bicep
  [
    'Analytics'
    'Basic'
  ]
  ```

### Parameter: `restoredLogs`

Restore parameters.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `retentionInDays`

The table retention in days, between 4 and 730. Setting this property to -1 will default to the workspace retention.
- Required: No
- Type: int
- Default: `-1`

### Parameter: `schema`

Table's schema.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `searchResults`

Parameters of the search job that initiated this table.
- Required: No
- Type: object
- Default: `{}`

### Parameter: `totalRetentionInDays`

The table total retention in days, between 4 and 2555. Setting this property to -1 will default to table retention.
- Required: No
- Type: int
- Default: `-1`

### Parameter: `workspaceName`

The name of the parent workspaces. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the table. |
| `resourceGroupName` | string | The name of the resource group the table was created in. |
| `resourceId` | string | The resource ID of the table. |

## Cross-referenced modules

_None_
