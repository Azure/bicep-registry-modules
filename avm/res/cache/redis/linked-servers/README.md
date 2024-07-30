# Redis Cache Linked Servers `[Microsoft.Cache/redis/linkedServers]`

This module connects a primary and secondary Redis Cache together for geo-replication.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
