# DBforPostgreSQL Flexible Server Firewall Rules `[Microsoft.DBforPostgreSQL/flexibleServers/firewallRules]`

This module deploys a DBforPostgreSQL Flexible Server Firewall Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforPostgreSQL/flexibleServers/firewallRules` | [2022-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforPostgreSQL/2022-12-01/flexibleServers/firewallRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endIpAddress`](#parameter-endipaddress) | string | The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses. |
| [`name`](#parameter-name) | string | The name of the PostgreSQL flexible server Firewall Rule. |
| [`startIpAddress`](#parameter-startipaddress) | string | The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`flexibleServerName`](#parameter-flexibleservername) | string | The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment. |

### Parameter: `endIpAddress`

The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the PostgreSQL flexible server Firewall Rule.

- Required: Yes
- Type: string

### Parameter: `startIpAddress`

The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses.

- Required: Yes
- Type: string

### Parameter: `flexibleServerName`

The name of the parent PostgreSQL flexible server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed firewall rule. |
| `resourceGroupName` | string | The resource group of the deployed firewall rule. |
| `resourceId` | string | The resource ID of the deployed firewall rule. |
