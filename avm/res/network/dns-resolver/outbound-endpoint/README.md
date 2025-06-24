# DNS Resolver Outbound Endpoint `[Microsoft.Network/dnsResolvers/outboundEndpoints]`

This module deploys a DNS Resolver Outbound Endpoint.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/dnsResolvers/outboundEndpoints` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsResolvers/outboundEndpoints) |

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
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `dnsResolverName`

Name of the DNS Private Resolver.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the inbound endpoint.

- Required: Yes
- Type: string

### Parameter: `subnetResourceId`

The subnet ID of the inbound endpoint.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the resource. |
| `resourceGroupName` | string | The resource group of the resource. |
| `resourceId` | string | The resource ID of the resource. |
