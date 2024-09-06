# VPN Gateways `[Microsoft.Network/vpnGateways]`

This module deploys a VPN Gateway.

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
| `Microsoft.Network/vpnGateways` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/vpnGateways) |
| `Microsoft.Network/vpnGateways/natRules` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/vpnGateways/natRules) |
| `Microsoft.Network/vpnGateways/vpnConnections` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/vpnGateways/vpnConnections) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/vpn-gateway:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module vpnGateway 'br/public:avm/res/network/vpn-gateway:<version>' = {
  name: 'vpnGatewayDeployment'
  params: {
    // Required parameters
    name: 'vpngmin001'
    virtualHubResourceId: '<virtualHubResourceId>'
    // Non-required parameters
    location: '<location>'
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
      "value": "vpngmin001"
    },
    "virtualHubResourceId": {
      "value": "<virtualHubResourceId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
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
module vpnGateway 'br/public:avm/res/network/vpn-gateway:<version>' = {
  name: 'vpnGatewayDeployment'
  params: {
    // Required parameters
    name: 'vpngmax001'
    virtualHubResourceId: '<virtualHubResourceId>'
    // Non-required parameters
    bgpSettings: {
      asn: 65515
      peerWeight: 0
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    natRules: [
      {
        externalMappings: [
          {
            addressSpace: '192.168.21.0/24'
          }
        ]
        internalMappings: [
          {
            addressSpace: '10.4.0.0/24'
          }
        ]
        mode: 'EgressSnat'
        name: 'natRule1'
        type: 'Static'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vpnConnections: [
      {
        connectionBandwidth: 100
        enableBgp: false
        enableInternetSecurity: true
        enableRateLimiting: false
        name: '<name>'
        remoteVpnSiteResourceId: '<remoteVpnSiteResourceId>'
        routingWeight: 0
        useLocalAzureIpAddress: false
        usePolicyBasedTrafficSelectors: false
        vpnConnectionProtocolType: 'IKEv2'
      }
    ]
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
      "value": "vpngmax001"
    },
    "virtualHubResourceId": {
      "value": "<virtualHubResourceId>"
    },
    // Non-required parameters
    "bgpSettings": {
      "value": {
        "asn": 65515,
        "peerWeight": 0
      }
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
    "natRules": {
      "value": [
        {
          "externalMappings": [
            {
              "addressSpace": "192.168.21.0/24"
            }
          ],
          "internalMappings": [
            {
              "addressSpace": "10.4.0.0/24"
            }
          ],
          "mode": "EgressSnat",
          "name": "natRule1",
          "type": "Static"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vpnConnections": {
      "value": [
        {
          "connectionBandwidth": 100,
          "enableBgp": false,
          "enableInternetSecurity": true,
          "enableRateLimiting": false,
          "name": "<name>",
          "remoteVpnSiteResourceId": "<remoteVpnSiteResourceId>",
          "routingWeight": 0,
          "useLocalAzureIpAddress": false,
          "usePolicyBasedTrafficSelectors": false,
          "vpnConnectionProtocolType": "IKEv2"
        }
      ]
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
module vpnGateway 'br/public:avm/res/network/vpn-gateway:<version>' = {
  name: 'vpnGatewayDeployment'
  params: {
    // Required parameters
    name: 'vpngwaf001'
    virtualHubResourceId: '<virtualHubResourceId>'
    // Non-required parameters
    bgpSettings: {
      asn: 65515
      peerWeight: 0
    }
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    natRules: [
      {
        externalMappings: [
          {
            addressSpace: '192.168.21.0/24'
          }
        ]
        internalMappings: [
          {
            addressSpace: '10.4.0.0/24'
          }
        ]
        mode: 'EgressSnat'
        name: 'natRule1'
        type: 'Static'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vpnConnections: [
      {
        connectionBandwidth: 100
        enableBgp: false
        enableInternetSecurity: true
        enableRateLimiting: false
        name: '<name>'
        remoteVpnSiteResourceId: '<remoteVpnSiteResourceId>'
        routingWeight: 0
        useLocalAzureIpAddress: false
        usePolicyBasedTrafficSelectors: false
        vpnConnectionProtocolType: 'IKEv2'
      }
    ]
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
      "value": "vpngwaf001"
    },
    "virtualHubResourceId": {
      "value": "<virtualHubResourceId>"
    },
    // Non-required parameters
    "bgpSettings": {
      "value": {
        "asn": 65515,
        "peerWeight": 0
      }
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
    "natRules": {
      "value": [
        {
          "externalMappings": [
            {
              "addressSpace": "192.168.21.0/24"
            }
          ],
          "internalMappings": [
            {
              "addressSpace": "10.4.0.0/24"
            }
          ],
          "mode": "EgressSnat",
          "name": "natRule1",
          "type": "Static"
        }
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vpnConnections": {
      "value": [
        {
          "connectionBandwidth": 100,
          "enableBgp": false,
          "enableInternetSecurity": true,
          "enableRateLimiting": false,
          "name": "<name>",
          "remoteVpnSiteResourceId": "<remoteVpnSiteResourceId>",
          "routingWeight": 0,
          "useLocalAzureIpAddress": false,
          "usePolicyBasedTrafficSelectors": false,
          "vpnConnectionProtocolType": "IKEv2"
        }
      ]
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
| [`name`](#parameter-name) | string | Name of the VPN gateway. |
| [`virtualHubResourceId`](#parameter-virtualhubresourceid) | string | The resource ID of a virtual Hub to connect to. Note: The virtual Hub and Gateway must be deployed into the same location. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bgpSettings`](#parameter-bgpsettings) | object | BGP settings details. |
| [`enableBgpRouteTranslationForNat`](#parameter-enablebgproutetranslationfornat) | bool | Enable BGP routes translation for NAT on this VPN gateway. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`isRoutingPreferenceInternet`](#parameter-isroutingpreferenceinternet) | bool | Enable routing preference property for the public IP interface of the VPN gateway. |
| [`location`](#parameter-location) | string | Location where all resources will be created. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`natRules`](#parameter-natrules) | array | List of all the NAT Rules to associate with the gateway. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`vpnConnections`](#parameter-vpnconnections) | array | The VPN connections to create in the VPN gateway. |
| [`vpnGatewayScaleUnit`](#parameter-vpngatewayscaleunit) | int | The scale unit for this VPN gateway. |

### Parameter: `name`

Name of the VPN gateway.

- Required: Yes
- Type: string

### Parameter: `virtualHubResourceId`

The resource ID of a virtual Hub to connect to. Note: The virtual Hub and Gateway must be deployed into the same location.

- Required: Yes
- Type: string

### Parameter: `bgpSettings`

BGP settings details.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `enableBgpRouteTranslationForNat`

Enable BGP routes translation for NAT on this VPN gateway.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `isRoutingPreferenceInternet`

Enable routing preference property for the public IP interface of the VPN gateway.

- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `natRules`

List of all the NAT Rules to associate with the gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `vpnConnections`

The VPN connections to create in the VPN gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `vpnGatewayScaleUnit`

The scale unit for this VPN gateway.

- Required: No
- Type: int
- Default: `2`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the VPN gateway. |
| `resourceGroupName` | string | The name of the resource group the VPN gateway was deployed into. |
| `resourceId` | string | The resource ID of the VPN gateway. |

## Notes

### Parameter Usage: `bgpSettings`

<details>

<summary>Parameter JSON format</summary>

```json
"bgpSettings": {
    "asn": 65515,
    "peerWeight": 0,
    "bgpPeeringAddresses": [
        {
            "ipconfigurationId": "Instance0",
            "defaultBgpIpAddresses": [
                "10.0.0.12"
            ],
            "customBgpIpAddresses": [],
            "tunnelIpAddresses": [
                "20.84.35.53",
                "10.0.0.4"
            ]
        },
        {
            "ipconfigurationId": "Instance1",
            "defaultBgpIpAddresses": [
                "10.0.0.13"
            ],
            "customBgpIpAddresses": [],
            "tunnelIpAddresses": [
                "20.84.34.225",
                "10.0.0.5"
            ]
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
bgpSettings: {
    asn: 65515
    peerWeight: 0
    bgpPeeringAddresses: [
        {
            ipconfigurationId: 'Instance0'
            defaultBgpIpAddresses: [
                '10.0.0.12'
            ]
            customBgpIpAddresses: []
            tunnelIpAddresses: [
                '20.84.35.53'
                '10.0.0.4'
            ]
        }
        {
            ipconfigurationId: 'Instance1'
            defaultBgpIpAddresses: [
                '10.0.0.13'
            ]
            customBgpIpAddresses: []
            tunnelIpAddresses: [
                '20.84.34.225'
                '10.0.0.5'
            ]
        }
    ]
}
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
