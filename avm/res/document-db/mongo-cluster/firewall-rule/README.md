# Azure Cosmos DB for MongoDB (vCore) cluster Config FireWall Rules `[Microsoft.DocumentDB/mongoClusters/firewallRules]`

This module config firewall rules for the Azure Cosmos DB for MongoDB (vCore) cluster.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.DocumentDB/mongoClusters/firewallRules` | [2024-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DocumentDB/2024-10-01-preview/mongoClusters/firewallRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endIpAddress`](#parameter-endipaddress) | string | The end IP address of the Azure Cosmos DB for MongoDB (vCore) cluster firewall rule. Must be IPv4 format. |
| [`name`](#parameter-name) | string | The name of the firewall rule. Must match the pattern `^[a-zA-Z0-9][-_a-zA-Z0-9]*`. |
| [`startIpAddress`](#parameter-startipaddress) | string | The start IP address of the Azure Cosmos DB for MongoDB (vCore) cluster firewall rule. Must be IPv4 format. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`mongoClusterName`](#parameter-mongoclustername) | string | The name of the parent Azure Cosmos DB for MongoDB (vCore) cluster. Required if the template is used in a standalone deployment. |

### Parameter: `endIpAddress`

The end IP address of the Azure Cosmos DB for MongoDB (vCore) cluster firewall rule. Must be IPv4 format.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the firewall rule. Must match the pattern `^[a-zA-Z0-9][-_a-zA-Z0-9]*`.

- Required: Yes
- Type: string

### Parameter: `startIpAddress`

The start IP address of the Azure Cosmos DB for MongoDB (vCore) cluster firewall rule. Must be IPv4 format.

- Required: Yes
- Type: string

### Parameter: `mongoClusterName`

The name of the parent Azure Cosmos DB for MongoDB (vCore) cluster. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the firewall rule. |
| `resourceGroupName` | string | The name of the resource group the Azure Cosmos DB for MongoDB (vCore) cluster was created in. |
| `resourceId` | string | The resource ID of the firewall rule. |
