# API Management Service Caches `[Microsoft.ApiManagement/service/caches]`

This module deploys an API Management Service Cache.

You can reference the module as follows:
```bicep
module service 'br/public:avm/res/api-management/service/cache:<version>' = {
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
| `Microsoft.ApiManagement/service/caches` | 2024-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.apimanagement_service_caches.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/caches)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionString`](#parameter-connectionstring) | string | Runtime connection string to cache. Can be referenced by a named value like so, {{<named-value>}}. |
| [`name`](#parameter-name) | string | Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier). |
| [`useFromLocation`](#parameter-usefromlocation) | string | Location identifier to use cache from (should be either 'default' or valid Azure region identifier). |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | Cache description. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`resourceId`](#parameter-resourceid) | string | Original uri of entity in external system cache points to. |

### Parameter: `connectionString`

Runtime connection string to cache. Can be referenced by a named value like so, {{<named-value>}}.

- Required: Yes
- Type: string

### Parameter: `name`

Identifier of the Cache entity. Cache identifier (should be either 'default' or valid Azure region identifier).

- Required: Yes
- Type: string

### Parameter: `useFromLocation`

Location identifier to use cache from (should be either 'default' or valid Azure region identifier).

- Required: Yes
- Type: string

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

Cache description.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `resourceId`

Original uri of entity in external system cache points to.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API management service cache. |
| `resourceGroupName` | string | The resource group the API management service cache was deployed into. |
| `resourceId` | string | The resource ID of the API management service cache. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
