# DBforMySQL Flexible Server Configurations `[Microsoft.DBforMySQL/flexibleServers/configurations]`

This module deploys a DBforMySQL Flexible Server Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.DBforMySQL/flexibleServers/configurations` | 2024-12-30 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.dbformysql_flexibleservers_configurations.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2024-12-30/flexibleServers/configurations)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the configuration. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`flexibleServerName`](#parameter-flexibleservername) | string | The name of the parent MySQL flexible server. Required if the template is used in a standalone deployment. |

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

The name of the parent MySQL flexible server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `source`

Source of the configuration.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'system-default'
    'user-override'
  ]
  ```

### Parameter: `value`

Value of the configuration.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed configuration. |
| `resourceGroupName` | string | The resource group name of the deployed configuration. |
| `resourceId` | string | The resource ID of the deployed configuration. |
