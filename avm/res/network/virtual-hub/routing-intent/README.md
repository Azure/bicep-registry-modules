# Virtual Hub Routing Intent `[Microsoft.Network/virtualHubs/routingIntent]`

This module configures Routing Intent for a Virtual Hub; this module requires an existing Virtual Hub, as well the firewall Resource ID.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/virtualHubs/routingIntent` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualHubs/routingIntent) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureFirewallResourceId`](#parameter-azurefirewallresourceid) | string | Hub firewall Resource ID. |
| [`virtualHubName`](#parameter-virtualhubname) | string | Name of the Virtual Hub. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`internetToFirewall`](#parameter-internettofirewall) | bool | Configures Routing Intent to Forward Internet traffic to the firewall (0.0.0.0/0). |
| [`name`](#parameter-name) | string | The name of the routing intent configuration. |
| [`privateToFirewall`](#parameter-privatetofirewall) | bool | Configures Routing Intent to forward Private traffic to the firewall (RFC1918). |

### Parameter: `azureFirewallResourceId`

Hub firewall Resource ID.

- Required: Yes
- Type: string

### Parameter: `virtualHubName`

Name of the Virtual Hub.

- Required: Yes
- Type: string

### Parameter: `internetToFirewall`

Configures Routing Intent to Forward Internet traffic to the firewall (0.0.0.0/0).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `name`

The name of the routing intent configuration.

- Required: No
- Type: string
- Default: `'defaultRouteTable'`
- Allowed:
  ```Bicep
  [
    'defaultRouteTable'
  ]
  ```

### Parameter: `privateToFirewall`

Configures Routing Intent to forward Private traffic to the firewall (RFC1918).

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Routing Intent configuration. |
| `resourceGroupName` | string | The resource group the Routing Intent configuration was deployed into. |
| `resourceId` | string | The resource ID of the Routing Intent configuration. |

## Notes

The use of Routing Intent in a Virtual Hub requires the hub be made 'secure' by associating a firewall (to serve as the next-hop for the routing policy).

The 'azureFirewall' parameter in Microsoft.Network/virtualHubs is *read-only*; in order to properly deploy a Virtual Hub using Routing Intent, the hub's Resource ID must first be passed to the firewall in order for it to be properly associated. In order for this resource to work properly, the resources need to be created in the following order:

- **Virtual Hub**: Suggest minimal hub configuration; name/location/addressPrefix/virtualWan.id
- **Firewall**: Including Virtual Hub Resource ID in the firewall configuration
- **Virtual Hub**: Including all remaining parameters + Routing Intent
