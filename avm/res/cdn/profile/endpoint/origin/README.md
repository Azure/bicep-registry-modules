# CDN Profiles Endpoints Origins `[Microsoft.Cdn/profiles/endpoints/origins]`

This module deploys a CDN Profile Endpoint Origin.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/endpoints/origins` | [2021-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2021-06-01/profiles/endpoints/origins) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`endpointName`](#parameter-endpointname) | string | The name of the CDN Endpoint. |
| [`hostName`](#parameter-hostname) | string | The hostname of the origin. |
| [`name`](#parameter-name) | string | The name of the origin. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`priority`](#parameter-priority) | int | The priority of origin in given origin group for load balancing. Required if `weight` is provided. |
| [`privateLinkAlias`](#parameter-privatelinkalias) | string | The private link alias of the origin. Required if privateLinkLocation is provided. |
| [`privateLinkLocation`](#parameter-privatelinklocation) | string | The private link location of the origin. Required if privateLinkAlias is provided. |
| [`weight`](#parameter-weight) | int | The weight of the origin used for load balancing. Required if `priority` is provided. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-enabled) | bool | Whether the origin is enabled for load balancing. |
| [`httpPort`](#parameter-httpport) | int | The HTTP port of the origin. |
| [`httpsPort`](#parameter-httpsport) | int | The HTTPS port of the origin. |
| [`originHostHeader`](#parameter-originhostheader) | string | The host header value sent to the origin. |
| [`privateLinkResourceId`](#parameter-privatelinkresourceid) | string | The private link resource ID of the origin. |
| [`profileName`](#parameter-profilename) | string | The name of the CDN profile. Default to "default". |

### Parameter: `endpointName`

The name of the CDN Endpoint.

- Required: Yes
- Type: string

### Parameter: `hostName`

The hostname of the origin.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the origin.

- Required: Yes
- Type: string

### Parameter: `priority`

The priority of origin in given origin group for load balancing. Required if `weight` is provided.

- Required: No
- Type: int
- Default: `-1`

### Parameter: `privateLinkAlias`

The private link alias of the origin. Required if privateLinkLocation is provided.

- Required: No
- Type: string

### Parameter: `privateLinkLocation`

The private link location of the origin. Required if privateLinkAlias is provided.

- Required: No
- Type: string

### Parameter: `weight`

The weight of the origin used for load balancing. Required if `priority` is provided.

- Required: No
- Type: int
- Default: `-1`

### Parameter: `enabled`

Whether the origin is enabled for load balancing.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `httpPort`

The HTTP port of the origin.

- Required: No
- Type: int
- Default: `80`

### Parameter: `httpsPort`

The HTTPS port of the origin.

- Required: No
- Type: int
- Default: `443`

### Parameter: `originHostHeader`

The host header value sent to the origin.

- Required: No
- Type: string

### Parameter: `privateLinkResourceId`

The private link resource ID of the origin.

- Required: No
- Type: string

### Parameter: `profileName`

The name of the CDN profile. Default to "default".

- Required: No
- Type: string
- Default: `'default'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the endpoint. |
| `resourceGroupName` | string | The name of the resource group the endpoint was created in. |
| `resourceId` | string | The resource ID of the endpoint. |
