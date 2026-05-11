# Redis Cache Access Policy Assignment `[Microsoft.Cache/redis/accessPolicyAssignments]`

This module deploys an access policy assignment for Redis Cache.

You can reference the module as follows:
```bicep
module redis 'br/public:avm/res/cache/redis/access-policy-assignment:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Cache/redis/accessPolicyAssignments` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cache_redis_accesspolicyassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2024-11-01/redis/accessPolicyAssignments)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessPolicyName`](#parameter-accesspolicyname) | string | Name of the access policy to be assigned. |
| [`objectId`](#parameter-objectid) | string | Object ID to which the access policy will be assigned. |
| [`objectIdAlias`](#parameter-objectidalias) | string | Alias for the target object ID. |
| [`redisCacheName`](#parameter-rediscachename) | string | The name of the Redis cache. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`name`](#parameter-name) | string | The name of the assignment. By default uses the Object ID to which the access policy will be assigned. |

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `name`

The name of the assignment. By default uses the Object ID to which the access policy will be assigned.

- Required: No
- Type: string
- Default: `[parameters('objectId')]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the access policy assignment. |
| `resourceGroupName` | string | The name of the resource group the access policy assignment was created in. |
| `resourceId` | string | The resource ID of the access policy assignment. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
