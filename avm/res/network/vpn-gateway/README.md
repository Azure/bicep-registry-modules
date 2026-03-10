# VPN Gateways `[Microsoft.Network/vpnGateways]`

This module deploys a VPN Gateway.

You can reference the module as follows:
```bicep
module vpnGateway 'br/public:avm/res/network/vpn-gateway:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Network/vpnGateways` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_vpngateways.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/vpnGateways)</li></ul> |
| `Microsoft.Network/vpnGateways/natRules` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_vpngateways_natrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/vpnGateways/natRules)</li></ul> |
| `Microsoft.Network/vpnGateways/vpnConnections` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_vpngateways_vpnconnections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/vpnGateways/vpnConnections)</li></ul> |

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

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module vpnGateway 'br/public:avm/res/network/vpn-gateway:<version>' = {
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

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module vpnGateway 'br/public:avm/res/network/vpn-gateway:<version>' = {
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

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/nat-rule]


<details>

<summary>via Bicep module</summary>

```bicep
module vpnGateway 'br/public:avm/res/network/vpn-gateway:<version>' = {
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

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module vpnGateway 'br/public:avm/res/network/vpn-gateway:<version>' = {
  params: {
    // Required parameters
    name: 'vpngwaf001'
    virtualHubResourceId: '<virtualHubResourceId>'
    // Non-required parameters
    bgpSettings: {
      asn: 65515
      peerWeight: 0
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
| [`bgpSettings`](#parameter-bgpsettings) | object | BGP settings details. You can specify either bgpPeeringAddress (for custom IPs outside APIPA ranges) OR bgpPeeringAddresses (for APIPA ranges 169.254.21.*/169.254.22.*), but not both simultaneously. |
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

BGP settings details. You can specify either bgpPeeringAddress (for custom IPs outside APIPA ranges) OR bgpPeeringAddresses (for APIPA ranges 169.254.21.*/169.254.22.*), but not both simultaneously.

- Required: No
- Type: object

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
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

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

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `natRules`

List of all the NAT Rules to associate with the gateway.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-natrulesname) | string | The name of the NAT rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`externalMappings`](#parameter-natrulesexternalmappings) | array | External mappings. |
| [`internalMappings`](#parameter-natrulesinternalmappings) | array | An address prefix range of source IPs on the inside network that will be mapped to a set of external IPs. In other words, your pre-NAT address prefix range. |
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

### Parameter: `natRules.internalMappings`

An address prefix range of source IPs on the inside network that will be mapped to a set of external IPs. In other words, your pre-NAT address prefix range.

- Required: No
- Type: array

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
| [`ipsecPolicies`](#parameter-vpnconnectionsipsecpolicies) | array | The IPSec policies to be considered by this connection. |
| [`remoteVpnSiteResourceId`](#parameter-vpnconnectionsremotevpnsiteresourceid) | string | Remote VPN site resource ID. |
| [`routingConfiguration`](#parameter-vpnconnectionsroutingconfiguration) | object | Routing configuration indicating the associated and propagated route tables for this connection. |
| [`routingWeight`](#parameter-vpnconnectionsroutingweight) | int | Routing weight. |
| [`sharedKey`](#parameter-vpnconnectionssharedkey) | securestring | Shared key. |
| [`trafficSelectorPolicies`](#parameter-vpnconnectionstrafficselectorpolicies) | array | The traffic selector policies to be considered by this connection. |
| [`useLocalAzureIpAddress`](#parameter-vpnconnectionsuselocalazureipaddress) | bool | Use local Azure IP address. |
| [`usePolicyBasedTrafficSelectors`](#parameter-vpnconnectionsusepolicybasedtrafficselectors) | bool | Use policy-based traffic selectors. |
| [`vpnConnectionProtocolType`](#parameter-vpnconnectionsvpnconnectionprotocoltype) | string | VPN connection protocol type. |
| [`vpnLinkConnections`](#parameter-vpnconnectionsvpnlinkconnections) | array | List of all VPN site link connections to the gateway. |

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

The IPSec policies to be considered by this connection.

- Required: No
- Type: array

### Parameter: `vpnConnections.remoteVpnSiteResourceId`

Remote VPN site resource ID.

- Required: No
- Type: string

### Parameter: `vpnConnections.routingConfiguration`

Routing configuration indicating the associated and propagated route tables for this connection.

- Required: No
- Type: object

### Parameter: `vpnConnections.routingWeight`

Routing weight.

- Required: No
- Type: int

### Parameter: `vpnConnections.sharedKey`

Shared key.

- Required: No
- Type: securestring

### Parameter: `vpnConnections.trafficSelectorPolicies`

The traffic selector policies to be considered by this connection.

- Required: No
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

List of all VPN site link connections to the gateway.

- Required: No
- Type: array

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
| `br/public:avm/utl/types/avm-common-types:0.7.0` | Remote reference |

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

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
