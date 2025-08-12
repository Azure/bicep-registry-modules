# API Management Service API Version Sets `[Microsoft.ApiManagement/service/apiVersionSets]`

This module deploys an API Management Service API Version Set.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ApiManagement/service/apiVersionSets` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ApiManagement/2024-05-01/service/apiVersionSets) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | The display name of the Name of API Version Set. |
| [`versioningScheme`](#parameter-versioningscheme) | string | An value that determines where the API Version identifier will be located in a HTTP request. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementServiceName`](#parameter-apimanagementservicename) | string | The name of the parent API Management service. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | Description of API Version Set. |
| [`name`](#parameter-name) | string | API Version set name. |
| [`versionHeaderName`](#parameter-versionheadername) | string | Name of HTTP header parameter that indicates the API Version if versioningScheme is set to header. |
| [`versionQueryName`](#parameter-versionqueryname) | string | Name of query parameter that indicates the API Version if versioningScheme is set to query. |

### Parameter: `displayName`

The display name of the Name of API Version Set.

- Required: Yes
- Type: string

### Parameter: `versioningScheme`

An value that determines where the API Version identifier will be located in a HTTP request.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Header'
    'Query'
    'Segment'
  ]
  ```

### Parameter: `apiManagementServiceName`

The name of the parent API Management service. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

Description of API Version Set.

- Required: No
- Type: string

### Parameter: `name`

API Version set name.

- Required: No
- Type: string
- Default: `'default'`

### Parameter: `versionHeaderName`

Name of HTTP header parameter that indicates the API Version if versioningScheme is set to header.

- Required: No
- Type: string

### Parameter: `versionQueryName`

Name of query parameter that indicates the API Version if versioningScheme is set to query.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the API Version set. |
| `resourceGroupName` | string | The resource group the API Version set was deployed into. |
| `resourceId` | string | The resource ID of the API Version set. |
