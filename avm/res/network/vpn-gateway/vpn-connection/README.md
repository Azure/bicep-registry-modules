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
| `Microsoft.Network/vpnGateways/vpnConnections` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/vpnGateways/vpnConnections) |

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dhGroup`](#parameter-ipsecpoliciesdhgroup) | string | The DH Group used in IKE Phase 1 for initial SA. |
| [`ikeEncryption`](#parameter-ipsecpoliciesikeencryption) | string | The IKE encryption algorithm (IKE phase 2). |
| [`ikeIntegrity`](#parameter-ipsecpoliciesikeintegrity) | string | The IKE integrity algorithm (IKE phase 2). |
| [`ipsecEncryption`](#parameter-ipsecpoliciesipsecencryption) | string | The IPSec encryption algorithm (IKE phase 1). |
| [`ipsecIntegrity`](#parameter-ipsecpoliciesipsecintegrity) | string | The IPSec integrity algorithm (IKE phase 1). |
| [`pfsGroup`](#parameter-ipsecpoliciespfsgroup) | string | The Pfs Group used in IKE Phase 2 for new child SA. |
| [`saDataSizeKilobytes`](#parameter-ipsecpoliciessadatasizekilobytes) | int | The IPSec Security Association payload size in KB for a site to site VPN tunnel. |
| [`saLifeTimeSeconds`](#parameter-ipsecpoliciessalifetimeseconds) | int | The IPSec Security Association lifetime in seconds for a site to site VPN tunnel. |

### Parameter: `ipsecPolicies.dhGroup`

The DH Group used in IKE Phase 1 for initial SA.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'DHGroup1'
    'DHGroup14'
    'DHGroup2'
    'DHGroup2048'
    'DHGroup24'
    'ECP256'
    'ECP384'
    'None'
  ]
  ```

### Parameter: `ipsecPolicies.ikeEncryption`

The IKE encryption algorithm (IKE phase 2).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AES128'
    'AES192'
    'AES256'
    'DES'
    'DES3'
    'GCMAES128'
    'GCMAES256'
  ]
  ```

### Parameter: `ipsecPolicies.ikeIntegrity`

The IKE integrity algorithm (IKE phase 2).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'GCMAES128'
    'GCMAES256'
    'MD5'
    'SHA1'
    'SHA256'
    'SHA384'
  ]
  ```

### Parameter: `ipsecPolicies.ipsecEncryption`

The IPSec encryption algorithm (IKE phase 1).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AES128'
    'AES192'
    'AES256'
    'DES'
    'DES3'
    'GCMAES128'
    'GCMAES192'
    'GCMAES256'
    'None'
  ]
  ```

### Parameter: `ipsecPolicies.ipsecIntegrity`

The IPSec integrity algorithm (IKE phase 1).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'GCMAES128'
    'GCMAES192'
    'GCMAES256'
    'MD5'
    'SHA1'
    'SHA256'
  ]
  ```

### Parameter: `ipsecPolicies.pfsGroup`

The Pfs Group used in IKE Phase 2 for new child SA.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ECP256'
    'ECP384'
    'None'
    'PFS1'
    'PFS14'
    'PFS2'
    'PFS2048'
    'PFS24'
    'PFSMM'
  ]
  ```

### Parameter: `ipsecPolicies.saDataSizeKilobytes`

The IPSec Security Association payload size in KB for a site to site VPN tunnel.

- Required: Yes
- Type: int

### Parameter: `ipsecPolicies.saLifeTimeSeconds`

The IPSec Security Association lifetime in seconds for a site to site VPN tunnel.

- Required: Yes
- Type: int

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`localAddressRanges`](#parameter-trafficselectorpolicieslocaladdressranges) | array | A collection of local address spaces in CIDR format. |
| [`remoteAddressRanges`](#parameter-trafficselectorpoliciesremoteaddressranges) | array | A collection of remote address spaces in CIDR format. |

### Parameter: `trafficSelectorPolicies.localAddressRanges`

A collection of local address spaces in CIDR format.

- Required: Yes
- Type: array

### Parameter: `trafficSelectorPolicies.remoteAddressRanges`

A collection of remote address spaces in CIDR format.

- Required: Yes
- Type: array

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

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-vpnlinkconnectionsname) | string | The name of the VPN site link connection. |
| [`properties`](#parameter-vpnlinkconnectionsproperties) | object | Properties of the VPN site link connection. |

### Parameter: `vpnLinkConnections.name`

The name of the VPN site link connection.

- Required: No
- Type: string

### Parameter: `vpnLinkConnections.properties`

Properties of the VPN site link connection.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionBandwidth`](#parameter-vpnlinkconnectionspropertiesconnectionbandwidth) | int | Expected bandwidth in MBPS. |
| [`dpdTimeoutSeconds`](#parameter-vpnlinkconnectionspropertiesdpdtimeoutseconds) | int | Dead Peer Detection timeout in seconds for VPN link connection. |
| [`egressNatRules`](#parameter-vpnlinkconnectionspropertiesegressnatrules) | array | List of egress NAT rules. |
| [`enableBgp`](#parameter-vpnlinkconnectionspropertiesenablebgp) | bool | EnableBgp flag. |
| [`enableRateLimiting`](#parameter-vpnlinkconnectionspropertiesenableratelimiting) | bool | EnableBgp flag for rate limiting. |
| [`ingressNatRules`](#parameter-vpnlinkconnectionspropertiesingressnatrules) | array | List of ingress NAT rules. |
| [`ipsecPolicies`](#parameter-vpnlinkconnectionspropertiesipsecpolicies) | array | The IPSec Policies to be considered by this connection. |
| [`routingWeight`](#parameter-vpnlinkconnectionspropertiesroutingweight) | int | Routing weight for VPN connection. |
| [`sharedKey`](#parameter-vpnlinkconnectionspropertiessharedkey) | string | SharedKey for the VPN connection. |
| [`useLocalAzureIpAddress`](#parameter-vpnlinkconnectionspropertiesuselocalazureipaddress) | bool | Use local azure ip to initiate connection. |
| [`usePolicyBasedTrafficSelectors`](#parameter-vpnlinkconnectionspropertiesusepolicybasedtrafficselectors) | bool | Enable policy-based traffic selectors. |
| [`vpnConnectionProtocolType`](#parameter-vpnlinkconnectionspropertiesvpnconnectionprotocoltype) | string | Connection protocol used for this connection. |
| [`vpnGatewayCustomBgpAddresses`](#parameter-vpnlinkconnectionspropertiesvpngatewaycustombgpaddresses) | array | VPN gateway custom BGP addresses used by this connection. |
| [`vpnLinkConnectionMode`](#parameter-vpnlinkconnectionspropertiesvpnlinkconnectionmode) | string | VPN link connection mode. |
| [`vpnSiteLink`](#parameter-vpnlinkconnectionspropertiesvpnsitelink) | object | Id of the connected VPN site link. |

### Parameter: `vpnLinkConnections.properties.connectionBandwidth`

Expected bandwidth in MBPS.

- Required: No
- Type: int

### Parameter: `vpnLinkConnections.properties.dpdTimeoutSeconds`

Dead Peer Detection timeout in seconds for VPN link connection.

- Required: No
- Type: int

### Parameter: `vpnLinkConnections.properties.egressNatRules`

List of egress NAT rules.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-vpnlinkconnectionspropertiesegressnatrulesid) | string | Resource ID of the egress NAT rule. |

### Parameter: `vpnLinkConnections.properties.egressNatRules.id`

Resource ID of the egress NAT rule.

- Required: Yes
- Type: string

### Parameter: `vpnLinkConnections.properties.enableBgp`

EnableBgp flag.

- Required: No
- Type: bool

### Parameter: `vpnLinkConnections.properties.enableRateLimiting`

EnableBgp flag for rate limiting.

- Required: No
- Type: bool

### Parameter: `vpnLinkConnections.properties.ingressNatRules`

List of ingress NAT rules.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-vpnlinkconnectionspropertiesingressnatrulesid) | string | Resource ID of the ingress NAT rule. |

### Parameter: `vpnLinkConnections.properties.ingressNatRules.id`

Resource ID of the ingress NAT rule.

- Required: Yes
- Type: string

### Parameter: `vpnLinkConnections.properties.ipsecPolicies`

The IPSec Policies to be considered by this connection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dhGroup`](#parameter-vpnlinkconnectionspropertiesipsecpoliciesdhgroup) | string | The DH Group used in IKE Phase 1 for initial SA. |
| [`ikeEncryption`](#parameter-vpnlinkconnectionspropertiesipsecpoliciesikeencryption) | string | The IKE encryption algorithm (IKE phase 2). |
| [`ikeIntegrity`](#parameter-vpnlinkconnectionspropertiesipsecpoliciesikeintegrity) | string | The IKE integrity algorithm (IKE phase 2). |
| [`ipsecEncryption`](#parameter-vpnlinkconnectionspropertiesipsecpoliciesipsecencryption) | string | The IPSec encryption algorithm (IKE phase 1). |
| [`ipsecIntegrity`](#parameter-vpnlinkconnectionspropertiesipsecpoliciesipsecintegrity) | string | The IPSec integrity algorithm (IKE phase 1). |
| [`pfsGroup`](#parameter-vpnlinkconnectionspropertiesipsecpoliciespfsgroup) | string | The Pfs Group used in IKE Phase 2 for new child SA. |
| [`saDataSizeKilobytes`](#parameter-vpnlinkconnectionspropertiesipsecpoliciessadatasizekilobytes) | int | The IPSec Security Association payload size in KB for a site to site VPN tunnel. |
| [`saLifeTimeSeconds`](#parameter-vpnlinkconnectionspropertiesipsecpoliciessalifetimeseconds) | int | The IPSec Security Association lifetime in seconds for a site to site VPN tunnel. |

### Parameter: `vpnLinkConnections.properties.ipsecPolicies.dhGroup`

The DH Group used in IKE Phase 1 for initial SA.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'DHGroup1'
    'DHGroup14'
    'DHGroup2'
    'DHGroup2048'
    'DHGroup24'
    'ECP256'
    'ECP384'
    'None'
  ]
  ```

### Parameter: `vpnLinkConnections.properties.ipsecPolicies.ikeEncryption`

The IKE encryption algorithm (IKE phase 2).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AES128'
    'AES192'
    'AES256'
    'DES'
    'DES3'
    'GCMAES128'
    'GCMAES256'
  ]
  ```

### Parameter: `vpnLinkConnections.properties.ipsecPolicies.ikeIntegrity`

The IKE integrity algorithm (IKE phase 2).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'GCMAES128'
    'GCMAES256'
    'MD5'
    'SHA1'
    'SHA256'
    'SHA384'
  ]
  ```

### Parameter: `vpnLinkConnections.properties.ipsecPolicies.ipsecEncryption`

The IPSec encryption algorithm (IKE phase 1).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AES128'
    'AES192'
    'AES256'
    'DES'
    'DES3'
    'GCMAES128'
    'GCMAES192'
    'GCMAES256'
    'None'
  ]
  ```

### Parameter: `vpnLinkConnections.properties.ipsecPolicies.ipsecIntegrity`

The IPSec integrity algorithm (IKE phase 1).

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'GCMAES128'
    'GCMAES192'
    'GCMAES256'
    'MD5'
    'SHA1'
    'SHA256'
  ]
  ```

### Parameter: `vpnLinkConnections.properties.ipsecPolicies.pfsGroup`

The Pfs Group used in IKE Phase 2 for new child SA.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ECP256'
    'ECP384'
    'None'
    'PFS1'
    'PFS14'
    'PFS2'
    'PFS2048'
    'PFS24'
    'PFSMM'
  ]
  ```

### Parameter: `vpnLinkConnections.properties.ipsecPolicies.saDataSizeKilobytes`

The IPSec Security Association payload size in KB for a site to site VPN tunnel.

- Required: Yes
- Type: int

### Parameter: `vpnLinkConnections.properties.ipsecPolicies.saLifeTimeSeconds`

The IPSec Security Association lifetime in seconds for a site to site VPN tunnel.

- Required: Yes
- Type: int

### Parameter: `vpnLinkConnections.properties.routingWeight`

Routing weight for VPN connection.

- Required: No
- Type: int

### Parameter: `vpnLinkConnections.properties.sharedKey`

SharedKey for the VPN connection.

- Required: No
- Type: string

### Parameter: `vpnLinkConnections.properties.useLocalAzureIpAddress`

Use local azure ip to initiate connection.

- Required: No
- Type: bool

### Parameter: `vpnLinkConnections.properties.usePolicyBasedTrafficSelectors`

Enable policy-based traffic selectors.

- Required: No
- Type: bool

### Parameter: `vpnLinkConnections.properties.vpnConnectionProtocolType`

Connection protocol used for this connection.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IKEv1'
    'IKEv2'
  ]
  ```

### Parameter: `vpnLinkConnections.properties.vpnGatewayCustomBgpAddresses`

VPN gateway custom BGP addresses used by this connection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customBgpIpAddress`](#parameter-vpnlinkconnectionspropertiesvpngatewaycustombgpaddressescustombgpipaddress) | string | The custom BgpPeeringAddress which belongs to IpconfigurationId. |
| [`ipConfigurationId`](#parameter-vpnlinkconnectionspropertiesvpngatewaycustombgpaddressesipconfigurationid) | string | The IpconfigurationId of ipconfiguration which belongs to gateway. |

### Parameter: `vpnLinkConnections.properties.vpnGatewayCustomBgpAddresses.customBgpIpAddress`

The custom BgpPeeringAddress which belongs to IpconfigurationId.

- Required: Yes
- Type: string

### Parameter: `vpnLinkConnections.properties.vpnGatewayCustomBgpAddresses.ipConfigurationId`

The IpconfigurationId of ipconfiguration which belongs to gateway.

- Required: Yes
- Type: string

### Parameter: `vpnLinkConnections.properties.vpnLinkConnectionMode`

VPN link connection mode.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Default'
    'InitiatorOnly'
    'ResponderOnly'
  ]
  ```

### Parameter: `vpnLinkConnections.properties.vpnSiteLink`

Id of the connected VPN site link.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-vpnlinkconnectionspropertiesvpnsitelinkid) | string | Resource ID of the VPN site link. |

### Parameter: `vpnLinkConnections.properties.vpnSiteLink.id`

Resource ID of the VPN site link.

- Required: Yes
- Type: string

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
