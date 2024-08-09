# DBforMySQL Flexible Server Databases `[Microsoft.DBforMySQL/flexibleServers/databases]`

This module deploys a DBforMySQL Flexible Server Database.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforMySQL/flexibleServers/databases` | [2023-06-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2023-06-30/flexibleServers/databases) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the database. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`flexibleServerName`](#parameter-flexibleservername) | string | The name of the parent MySQL flexible server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`charset`](#parameter-charset) | string | The charset of the database. |
| [`collation`](#parameter-collation) | string | The collation of the database. |

### Parameter: `name`

The name of the database.

- Required: Yes
- Type: string

### Parameter: `flexibleServerName`

The name of the parent MySQL flexible server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `charset`

The charset of the database.

- Required: No
- Type: string
- Default: `'utf8_general_ci'`

### Parameter: `collation`

The collation of the database.

- Required: No
- Type: string
- Default: `'utf8'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed database. |
| `resourceGroupName` | string | The resource group of the deployed database. |
| `resourceId` | string | The resource ID of the deployed database. |
