# Virtual Hub Virtual Network Connections `[Microsoft.Network/virtualHubs/hubVirtualNetworkConnections]`

This module deploys a Virtual Hub Virtual Network Connection.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/virtualHubs/hubVirtualNetworkConnections) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The connection name. |
| [`remoteVirtualNetworkId`](#parameter-remotevirtualnetworkid) | string | Resource ID of the virtual network to link to. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualHubName`](#parameter-virtualhubname) | string | The name of the parent virtual hub. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableInternetSecurity`](#parameter-enableinternetsecurity) | bool | Enable internet security. |
| [`routingConfiguration`](#parameter-routingconfiguration) | object | Routing Configuration indicating the associated and propagated route tables for this connection. |

### Parameter: `name`

The connection name.

- Required: Yes
- Type: string

### Parameter: `remoteVirtualNetworkId`

Resource ID of the virtual network to link to.

- Required: Yes
- Type: string

### Parameter: `virtualHubName`

The name of the parent virtual hub. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableInternetSecurity`

Enable internet security.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `routingConfiguration`

Routing Configuration indicating the associated and propagated route tables for this connection.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the virtual hub connection. |
| `resourceGroupName` | string | The resource group the virtual hub connection was deployed into. |
| `resourceId` | string | The resource ID of the virtual hub connection. |
