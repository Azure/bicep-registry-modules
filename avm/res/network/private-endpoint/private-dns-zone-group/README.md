# Private Endpoint Private DNS Zone Groups `[Microsoft.Network/privateEndpoints/privateDnsZoneGroups]`

This module deploys a Private Endpoint Private DNS Zone Group.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDNSResourceIds`](#parameter-privatednsresourceids) | array | Array of private DNS zone resource IDs. A DNS zone group can support up to 5 DNS zones. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateEndpointName`](#parameter-privateendpointname) | string | The name of the parent private endpoint. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the private DNS zone group. |

### Parameter: `name`

The name of the private DNS zone group.
- Required: No
- Type: string
- Default: `'default'`

### Parameter: `privateDNSResourceIds`

Array of private DNS zone resource IDs. A DNS zone group can support up to 5 DNS zones.
- Required: Yes
- Type: array

### Parameter: `privateEndpointName`

The name of the parent private endpoint. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the private endpoint DNS zone group. |
| `resourceGroupName` | string | The resource group the private endpoint DNS zone group was deployed into. |
| `resourceId` | string | The resource ID of the private endpoint DNS zone group. |

## Cross-referenced modules

_None_
