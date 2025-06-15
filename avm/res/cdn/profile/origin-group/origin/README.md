# CDN Profiles Origin `[Microsoft.Cdn/profiles/originGroups/origins]`

This module deploys a CDN Profile Origin.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/originGroups/origins` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/originGroups/origins) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hostName`](#parameter-hostname) | string | The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported.This should be unique across all origins in an endpoint. |
| [`name`](#parameter-name) | string | The name of the origion. |
| [`originGroupName`](#parameter-origingroupname) | string | The name of the group. |
| [`profileName`](#parameter-profilename) | string | The name of the CDN profile. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabledState`](#parameter-enabledstate) | string | Whether to enable health probes to be made against backends defined under backendPools. Health probes can only be disabled if there is a single enabled backend in single enabled backend pool. |
| [`enforceCertificateNameCheck`](#parameter-enforcecertificatenamecheck) | bool | Whether to enable certificate name check at origin level. |
| [`httpPort`](#parameter-httpport) | int | The value of the HTTP port. Must be between 1 and 65535. |
| [`httpsPort`](#parameter-httpsport) | int | The value of the HTTPS port. Must be between 1 and 65535. |
| [`originHostHeader`](#parameter-originhostheader) | string | The host header value sent to the origin with each request. If you leave this blank, the request hostname determines this value. Azure Front Door origins, such as Web Apps, Blob Storage, and Cloud Services require this host header value to match the origin hostname by default. This overrides the host header defined at Endpoint. |
| [`priority`](#parameter-priority) | int | Priority of origin in given origin group for load balancing. Higher priorities will not be used for load balancing if any lower priority origin is healthy.Must be between 1 and 5. |
| [`sharedPrivateLinkResource`](#parameter-sharedprivatelinkresource) | object | The properties of the private link resource for private origin. |
| [`weight`](#parameter-weight) | int | Weight of the origin in given origin group for load balancing. Must be between 1 and 1000. |

### Parameter: `hostName`

The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported.This should be unique across all origins in an endpoint.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the origion.

- Required: Yes
- Type: string

### Parameter: `originGroupName`

The name of the group.

- Required: Yes
- Type: string

### Parameter: `profileName`

The name of the CDN profile.

- Required: Yes
- Type: string

### Parameter: `enabledState`

Whether to enable health probes to be made against backends defined under backendPools. Health probes can only be disabled if there is a single enabled backend in single enabled backend pool.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `enforceCertificateNameCheck`

Whether to enable certificate name check at origin level.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `httpPort`

The value of the HTTP port. Must be between 1 and 65535.

- Required: No
- Type: int
- Default: `80`

### Parameter: `httpsPort`

The value of the HTTPS port. Must be between 1 and 65535.

- Required: No
- Type: int
- Default: `443`

### Parameter: `originHostHeader`

The host header value sent to the origin with each request. If you leave this blank, the request hostname determines this value. Azure Front Door origins, such as Web Apps, Blob Storage, and Cloud Services require this host header value to match the origin hostname by default. This overrides the host header defined at Endpoint.

- Required: No
- Type: string
- Default: `''`

### Parameter: `priority`

Priority of origin in given origin group for load balancing. Higher priorities will not be used for load balancing if any lower priority origin is healthy.Must be between 1 and 5.

- Required: No
- Type: int
- Default: `1`

### Parameter: `sharedPrivateLinkResource`

The properties of the private link resource for private origin.

- Required: No
- Type: object

### Parameter: `weight`

Weight of the origin in given origin group for load balancing. Must be between 1 and 1000.

- Required: No
- Type: int
- Default: `1000`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the origin. |
| `resourceGroupName` | string | The name of the resource group the origin was created in. |
| `resourceId` | string | The resource id of the origin. |
