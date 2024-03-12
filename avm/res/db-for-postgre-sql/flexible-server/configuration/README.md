# DBforPostgreSQL Flexible Server Configurations `[Microsoft.DBforPostgreSQL/flexibleServers/configurations]`

This module deploys a DBforPostgreSQL Flexible Server Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforPostgreSQL/flexibleServers/configurations` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers/configurations) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the configuration. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`flexibleServerName`](#parameter-flexibleservername) | string | The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`source`](#parameter-source) | string | Source of the configuration. |
| [`value`](#parameter-value) | string | Value of the configuration. |

### Parameter: `name`

The name of the configuration.

- Required: Yes
- Type: string

### Parameter: `flexibleServerName`

The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `source`

Source of the configuration.

- Required: No
- Type: string
- Default: `''`

### Parameter: `value`

Value of the configuration.

- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed configuration. |
| `resourceGroupName` | string | The resource group of the deployed configuration. |
| `resourceId` | string | The resource ID of the deployed configuration. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
