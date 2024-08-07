# Redis Cache Linked Servers `[Microsoft.Cache/redis/linkedServers]`

This module connects a primary and secondary Redis Cache together for geo-replication.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cache/redis/linkedServers` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/redis/linkedServers) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`linkedRedisCacheResourceId`](#parameter-linkedrediscacheresourceid) | string | The resource ID of the linked server. |
| [`redisCacheName`](#parameter-rediscachename) | string | Primary Redis cache name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`linkedRedisCacheLocation`](#parameter-linkedrediscachelocation) | string | The location of the linked server. If not provided, the location of the primary Redis cache is used. |
| [`name`](#parameter-name) | string | The name of the secondary Redis cache. If not provided, the primary Redis cache name is used. |
| [`serverRole`](#parameter-serverrole) | string | The role of the linked server. Possible values include: "Primary", "Secondary". Default value is "Secondary". |

### Parameter: `linkedRedisCacheResourceId`

The resource ID of the linked server.

- Required: Yes
- Type: string

### Parameter: `redisCacheName`

Primary Redis cache name.

- Required: Yes
- Type: string

### Parameter: `linkedRedisCacheLocation`

The location of the linked server. If not provided, the location of the primary Redis cache is used.

- Required: No
- Type: string

### Parameter: `name`

The name of the secondary Redis cache. If not provided, the primary Redis cache name is used.

- Required: No
- Type: string
- Default: `[parameters('redisCacheName')]`

### Parameter: `serverRole`

The role of the linked server. Possible values include: "Primary", "Secondary". Default value is "Secondary".

- Required: No
- Type: string
- Default: `'Secondary'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `geoReplicatedPrimaryHostName` | string | The hostname of the linkedServer. |
| `name` | string | The name of the linkedServer resource. |
| `resourceGroupName` | string | The resource group of the deployed linkedServer. |
| `resourceId` | string | The resource ID of the linkedServer. |
