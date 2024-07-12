# Virtual Network Peerings `[Microsoft.Network/virtualNetworks/virtualNetworkPeerings]`

This module deploys a Virtual Network Peering.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualNetworks/virtualNetworkPeerings) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`remoteVirtualNetworkId`](#parameter-remotevirtualnetworkid) | string | The Resource ID of the VNet that is this Local VNet is being peered to. Should be in the format of a Resource ID. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`localVnetName`](#parameter-localvnetname) | string | The name of the parent Virtual Network to add the peering to. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowForwardedTraffic`](#parameter-allowforwardedtraffic) | bool | Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. Default is true. |
| [`allowGatewayTransit`](#parameter-allowgatewaytransit) | bool | If gateway links can be used in remote virtual networking to link to this virtual network. Default is false. |
| [`allowVirtualNetworkAccess`](#parameter-allowvirtualnetworkaccess) | bool | Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. Default is true. |
| [`doNotVerifyRemoteGateways`](#parameter-donotverifyremotegateways) | bool | If we need to verify the provisioning state of the remote gateway. Default is true. |
| [`name`](#parameter-name) | string | The Name of Vnet Peering resource. If not provided, default value will be localVnetName-remoteVnetName. |
| [`useRemoteGateways`](#parameter-useremotegateways) | bool | If remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Default is false. |

### Parameter: `remoteVirtualNetworkId`

The Resource ID of the VNet that is this Local VNet is being peered to. Should be in the format of a Resource ID.

- Required: Yes
- Type: string

### Parameter: `localVnetName`

The name of the parent Virtual Network to add the peering to. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `allowForwardedTraffic`

Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. Default is true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `allowGatewayTransit`

If gateway links can be used in remote virtual networking to link to this virtual network. Default is false.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `allowVirtualNetworkAccess`

Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. Default is true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `doNotVerifyRemoteGateways`

If we need to verify the provisioning state of the remote gateway. Default is true.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `name`

The Name of Vnet Peering resource. If not provided, default value will be localVnetName-remoteVnetName.

- Required: No
- Type: string
- Default: `[format('{0}-{1}', parameters('localVnetName'), last(split(parameters('remoteVirtualNetworkId'), '/')))]`

### Parameter: `useRemoteGateways`

If remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Default is false.

- Required: No
- Type: bool
- Default: `False`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual network peering. |
| `resourceGroupName` | string | The resource group the virtual network peering was deployed into. |
| `resourceId` | string | The resource ID of the virtual network peering. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
