# Redis Cache Firewall Rules `[Microsoft.Cache/redis/firewallRules]`

This module creates a firewall rule for Redis Cache.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cache/redis/firewallRules` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2024-11-01/redis/firewallRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endIP`](#parameter-endip) | string | The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses. |
| [`name`](#parameter-name) | string | The name of the Redis Cache Firewall Rule. |
| [`redisCacheName`](#parameter-rediscachename) | string | Redis cache name. |
| [`startIP`](#parameter-startip) | string | The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses. |

### Parameter: `endIP`

The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value '0.0.0.0' for all Azure-internal IP addresses.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the Redis Cache Firewall Rule.

- Required: Yes
- Type: string

### Parameter: `redisCacheName`

Redis cache name.

- Required: Yes
- Type: string

### Parameter: `startIP`

The start IP address of the firewall rule. Must be IPv4 format. Use value '0.0.0.0' for all Azure-internal IP addresses.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed firewall rule. |
| `resourceGroupName` | string | The resource group of the deployed firewall rule. |
| `resourceId` | string | The resource ID of the deployed firewall rule. |
