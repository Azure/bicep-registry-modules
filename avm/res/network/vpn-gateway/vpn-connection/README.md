# VPN Gateway VPN Connections `[Microsoft.Network/vpnGateways/vpnConnections]`

This module deploys a VPN Gateway VPN Connection.

You can reference the module as follows:
```bicep
module vpnGateway 'br/public:avm/res/network/vpn-gateway/vpn-connection:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Network/vpnGateways/vpnConnections` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_vpngateways_vpnconnections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/vpnGateways/vpnConnections)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the VPN connection. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`vpnGatewayName`](#parameter-vpngatewayname) | string | The name of the parent VPN gateway this VPN connection is associated with. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionBandwidth`](#parameter-connectionbandwidth) | int | Expected bandwidth in MBPS. This parameter is deprecated and should be avoided in favor of VpnSiteLinkConnection configuration. |
| [`enableBgp`](#parameter-enablebgp) | bool | Enable BGP flag. |
| [`enableInternetSecurity`](#parameter-enableinternetsecurity) | bool | Enable internet security. |
| [`enableRateLimiting`](#parameter-enableratelimiting) | bool | Enable rate limiting. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipsecPolicies`](#parameter-ipsecpolicies) | array | The IPSec policies to be considered by this connection. |
| [`remoteVpnSiteResourceId`](#parameter-remotevpnsiteresourceid) | string | Reference to a VPN site to link to. |
| [`routingConfiguration`](#parameter-routingconfiguration) | object | Routing configuration indicating the associated and propagated route tables for this connection. |
| [`routingWeight`](#parameter-routingweight) | int | Routing weight for VPN connection. |
| [`sharedKey`](#parameter-sharedkey) | securestring | SharedKey for the VPN connection. |
| [`trafficSelectorPolicies`](#parameter-trafficselectorpolicies) | array | The traffic selector policies to be considered by this connection. |
| [`useLocalAzureIpAddress`](#parameter-uselocalazureipaddress) | bool | Use local Azure IP to initiate connection. |
| [`usePolicyBasedTrafficSelectors`](#parameter-usepolicybasedtrafficselectors) | bool | Enable policy-based traffic selectors. |
| [`vpnConnectionProtocolType`](#parameter-vpnconnectionprotocoltype) | string | Gateway connection protocol. |
| [`vpnLinkConnections`](#parameter-vpnlinkconnections) | array | List of all VPN site link connections to the gateway. |

### Parameter: `name`

The name of the VPN connection.

- Required: Yes
- Type: string

### Parameter: `vpnGatewayName`

The name of the parent VPN gateway this VPN connection is associated with. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `connectionBandwidth`

Expected bandwidth in MBPS. This parameter is deprecated and should be avoided in favor of VpnSiteLinkConnection configuration.

- Required: No
- Type: int

### Parameter: `enableBgp`

Enable BGP flag.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableInternetSecurity`

Enable internet security.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableRateLimiting`

Enable rate limiting.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `ipsecPolicies`

The IPSec policies to be considered by this connection.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `remoteVpnSiteResourceId`

Reference to a VPN site to link to.

- Required: No
- Type: string
- Default: `''`

### Parameter: `routingConfiguration`

Routing configuration indicating the associated and propagated route tables for this connection.

- Required: No
- Type: object

### Parameter: `routingWeight`

Routing weight for VPN connection.

- Required: No
- Type: int
- Default: `0`

### Parameter: `sharedKey`

SharedKey for the VPN connection.

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `trafficSelectorPolicies`

The traffic selector policies to be considered by this connection.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `useLocalAzureIpAddress`

Use local Azure IP to initiate connection.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `usePolicyBasedTrafficSelectors`

Enable policy-based traffic selectors.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `vpnConnectionProtocolType`

Gateway connection protocol.

- Required: No
- Type: string
- Default: `'IKEv2'`
- Allowed:
  ```Bicep
  [
    'IKEv1'
    'IKEv2'
  ]
  ```

### Parameter: `vpnLinkConnections`

List of all VPN site link connections to the gateway.

- Required: No
- Type: array
- Default: `[]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the VPN connection. |
| `resourceGroupName` | string | The name of the resource group the VPN connection was deployed into. |
| `resourceId` | string | The resource ID of the VPN connection. |

## Notes

### Parameter Usage: `routingConfiguration`

<details>

<summary>Parameter JSON format</summary>

```json
"routingConfiguration": {
    "associatedRouteTable": {
        "id": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualHubs/SampleVirtualHub/hubRouteTables/defaultRouteTable"
    },
    "propagatedRouteTables": {
        "labels": [
            "default"
        ],
        "ids": [
            {
                "id": "/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualHubs/SampleVirtualHub/hubRouteTables/defaultRouteTable"
            }
        ]
    },
    "vnetRoutes": {
        "staticRoutes": []
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
routingConfiguration: {
    associatedRouteTable: {
        id: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualHubs/SampleVirtualHub/hubRouteTables/defaultRouteTable'
    }
    propagatedRouteTables: {
        labels: [
            'default'
        ]
        ids: [
            {
                id: '/subscriptions/[[subscriptionId]]/resourceGroups/validation-rg/providers/Microsoft.Network/virtualHubs/SampleVirtualHub/hubRouteTables/defaultRouteTable'
            }
        ]
    }
    vnetRoutes: {
        staticRoutes: []
    }
}
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
