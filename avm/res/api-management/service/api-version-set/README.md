# API Management Service API Version Sets `[Microsoft.ApiManagement/service/apiVersionSets]`

This module deploys an API Management Service API Version Set.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apiVersionSets` | [2022-08-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2022-08-01/service/apiVersionSets) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | API Version set name. |
| [`properties`](#parameter-properties) | object | API Version set properties. |

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `name`

API Version set name.

- Required: No
- Type: string
- Default: `'default'`

### Parameter: `properties`

API Version set properties.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API Version set. |
| `resourceGroupName` | string | The resource group the API Version set was deployed into. |
| `resourceId` | string | The resource ID of the API Version set. |
