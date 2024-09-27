# CDN Profiles Endpoints `[Microsoft.Cdn/profiles/endpoints]`

This module deploys a CDN Profile Endpoint.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/endpoints` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2021-06-01/profiles/endpoints) |
| `Microsoft.Cdn/profiles/endpoints/origins` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2021-06-01/profiles/endpoints/origins) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the endpoint under the profile which is unique globally. |
| [`properties`](#parameter-properties) | object | Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details). |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`profileName`](#parameter-profilename) | string | The name of the parent CDN profile. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Resource location. |
| [`tags`](#parameter-tags) | object | Endpoint tags. |

### Parameter: `name`

Name of the endpoint under the profile which is unique globally.

- Required: Yes
- Type: string

### Parameter: `properties`

Endpoint properties (see https://learn.microsoft.com/en-us/azure/templates/microsoft.cdn/profiles/endpoints?pivots=deployment-language-bicep#endpointproperties for details).

- Required: Yes
- Type: object

### Parameter: `profileName`

The name of the parent CDN profile. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `location`

Resource location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Endpoint tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `endpointProperties` | object | The properties of the endpoint. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the endpoint. |
| `resourceGroupName` | string | The name of the resource group the endpoint was created in. |
| `resourceId` | string | The resource ID of the endpoint. |
| `uri` | string | The uri of the endpoint. |
