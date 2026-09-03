# Azure Managed Redis Database Access Policy Assignment `[Microsoft.Cache/redisEnterprise/databases/accessPolicyAssignments]`

This module deploys an access policy assignment for an Azure Managed Redis database.

You can reference the module as follows:
```bicep
module redisEnterprise 'br/public:avm/res/cache/redis-enterprise/database/access-policy-assignment:<version>' = {
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
| `Microsoft.Cache/redisEnterprise/databases/accessPolicyAssignments` | 2025-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cache_redisenterprise_databases_accesspolicyassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cache/2025-07-01/redisEnterprise/databases/accessPolicyAssignments)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`userObjectId`](#parameter-userobjectid) | string | Object ID to which the access policy will be assigned. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterName`](#parameter-clustername) | string | The name of the grandparent Azure Managed Redis cluster. Required if the template is used in a standalone deployment. |
| [`databaseName`](#parameter-databasename) | string | The name of the parent Azure Managed Redis database. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessPolicyName`](#parameter-accesspolicyname) | string | Name of the access policy to be assigned. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`name`](#parameter-name) | string | Name of the access policy assignment. |

### Parameter: `userObjectId`

Object ID to which the access policy will be assigned.

- Required: Yes
- Type: string

### Parameter: `clusterName`

The name of the grandparent Azure Managed Redis cluster. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `databaseName`

The name of the parent Azure Managed Redis database. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `accessPolicyName`

Name of the access policy to be assigned.

- Required: No
- Type: string
- Default: `'default'`
- Allowed:
  ```Bicep
  [
    'default'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `name`

Name of the access policy assignment.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the access policy assignment. |
| `resourceGroupName` | string | The resource group the access policy assignment was deployed into. |
| `resourceId` | string | The resource ID of the access policy assignment. |
| `userObjectId` | string | The object ID of the user associated with the access policy. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
