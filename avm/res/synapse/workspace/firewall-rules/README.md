# Synapse Workspaces Firewall Rules `[Microsoft.Synapse/workspaces/firewallRules]`

This module deploys Synapse Workspaces Firewall Rules.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Synapse/workspaces/firewallRules` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Synapse/2021-06-01/workspaces/firewallRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endIpAddress`](#parameter-endipaddress) | string | The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. |
| [`name`](#parameter-name) | string | The name of the firewall rule. |
| [`startIpAddress`](#parameter-startipaddress) | string | The start IP address of the firewall rule. Must be IPv4 format. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`workspaceName`](#parameter-workspacename) | string | The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment. |

### Parameter: `endIpAddress`

The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the firewall rule.

- Required: Yes
- Type: string

### Parameter: `startIpAddress`

The start IP address of the firewall rule. Must be IPv4 format.

- Required: Yes
- Type: string

### Parameter: `workspaceName`

The name of the parent Synapse Workspace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed firewall rule. |
| `resourceGroupName` | string | The resource group of the deployed firewall rule. |
| `resourceId` | string | The resource ID of the deployed firewall rule. |
