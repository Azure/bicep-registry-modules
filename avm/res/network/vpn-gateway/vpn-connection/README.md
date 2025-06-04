# VPN Gateway VPN Connections `[Microsoft.Network/vpnGateways/vpnConnections]`

This module deploys a VPN Gateway VPN Connection.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/vpnGateways/vpnConnections` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/vpnGateways/vpnConnections) |

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

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`associatedRouteTable`](#parameter-routingconfigurationassociatedroutetable) | object | The associated route table for this connection. |
| [`propagatedRouteTables`](#parameter-routingconfigurationpropagatedroutetables) | object | The propagated route tables for this connection. |
| [`vnetRoutes`](#parameter-routingconfigurationvnetroutes) | object | The virtual network routes for this connection. |

### Parameter: `routingConfiguration.associatedRouteTable`

The associated route table for this connection.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-routingconfigurationassociatedroutetableid) | string | The resource ID of the route table. |

### Parameter: `routingConfiguration.associatedRouteTable.id`

The resource ID of the route table.

- Required: Yes
- Type: string

### Parameter: `routingConfiguration.propagatedRouteTables`

The propagated route tables for this connection.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ids`](#parameter-routingconfigurationpropagatedroutetablesids) | array | The list of route table resource IDs to propagate to. |
| [`labels`](#parameter-routingconfigurationpropagatedroutetableslabels) | array | The list of labels to propagate to. |

### Parameter: `routingConfiguration.propagatedRouteTables.ids`

The list of route table resource IDs to propagate to.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-routingconfigurationpropagatedroutetablesidsid) | string | The resource ID of the route table. |

### Parameter: `routingConfiguration.propagatedRouteTables.ids.id`

The resource ID of the route table.

- Required: Yes
- Type: string

### Parameter: `routingConfiguration.propagatedRouteTables.labels`

The list of labels to propagate to.

- Required: No
- Type: array

### Parameter: `routingConfiguration.vnetRoutes`

The virtual network routes for this connection.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`staticRoutes`](#parameter-routingconfigurationvnetroutesstaticroutes) | array | The list of static routes. |
| [`staticRoutesConfig`](#parameter-routingconfigurationvnetroutesstaticroutesconfig) | object | Static routes configuration. |

### Parameter: `routingConfiguration.vnetRoutes.staticRoutes`

The list of static routes.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-routingconfigurationvnetroutesstaticroutesaddressprefixes) | array | The address prefixes for the static route. |
| [`name`](#parameter-routingconfigurationvnetroutesstaticroutesname) | string | The name of the static route. |
| [`nextHopIpAddress`](#parameter-routingconfigurationvnetroutesstaticroutesnexthopipaddress) | string | The next hop IP address for the static route. |

### Parameter: `routingConfiguration.vnetRoutes.staticRoutes.addressPrefixes`

The address prefixes for the static route.

- Required: No
- Type: array

### Parameter: `routingConfiguration.vnetRoutes.staticRoutes.name`

The name of the static route.

- Required: No
- Type: string

### Parameter: `routingConfiguration.vnetRoutes.staticRoutes.nextHopIpAddress`

The next hop IP address for the static route.

- Required: No
- Type: string

### Parameter: `routingConfiguration.vnetRoutes.staticRoutesConfig`

Static routes configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`vnetLocalRouteOverrideCriteria`](#parameter-routingconfigurationvnetroutesstaticroutesconfigvnetlocalrouteoverridecriteria) | string | Determines whether the NVA in a SPOKE VNET is bypassed for traffic with destination in spoke. |

### Parameter: `routingConfiguration.vnetRoutes.staticRoutesConfig.vnetLocalRouteOverrideCriteria`

Determines whether the NVA in a SPOKE VNET is bypassed for traffic with destination in spoke.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Contains'
    'Equal'
  ]
  ```

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
