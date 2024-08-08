# Private Endpoint Private DNS Zone Groups `[Microsoft.Network/privateEndpoints/privateDnsZoneGroups]`

This module deploys a Private Endpoint Private DNS Zone Group.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/privateEndpoints/privateDnsZoneGroups) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneConfigs`](#parameter-privatednszoneconfigs) | array | Array of private DNS zone configurations of the private DNS zone group. A DNS zone group can support up to 5 DNS zones. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateEndpointName`](#parameter-privateendpointname) | string | The name of the parent private endpoint. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the private DNS zone group. |

### Parameter: `privateDnsZoneConfigs`

Array of private DNS zone configurations of the private DNS zone group. A DNS zone group can support up to 5 DNS zones.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneResourceId`](#parameter-privatednszoneconfigsprivatednszoneresourceid) | string | The resource id of the private DNS zone. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privatednszoneconfigsname) | string | The name of the private DNS zone group config. |

### Parameter: `privateDnsZoneConfigs.privateDnsZoneResourceId`

The resource id of the private DNS zone.

- Required: Yes
- Type: string

### Parameter: `privateDnsZoneConfigs.name`

The name of the private DNS zone group config.

- Required: No
- Type: string

### Parameter: `privateEndpointName`

The name of the parent private endpoint. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the private DNS zone group.

- Required: No
- Type: string
- Default: `'default'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the private endpoint DNS zone group. |
| `resourceGroupName` | string | The resource group the private endpoint DNS zone group was deployed into. |
| `resourceId` | string | The resource ID of the private endpoint DNS zone group. |
