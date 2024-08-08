# Private DNS Zone Virtual Network Link `[Microsoft.Network/privateDnsZones/virtualNetworkLinks]`

This module deploys a Private DNS Zone Virtual Network Link.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | [2020-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones/virtualNetworkLinks) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualNetworkResourceId`](#parameter-virtualnetworkresourceid) | string | Link to another virtual network resource ID. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneName`](#parameter-privatednszonename) | string | The name of the parent Private DNS zone. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | The location of the PrivateDNSZone. Should be global. |
| [`name`](#parameter-name) | string | The name of the virtual network link. |
| [`registrationEnabled`](#parameter-registrationenabled) | bool | Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `virtualNetworkResourceId`

Link to another virtual network resource ID.

- Required: Yes
- Type: string

### Parameter: `privateDnsZoneName`

The name of the parent Private DNS zone. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `location`

The location of the PrivateDNSZone. Should be global.

- Required: No
- Type: string
- Default: `'global'`

### Parameter: `name`

The name of the virtual network link.

- Required: No
- Type: string
- Default: `[format('{0}-vnetlink', last(split(parameters('virtualNetworkResourceId'), '/')))]`

### Parameter: `registrationEnabled`

Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed virtual network link. |
| `resourceGroupName` | string | The resource group of the deployed virtual network link. |
| `resourceId` | string | The resource ID of the deployed virtual network link. |
