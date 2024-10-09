# API Management Service Caches `[Microsoft.ApiManagement/service/caches]`

This module deploys an API Management Service Cache.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/caches` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/caches) |

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
