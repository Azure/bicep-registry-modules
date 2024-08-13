# Virtual Hub Routing Intent `[Microsoft.Network/virtualHubs]`

This module configures Routing Intent for a Virtual Hub; this module requires an existing Virtual Hub, as well the firewall Resource ID.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualHubs/routingIntent` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualHubs/routingIntent) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureFirewallResourceId`](#parameter-azurefirewallresourceid) | string | Hub firewall Resource ID. |
| [`internetToFirewall`](#parameter-internettofirewall) | bool | Configures Routing Intent to Forward Internet traffic to the firewall (0.0.0.0/0). |
| [`privateToFirewall`](#parameter-privatetofirewall) | bool | Configures Routing Intent to forward Private traffic to the firewall (RFC1918). |
| [`virtualHubName`](#parameter-virtualhubname) | string | Name of the Virtual Hub. |

### Parameter: `azureFirewallResourceId`

Hub firewall Resource ID.

- Required: Yes
- Type: string

### Parameter: `internetToFirewall`

Configures Routing Intent to Forward Internet traffic to the firewall (0.0.0.0/0).

- Required: Yes
- Type: bool

### Parameter: `privateToFirewall`

Configures Routing Intent to forward Private traffic to the firewall (RFC1918).

- Required: Yes
- Type: bool

### Parameter: `virtualHubName`

Name of the Virtual Hub.

- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Routing Intent configuration. |
| `resourceGroupName` | string | The resource group the Routing Intent configuration was deployed into. |
| `resourceId` | string | The resource ID of the Routing Intent configuration. |

## Cross-referenced modules

_None_

## Notes

The use of Routing Intent in a Virtual Hub requires the hub be made 'secure' by associating a firewall (to serve as the next-hop for the routing policy).

The 'azureFirewall' parameter in Microsoft.Network/virtualHubs is *read-only*; in order to properly deploy a Virtual Hub using Routing Intent, the hub's Resource ID must first be passed to the firewall in order for it to be properly associated. In order for this resource to work properly, the resources need to be created in the following order:

- **Virtual Hub**: Suggest minimal hub configuration; name/location/addressPrefix/virtualWan.id
- **Firewall**: Including Virtual Hub Resource ID in the firewall configuration
- **Virtual Hub**: Including all remaining parameters + Routing Intent

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
