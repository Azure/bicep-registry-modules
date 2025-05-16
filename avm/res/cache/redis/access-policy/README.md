# Redis Cache Access Policy `[Microsoft.Cache/redis/accessPolicies]`

This module deploys an access policy for Redis Cache.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cache/redis/accessPolicies` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2024-11-01/redis/accessPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the access policy. |
| [`permissions`](#parameter-permissions) | string | Permissions associated with the access policy. |
| [`redisCacheName`](#parameter-rediscachename) | string | The name of the Redis cache. |

### Parameter: `name`

The name of the access policy.

- Required: Yes
- Type: string

### Parameter: `permissions`

Permissions associated with the access policy.

- Required: Yes
- Type: string

### Parameter: `redisCacheName`

The name of the Redis cache.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the access policy. |
| `resourceGroupName` | string | The name of the resource group the access policy was created in. |
| `resourceId` | string | The resource ID of the access policy. |
