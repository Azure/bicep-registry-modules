# DBforMySQL Flexible Server Firewall Rules `[Microsoft.DBforMySQL/flexibleServers/firewallRules]`

This module deploys a DBforMySQL Flexible Server Firewall Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DBforMySQL/flexibleServers/firewallRules` | [2023-06-30](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DBforMySQL/2023-06-30/flexibleServers/firewallRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endIpAddress`](#parameter-endipaddress) | string | The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses. |
| [`name`](#parameter-name) | string | The name of the MySQL flexible server Firewall Rule. |
| [`startIpAddress`](#parameter-startipaddress) | string | The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`flexibleServerName`](#parameter-flexibleservername) | string | The name of the parent MySQL flexible server. Required if the template is used in a standalone deployment. |

### Parameter: `endIpAddress`

The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the MySQL flexible server Firewall Rule.

- Required: Yes
- Type: string

### Parameter: `startIpAddress`

The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses.

- Required: Yes
- Type: string

### Parameter: `flexibleServerName`

The name of the parent MySQL flexible server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed firewall rule. |
| `resourceGroupName` | string | The resource group of the deployed firewall rule. |
| `resourceId` | string | The resource ID of the deployed firewall rule. |
