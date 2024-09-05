# Virtual Network Gateway Connections `[Microsoft.Network/connections]`

This module deploys a Virtual Network Gateway Connection.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Network/connections` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/connections) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/connection:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module connection 'br/public:avm/res/network/connection:<version>' = {
  name: 'connectionDeployment'
  params: {
    // Required parameters
    name: 'ncmin001'
    virtualNetworkGateway1: {
      id: '<id>'
    }
    // Non-required parameters
    connectionType: 'Vnet2Vnet'
    location: '<location>'
    virtualNetworkGateway2: {
      id: '<id>'
    }
    vpnSharedKey: '<vpnSharedKey>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "ncmin001"
    },
    "virtualNetworkGateway1": {
      "value": {
        "id": "<id>"
      }
    },
    // Non-required parameters
    "connectionType": {
      "value": "Vnet2Vnet"
    },
    "location": {
      "value": "<location>"
    },
    "virtualNetworkGateway2": {
      "value": {
        "id": "<id>"
      }
    },
    "vpnSharedKey": {
      "value": "<vpnSharedKey>"
    }
  }
}
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module connection 'br/public:avm/res/network/connection:<version>' = {
  name: 'connectionDeployment'
  params: {
    // Required parameters
    name: 'ncmax001'
    virtualNetworkGateway1: {
      id: '<id>'
    }
    // Non-required parameters
    connectionType: 'Vnet2Vnet'
    dpdTimeoutSeconds: 45
    enableBgp: false
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    usePolicyBasedTrafficSelectors: false
    virtualNetworkGateway2: {
      id: '<id>'
    }
    vpnSharedKey: '<vpnSharedKey>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "ncmax001"
    },
    "virtualNetworkGateway1": {
      "value": {
        "id": "<id>"
      }
    },
    // Non-required parameters
    "connectionType": {
      "value": "Vnet2Vnet"
    },
    "dpdTimeoutSeconds": {
      "value": 45
    },
    "enableBgp": {
      "value": false
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "usePolicyBasedTrafficSelectors": {
      "value": false
    },
    "virtualNetworkGateway2": {
      "value": {
        "id": "<id>"
      }
    },
    "vpnSharedKey": {
      "value": "<vpnSharedKey>"
    }
  }
}
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module connection 'br/public:avm/res/network/connection:<version>' = {
  name: 'connectionDeployment'
  params: {
    // Required parameters
    name: 'ncwaf001'
    virtualNetworkGateway1: {
      id: '<id>'
    }
    // Non-required parameters
    connectionType: 'Vnet2Vnet'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    virtualNetworkGateway2: {
      id: '<id>'
    }
    vpnSharedKey: '<vpnSharedKey>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "ncwaf001"
    },
    "virtualNetworkGateway1": {
      "value": {
        "id": "<id>"
      }
    },
    // Non-required parameters
    "connectionType": {
      "value": "Vnet2Vnet"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "virtualNetworkGateway2": {
      "value": {
        "id": "<id>"
      }
    },
    "vpnSharedKey": {
      "value": "<vpnSharedKey>"
    }
  }
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Remote connection name. |
| [`virtualNetworkGateway1`](#parameter-virtualnetworkgateway1) | object | The primary Virtual Network Gateway. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationKey`](#parameter-authorizationkey) | securestring | The Authorization Key to connect to an Express Route Circuit. Used for connection type [ExpressRoute]. |
| [`connectionMode`](#parameter-connectionmode) | string | The connection connectionMode for this connection. Available for IPSec connections. |
| [`connectionProtocol`](#parameter-connectionprotocol) | string | Connection connectionProtocol used for this connection. Available for IPSec connections. |
| [`connectionType`](#parameter-connectiontype) | string | Gateway connection connectionType. |
| [`customIPSecPolicy`](#parameter-customipsecpolicy) | object | The IPSec Policies to be considered by this connection. |
| [`dpdTimeoutSeconds`](#parameter-dpdtimeoutseconds) | int | The dead peer detection timeout of this connection in seconds. Setting the timeout to shorter periods will cause IKE to rekey more aggressively, causing the connection to appear to be disconnected in some instances. The general recommendation is to set the timeout between 30 to 45 seconds. |
| [`enableBgp`](#parameter-enablebgp) | bool | Value to specify if BGP is enabled or not. |
| [`enablePrivateLinkFastPath`](#parameter-enableprivatelinkfastpath) | bool | Bypass the ExpressRoute gateway when accessing private-links. ExpressRoute FastPath (expressRouteGatewayBypass) must be enabled. Only available when connection connectionType is Express Route. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`expressRouteGatewayBypass`](#parameter-expressroutegatewaybypass) | bool | Bypass ExpressRoute Gateway for data forwarding. Only available when connection connectionType is Express Route. |
| [`localNetworkGateway2`](#parameter-localnetworkgateway2) | object | The local network gateway. Used for connection type [IPsec]. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`peer`](#parameter-peer) | object | The remote peer. Used for connection connectionType [ExpressRoute]. |
| [`routingWeight`](#parameter-routingweight) | int | The weight added to routes learned from this BGP speaker. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`trafficSelectorPolicies`](#parameter-trafficselectorpolicies) | array | The traffic selector policies to be considered by this connection. |
| [`useLocalAzureIpAddress`](#parameter-uselocalazureipaddress) | bool | Use private local Azure IP for the connection. Only available for IPSec Virtual Network Gateways that use the Azure Private IP Property. |
| [`usePolicyBasedTrafficSelectors`](#parameter-usepolicybasedtrafficselectors) | bool | Enable policy-based traffic selectors. |
| [`virtualNetworkGateway2`](#parameter-virtualnetworkgateway2) | object | The remote Virtual Network Gateway. Used for connection connectionType [Vnet2Vnet]. |
| [`vpnSharedKey`](#parameter-vpnsharedkey) | securestring | Specifies a VPN shared key. The same value has to be specified on both Virtual Network Gateways. |

### Parameter: `name`

Remote connection name.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkGateway1`

The primary Virtual Network Gateway.

- Required: Yes
- Type: object

### Parameter: `authorizationKey`

The Authorization Key to connect to an Express Route Circuit. Used for connection type [ExpressRoute].

- Required: No
- Type: securestring
- Default: `''`

### Parameter: `connectionMode`

The connection connectionMode for this connection. Available for IPSec connections.

- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Default'
    'InitiatorOnly'
    'ResponderOnly'
  ]
  ```

### Parameter: `connectionProtocol`

Connection connectionProtocol used for this connection. Available for IPSec connections.

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

### Parameter: `connectionType`

Gateway connection connectionType.

- Required: No
- Type: string
- Default: `'IPsec'`
- Allowed:
  ```Bicep
  [
    'ExpressRoute'
    'IPsec'
    'Vnet2Vnet'
    'VPNClient'
  ]
  ```

### Parameter: `customIPSecPolicy`

The IPSec Policies to be considered by this connection.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      dhGroup: ''
      ikeEncryption: ''
      ikeIntegrity: ''
      ipsecEncryption: ''
      ipsecIntegrity: ''
      pfsGroup: ''
      saDataSizeKilobytes: 0
      saLifeTimeSeconds: 0
  }
  ```

### Parameter: `dpdTimeoutSeconds`

The dead peer detection timeout of this connection in seconds. Setting the timeout to shorter periods will cause IKE to rekey more aggressively, causing the connection to appear to be disconnected in some instances. The general recommendation is to set the timeout between 30 to 45 seconds.

- Required: No
- Type: int
- Default: `45`

### Parameter: `enableBgp`

Value to specify if BGP is enabled or not.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePrivateLinkFastPath`

Bypass the ExpressRoute gateway when accessing private-links. ExpressRoute FastPath (expressRouteGatewayBypass) must be enabled. Only available when connection connectionType is Express Route.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `expressRouteGatewayBypass`

Bypass ExpressRoute Gateway for data forwarding. Only available when connection connectionType is Express Route.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `localNetworkGateway2`

The local network gateway. Used for connection type [IPsec].

- Required: No
- Type: object
- Default: `{}`

### Parameter: `location`

Location for all resources.

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

### Parameter: `peer`

The remote peer. Used for connection connectionType [ExpressRoute].

- Required: No
- Type: object
- Default: `{}`

### Parameter: `routingWeight`

The weight added to routes learned from this BGP speaker.

- Required: No
- Type: int

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `trafficSelectorPolicies`

The traffic selector policies to be considered by this connection.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `useLocalAzureIpAddress`

Use private local Azure IP for the connection. Only available for IPSec Virtual Network Gateways that use the Azure Private IP Property.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `usePolicyBasedTrafficSelectors`

Enable policy-based traffic selectors.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `virtualNetworkGateway2`

The remote Virtual Network Gateway. Used for connection connectionType [Vnet2Vnet].

- Required: No
- Type: object
- Default: `{}`

### Parameter: `vpnSharedKey`

Specifies a VPN shared key. The same value has to be specified on both Virtual Network Gateways.

- Required: No
- Type: securestring
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the remote connection. |
| `resourceGroupName` | string | The resource group the remote connection was deployed into. |
| `resourceId` | string | The resource ID of the remote connection. |

## Notes

### Parameter Usage: `localNetworkGateway2`

The local virtual network gateway object.

<details>

<summary>Parameter JSON format</summary>

```json
"localNetworkGateway2": {
    "value": {
        "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/localNetworkGateways/myGateway"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
localNetworkGateway2: {
    id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/localNetworkGateways/myGateway'
}
```

</details>
<p>

### Parameter Usage: `peer`

The remote peer object used for ExpressRoute connections

<details>

<summary>Parameter JSON format</summary>

```json
"peer": {
    "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/expressRouteCircuits/expressRoute"
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
'peer': {
    id: '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myRG/providers/Microsoft.Network/expressRouteCircuits/expressRoute'
}
```

</details>
<p>

### Parameter Usage: `customIPSecPolicy`

If ipsecEncryption parameter is empty, customIPSecPolicy will not be deployed. The parameter file should look like below.

<details>

<summary>Parameter JSON format</summary>

```json
"customIPSecPolicy": {
    "value": {
        "saLifeTimeSeconds": 0,
        "saDataSizeKilobytes": 0,
        "ipsecEncryption": "",
        "ipsecIntegrity": "",
        "ikeEncryption": "",
        "ikeIntegrity": "",
        "dhGroup": "",
        "pfsGroup": ""
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
customIPSecPolicy: {
    saLifeTimeSeconds: 0
    saDataSizeKilobytes: 0
    ipsecEncryption: ''
    ipsecIntegrity: ''
    ikeEncryption: ''
    ikeIntegrity: ''
    dhGroup: ''
    pfsGroup: ''
}
```

</details>
<p>

Format of the full customIPSecPolicy parameter in parameter file.

<details>

<summary>Parameter JSON format</summary>

```json
"customIPSecPolicy": {
    "value": {
        "saLifeTimeSeconds": 28800,
        "saDataSizeKilobytes": 102400000,
        "ipsecEncryption": "AES256",
        "ipsecIntegrity": "SHA256",
        "ikeEncryption": "AES256",
        "ikeIntegrity": "SHA256",
        "dhGroup": "DHGroup14",
        "pfsGroup": "None"
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
customIPSecPolicy: {
    saLifeTimeSeconds: 28800
    saDataSizeKilobytes: 102400000
    ipsecEncryption: 'AES256'
    ipsecIntegrity: 'SHA256'
    ikeEncryption: 'AES256'
    ikeIntegrity: 'SHA256'
    dhGroup: 'DHGroup14'
    pfsGroup: 'None'
}
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
