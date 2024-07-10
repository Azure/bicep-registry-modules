# Virtual Hub Routing Intent `[Microsoft.Network/virtualHubs]`

This module configures Routing Intent for a Virtual Hub.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualHubs/routingIntent` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualHubs/routingIntent) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureFirewallResourceId`](#parameter-azurefirewallresourceid) | string | Hub firewall Resource ID  |
| [`internetToFirewall`](#parameter-internettofirewall) | bool | orward Internet traffic to the Azure firewall (0.0.0.0/0) |
| [`privateToFirewall`](#parameter-privatetofirewall) | bool | Forward Private traffic to the Azure firewall (RFC1918) |
| [`virtualHubName`](#parameter-virtualhubname) | string | Name of the Virtual Hub |

### Parameter: `azureFirewallResourceId`

Hub firewall Resource ID 

- Required: Yes
- Type: string

### Parameter: `internetToFirewall`

orward Internet traffic to the Azure firewall (0.0.0.0/0)

- Required: Yes
- Type: bool

### Parameter: `privateToFirewall`

Forward Private traffic to the Azure firewall (RFC1918)

- Required: Yes
- Type: bool

### Parameter: `virtualHubName`

Name of the Virtual Hub

- Required: Yes
- Type: string


## Outputs

| Output | Type |
| :-- | :-- |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
