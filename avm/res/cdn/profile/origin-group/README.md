# CDN Profiles Origin Group `[Microsoft.Cdn/profiles/originGroups]`

This module deploys a CDN Profile Origin Group.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Cdn/profiles/originGroups` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_origingroups.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/originGroups)</li></ul> |
| `Microsoft.Cdn/profiles/originGroups/origins` | 2025-04-15 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_origingroups_origins.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/originGroups/origins)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`loadBalancingSettings`](#parameter-loadbalancingsettings) | object | Load balancing settings for a backend pool. |
| [`name`](#parameter-name) | string | The name of the origin group. |
| [`origins`](#parameter-origins) | array | The list of origins within the origin group. |
| [`profileName`](#parameter-profilename) | string | The name of the CDN profile. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`healthProbeSettings`](#parameter-healthprobesettings) | object | Health probe settings to the origin that is used to determine the health of the origin. |
| [`sessionAffinityState`](#parameter-sessionaffinitystate) | string | Whether to allow session affinity on this host. |
| [`trafficRestorationTimeToHealedOrNewEndpointsInMinutes`](#parameter-trafficrestorationtimetohealedornewendpointsinminutes) | int | Time in minutes to shift the traffic to the endpoint gradually when an unhealthy endpoint comes healthy or a new endpoint is added. Default is 10 mins. |

### Parameter: `loadBalancingSettings`

Load balancing settings for a backend pool.

- Required: Yes
- Type: object

### Parameter: `name`

The name of the origin group.

- Required: Yes
- Type: string

### Parameter: `origins`

The list of origins within the origin group.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hostName`](#parameter-originshostname) | string | The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported.This should be unique across all origins in an endpoint. |
| [`name`](#parameter-originsname) | string | The name of the origion. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabledState`](#parameter-originsenabledstate) | string | Whether to enable health probes to be made against backends defined under backendPools. Health probes can only be disabled if there is a single enabled backend in single enabled backend pool. |
| [`enforceCertificateNameCheck`](#parameter-originsenforcecertificatenamecheck) | bool | Whether to enable certificate name check at origin level. |
| [`httpPort`](#parameter-originshttpport) | int | The value of the HTTP port. Must be between 1 and 65535. |
| [`httpsPort`](#parameter-originshttpsport) | int | The value of the HTTPS port. Must be between 1 and 65535. |
| [`originHostHeader`](#parameter-originsoriginhostheader) | string | The host header value sent to the origin with each request. If you leave this blank, the request hostname determines this value. Azure Front Door origins, such as Web Apps, Blob Storage, and Cloud Services require this host header value to match the origin hostname by default. This overrides the host header defined at Endpoint. |
| [`priority`](#parameter-originspriority) | int | Priority of origin in given origin group for load balancing. Higher priorities will not be used for load balancing if any lower priority origin is healthy.Must be between 1 and 5. |
| [`sharedPrivateLinkResource`](#parameter-originssharedprivatelinkresource) | object | The properties of the private link resource for private origin. |
| [`weight`](#parameter-originsweight) | int | Weight of the origin in given origin group for load balancing. Must be between 1 and 1000. |

### Parameter: `origins.hostName`

The address of the origin. Domain names, IPv4 addresses, and IPv6 addresses are supported.This should be unique across all origins in an endpoint.

- Required: Yes
- Type: string

### Parameter: `origins.name`

The name of the origion.

- Required: Yes
- Type: string

### Parameter: `origins.enabledState`

Whether to enable health probes to be made against backends defined under backendPools. Health probes can only be disabled if there is a single enabled backend in single enabled backend pool.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `origins.enforceCertificateNameCheck`

Whether to enable certificate name check at origin level.

- Required: No
- Type: bool

### Parameter: `origins.httpPort`

The value of the HTTP port. Must be between 1 and 65535.

- Required: No
- Type: int

### Parameter: `origins.httpsPort`

The value of the HTTPS port. Must be between 1 and 65535.

- Required: No
- Type: int

### Parameter: `origins.originHostHeader`

The host header value sent to the origin with each request. If you leave this blank, the request hostname determines this value. Azure Front Door origins, such as Web Apps, Blob Storage, and Cloud Services require this host header value to match the origin hostname by default. This overrides the host header defined at Endpoint.

- Required: No
- Type: string

### Parameter: `origins.priority`

Priority of origin in given origin group for load balancing. Higher priorities will not be used for load balancing if any lower priority origin is healthy.Must be between 1 and 5.

- Required: No
- Type: int

### Parameter: `origins.sharedPrivateLinkResource`

The properties of the private link resource for private origin.

- Required: No
- Type: object

### Parameter: `origins.weight`

Weight of the origin in given origin group for load balancing. Must be between 1 and 1000.

- Required: No
- Type: int

### Parameter: `profileName`

The name of the CDN profile.

- Required: Yes
- Type: string

### Parameter: `healthProbeSettings`

Health probe settings to the origin that is used to determine the health of the origin.

- Required: No
- Type: object

### Parameter: `sessionAffinityState`

Whether to allow session affinity on this host.

- Required: No
- Type: string
- Default: `'Disabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `trafficRestorationTimeToHealedOrNewEndpointsInMinutes`

Time in minutes to shift the traffic to the endpoint gradually when an unhealthy endpoint comes healthy or a new endpoint is added. Default is 10 mins.

- Required: No
- Type: int
- Default: `10`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the origin group. |
| `resourceGroupName` | string | The name of the resource group the origin group was created in. |
| `resourceId` | string | The resource id of the origin group. |
