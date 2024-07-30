# Private Endpoint Private DNS Zone Groups `[Microsoft.Network/privateEndpoints/privateDnsZoneGroups]`

This module deploys a Private Endpoint Private DNS Zone Group.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
