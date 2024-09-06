# Virtual Network Peerings `[Microsoft.Network/virtualNetworks/virtualNetworkPeerings]`

This module deploys a Virtual Network Peering.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/virtualNetworks/virtualNetworkPeerings) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`remoteVirtualNetworkResourceId`](#parameter-remotevirtualnetworkresourceid) | string | The Resource ID of the VNet that is this Local VNet is being peered to. Should be in the format of a Resource ID. |

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
| [`name`](#parameter-name) | string | The Name of VNET Peering resource. If not provided, default value will be localVnetName-remoteVnetName. |
| [`useRemoteGateways`](#parameter-useremotegateways) | bool | If remote gateways can be used on this virtual network. If the flag is set to true, and allowGatewayTransit on remote peering is also true, virtual network will use gateways of remote virtual network for transit. Only one peering can have this flag set to true. This flag cannot be set if virtual network already has a gateway. Default is false. |

### Parameter: `remoteVirtualNetworkResourceId`

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

The Name of VNET Peering resource. If not provided, default value will be localVnetName-remoteVnetName.

- Required: No
- Type: string
- Default: `[format('peer-{0}-{1}', parameters('localVnetName'), last(split(parameters('remoteVirtualNetworkResourceId'), '/')))]`

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
