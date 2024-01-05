# Log Analytics Workspace Tables `[Microsoft.OperationalInsights/workspaces/tables]`

This module deploys a Log Analytics Workspace Table.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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
| [`plan`](#parameter-plan) | string | Instruct the system how to handle and charge the logs ingested to this table. |
| [`restoredLogs`](#parameter-restoredlogs) | object | Restore parameters. |
| [`retentionInDays`](#parameter-retentionindays) | int | The table retention in days, between 4 and 730. Setting this property to -1 will default to the workspace retention. |
| [`schema`](#parameter-schema) | object | Table's schema. |
| [`searchResults`](#parameter-searchresults) | object | Parameters of the search job that initiated this table. |
| [`totalRetentionInDays`](#parameter-totalretentionindays) | int | The table total retention in days, between 4 and 2555. Setting this property to -1 will default to table retention. |

### Parameter: `name`

The name of the table.

- Required: Yes
- Type: string

### Parameter: `workspaceName`

The name of the parent workspaces. Required if the template is used in a standalone deployment.

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


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the table. |
| `resourceGroupName` | string | The name of the resource group the table was created in. |
| `resourceId` | string | The resource ID of the table. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
