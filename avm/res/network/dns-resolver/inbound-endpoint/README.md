# DNS Resolver Inbound Endpoint `[Microsoft.Network/dnsResolvers/inboundEndpoints]`

This module deploys a DNS Resolver Inbound Endpoint.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

### Parameter: `privateIpAddress`

The private IP address of the inbound endpoint.

- Required: No
- Type: string

### Parameter: `privateIpAllocationMethod`

The private IP allocation method of the inbound endpoint.

- Required: No
- Type: string
- Default: `'Dynamic'`

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
