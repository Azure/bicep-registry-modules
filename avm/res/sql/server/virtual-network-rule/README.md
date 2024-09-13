# Azure SQL Server Virtual Network Rules `[Microsoft.Sql/servers/virtualNetworkRules]`

This module deploys an Azure SQL Server Virtual Network Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/virtualNetworkRules` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/virtualNetworkRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Server Virtual Network Rule. |
| [`virtualNetworkSubnetId`](#parameter-virtualnetworksubnetid) | string | The resource ID of the virtual network subnet. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverName`](#parameter-servername) | string | The name of the parent SQL Server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ignoreMissingVnetServiceEndpoint`](#parameter-ignoremissingvnetserviceendpoint) | bool | Allow creating a firewall rule before the virtual network has vnet service endpoint enabled. |

### Parameter: `name`

The name of the Server Virtual Network Rule.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkSubnetId`

The resource ID of the virtual network subnet.

- Required: Yes
- Type: string

### Parameter: `serverName`

The name of the parent SQL Server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `ignoreMissingVnetServiceEndpoint`

Allow creating a firewall rule before the virtual network has vnet service endpoint enabled.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed virtual network rule. |
| `resourceGroupName` | string | The resource group of the deployed virtual network rule. |
| `resourceId` | string | The resource ID of the deployed virtual network rule. |
