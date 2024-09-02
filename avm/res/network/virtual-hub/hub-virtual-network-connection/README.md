# Virtual Hub Virtual Network Connections `[Microsoft.Network/virtualHubs/hubVirtualNetworkConnections]`

This module deploys a Virtual Hub Virtual Network Connection.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/virtualHubs/hubVirtualNetworkConnections) |

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
