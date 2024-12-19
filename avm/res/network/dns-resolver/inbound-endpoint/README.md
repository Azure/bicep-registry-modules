# DNS Resolver Inbound Endpoint `[Microsoft.Network/dnsResolvers/inboundEndpoints]`

This module deploys a DNS Resolver Inbound Endpoint.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/dnsResolvers/inboundEndpoints` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsResolvers/inboundEndpoints) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dnsResolverName`](#parameter-dnsresolvername) | string | Name of the DNS Private Resolver. |
| [`name`](#parameter-name) | string | The name of the inbound endpoint. |
| [`subnetResourceId`](#parameter-subnetresourceid) | string | The subnet ID of the inbound endpoint. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`privateIpAddress`](#parameter-privateipaddress) | string | The private IP address of the inbound endpoint. |
| [`privateIpAllocationMethod`](#parameter-privateipallocationmethod) | string | The private IP allocation method of the inbound endpoint. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `dnsResolverName`

Name of the DNS Private Resolver.

- Required: Yes
- Type: string
- Nullable: No

### Parameter: `name`

The name of the inbound endpoint.

- Required: Yes
- Type: string
- Nullable: No

### Parameter: `subnetResourceId`

The subnet ID of the inbound endpoint.

- Required: Yes
- Type: string
- Nullable: No

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Nullable: No
- Default: `[resourceGroup().location]`

### Parameter: `privateIpAddress`

The private IP address of the inbound endpoint.

- Required: No
- Type: string
- Nullable: Yes

### Parameter: `privateIpAllocationMethod`

The private IP allocation method of the inbound endpoint.

- Required: No
- Type: string
- Nullable: No
- Default: `'Dynamic'`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object
- Nullable: Yes

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the resource. |
| `resourceGroupName` | string | The resource group of the resource. |
| `resourceId` | string | The resource ID of the resource. |
