# P2S VPN Gateway `[Microsoft.Network/p2svpnGateways]`

This module deploys a Virtual Hub P2S Gateway.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Network/p2svpnGateways` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-01-01/p2svpnGateways) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/p2s-vpn-gateway:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module p2sVpnGateway 'br/public:avm/res/network/p2s-vpn-gateway:<version>' = {
  name: 'p2sVpnGatewayDeployment'
  params: {
    // Required parameters
    name: 'npvgminp2sVpnGw'
    virtualHubResourceId: '<virtualHubResourceId>'
    // Non-required parameters
    associatedRouteTableName: 'defaultRouteTable'
    p2SConnectionConfigurationsName: 'p2sConnectionConfig1'
    vpnClientAddressPoolAddressPrefixes: [
      '10.0.2.0/24'
    ]
    vpnServerConfigurationResourceId: '<vpnServerConfigurationResourceId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "npvgminp2sVpnGw"
    },
    "virtualHubResourceId": {
      "value": "<virtualHubResourceId>"
    },
    // Non-required parameters
    "associatedRouteTableName": {
      "value": "defaultRouteTable"
    },
    "p2SConnectionConfigurationsName": {
      "value": "p2sConnectionConfig1"
    },
    "vpnClientAddressPoolAddressPrefixes": {
      "value": [
        "10.0.2.0/24"
      ]
    },
    "vpnServerConfigurationResourceId": {
      "value": "<vpnServerConfigurationResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/p2s-vpn-gateway:<version>'

// Required parameters
param name = 'npvgminp2sVpnGw'
param virtualHubResourceId = '<virtualHubResourceId>'
// Non-required parameters
param associatedRouteTableName = 'defaultRouteTable'
p2SConnectionConfigurationsName: 'p2sConnectionConfig1'
param vpnClientAddressPoolAddressPrefixes = [
  '10.0.2.0/24'
]
param vpnServerConfigurationResourceId = '<vpnServerConfigurationResourceId>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module p2sVpnGateway 'br/public:avm/res/network/p2s-vpn-gateway:<version>' = {
  name: 'p2sVpnGatewayDeployment'
  params: {
    // Required parameters
    name: 'npvgmaxp2sVpnGw'
    virtualHubResourceId: '<virtualHubResourceId>'
    // Non-required parameters
    associatedRouteTableName: 'noneRouteTable'
    customDnsServers: [
      '10.50.10.50'
      '10.50.50.50'
    ]
    enableInternetSecurity: false
    inboundRouteMapResourceId: '<inboundRouteMapResourceId>'
    isRoutingPreferenceInternet: false
    location: '<location>'
    outboundRouteMapResourceId: '<outboundRouteMapResourceId>'
    p2SConnectionConfigurationsName: 'p2sConnectionConfig'
    propagatedLabelNames: '<propagatedLabelNames>'
    propagatedRouteTableNames: [
      '<hubRouteTableName>'
    ]
    vpnClientAddressPoolAddressPrefixes: [
      '10.0.2.0/24'
      '10.0.3.0/24'
    ]
    vpnGatewayScaleUnit: 5
    vpnServerConfigurationResourceId: '<vpnServerConfigurationResourceId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "npvgmaxp2sVpnGw"
    },
    "virtualHubResourceId": {
      "value": "<virtualHubResourceId>"
    },
    // Non-required parameters
    "associatedRouteTableName": {
      "value": "noneRouteTable"
    },
    "customDnsServers": {
      "value": [
        "10.50.10.50",
        "10.50.50.50"
      ]
    },
    "enableInternetSecurity": {
      "value": false
    },
    "inboundRouteMapResourceId": {
      "value": "<inboundRouteMapResourceId>"
    },
    "isRoutingPreferenceInternet": {
      "value": false
    },
    "location": {
      "value": "<location>"
    },
    "outboundRouteMapResourceId": {
      "value": "<outboundRouteMapResourceId>"
    },
    "p2SConnectionConfigurationsName": {
      "value": "p2sConnectionConfig"
    },
    "propagatedLabelNames": {
      "value": "<propagatedLabelNames>"
    },
    "propagatedRouteTableNames": {
      "value": [
        "<hubRouteTableName>"
      ]
    },
    "vpnClientAddressPoolAddressPrefixes": {
      "value": [
        "10.0.2.0/24",
        "10.0.3.0/24"
      ]
    },
    "vpnGatewayScaleUnit": {
      "value": 5
    },
    "vpnServerConfigurationResourceId": {
      "value": "<vpnServerConfigurationResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/p2s-vpn-gateway:<version>'

// Required parameters
param name = 'npvgmaxp2sVpnGw'
param virtualHubResourceId = '<virtualHubResourceId>'
// Non-required parameters
param associatedRouteTableName = 'noneRouteTable'
param customDnsServers = [
  '10.50.10.50'
  '10.50.50.50'
]
param enableInternetSecurity = false
param inboundRouteMapResourceId = '<inboundRouteMapResourceId>'
param isRoutingPreferenceInternet = false
param location = '<location>'
param outboundRouteMapResourceId = '<outboundRouteMapResourceId>'
p2SConnectionConfigurationsName: 'p2sConnectionConfig'
param propagatedLabelNames = '<propagatedLabelNames>'
param propagatedRouteTableNames = [
  '<hubRouteTableName>'
]
param vpnClientAddressPoolAddressPrefixes = [
  '10.0.2.0/24'
  '10.0.3.0/24'
]
param vpnGatewayScaleUnit = 5
param vpnServerConfigurationResourceId = '<vpnServerConfigurationResourceId>'
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module p2sVpnGateway 'br/public:avm/res/network/p2s-vpn-gateway:<version>' = {
  name: 'p2sVpnGatewayDeployment'
  params: {
    // Required parameters
    name: 'npvgwafp2sVpnGw'
    virtualHubResourceId: '<virtualHubResourceId>'
    // Non-required parameters
    associatedRouteTableName: 'defaultRouteTable'
    enableInternetSecurity: true
    isRoutingPreferenceInternet: false
    location: '<location>'
    p2SConnectionConfigurationsName: 'p2sConnectionConfig1'
    tags: {
      Environment: 'Non-Prod'
      Role: 'DeploymentValidation'
    }
    vpnClientAddressPoolAddressPrefixes: [
      '10.0.2.0/24'
    ]
    vpnServerConfigurationResourceId: '<vpnServerConfigurationResourceId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "npvgwafp2sVpnGw"
    },
    "virtualHubResourceId": {
      "value": "<virtualHubResourceId>"
    },
    // Non-required parameters
    "associatedRouteTableName": {
      "value": "defaultRouteTable"
    },
    "enableInternetSecurity": {
      "value": true
    },
    "isRoutingPreferenceInternet": {
      "value": false
    },
    "location": {
      "value": "<location>"
    },
    "p2SConnectionConfigurationsName": {
      "value": "p2sConnectionConfig1"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "Role": "DeploymentValidation"
      }
    },
    "vpnClientAddressPoolAddressPrefixes": {
      "value": [
        "10.0.2.0/24"
      ]
    },
    "vpnServerConfigurationResourceId": {
      "value": "<vpnServerConfigurationResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/p2s-vpn-gateway:<version>'

// Required parameters
param name = 'npvgwafp2sVpnGw'
param virtualHubResourceId = '<virtualHubResourceId>'
// Non-required parameters
param associatedRouteTableName = 'defaultRouteTable'
param enableInternetSecurity = true
param isRoutingPreferenceInternet = false
param location = '<location>'
p2SConnectionConfigurationsName: 'p2sConnectionConfig1'
param tags = {
  Environment: 'Non-Prod'
  Role: 'DeploymentValidation'
}
param vpnClientAddressPoolAddressPrefixes = [
  '10.0.2.0/24'
]
param vpnServerConfigurationResourceId = '<vpnServerConfigurationResourceId>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the P2S VPN Gateway. |
| [`virtualHubResourceId`](#parameter-virtualhubresourceid) | string | The resource ID of the gateways virtual hub. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`associatedRouteTableName`](#parameter-associatedroutetablename) | string | The name of the associated route table. Required if deploying in a Secure Virtual Hub; cannot be a custom route table. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customDnsServers`](#parameter-customdnsservers) | array | The custom DNS servers for the P2S VPN Gateway. |
| [`enableInternetSecurity`](#parameter-enableinternetsecurity) | bool | Enable/Disable Internet Security; "Propagate Default Route". |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`inboundRouteMapResourceId`](#parameter-inboundroutemapresourceid) | string | The Resource ID of the inbound route map. |
| [`isRoutingPreferenceInternet`](#parameter-isroutingpreferenceinternet) | bool | The routing preference for the P2S VPN Gateway, Internet or Microsoft network. |
| [`location`](#parameter-location) | string | Location where all resources will be created. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`outboundRouteMapResourceId`](#parameter-outboundroutemapresourceid) | string | The Resource ID of the outbound route map. |
| [`p2SConnectionConfigurationsName`](#parameter-p2sconnectionconfigurationsname) | string | The name of the P2S Connection Configuration. |
| [`propagatedLabelNames`](#parameter-propagatedlabelnames) | array | The Labels to propagate routes to. |
| [`propagatedRouteTableNames`](#parameter-propagatedroutetablenames) | array | The names of the route tables to propagate to the P2S VPN Gateway. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`vnetRoutesStaticRoutes`](#parameter-vnetroutesstaticroutes) | object | The routes from the virtual hub to virtual network connections. |
| [`vpnClientAddressPoolAddressPrefixes`](#parameter-vpnclientaddresspooladdressprefixes) | array | The address prefixes for the VPN Client Address Pool. |
| [`vpnGatewayScaleUnit`](#parameter-vpngatewayscaleunit) | int | The scale unit of the VPN Gateway. |
| [`vpnServerConfigurationResourceId`](#parameter-vpnserverconfigurationresourceid) | string | The resource ID of the VPN Server Configuration. |

### Parameter: `name`

The name of the P2S VPN Gateway.

- Required: Yes
- Type: string

### Parameter: `virtualHubResourceId`

The resource ID of the gateways virtual hub.

- Required: Yes
- Type: string

### Parameter: `associatedRouteTableName`

The name of the associated route table. Required if deploying in a Secure Virtual Hub; cannot be a custom route table.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'defaultRouteTable'
    'noneRouteTable'
  ]
  ```

### Parameter: `customDnsServers`

The custom DNS servers for the P2S VPN Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableInternetSecurity`

Enable/Disable Internet Security; "Propagate Default Route".

- Required: No
- Type: bool

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `inboundRouteMapResourceId`

The Resource ID of the inbound route map.

- Required: No
- Type: string

### Parameter: `isRoutingPreferenceInternet`

The routing preference for the P2S VPN Gateway, Internet or Microsoft network.

- Required: No
- Type: bool

### Parameter: `location`

Location where all resources will be created.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `outboundRouteMapResourceId`

The Resource ID of the outbound route map.

- Required: No
- Type: string

### Parameter: `p2SConnectionConfigurationsName`

The name of the P2S Connection Configuration.

- Required: No
- Type: string

### Parameter: `propagatedLabelNames`

The Labels to propagate routes to.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `propagatedRouteTableNames`

The names of the route tables to propagate to the P2S VPN Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `vnetRoutesStaticRoutes`

The routes from the virtual hub to virtual network connections.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`staticRoutes`](#parameter-vnetroutesstaticroutesstaticroutes) | array | The static route configuration for the P2S VPN Gateway. |
| [`staticRoutesConfig`](#parameter-vnetroutesstaticroutesstaticroutesconfig) | object | The static route configuration for the P2S VPN Gateway. |

### Parameter: `vnetRoutesStaticRoutes.staticRoutes`

The static route configuration for the P2S VPN Gateway.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-vnetroutesstaticroutesstaticroutesaddressprefixes) | array | The address prefixes of the static route. |
| [`name`](#parameter-vnetroutesstaticroutesstaticroutesname) | string | The name of the static route. |
| [`nextHopIpAddress`](#parameter-vnetroutesstaticroutesstaticroutesnexthopipaddress) | string | The next hop IP of the static route. |

### Parameter: `vnetRoutesStaticRoutes.staticRoutes.addressPrefixes`

The address prefixes of the static route.

- Required: No
- Type: array

### Parameter: `vnetRoutesStaticRoutes.staticRoutes.name`

The name of the static route.

- Required: No
- Type: string

### Parameter: `vnetRoutesStaticRoutes.staticRoutes.nextHopIpAddress`

The next hop IP of the static route.

- Required: No
- Type: string

### Parameter: `vnetRoutesStaticRoutes.staticRoutesConfig`

The static route configuration for the P2S VPN Gateway.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`vnetLocalRouteOverrideCriteria`](#parameter-vnetroutesstaticroutesstaticroutesconfigvnetlocalrouteoverridecriteria) | string | Determines whether the NVA in a SPOKE VNET is bypassed for traffic with destination in spoke. |

### Parameter: `vnetRoutesStaticRoutes.staticRoutesConfig.vnetLocalRouteOverrideCriteria`

Determines whether the NVA in a SPOKE VNET is bypassed for traffic with destination in spoke.

- Required: No
- Type: string

### Parameter: `vpnClientAddressPoolAddressPrefixes`

The address prefixes for the VPN Client Address Pool.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `vpnGatewayScaleUnit`

The scale unit of the VPN Gateway.

- Required: No
- Type: int

### Parameter: `vpnServerConfigurationResourceId`

The resource ID of the VPN Server Configuration.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the user VPN configuration. |
| `resourceGroupName` | string | The name of the resource group the user VPN configuration was deployed into. |
| `resourceId` | string | The resource ID of the user VPN configuration. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
