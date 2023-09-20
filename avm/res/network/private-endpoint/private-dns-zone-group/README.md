# Private Endpoint Private DNS Zone Groups `[Microsoft.Network/privateEndpoints/privateDnsZoneGroups]`

This module deploys a Private Endpoint Private DNS Zone Group.

## Navigation

- [Private Endpoint Private DNS Zone Groups `[Microsoft.Network/privateEndpoints/privateDnsZoneGroups]`](#private-endpoint-private-dns-zone-groups-microsoftnetworkprivateendpointsprivatednszonegroups)
  - [Navigation](#navigation)
  - [Resource Types](#resource-types)
  - [Parameters](#parameters)
  - [Outputs](#outputs)
  - [Cross-referenced modules](#cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroup` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Required parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `privateDNSResourceIds` | array | Array of private DNS zone resource IDs. A DNS zone group can support up to 5 DNS zones. |

**Conditional parameters**

| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `privateEndpointName` | string | The name of the parent private endpoint. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableTelemetry` | bool | `True` | Enable telemetry via a Globally Unique Identifier (GUID). |
| `name` | string | `'default'` | The name of the private DNS zone group. |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the private endpoint DNS zone group. |
| `resourceGroupName` | string | The resource group the private endpoint DNS zone group was deployed into. |
| `resourceId` | string | The resource ID of the private endpoint DNS zone group. |

## Cross-referenced modules

_None_
