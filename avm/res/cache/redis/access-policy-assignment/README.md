# Redis Cache Access Policy Assignment `[Microsoft.Cache/redis/accessPolicyAssignments]`

This module deploys an access policy assignment for Redis Cache.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cache/redis/accessPolicyAssignments` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2024-11-01/redis/accessPolicyAssignments) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessPolicyName`](#parameter-accesspolicyname) | string | Name of the access policy to be assigned. |
| [`objectId`](#parameter-objectid) | string | Object ID to which the access policy will be assigned. |
| [`objectIdAlias`](#parameter-objectidalias) | string | Alias for the target object ID. |
| [`redisCacheName`](#parameter-rediscachename) | string | The name of the Redis cache. |

### Parameter: `accessPolicyName`

Name of the access policy to be assigned.

- Required: Yes
- Type: string

### Parameter: `objectId`

Object ID to which the access policy will be assigned.

- Required: Yes
- Type: string

### Parameter: `objectIdAlias`

Alias for the target object ID.

- Required: Yes
- Type: string

### Parameter: `redisCacheName`

The name of the Redis cache.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the access policy assignment. |
| `resourceGroupName` | string | The name of the resource group the access policy assignment was created in. |
| `resourceId` | string | The resource ID of the access policy assignment. |
