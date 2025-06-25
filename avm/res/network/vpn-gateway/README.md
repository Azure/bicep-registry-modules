# VPN Gateways `[Microsoft.Network/vpnGateways]`

This module deploys a VPN Gateway.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Network/vpnGateways` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/vpnGateways) |
| `Microsoft.Network/vpnGateways/natRules` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/vpnGateways/natRules) |
| `Microsoft.Network/vpnGateways/vpnConnections` | [2024-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/vpnGateways/vpnConnections) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/vpn-gateway:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [Using NAT Rules](#example-3-using-nat-rules)
- [WAF-aligned](#example-4-waf-aligned)

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
      "value": "vpngmin001"
    },
    "virtualHubResourceId": {
      "value": "<virtualHubResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/vpn-gateway:<version>'

// Required parameters
param name = 'vpngmin001'
param virtualHubResourceId = '<virtualHubResourceId>'
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

<summary>via JSON parameters file</summary>

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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/vpn-gateway:<version>'

// Required parameters
param name = 'vpngmax001'
param virtualHubResourceId = '<virtualHubResourceId>'
// Non-required parameters
param bgpSettings = {
  asn: 65515
  peerWeight: 0
}
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param natRules = [
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
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param vpnConnections = [
  {
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
```

</details>
<p>

### Example 3: _Using NAT Rules_

This instance deploys the module using NAT rule.


<details>

<summary>via Bicep module</summary>

```bicep
module vpnGateway 'br/public:avm/res/network/vpn-gateway:<version>' = {
  name: 'vpnGatewayDeployment'
  params: {
    // Required parameters
    name: 'vpngnat001'
    virtualHubResourceId: '<virtualHubResourceId>'
    // Non-required parameters
    bgpSettings: {
      asn: 65515
      peerWeight: 0
    }
    enableTelemetry: true
    location: '<location>'
    natRules: [
      {
        externalMappings: [
          {
            addressSpace: '10.52.18.0/28'
          }
        ]
        internalMappings: [
          {
            addressSpace: '10.33.5.64/28'
          }
        ]
        mode: 'EgressSnat'
        name: 'testnatrule'
        type: 'Static'
      }
      {
        externalMappings: [
          {
            addressSpace: '192.168.100.0/24'
          }
        ]
        internalMappings: [
          {
            addressSpace: '10.10.10.0/24'
          }
        ]
        mode: 'IngressSnat'
        name: 'ingress-nat-rule'
        type: 'Static'
      }
    ]
    vpnConnections: [
      {
        enableBgp: false
        enableInternetSecurity: true
        enableRateLimiting: false
        name: 'test-connection-with-nat'
        remoteVpnSiteResourceId: '<remoteVpnSiteResourceId>'
        useLocalAzureIpAddress: false
        usePolicyBasedTrafficSelectors: false
        vpnConnectionProtocolType: 'IKEv2'
        vpnLinkConnections: [
          {
            name: 'link-connection-with-egress-nat'
            properties: {
              connectionBandwidth: 100
              egressNatRules: [
                {
                  id: '<id>'
                }
              ]
              enableBgp: false
              enableRateLimiting: false
              ingressNatRules: [
                {
                  id: '<id>'
                }
              ]
              routingWeight: 10
              usePolicyBasedTrafficSelectors: false
              vpnConnectionProtocolType: 'IKEv2'
              vpnLinkConnectionMode: 'Default'
              vpnSiteLink: {
                id: '<id>'
              }
            }
          }
        ]
      }
    ]
    vpnGatewayScaleUnit: 2
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
      "value": "vpngnat001"
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
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "natRules": {
      "value": [
        {
          "externalMappings": [
            {
              "addressSpace": "10.52.18.0/28"
            }
          ],
          "internalMappings": [
            {
              "addressSpace": "10.33.5.64/28"
            }
          ],
          "mode": "EgressSnat",
          "name": "testnatrule",
          "type": "Static"
        },
        {
          "externalMappings": [
            {
              "addressSpace": "192.168.100.0/24"
            }
          ],
          "internalMappings": [
            {
              "addressSpace": "10.10.10.0/24"
            }
          ],
          "mode": "IngressSnat",
          "name": "ingress-nat-rule",
          "type": "Static"
        }
      ]
    },
    "vpnConnections": {
      "value": [
        {
          "enableBgp": false,
          "enableInternetSecurity": true,
          "enableRateLimiting": false,
          "name": "test-connection-with-nat",
          "remoteVpnSiteResourceId": "<remoteVpnSiteResourceId>",
          "useLocalAzureIpAddress": false,
          "usePolicyBasedTrafficSelectors": false,
          "vpnConnectionProtocolType": "IKEv2",
          "vpnLinkConnections": [
            {
              "name": "link-connection-with-egress-nat",
              "properties": {
                "connectionBandwidth": 100,
                "egressNatRules": [
                  {
                    "id": "<id>"
                  }
                ],
                "enableBgp": false,
                "enableRateLimiting": false,
                "ingressNatRules": [
                  {
                    "id": "<id>"
                  }
                ],
                "routingWeight": 10,
                "usePolicyBasedTrafficSelectors": false,
                "vpnConnectionProtocolType": "IKEv2",
                "vpnLinkConnectionMode": "Default",
                "vpnSiteLink": {
                  "id": "<id>"
                }
              }
            }
          ]
        }
      ]
    },
    "vpnGatewayScaleUnit": {
      "value": 2
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/vpn-gateway:<version>'

// Required parameters
param name = 'vpngnat001'
param virtualHubResourceId = '<virtualHubResourceId>'
// Non-required parameters
param bgpSettings = {
  asn: 65515
  peerWeight: 0
}
param enableTelemetry = true
param location = '<location>'
param natRules = [
  {
    externalMappings: [
      {
        addressSpace: '10.52.18.0/28'
      }
    ]
    internalMappings: [
      {
        addressSpace: '10.33.5.64/28'
      }
    ]
    mode: 'EgressSnat'
    name: 'testnatrule'
    type: 'Static'
  }
  {
    externalMappings: [
      {
        addressSpace: '192.168.100.0/24'
      }
    ]
    internalMappings: [
      {
        addressSpace: '10.10.10.0/24'
      }
    ]
    mode: 'IngressSnat'
    name: 'ingress-nat-rule'
    type: 'Static'
  }
]
param vpnConnections = [
  {
    enableBgp: false
    enableInternetSecurity: true
    enableRateLimiting: false
    name: 'test-connection-with-nat'
    remoteVpnSiteResourceId: '<remoteVpnSiteResourceId>'
    useLocalAzureIpAddress: false
    usePolicyBasedTrafficSelectors: false
    vpnConnectionProtocolType: 'IKEv2'
    vpnLinkConnections: [
      {
        name: 'link-connection-with-egress-nat'
        properties: {
          connectionBandwidth: 100
          egressNatRules: [
            {
              id: '<id>'
            }
          ]
          enableBgp: false
          enableRateLimiting: false
          ingressNatRules: [
            {
              id: '<id>'
            }
          ]
          routingWeight: 10
          usePolicyBasedTrafficSelectors: false
          vpnConnectionProtocolType: 'IKEv2'
          vpnLinkConnectionMode: 'Default'
          vpnSiteLink: {
            id: '<id>'
          }
        }
      }
    ]
  }
]
param vpnGatewayScaleUnit = 2
```

</details>
<p>

### Example 4: _WAF-aligned_

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

<summary>via JSON parameters file</summary>

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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/vpn-gateway:<version>'

// Required parameters
param name = 'vpngwaf001'
param virtualHubResourceId = '<virtualHubResourceId>'
// Non-required parameters
param bgpSettings = {
  asn: 65515
  peerWeight: 0
}
param location = '<location>'
param natRules = [
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
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param vpnConnections = [
  {
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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`asn`](#parameter-bgpsettingsasn) | int | The BGP speaker's ASN (Autonomous System Number). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bgpPeeringAddresses`](#parameter-bgpsettingsbgppeeringaddresses) | array | BGP peering addresses for this VPN Gateway. |
| [`peerWeight`](#parameter-bgpsettingspeerweight) | int | The weight added to routes learned from this BGP speaker. |

### Parameter: `bgpSettings.asn`

The BGP speaker's ASN (Autonomous System Number).

- Required: Yes
- Type: int
- MinValue: 0
- MaxValue: 4294967295

### Parameter: `bgpSettings.bgpPeeringAddresses`

BGP peering addresses for this VPN Gateway.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customBgpIpAddresses`](#parameter-bgpsettingsbgppeeringaddressescustombgpipaddresses) | array | The custom BGP peering addresses. |
| [`ipconfigurationId`](#parameter-bgpsettingsbgppeeringaddressesipconfigurationid) | string | The IP configuration ID. |

### Parameter: `bgpSettings.bgpPeeringAddresses.customBgpIpAddresses`

The custom BGP peering addresses.

- Required: No
- Type: array

### Parameter: `bgpSettings.bgpPeeringAddresses.ipconfigurationId`

The IP configuration ID.

- Required: No
- Type: string

### Parameter: `bgpSettings.peerWeight`

The weight added to routes learned from this BGP speaker.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 100

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-natrulesname) | string | The name of the NAT rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`externalMappings`](#parameter-natrulesexternalmappings) | array | External mappings. |
| [`internalMappings`](#parameter-natrulesinternalmappings) | array | Internal mappings. |
| [`ipConfigurationId`](#parameter-natrulesipconfigurationid) | string | IP configuration ID. |
| [`mode`](#parameter-natrulesmode) | string | NAT rule mode. |
| [`type`](#parameter-natrulestype) | string | NAT rule type. |

### Parameter: `natRules.name`

The name of the NAT rule.

- Required: Yes
- Type: string

### Parameter: `natRules.externalMappings`

External mappings.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressSpace`](#parameter-natrulesexternalmappingsaddressspace) | string | Address space for VPN NAT rule mapping. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`portRange`](#parameter-natrulesexternalmappingsportrange) | string | Port range for VPN NAT rule mapping. |

### Parameter: `natRules.externalMappings.addressSpace`

Address space for VPN NAT rule mapping.

- Required: Yes
- Type: string

### Parameter: `natRules.externalMappings.portRange`

Port range for VPN NAT rule mapping.

- Required: No
- Type: string

### Parameter: `natRules.internalMappings`

Internal mappings.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressSpace`](#parameter-natrulesinternalmappingsaddressspace) | string | Address space for VPN NAT rule mapping. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`portRange`](#parameter-natrulesinternalmappingsportrange) | string | Port range for VPN NAT rule mapping. |

### Parameter: `natRules.internalMappings.addressSpace`

Address space for VPN NAT rule mapping.

- Required: Yes
- Type: string

### Parameter: `natRules.internalMappings.portRange`

Port range for VPN NAT rule mapping.

- Required: No
- Type: string

### Parameter: `natRules.ipConfigurationId`

IP configuration ID.

- Required: No
- Type: string

### Parameter: `natRules.mode`

NAT rule mode.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'EgressSnat'
    'IngressSnat'
  ]
  ```

### Parameter: `natRules.type`

NAT rule type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'Static'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `vpnConnections`

The VPN connections to create in the VPN gateway.

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-vpnconnectionsname) | string | The name of the VPN connection. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionBandwidth`](#parameter-vpnconnectionsconnectionbandwidth) | int | Connection bandwidth in MBPS. |
| [`enableBgp`](#parameter-vpnconnectionsenablebgp) | bool | Enable BGP flag. |
| [`enableInternetSecurity`](#parameter-vpnconnectionsenableinternetsecurity) | bool | Enable internet security. |
| [`enableRateLimiting`](#parameter-vpnconnectionsenableratelimiting) | bool | Enable rate limiting. |
| [`ipsecPolicies`](#parameter-vpnconnectionsipsecpolicies) | array | IPSec policies. |
| [`remoteVpnSiteResourceId`](#parameter-vpnconnectionsremotevpnsiteresourceid) | string | Remote VPN site resource ID. |
| [`routingConfiguration`](#parameter-vpnconnectionsroutingconfiguration) | object | Routing configuration. |
| [`routingWeight`](#parameter-vpnconnectionsroutingweight) | int | Routing weight. |
| [`sharedKey`](#parameter-vpnconnectionssharedkey) | string | Shared key. |
| [`trafficSelectorPolicies`](#parameter-vpnconnectionstrafficselectorpolicies) | array | Traffic selector policies. |
| [`useLocalAzureIpAddress`](#parameter-vpnconnectionsuselocalazureipaddress) | bool | Use local Azure IP address. |
| [`usePolicyBasedTrafficSelectors`](#parameter-vpnconnectionsusepolicybasedtrafficselectors) | bool | Use policy-based traffic selectors. |
| [`vpnConnectionProtocolType`](#parameter-vpnconnectionsvpnconnectionprotocoltype) | string | VPN connection protocol type. |
| [`vpnLinkConnections`](#parameter-vpnconnectionsvpnlinkconnections) | array | VPN link connections. |

### Parameter: `vpnConnections.name`

The name of the VPN connection.

- Required: Yes
- Type: string

### Parameter: `vpnConnections.connectionBandwidth`

Connection bandwidth in MBPS.

- Required: No
- Type: int

### Parameter: `vpnConnections.enableBgp`

Enable BGP flag.

- Required: No
- Type: bool

### Parameter: `vpnConnections.enableInternetSecurity`

Enable internet security.

- Required: No
- Type: bool

### Parameter: `vpnConnections.enableRateLimiting`

Enable rate limiting.

- Required: No
- Type: bool

### Parameter: `vpnConnections.ipsecPolicies`

IPSec policies.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dhGroup`](#parameter-vpnconnectionsipsecpoliciesdhgroup) | string | The DH Group used in IKE Phase 1 for initial SA. |
| [`ikeEncryption`](#parameter-vpnconnectionsipsecpoliciesikeencryption) | string | The IKE encryption algorithm (IKE phase 2). |
| [`ikeIntegrity`](#parameter-vpnconnectionsipsecpoliciesikeintegrity) | string | The IKE integrity algorithm (IKE phase 2). |
| [`ipsecEncryption`](#parameter-vpnconnectionsipsecpoliciesipsecencryption) | string | The IPSec encryption algorithm (IKE phase 1). |
| [`ipsecIntegrity`](#parameter-vpnconnectionsipsecpoliciesipsecintegrity) | string | The IPSec integrity algorithm (IKE phase 1). |
| [`pfsGroup`](#parameter-vpnconnectionsipsecpoliciespfsgroup) | string | The Pfs Group used in IKE Phase 2 for new child SA. |
| [`saDataSizeKilobytes`](#parameter-vpnconnectionsipsecpoliciessadatasizekilobytes) | int | The IPSec Security Association payload size in KB for a site to site VPN tunnel. |
| [`saLifeTimeSeconds`](#parameter-vpnconnectionsipsecpoliciessalifetimeseconds) | int | The IPSec Security Association lifetime in seconds for a site to site VPN tunnel. |

### Parameter: `vpnConnections.ipsecPolicies.dhGroup`

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

### Parameter: `vpnConnections.ipsecPolicies.ikeEncryption`

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

### Parameter: `vpnConnections.ipsecPolicies.ikeIntegrity`

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

### Parameter: `vpnConnections.ipsecPolicies.ipsecEncryption`

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

### Parameter: `vpnConnections.ipsecPolicies.ipsecIntegrity`

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

### Parameter: `vpnConnections.ipsecPolicies.pfsGroup`

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

### Parameter: `vpnConnections.ipsecPolicies.saDataSizeKilobytes`

The IPSec Security Association payload size in KB for a site to site VPN tunnel.

- Required: Yes
- Type: int

### Parameter: `vpnConnections.ipsecPolicies.saLifeTimeSeconds`

The IPSec Security Association lifetime in seconds for a site to site VPN tunnel.

- Required: Yes
- Type: int

### Parameter: `vpnConnections.remoteVpnSiteResourceId`

Remote VPN site resource ID.

- Required: No
- Type: string

### Parameter: `vpnConnections.routingConfiguration`

Routing configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`associatedRouteTable`](#parameter-vpnconnectionsroutingconfigurationassociatedroutetable) | object | The associated route table for this connection. |
| [`propagatedRouteTables`](#parameter-vpnconnectionsroutingconfigurationpropagatedroutetables) | object | The propagated route tables for this connection. |
| [`vnetRoutes`](#parameter-vpnconnectionsroutingconfigurationvnetroutes) | object | The virtual network routes for this connection. |

### Parameter: `vpnConnections.routingConfiguration.associatedRouteTable`

The associated route table for this connection.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-vpnconnectionsroutingconfigurationassociatedroutetableid) | string | The resource ID of the route table. |

### Parameter: `vpnConnections.routingConfiguration.associatedRouteTable.id`

The resource ID of the route table.

- Required: Yes
- Type: string

### Parameter: `vpnConnections.routingConfiguration.propagatedRouteTables`

The propagated route tables for this connection.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ids`](#parameter-vpnconnectionsroutingconfigurationpropagatedroutetablesids) | array | The list of route table resource IDs to propagate to. |
| [`labels`](#parameter-vpnconnectionsroutingconfigurationpropagatedroutetableslabels) | array | The list of labels to propagate to. |

### Parameter: `vpnConnections.routingConfiguration.propagatedRouteTables.ids`

The list of route table resource IDs to propagate to.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-vpnconnectionsroutingconfigurationpropagatedroutetablesidsid) | string | The resource ID of the route table. |

### Parameter: `vpnConnections.routingConfiguration.propagatedRouteTables.ids.id`

The resource ID of the route table.

- Required: Yes
- Type: string

### Parameter: `vpnConnections.routingConfiguration.propagatedRouteTables.labels`

The list of labels to propagate to.

- Required: No
- Type: array

### Parameter: `vpnConnections.routingConfiguration.vnetRoutes`

The virtual network routes for this connection.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`staticRoutes`](#parameter-vpnconnectionsroutingconfigurationvnetroutesstaticroutes) | array | The list of static routes. |
| [`staticRoutesConfig`](#parameter-vpnconnectionsroutingconfigurationvnetroutesstaticroutesconfig) | object | Static routes configuration. |

### Parameter: `vpnConnections.routingConfiguration.vnetRoutes.staticRoutes`

The list of static routes.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-vpnconnectionsroutingconfigurationvnetroutesstaticroutesaddressprefixes) | array | The address prefixes for the static route. |
| [`name`](#parameter-vpnconnectionsroutingconfigurationvnetroutesstaticroutesname) | string | The name of the static route. |
| [`nextHopIpAddress`](#parameter-vpnconnectionsroutingconfigurationvnetroutesstaticroutesnexthopipaddress) | string | The next hop IP address for the static route. |

### Parameter: `vpnConnections.routingConfiguration.vnetRoutes.staticRoutes.addressPrefixes`

The address prefixes for the static route.

- Required: No
- Type: array

### Parameter: `vpnConnections.routingConfiguration.vnetRoutes.staticRoutes.name`

The name of the static route.

- Required: No
- Type: string

### Parameter: `vpnConnections.routingConfiguration.vnetRoutes.staticRoutes.nextHopIpAddress`

The next hop IP address for the static route.

- Required: No
- Type: string

### Parameter: `vpnConnections.routingConfiguration.vnetRoutes.staticRoutesConfig`

Static routes configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`vnetLocalRouteOverrideCriteria`](#parameter-vpnconnectionsroutingconfigurationvnetroutesstaticroutesconfigvnetlocalrouteoverridecriteria) | string | Determines whether the NVA in a SPOKE VNET is bypassed for traffic with destination in spoke. |

### Parameter: `vpnConnections.routingConfiguration.vnetRoutes.staticRoutesConfig.vnetLocalRouteOverrideCriteria`

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

### Parameter: `vpnConnections.routingWeight`

Routing weight.

- Required: No
- Type: int

### Parameter: `vpnConnections.sharedKey`

Shared key.

- Required: No
- Type: string

### Parameter: `vpnConnections.trafficSelectorPolicies`

Traffic selector policies.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`localAddressRanges`](#parameter-vpnconnectionstrafficselectorpolicieslocaladdressranges) | array | A collection of local address spaces in CIDR format. |
| [`remoteAddressRanges`](#parameter-vpnconnectionstrafficselectorpoliciesremoteaddressranges) | array | A collection of remote address spaces in CIDR format. |

### Parameter: `vpnConnections.trafficSelectorPolicies.localAddressRanges`

A collection of local address spaces in CIDR format.

- Required: Yes
- Type: array

### Parameter: `vpnConnections.trafficSelectorPolicies.remoteAddressRanges`

A collection of remote address spaces in CIDR format.

- Required: Yes
- Type: array

### Parameter: `vpnConnections.useLocalAzureIpAddress`

Use local Azure IP address.

- Required: No
- Type: bool

### Parameter: `vpnConnections.usePolicyBasedTrafficSelectors`

Use policy-based traffic selectors.

- Required: No
- Type: bool

### Parameter: `vpnConnections.vpnConnectionProtocolType`

VPN connection protocol type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IKEv1'
    'IKEv2'
  ]
  ```

### Parameter: `vpnConnections.vpnLinkConnections`

VPN link connections.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-vpnconnectionsvpnlinkconnectionsname) | string | The name of the VPN site link connection. |
| [`properties`](#parameter-vpnconnectionsvpnlinkconnectionsproperties) | object | Properties of the VPN site link connection. |

### Parameter: `vpnConnections.vpnLinkConnections.name`

The name of the VPN site link connection.

- Required: No
- Type: string

### Parameter: `vpnConnections.vpnLinkConnections.properties`

Properties of the VPN site link connection.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`connectionBandwidth`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesconnectionbandwidth) | int | Expected bandwidth in MBPS. |
| [`dpdTimeoutSeconds`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesdpdtimeoutseconds) | int | Dead Peer Detection timeout in seconds for VPN link connection. |
| [`egressNatRules`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesegressnatrules) | array | List of egress NAT rules. |
| [`enableBgp`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesenablebgp) | bool | EnableBgp flag. |
| [`enableRateLimiting`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesenableratelimiting) | bool | EnableBgp flag for rate limiting. |
| [`ingressNatRules`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesingressnatrules) | array | List of ingress NAT rules. |
| [`ipsecPolicies`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesipsecpolicies) | array | The IPSec Policies to be considered by this connection. |
| [`routingWeight`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesroutingweight) | int | Routing weight for VPN connection. |
| [`sharedKey`](#parameter-vpnconnectionsvpnlinkconnectionspropertiessharedkey) | string | SharedKey for the VPN connection. |
| [`useLocalAzureIpAddress`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesuselocalazureipaddress) | bool | Use local azure ip to initiate connection. |
| [`usePolicyBasedTrafficSelectors`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesusepolicybasedtrafficselectors) | bool | Enable policy-based traffic selectors. |
| [`vpnConnectionProtocolType`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesvpnconnectionprotocoltype) | string | Connection protocol used for this connection. |
| [`vpnGatewayCustomBgpAddresses`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesvpngatewaycustombgpaddresses) | array | VPN gateway custom BGP addresses used by this connection. |
| [`vpnLinkConnectionMode`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesvpnlinkconnectionmode) | string | VPN link connection mode. |
| [`vpnSiteLink`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesvpnsitelink) | object | Id of the connected VPN site link. |

### Parameter: `vpnConnections.vpnLinkConnections.properties.connectionBandwidth`

Expected bandwidth in MBPS.

- Required: No
- Type: int

### Parameter: `vpnConnections.vpnLinkConnections.properties.dpdTimeoutSeconds`

Dead Peer Detection timeout in seconds for VPN link connection.

- Required: No
- Type: int

### Parameter: `vpnConnections.vpnLinkConnections.properties.egressNatRules`

List of egress NAT rules.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesegressnatrulesid) | string | Resource ID of the egress NAT rule. |

### Parameter: `vpnConnections.vpnLinkConnections.properties.egressNatRules.id`

Resource ID of the egress NAT rule.

- Required: Yes
- Type: string

### Parameter: `vpnConnections.vpnLinkConnections.properties.enableBgp`

EnableBgp flag.

- Required: No
- Type: bool

### Parameter: `vpnConnections.vpnLinkConnections.properties.enableRateLimiting`

EnableBgp flag for rate limiting.

- Required: No
- Type: bool

### Parameter: `vpnConnections.vpnLinkConnections.properties.ingressNatRules`

List of ingress NAT rules.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesingressnatrulesid) | string | Resource ID of the ingress NAT rule. |

### Parameter: `vpnConnections.vpnLinkConnections.properties.ingressNatRules.id`

Resource ID of the ingress NAT rule.

- Required: Yes
- Type: string

### Parameter: `vpnConnections.vpnLinkConnections.properties.ipsecPolicies`

The IPSec Policies to be considered by this connection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dhGroup`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesipsecpoliciesdhgroup) | string | The DH Group used in IKE Phase 1 for initial SA. |
| [`ikeEncryption`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesipsecpoliciesikeencryption) | string | The IKE encryption algorithm (IKE phase 2). |
| [`ikeIntegrity`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesipsecpoliciesikeintegrity) | string | The IKE integrity algorithm (IKE phase 2). |
| [`ipsecEncryption`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesipsecpoliciesipsecencryption) | string | The IPSec encryption algorithm (IKE phase 1). |
| [`ipsecIntegrity`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesipsecpoliciesipsecintegrity) | string | The IPSec integrity algorithm (IKE phase 1). |
| [`pfsGroup`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesipsecpoliciespfsgroup) | string | The Pfs Group used in IKE Phase 2 for new child SA. |
| [`saDataSizeKilobytes`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesipsecpoliciessadatasizekilobytes) | int | The IPSec Security Association payload size in KB for a site to site VPN tunnel. |
| [`saLifeTimeSeconds`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesipsecpoliciessalifetimeseconds) | int | The IPSec Security Association lifetime in seconds for a site to site VPN tunnel. |

### Parameter: `vpnConnections.vpnLinkConnections.properties.ipsecPolicies.dhGroup`

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

### Parameter: `vpnConnections.vpnLinkConnections.properties.ipsecPolicies.ikeEncryption`

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

### Parameter: `vpnConnections.vpnLinkConnections.properties.ipsecPolicies.ikeIntegrity`

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

### Parameter: `vpnConnections.vpnLinkConnections.properties.ipsecPolicies.ipsecEncryption`

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

### Parameter: `vpnConnections.vpnLinkConnections.properties.ipsecPolicies.ipsecIntegrity`

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

### Parameter: `vpnConnections.vpnLinkConnections.properties.ipsecPolicies.pfsGroup`

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

### Parameter: `vpnConnections.vpnLinkConnections.properties.ipsecPolicies.saDataSizeKilobytes`

The IPSec Security Association payload size in KB for a site to site VPN tunnel.

- Required: Yes
- Type: int

### Parameter: `vpnConnections.vpnLinkConnections.properties.ipsecPolicies.saLifeTimeSeconds`

The IPSec Security Association lifetime in seconds for a site to site VPN tunnel.

- Required: Yes
- Type: int

### Parameter: `vpnConnections.vpnLinkConnections.properties.routingWeight`

Routing weight for VPN connection.

- Required: No
- Type: int

### Parameter: `vpnConnections.vpnLinkConnections.properties.sharedKey`

SharedKey for the VPN connection.

- Required: No
- Type: string

### Parameter: `vpnConnections.vpnLinkConnections.properties.useLocalAzureIpAddress`

Use local azure ip to initiate connection.

- Required: No
- Type: bool

### Parameter: `vpnConnections.vpnLinkConnections.properties.usePolicyBasedTrafficSelectors`

Enable policy-based traffic selectors.

- Required: No
- Type: bool

### Parameter: `vpnConnections.vpnLinkConnections.properties.vpnConnectionProtocolType`

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

### Parameter: `vpnConnections.vpnLinkConnections.properties.vpnGatewayCustomBgpAddresses`

VPN gateway custom BGP addresses used by this connection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customBgpIpAddress`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesvpngatewaycustombgpaddressescustombgpipaddress) | string | The custom BgpPeeringAddress which belongs to IpconfigurationId. |
| [`ipConfigurationId`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesvpngatewaycustombgpaddressesipconfigurationid) | string | The IpconfigurationId of ipconfiguration which belongs to gateway. |

### Parameter: `vpnConnections.vpnLinkConnections.properties.vpnGatewayCustomBgpAddresses.customBgpIpAddress`

The custom BgpPeeringAddress which belongs to IpconfigurationId.

- Required: Yes
- Type: string

### Parameter: `vpnConnections.vpnLinkConnections.properties.vpnGatewayCustomBgpAddresses.ipConfigurationId`

The IpconfigurationId of ipconfiguration which belongs to gateway.

- Required: Yes
- Type: string

### Parameter: `vpnConnections.vpnLinkConnections.properties.vpnLinkConnectionMode`

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

### Parameter: `vpnConnections.vpnLinkConnections.properties.vpnSiteLink`

Id of the connected VPN site link.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-vpnconnectionsvpnlinkconnectionspropertiesvpnsitelinkid) | string | Resource ID of the VPN site link. |

### Parameter: `vpnConnections.vpnLinkConnections.properties.vpnSiteLink.id`

Resource ID of the VPN site link.

- Required: Yes
- Type: string

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
| `natRuleResourceIds` | array | The resource IDs of the NAT rules. |
| `resourceGroupName` | string | The name of the resource group the VPN gateway was deployed into. |
| `resourceId` | string | The resource ID of the VPN gateway. |
| `vpnConnectionResourceIds` | array | The resource IDs of the VPN connections. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

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
