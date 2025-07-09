# Virtual Network Gateways `[Microsoft.Network/virtualNetworkGateways]`

This module deploys a Virtual Network Gateway.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/publicIPAddresses` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/publicIPAddresses) |
| `Microsoft.Network/virtualNetworkGateways` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworkGateways) |
| `Microsoft.Network/virtualNetworkGateways/natRules` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualNetworkGateways/natRules) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/virtual-network-gateway:<version>`.

- [VPN Active Active with BGP settings](#example-1-vpn-active-active-with-bgp-settings)
- [VPN Active Active with BGP settings](#example-2-vpn-active-active-with-bgp-settings)
- [VPN Active Active without BGP settings using two existent Public IPs](#example-3-vpn-active-active-without-bgp-settings-using-two-existent-public-ips)
- [VPN Active Active without BGP settings](#example-4-vpn-active-active-without-bgp-settings)
- [VPN Active Passive with BGP settings](#example-5-vpn-active-passive-with-bgp-settings)
- [VPN Active Passive with BGP settings using existing Public IP](#example-6-vpn-active-passive-with-bgp-settings-using-existing-public-ip)
- [VPN Active Passive without BGP settings](#example-7-vpn-active-passive-without-bgp-settings)
- [Custom Routes](#example-8-custom-routes)
- [Using only defaults](#example-9-using-only-defaults)
- [ExpressRoute](#example-10-expressroute)
- [Using large parameter set](#example-11-using-large-parameter-set)
- [Using SKU without Availability Zones](#example-12-using-sku-without-availability-zones)
- [VPN](#example-13-vpn)
- [WAF-aligned](#example-14-waf-aligned)

### Example 1: _VPN Active Active with BGP settings_

This instance deploys the module with the VPN Active Active with BGP settings.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      clusterMode: 'activeActiveBgp'
    }
    gatewayType: 'Vpn'
    name: 'nvgaab001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgaab'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayResourceId: '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
    publicIpZones: [
      1
      2
      3
    ]
    skuName: 'VpnGw2AZ'
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
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
    "clusterSettings": {
      "value": {
        "clusterMode": "activeActiveBgp"
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgaab001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "allowRemoteVnetTraffic": {
      "value": true
    },
    "disableIPSecReplayProtection": {
      "value": true
    },
    "domainNameLabel": {
      "value": [
        "dm-nvgaab"
      ]
    },
    "enableBgpRouteTranslationForNat": {
      "value": true
    },
    "enablePrivateIpAddress": {
      "value": true
    },
    "gatewayDefaultSiteLocalNetworkGatewayResourceId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayResourceId>"
    },
    "publicIpZones": {
      "value": [
        1,
        2,
        3
      ]
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vpnGatewayGeneration": {
      "value": "Generation2"
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  clusterMode: 'activeActiveBgp'
}
param gatewayType = 'Vpn'
param name = 'nvgaab001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgaab'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayResourceId = '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
param publicIpZones = [
  1
  2
  3
]
param skuName = 'VpnGw2AZ'
param vpnGatewayGeneration = 'Generation2'
param vpnType = 'RouteBased'
```

</details>
<p>

### Example 2: _VPN Active Active with BGP settings_

This instance deploys the module with the VPN Active Active with APIPA BGP settings.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      clusterMode: 'activeActiveBgp'
      customBgpIpAddresses: [
        '169.254.21.4'
        '169.254.21.5'
      ]
      secondCustomBgpIpAddresses: [
        '169.254.22.4'
        '169.254.22.5'
      ]
    }
    gatewayType: 'Vpn'
    name: 'nvgaaa001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgaaa'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayResourceId: '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
    publicIpZones: [
      1
      2
      3
    ]
    skuName: 'VpnGw2AZ'
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
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
    "clusterSettings": {
      "value": {
        "clusterMode": "activeActiveBgp",
        "customBgpIpAddresses": [
          "169.254.21.4",
          "169.254.21.5"
        ],
        "secondCustomBgpIpAddresses": [
          "169.254.22.4",
          "169.254.22.5"
        ]
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgaaa001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "allowRemoteVnetTraffic": {
      "value": true
    },
    "disableIPSecReplayProtection": {
      "value": true
    },
    "domainNameLabel": {
      "value": [
        "dm-nvgaaa"
      ]
    },
    "enableBgpRouteTranslationForNat": {
      "value": true
    },
    "enablePrivateIpAddress": {
      "value": true
    },
    "gatewayDefaultSiteLocalNetworkGatewayResourceId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayResourceId>"
    },
    "publicIpZones": {
      "value": [
        1,
        2,
        3
      ]
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vpnGatewayGeneration": {
      "value": "Generation2"
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  clusterMode: 'activeActiveBgp'
  customBgpIpAddresses: [
    '169.254.21.4'
    '169.254.21.5'
  ]
  secondCustomBgpIpAddresses: [
    '169.254.22.4'
    '169.254.22.5'
  ]
}
param gatewayType = 'Vpn'
param name = 'nvgaaa001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgaaa'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayResourceId = '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
param publicIpZones = [
  1
  2
  3
]
param skuName = 'VpnGw2AZ'
param vpnGatewayGeneration = 'Generation2'
param vpnType = 'RouteBased'
```

</details>
<p>

### Example 3: _VPN Active Active without BGP settings using two existent Public IPs_

This instance deploys the module with the VPN Active Active without BGP settings.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      clusterMode: 'activeActiveNoBgp'
      existingSecondaryPublicIPResourceId: '<existingSecondaryPublicIPResourceId>'
    }
    gatewayType: 'Vpn'
    name: 'nvgaaep001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgaaep'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    existingPrimaryPublicIPResourceId: '<existingPrimaryPublicIPResourceId>'
    gatewayDefaultSiteLocalNetworkGatewayResourceId: '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
    publicIpZones: [
      1
      2
      3
    ]
    skuName: 'VpnGw2AZ'
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
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
    "clusterSettings": {
      "value": {
        "clusterMode": "activeActiveNoBgp",
        "existingSecondaryPublicIPResourceId": "<existingSecondaryPublicIPResourceId>"
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgaaep001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "allowRemoteVnetTraffic": {
      "value": true
    },
    "disableIPSecReplayProtection": {
      "value": true
    },
    "domainNameLabel": {
      "value": [
        "dm-nvgaaep"
      ]
    },
    "enableBgpRouteTranslationForNat": {
      "value": true
    },
    "enablePrivateIpAddress": {
      "value": true
    },
    "existingPrimaryPublicIPResourceId": {
      "value": "<existingPrimaryPublicIPResourceId>"
    },
    "gatewayDefaultSiteLocalNetworkGatewayResourceId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayResourceId>"
    },
    "publicIpZones": {
      "value": [
        1,
        2,
        3
      ]
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vpnGatewayGeneration": {
      "value": "Generation2"
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  clusterMode: 'activeActiveNoBgp'
  existingSecondaryPublicIPResourceId: '<existingSecondaryPublicIPResourceId>'
}
param gatewayType = 'Vpn'
param name = 'nvgaaep001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgaaep'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param existingPrimaryPublicIPResourceId = '<existingPrimaryPublicIPResourceId>'
param gatewayDefaultSiteLocalNetworkGatewayResourceId = '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
param publicIpZones = [
  1
  2
  3
]
param skuName = 'VpnGw2AZ'
param vpnGatewayGeneration = 'Generation2'
param vpnType = 'RouteBased'
```

</details>
<p>

### Example 4: _VPN Active Active without BGP settings_

This instance deploys the module with the VPN Active Active without BGP settings.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      clusterMode: 'activeActiveNoBgp'
    }
    gatewayType: 'Vpn'
    name: 'nvgaa001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgaa'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayResourceId: '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
    publicIpZones: [
      1
      2
      3
    ]
    skuName: 'VpnGw2AZ'
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
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
    "clusterSettings": {
      "value": {
        "clusterMode": "activeActiveNoBgp"
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgaa001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "allowRemoteVnetTraffic": {
      "value": true
    },
    "disableIPSecReplayProtection": {
      "value": true
    },
    "domainNameLabel": {
      "value": [
        "dm-nvgaa"
      ]
    },
    "enableBgpRouteTranslationForNat": {
      "value": true
    },
    "enablePrivateIpAddress": {
      "value": true
    },
    "gatewayDefaultSiteLocalNetworkGatewayResourceId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayResourceId>"
    },
    "publicIpZones": {
      "value": [
        1,
        2,
        3
      ]
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vpnGatewayGeneration": {
      "value": "Generation2"
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  clusterMode: 'activeActiveNoBgp'
}
param gatewayType = 'Vpn'
param name = 'nvgaa001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgaa'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayResourceId = '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
param publicIpZones = [
  1
  2
  3
]
param skuName = 'VpnGw2AZ'
param vpnGatewayGeneration = 'Generation2'
param vpnType = 'RouteBased'
```

</details>
<p>

### Example 5: _VPN Active Passive with BGP settings_

This instance deploys the module with the VPN Active Passive with APIPA BGP settings.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      asn: 65815
      clusterMode: 'activePassiveBgp'
      customBgpIpAddresses: [
        '169.254.21.4'
        '169.254.21.5'
      ]
    }
    gatewayType: 'Vpn'
    name: 'nvgapb001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgapb'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayResourceId: '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
    publicIpZones: [
      1
      2
      3
    ]
    skuName: 'VpnGw2AZ'
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
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
    "clusterSettings": {
      "value": {
        "asn": 65815,
        "clusterMode": "activePassiveBgp",
        "customBgpIpAddresses": [
          "169.254.21.4",
          "169.254.21.5"
        ]
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgapb001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "allowRemoteVnetTraffic": {
      "value": true
    },
    "disableIPSecReplayProtection": {
      "value": true
    },
    "domainNameLabel": {
      "value": [
        "dm-nvgapb"
      ]
    },
    "enableBgpRouteTranslationForNat": {
      "value": true
    },
    "enablePrivateIpAddress": {
      "value": true
    },
    "gatewayDefaultSiteLocalNetworkGatewayResourceId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayResourceId>"
    },
    "publicIpZones": {
      "value": [
        1,
        2,
        3
      ]
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vpnGatewayGeneration": {
      "value": "Generation2"
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  asn: 65815
  clusterMode: 'activePassiveBgp'
  customBgpIpAddresses: [
    '169.254.21.4'
    '169.254.21.5'
  ]
}
param gatewayType = 'Vpn'
param name = 'nvgapb001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgapb'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayResourceId = '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
param publicIpZones = [
  1
  2
  3
]
param skuName = 'VpnGw2AZ'
param vpnGatewayGeneration = 'Generation2'
param vpnType = 'RouteBased'
```

</details>
<p>

### Example 6: _VPN Active Passive with BGP settings using existing Public IP_

This instance deploys the module with the VPN Active Passive with APIPA BGP settings and existing primary public IP.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      asn: 65815
      clusterMode: 'activePassiveBgp'
      customBgpIpAddresses: [
        '169.254.21.4'
        '169.254.21.5'
      ]
    }
    gatewayType: 'Vpn'
    name: 'nvgapep001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgapep'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    existingPrimaryPublicIPResourceId: '<existingPrimaryPublicIPResourceId>'
    gatewayDefaultSiteLocalNetworkGatewayResourceId: '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
    publicIpZones: [
      1
      2
      3
    ]
    skuName: 'VpnGw2AZ'
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
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
    "clusterSettings": {
      "value": {
        "asn": 65815,
        "clusterMode": "activePassiveBgp",
        "customBgpIpAddresses": [
          "169.254.21.4",
          "169.254.21.5"
        ]
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgapep001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "allowRemoteVnetTraffic": {
      "value": true
    },
    "disableIPSecReplayProtection": {
      "value": true
    },
    "domainNameLabel": {
      "value": [
        "dm-nvgapep"
      ]
    },
    "enableBgpRouteTranslationForNat": {
      "value": true
    },
    "enablePrivateIpAddress": {
      "value": true
    },
    "existingPrimaryPublicIPResourceId": {
      "value": "<existingPrimaryPublicIPResourceId>"
    },
    "gatewayDefaultSiteLocalNetworkGatewayResourceId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayResourceId>"
    },
    "publicIpZones": {
      "value": [
        1,
        2,
        3
      ]
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vpnGatewayGeneration": {
      "value": "Generation2"
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  asn: 65815
  clusterMode: 'activePassiveBgp'
  customBgpIpAddresses: [
    '169.254.21.4'
    '169.254.21.5'
  ]
}
param gatewayType = 'Vpn'
param name = 'nvgapep001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgapep'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param existingPrimaryPublicIPResourceId = '<existingPrimaryPublicIPResourceId>'
param gatewayDefaultSiteLocalNetworkGatewayResourceId = '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
param publicIpZones = [
  1
  2
  3
]
param skuName = 'VpnGw2AZ'
param vpnGatewayGeneration = 'Generation2'
param vpnType = 'RouteBased'
```

</details>
<p>

### Example 7: _VPN Active Passive without BGP settings_

This instance deploys the module with the VPN Active Passive without BGP settings.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      clusterMode: 'activePassiveNoBgp'
    }
    gatewayType: 'Vpn'
    name: 'nvgap001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgap'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayResourceId: '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
    publicIpZones: [
      1
      2
      3
    ]
    skuName: 'VpnGw2AZ'
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
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
    "clusterSettings": {
      "value": {
        "clusterMode": "activePassiveNoBgp"
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgap001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "allowRemoteVnetTraffic": {
      "value": true
    },
    "disableIPSecReplayProtection": {
      "value": true
    },
    "domainNameLabel": {
      "value": [
        "dm-nvgap"
      ]
    },
    "enableBgpRouteTranslationForNat": {
      "value": true
    },
    "enablePrivateIpAddress": {
      "value": true
    },
    "gatewayDefaultSiteLocalNetworkGatewayResourceId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayResourceId>"
    },
    "publicIpZones": {
      "value": [
        1,
        2,
        3
      ]
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vpnGatewayGeneration": {
      "value": "Generation2"
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  clusterMode: 'activePassiveNoBgp'
}
param gatewayType = 'Vpn'
param name = 'nvgap001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgap'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayResourceId = '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
param publicIpZones = [
  1
  2
  3
]
param skuName = 'VpnGw2AZ'
param vpnGatewayGeneration = 'Generation2'
param vpnType = 'RouteBased'
```

</details>
<p>

### Example 8: _Custom Routes_

This instance deploys the module with custom routes configuration for Point-to-Site VPN clients.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      clusterMode: 'activePassiveNoBgp'
    }
    gatewayType: 'Vpn'
    name: 'nvgcr001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    customRoutes: {
      addressPrefixes: [
        '10.1.0.0/16'
        '10.2.0.0/16'
        '192.168.100.0/24'
        '192.168.200.0/24'
      ]
    }
    skuName: 'VpnGw2AZ'
    vpnClientAddressPoolPrefix: '172.16.0.0/24'
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
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
    "clusterSettings": {
      "value": {
        "clusterMode": "activePassiveNoBgp"
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgcr001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "customRoutes": {
      "value": {
        "addressPrefixes": [
          "10.1.0.0/16",
          "10.2.0.0/16",
          "192.168.100.0/24",
          "192.168.200.0/24"
        ]
      }
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vpnClientAddressPoolPrefix": {
      "value": "172.16.0.0/24"
    },
    "vpnGatewayGeneration": {
      "value": "Generation2"
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  clusterMode: 'activePassiveNoBgp'
}
param gatewayType = 'Vpn'
param name = 'nvgcr001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param customRoutes = {
  addressPrefixes: [
    '10.1.0.0/16'
    '10.2.0.0/16'
    '192.168.100.0/24'
    '192.168.200.0/24'
  ]
}
param skuName = 'VpnGw2AZ'
param vpnClientAddressPoolPrefix = '172.16.0.0/24'
param vpnGatewayGeneration = 'Generation2'
param vpnType = 'RouteBased'
```

</details>
<p>

### Example 9: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      clusterMode: 'activeActiveNoBgp'
    }
    gatewayType: 'Vpn'
    name: 'nvgmin001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
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
    "clusterSettings": {
      "value": {
        "clusterMode": "activeActiveNoBgp"
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgmin001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  clusterMode: 'activeActiveNoBgp'
}
param gatewayType = 'Vpn'
param name = 'nvgmin001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
```

</details>
<p>

### Example 10: _ExpressRoute_

This instance deploys the module with the ExpressRoute set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      clusterMode: 'activePassiveBgp'
    }
    gatewayType: 'ExpressRoute'
    name: 'nvger001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    domainNameLabel: [
      'dm-nvger'
    ]
    primaryPublicIPName: 'pip-nvger'
    publicIpZones: [
      1
      2
      3
    ]
    skuName: 'ErGw1AZ'
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
    "clusterSettings": {
      "value": {
        "clusterMode": "activePassiveBgp"
      }
    },
    "gatewayType": {
      "value": "ExpressRoute"
    },
    "name": {
      "value": "nvger001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "domainNameLabel": {
      "value": [
        "dm-nvger"
      ]
    },
    "primaryPublicIPName": {
      "value": "pip-nvger"
    },
    "publicIpZones": {
      "value": [
        1,
        2,
        3
      ]
    },
    "skuName": {
      "value": "ErGw1AZ"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  clusterMode: 'activePassiveBgp'
}
param gatewayType = 'ExpressRoute'
param name = 'nvger001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param domainNameLabel = [
  'dm-nvger'
]
param primaryPublicIPName = 'pip-nvger'
param publicIpZones = [
  1
  2
  3
]
param skuName = 'ErGw1AZ'
```

</details>
<p>

### Example 11: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      clusterMode: 'activeActiveBgp'
      customBgpIpAddresses: [
        '169.254.21.4'
        '169.254.21.5'
      ]
      secondCustomBgpIpAddresses: [
        '169.254.22.4'
        '169.254.22.5'
      ]
      secondPipName: 'nvgmax001-pip2'
    }
    gatewayType: 'Vpn'
    name: 'nvgmax001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgmax'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayResourceId: '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    natRules: [
      {
        externalMappings: [
          {
            addressSpace: '192.168.0.0/24'
            portRange: '100'
          }
        ]
        internalMappings: [
          {
            addressSpace: '10.100.0.0/24'
            portRange: '100'
          }
        ]
        mode: 'IngressSnat'
        name: 'nat-rule-1-static-IngressSnat'
        type: 'Static'
      }
      {
        externalMappings: [
          {
            addressSpace: '10.200.0.0/26'
          }
        ]
        internalMappings: [
          {
            addressSpace: '172.16.0.0/26'
          }
        ]
        mode: 'EgressSnat'
        name: 'nat-rule-2-dynamic-EgressSnat'
        type: 'Static'
      }
    ]
    publicIpZones: [
      1
      2
      3
    ]
    roleAssignments: [
      {
        name: 'db30550e-70b7-4dbe-901e-e9363b69c05f'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
        name: '<name>'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
      }
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
      }
    ]
    skuName: 'VpnGw2AZ'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
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
    "clusterSettings": {
      "value": {
        "clusterMode": "activeActiveBgp",
        "customBgpIpAddresses": [
          "169.254.21.4",
          "169.254.21.5"
        ],
        "secondCustomBgpIpAddresses": [
          "169.254.22.4",
          "169.254.22.5"
        ],
        "secondPipName": "nvgmax001-pip2"
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgmax001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "allowRemoteVnetTraffic": {
      "value": true
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "disableIPSecReplayProtection": {
      "value": true
    },
    "domainNameLabel": {
      "value": [
        "dm-nvgmax"
      ]
    },
    "enableBgpRouteTranslationForNat": {
      "value": true
    },
    "enablePrivateIpAddress": {
      "value": true
    },
    "gatewayDefaultSiteLocalNetworkGatewayResourceId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayResourceId>"
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
              "addressSpace": "192.168.0.0/24",
              "portRange": "100"
            }
          ],
          "internalMappings": [
            {
              "addressSpace": "10.100.0.0/24",
              "portRange": "100"
            }
          ],
          "mode": "IngressSnat",
          "name": "nat-rule-1-static-IngressSnat",
          "type": "Static"
        },
        {
          "externalMappings": [
            {
              "addressSpace": "10.200.0.0/26"
            }
          ],
          "internalMappings": [
            {
              "addressSpace": "172.16.0.0/26"
            }
          ],
          "mode": "EgressSnat",
          "name": "nat-rule-2-dynamic-EgressSnat",
          "type": "Static"
        }
      ]
    },
    "publicIpZones": {
      "value": [
        1,
        2,
        3
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "db30550e-70b7-4dbe-901e-e9363b69c05f",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Owner"
        },
        {
          "name": "<name>",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "b24988ac-6180-42a0-ab88-20f7382dd24c"
        },
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "<roleDefinitionIdOrName>"
        }
      ]
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vpnGatewayGeneration": {
      "value": "Generation2"
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  clusterMode: 'activeActiveBgp'
  customBgpIpAddresses: [
    '169.254.21.4'
    '169.254.21.5'
  ]
  secondCustomBgpIpAddresses: [
    '169.254.22.4'
    '169.254.22.5'
  ]
  secondPipName: 'nvgmax001-pip2'
}
param gatewayType = 'Vpn'
param name = 'nvgmax001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgmax'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayResourceId = '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param natRules = [
  {
    externalMappings: [
      {
        addressSpace: '192.168.0.0/24'
        portRange: '100'
      }
    ]
    internalMappings: [
      {
        addressSpace: '10.100.0.0/24'
        portRange: '100'
      }
    ]
    mode: 'IngressSnat'
    name: 'nat-rule-1-static-IngressSnat'
    type: 'Static'
  }
  {
    externalMappings: [
      {
        addressSpace: '10.200.0.0/26'
      }
    ]
    internalMappings: [
      {
        addressSpace: '172.16.0.0/26'
      }
    ]
    mode: 'EgressSnat'
    name: 'nat-rule-2-dynamic-EgressSnat'
    type: 'Static'
  }
]
param publicIpZones = [
  1
  2
  3
]
param roleAssignments = [
  {
    name: 'db30550e-70b7-4dbe-901e-e9363b69c05f'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Owner'
  }
  {
    name: '<name>'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
  }
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
  }
]
param skuName = 'VpnGw2AZ'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param vpnGatewayGeneration = 'Generation2'
param vpnType = 'RouteBased'
```

</details>
<p>

### Example 12: _Using SKU without Availability Zones_

This instance deploys the module with a SKU that does not support Availability Zones.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      clusterMode: 'activePassiveNoBgp'
    }
    gatewayType: 'Vpn'
    name: 'nvgnaz001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    publicIpZones: []
    skuName: 'VpnGw1'
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
    "clusterSettings": {
      "value": {
        "clusterMode": "activePassiveNoBgp"
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgnaz001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "publicIpZones": {
      "value": []
    },
    "skuName": {
      "value": "VpnGw1"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  clusterMode: 'activePassiveNoBgp'
}
param gatewayType = 'Vpn'
param name = 'nvgnaz001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param publicIpZones = []
param skuName = 'VpnGw1'
```

</details>
<p>

### Example 13: _VPN_

This instance deploys the module with the VPN set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      clusterMode: 'activeActiveNoBgp'
    }
    gatewayType: 'Vpn'
    name: 'nvgvpn001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgvpn'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayResourceId: '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
    publicIpZones: [
      1
      2
      3
    ]
    skuName: 'VpnGw2AZ'
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
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
    "clusterSettings": {
      "value": {
        "clusterMode": "activeActiveNoBgp"
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgvpn001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "allowRemoteVnetTraffic": {
      "value": true
    },
    "disableIPSecReplayProtection": {
      "value": true
    },
    "domainNameLabel": {
      "value": [
        "dm-nvgvpn"
      ]
    },
    "enableBgpRouteTranslationForNat": {
      "value": true
    },
    "enablePrivateIpAddress": {
      "value": true
    },
    "gatewayDefaultSiteLocalNetworkGatewayResourceId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayResourceId>"
    },
    "publicIpZones": {
      "value": [
        1,
        2,
        3
      ]
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vpnGatewayGeneration": {
      "value": "Generation2"
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  clusterMode: 'activeActiveNoBgp'
}
param gatewayType = 'Vpn'
param name = 'nvgvpn001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgvpn'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayResourceId = '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
param publicIpZones = [
  1
  2
  3
]
param skuName = 'VpnGw2AZ'
param vpnGatewayGeneration = 'Generation2'
param vpnType = 'RouteBased'
```

</details>
<p>

### Example 14: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    clusterSettings: {
      asn: 65515
      clusterMode: 'activeActiveBgp'
      customBgpIpAddresses: [
        '169.254.21.4'
        '169.254.21.5'
      ]
      secondCustomBgpIpAddresses: [
        '169.254.22.4'
        '169.254.22.5'
      ]
    }
    gatewayType: 'Vpn'
    name: 'nvgmwaf001'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        metricCategories: [
          {
            category: 'AllMetrics'
          }
        ]
        name: 'customSetting'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgmwaf'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayResourceId: '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
    natRules: [
      {
        externalMappings: [
          {
            addressSpace: '192.168.0.0/24'
            portRange: '100'
          }
        ]
        internalMappings: [
          {
            addressSpace: '10.100.0.0/24'
            portRange: '100'
          }
        ]
        mode: 'IngressSnat'
        name: 'nat-rule-1-static-IngressSnat'
        type: 'Static'
      }
      {
        externalMappings: [
          {
            addressSpace: '10.200.0.0/26'
          }
        ]
        internalMappings: [
          {
            addressSpace: '172.16.0.0/26'
          }
        ]
        mode: 'EgressSnat'
        name: 'nat-rule-2-dynamic-EgressSnat'
        type: 'Static'
      }
    ]
    publicIpZones: [
      1
      2
      3
    ]
    skuName: 'VpnGw2AZ'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
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
    "clusterSettings": {
      "value": {
        "asn": 65515,
        "clusterMode": "activeActiveBgp",
        "customBgpIpAddresses": [
          "169.254.21.4",
          "169.254.21.5"
        ],
        "secondCustomBgpIpAddresses": [
          "169.254.22.4",
          "169.254.22.5"
        ]
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgmwaf001"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    // Non-required parameters
    "allowRemoteVnetTraffic": {
      "value": true
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "metricCategories": [
            {
              "category": "AllMetrics"
            }
          ],
          "name": "customSetting",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "disableIPSecReplayProtection": {
      "value": true
    },
    "domainNameLabel": {
      "value": [
        "dm-nvgmwaf"
      ]
    },
    "enableBgpRouteTranslationForNat": {
      "value": true
    },
    "enablePrivateIpAddress": {
      "value": true
    },
    "gatewayDefaultSiteLocalNetworkGatewayResourceId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayResourceId>"
    },
    "natRules": {
      "value": [
        {
          "externalMappings": [
            {
              "addressSpace": "192.168.0.0/24",
              "portRange": "100"
            }
          ],
          "internalMappings": [
            {
              "addressSpace": "10.100.0.0/24",
              "portRange": "100"
            }
          ],
          "mode": "IngressSnat",
          "name": "nat-rule-1-static-IngressSnat",
          "type": "Static"
        },
        {
          "externalMappings": [
            {
              "addressSpace": "10.200.0.0/26"
            }
          ],
          "internalMappings": [
            {
              "addressSpace": "172.16.0.0/26"
            }
          ],
          "mode": "EgressSnat",
          "name": "nat-rule-2-dynamic-EgressSnat",
          "type": "Static"
        }
      ]
    },
    "publicIpZones": {
      "value": [
        1,
        2,
        3
      ]
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vpnGatewayGeneration": {
      "value": "Generation2"
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-network-gateway:<version>'

// Required parameters
param clusterSettings = {
  asn: 65515
  clusterMode: 'activeActiveBgp'
  customBgpIpAddresses: [
    '169.254.21.4'
    '169.254.21.5'
  ]
  secondCustomBgpIpAddresses: [
    '169.254.22.4'
    '169.254.22.5'
  ]
}
param gatewayType = 'Vpn'
param name = 'nvgmwaf001'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param diagnosticSettings = [
  {
    eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
    eventHubName: '<eventHubName>'
    metricCategories: [
      {
        category: 'AllMetrics'
      }
    ]
    name: 'customSetting'
    storageAccountResourceId: '<storageAccountResourceId>'
    workspaceResourceId: '<workspaceResourceId>'
  }
]
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgmwaf'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayResourceId = '<gatewayDefaultSiteLocalNetworkGatewayResourceId>'
param natRules = [
  {
    externalMappings: [
      {
        addressSpace: '192.168.0.0/24'
        portRange: '100'
      }
    ]
    internalMappings: [
      {
        addressSpace: '10.100.0.0/24'
        portRange: '100'
      }
    ]
    mode: 'IngressSnat'
    name: 'nat-rule-1-static-IngressSnat'
    type: 'Static'
  }
  {
    externalMappings: [
      {
        addressSpace: '10.200.0.0/26'
      }
    ]
    internalMappings: [
      {
        addressSpace: '172.16.0.0/26'
      }
    ]
    mode: 'EgressSnat'
    name: 'nat-rule-2-dynamic-EgressSnat'
    type: 'Static'
  }
]
param publicIpZones = [
  1
  2
  3
]
param skuName = 'VpnGw2AZ'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param vpnGatewayGeneration = 'Generation2'
param vpnType = 'RouteBased'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterSettings`](#parameter-clustersettings) | object | Specifies one of the following four configurations: Active-Active with (clusterMode = activeActiveBgp) or without (clusterMode = activeActiveNoBgp) BGP, Active-Passive with (clusterMode = activePassiveBgp) or without (clusterMode = activePassiveNoBgp) BGP. |
| [`gatewayType`](#parameter-gatewaytype) | string | Specifies the gateway type. E.g. VPN, ExpressRoute. |
| [`name`](#parameter-name) | string | Specifies the Virtual Network Gateway name. |
| [`virtualNetworkResourceId`](#parameter-virtualnetworkresourceid) | string | Virtual Network resource ID. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`adminState`](#parameter-adminstate) | string | Property to indicate if the Express Route Gateway serves traffic when there are multiple Express Route Gateways in the vnet. Only applicable for ExpressRoute gateways. |
| [`allowRemoteVnetTraffic`](#parameter-allowremotevnettraffic) | bool | Configure this gateway to accept traffic from other Azure Virtual Networks. This configuration does not support connectivity to Azure Virtual WAN. |
| [`allowVirtualWanTraffic`](#parameter-allowvirtualwantraffic) | bool | Configures this gateway to accept traffic from remote Virtual WAN networks. |
| [`autoScaleConfiguration`](#parameter-autoscaleconfiguration) | object | Autoscale configuration for virtual network gateway. Only applicable for certain SKUs. |
| [`clientRevokedCertThumbprint`](#parameter-clientrevokedcertthumbprint) | string | Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet. |
| [`clientRootCertData`](#parameter-clientrootcertdata) | string | Client root certificate data used to authenticate VPN clients. Cannot be configured if vpnClientAadConfiguration is provided. |
| [`customRoutes`](#parameter-customroutes) | object | The reference to the address space resource which represents the custom routes address space specified by the customer for virtual network gateway and VpnClient. This is used to specify custom routes for Point-to-Site VPN clients. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableIPSecReplayProtection`](#parameter-disableipsecreplayprotection) | bool | disableIPSecReplayProtection flag. Used for VPN Gateways. |
| [`domainNameLabel`](#parameter-domainnamelabel) | array | DNS name(s) of the Public IP resource(s). If you enabled Active-Active mode, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com. |
| [`enableBgpRouteTranslationForNat`](#parameter-enablebgproutetranslationfornat) | bool | EnableBgpRouteTranslationForNat flag. Can only be used when "natRules" are enabled on the Virtual Network Gateway. |
| [`enableDnsForwarding`](#parameter-enablednsforwarding) | bool | Whether DNS forwarding is enabled or not and is only supported for Express Route Gateways. The DNS forwarding feature flag must be enabled on the current subscription. |
| [`enablePrivateIpAddress`](#parameter-enableprivateipaddress) | bool | Whether private IP needs to be enabled on this gateway for connections or not. Used for configuring a Site-to-Site VPN connection over ExpressRoute private peering. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`existingPrimaryPublicIPResourceId`](#parameter-existingprimarypublicipresourceid) | string | The Public IP resource ID to associate to the Virtual Network Gateway. If empty, then a new Public IP will be created and applied to the Virtual Network Gateway. |
| [`gatewayDefaultSiteLocalNetworkGatewayResourceId`](#parameter-gatewaydefaultsitelocalnetworkgatewayresourceid) | string | The reference to the LocalNetworkGateway resource which represents local network site having default routes. Assign Null value in case of removing existing default site setting. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentity`](#parameter-managedidentity) | object | The managed identity definition for this resource. Supports system-assigned and user-assigned identities. |
| [`natRules`](#parameter-natrules) | array | NatRules for virtual network gateway. NAT is supported on the the following SKUs: VpnGw2~5, VpnGw2AZ~5AZ and is supported for IPsec/IKE cross-premises connections only. |
| [`primaryPublicIPName`](#parameter-primarypublicipname) | string | Specifies the name of the Public IP to be created for the Virtual Network Gateway. This will only take effect if no existing Public IP is provided. If neither an existing Public IP nor this parameter is specified, a new Public IP will be created with a default name, using the gateway's name with the '-pip1' suffix. |
| [`publicIpDiagnosticSettings`](#parameter-publicipdiagnosticsettings) | array | The diagnostic settings of the Public IP. |
| [`publicIPPrefixResourceId`](#parameter-publicipprefixresourceid) | string | Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |
| [`publicIpZones`](#parameter-publicipzones) | array | Specifies the zones of the Public IP address. Basic IP SKU does not support Availability Zones. |
| [`resiliencyModel`](#parameter-resiliencymodel) | string | Property to indicate if the Express Route Gateway has resiliency model of MultiHomed or SingleHomed. Only applicable for ExpressRoute gateways. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`skuName`](#parameter-skuname) | string | The SKU of the Gateway. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`vpnClientAadConfiguration`](#parameter-vpnclientaadconfiguration) | object | Configuration for AAD Authentication for P2S Tunnel Type, Cannot be configured if clientRootCertData is provided. |
| [`vpnClientAddressPoolPrefix`](#parameter-vpnclientaddresspoolprefix) | string | The IP address range from which VPN clients will receive an IP address when connected. Range specified must not overlap with on-premise network. |
| [`vpnGatewayGeneration`](#parameter-vpngatewaygeneration) | string | The generation for this VirtualNetworkGateway. Must be None if virtualNetworkGatewayType is not VPN. |
| [`vpnType`](#parameter-vpntype) | string | Specifies the VPN type. |

### Parameter: `clusterSettings`

Specifies one of the following four configurations: Active-Active with (clusterMode = activeActiveBgp) or without (clusterMode = activeActiveNoBgp) BGP, Active-Passive with (clusterMode = activePassiveBgp) or without (clusterMode = activePassiveNoBgp) BGP.

- Required: Yes
- Type: object
- Discriminator: `clusterMode`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`activeActiveNoBgp`](#variant-clustersettingsclustermode-activeactivenobgp) | The type for an active-active no BGP cluster configuration. |
| [`activeActiveBgp`](#variant-clustersettingsclustermode-activeactivebgp) | The type for an active-active BGP cluster configuration. |
| [`activePassiveBgp`](#variant-clustersettingsclustermode-activepassivebgp) | The type for an active-passive BGP cluster configuration. |
| [`activePassiveNoBgp`](#variant-clustersettingsclustermode-activepassivenobgp) | The type for an active-passive no BGP cluster configuration. |

### Variant: `clusterSettings.clusterMode-activeActiveNoBgp`
The type for an active-active no BGP cluster configuration.

To use this variant, set the property `clusterMode` to `activeActiveNoBgp`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterMode`](#parameter-clustersettingsclustermode-activeactivenobgpclustermode) | string | The cluster mode deciding the configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`existingSecondaryPublicIPResourceId`](#parameter-clustersettingsclustermode-activeactivenobgpexistingsecondarypublicipresourceid) | string | The secondary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new secondary Public IP will be created as part of this module and applied to the Virtual Network Gateway. |
| [`existingTertiaryPublicIPResourceId`](#parameter-clustersettingsclustermode-activeactivenobgpexistingtertiarypublicipresourceid) | string | The tertiary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new tertiary Public IP will be created as part of this module and applied to the Virtual Network Gateway. |
| [`secondPipName`](#parameter-clustersettingsclustermode-activeactivenobgpsecondpipname) | string | Specifies the name of the secondary Public IP to be created for the Virtual Network Gateway in the Active-Active mode. This will only take effect if no existing secondary Public IP is provided. If neither an existing secondary Public IP nor this parameter is specified, a new secondary Public IP will be created with a default name, using the gateway's name with the '-pip2' suffix. |

### Parameter: `clusterSettings.clusterMode-activeActiveNoBgp.clusterMode`

The cluster mode deciding the configuration.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'activeActiveNoBgp'
  ]
  ```

### Parameter: `clusterSettings.clusterMode-activeActiveNoBgp.existingSecondaryPublicIPResourceId`

The secondary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new secondary Public IP will be created as part of this module and applied to the Virtual Network Gateway.

- Required: No
- Type: string

### Parameter: `clusterSettings.clusterMode-activeActiveNoBgp.existingTertiaryPublicIPResourceId`

The tertiary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new tertiary Public IP will be created as part of this module and applied to the Virtual Network Gateway.

- Required: No
- Type: string

### Parameter: `clusterSettings.clusterMode-activeActiveNoBgp.secondPipName`

Specifies the name of the secondary Public IP to be created for the Virtual Network Gateway in the Active-Active mode. This will only take effect if no existing secondary Public IP is provided. If neither an existing secondary Public IP nor this parameter is specified, a new secondary Public IP will be created with a default name, using the gateway's name with the '-pip2' suffix.

- Required: No
- Type: string

### Variant: `clusterSettings.clusterMode-activeActiveBgp`
The type for an active-active BGP cluster configuration.

To use this variant, set the property `clusterMode` to `activeActiveBgp`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterMode`](#parameter-clustersettingsclustermode-activeactivebgpclustermode) | string | The cluster mode deciding the configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`asn`](#parameter-clustersettingsclustermode-activeactivebgpasn) | int | The Autonomous System Number value. If it's not provided, a default '65515' value will be assigned to the ASN. |
| [`customBgpIpAddresses`](#parameter-clustersettingsclustermode-activeactivebgpcustombgpipaddresses) | array | The list of custom BGP IP Address (APIPA) peering addresses which belong to IP configuration. |
| [`existingSecondaryPublicIPResourceId`](#parameter-clustersettingsclustermode-activeactivebgpexistingsecondarypublicipresourceid) | string | The secondary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new secondary Public IP will be created as part of this module and applied to the Virtual Network Gateway. |
| [`existingTertiaryPublicIPResourceId`](#parameter-clustersettingsclustermode-activeactivebgpexistingtertiarypublicipresourceid) | string | The tertiary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new tertiary Public IP will be created as part of this module and applied to the Virtual Network Gateway. |
| [`secondCustomBgpIpAddresses`](#parameter-clustersettingsclustermode-activeactivebgpsecondcustombgpipaddresses) | array | The list of the second custom BGP IP Address (APIPA) peering addresses which belong to IP configuration. |
| [`secondPipName`](#parameter-clustersettingsclustermode-activeactivebgpsecondpipname) | string | Specifies the name of the secondary Public IP to be created for the Virtual Network Gateway in the Active-Active mode. This will only take effect if no existing secondary Public IP is provided. If neither an existing secondary Public IP nor this parameter is specified, a new secondary Public IP will be created with a default name, using the gateway's name with the '-pip2' suffix. |

### Parameter: `clusterSettings.clusterMode-activeActiveBgp.clusterMode`

The cluster mode deciding the configuration.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'activeActiveBgp'
  ]
  ```

### Parameter: `clusterSettings.clusterMode-activeActiveBgp.asn`

The Autonomous System Number value. If it's not provided, a default '65515' value will be assigned to the ASN.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 4294967295

### Parameter: `clusterSettings.clusterMode-activeActiveBgp.customBgpIpAddresses`

The list of custom BGP IP Address (APIPA) peering addresses which belong to IP configuration.

- Required: No
- Type: array

### Parameter: `clusterSettings.clusterMode-activeActiveBgp.existingSecondaryPublicIPResourceId`

The secondary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new secondary Public IP will be created as part of this module and applied to the Virtual Network Gateway.

- Required: No
- Type: string

### Parameter: `clusterSettings.clusterMode-activeActiveBgp.existingTertiaryPublicIPResourceId`

The tertiary Public IP resource ID to associate to the Virtual Network Gateway in the Active-Active mode. If empty, then a new tertiary Public IP will be created as part of this module and applied to the Virtual Network Gateway.

- Required: No
- Type: string

### Parameter: `clusterSettings.clusterMode-activeActiveBgp.secondCustomBgpIpAddresses`

The list of the second custom BGP IP Address (APIPA) peering addresses which belong to IP configuration.

- Required: No
- Type: array

### Parameter: `clusterSettings.clusterMode-activeActiveBgp.secondPipName`

Specifies the name of the secondary Public IP to be created for the Virtual Network Gateway in the Active-Active mode. This will only take effect if no existing secondary Public IP is provided. If neither an existing secondary Public IP nor this parameter is specified, a new secondary Public IP will be created with a default name, using the gateway's name with the '-pip2' suffix.

- Required: No
- Type: string

### Variant: `clusterSettings.clusterMode-activePassiveBgp`
The type for an active-passive BGP cluster configuration.

To use this variant, set the property `clusterMode` to `activePassiveBgp`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterMode`](#parameter-clustersettingsclustermode-activepassivebgpclustermode) | string | The cluster mode deciding the configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`asn`](#parameter-clustersettingsclustermode-activepassivebgpasn) | int | The Autonomous System Number value. If it's not provided, a default '65515' value will be assigned to the ASN. |
| [`customBgpIpAddresses`](#parameter-clustersettingsclustermode-activepassivebgpcustombgpipaddresses) | array | The list of custom BGP IP Address (APIPA) peering addresses which belong to IP configuration. |

### Parameter: `clusterSettings.clusterMode-activePassiveBgp.clusterMode`

The cluster mode deciding the configuration.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'activePassiveBgp'
  ]
  ```

### Parameter: `clusterSettings.clusterMode-activePassiveBgp.asn`

The Autonomous System Number value. If it's not provided, a default '65515' value will be assigned to the ASN.

- Required: No
- Type: int
- MinValue: 0
- MaxValue: 4294967295

### Parameter: `clusterSettings.clusterMode-activePassiveBgp.customBgpIpAddresses`

The list of custom BGP IP Address (APIPA) peering addresses which belong to IP configuration.

- Required: No
- Type: array

### Variant: `clusterSettings.clusterMode-activePassiveNoBgp`
The type for an active-passive no BGP cluster configuration.

To use this variant, set the property `clusterMode` to `activePassiveNoBgp`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clusterMode`](#parameter-clustersettingsclustermode-activepassivenobgpclustermode) | string | The cluster mode deciding the configuration. |

### Parameter: `clusterSettings.clusterMode-activePassiveNoBgp.clusterMode`

The cluster mode deciding the configuration.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'activePassiveNoBgp'
  ]
  ```

### Parameter: `gatewayType`

Specifies the gateway type. E.g. VPN, ExpressRoute.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ExpressRoute'
    'Vpn'
  ]
  ```

### Parameter: `name`

Specifies the Virtual Network Gateway name.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkResourceId`

Virtual Network resource ID.

- Required: Yes
- Type: string

### Parameter: `adminState`

Property to indicate if the Express Route Gateway serves traffic when there are multiple Express Route Gateways in the vnet. Only applicable for ExpressRoute gateways.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `allowRemoteVnetTraffic`

Configure this gateway to accept traffic from other Azure Virtual Networks. This configuration does not support connectivity to Azure Virtual WAN.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `allowVirtualWanTraffic`

Configures this gateway to accept traffic from remote Virtual WAN networks.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `autoScaleConfiguration`

Autoscale configuration for virtual network gateway. Only applicable for certain SKUs.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bounds`](#parameter-autoscaleconfigurationbounds) | object | The bounds of the autoscale configuration. |

### Parameter: `autoScaleConfiguration.bounds`

The bounds of the autoscale configuration.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`max`](#parameter-autoscaleconfigurationboundsmax) | int | Maximum Scale Units for autoscale configuration. |
| [`min`](#parameter-autoscaleconfigurationboundsmin) | int | Minimum Scale Units for autoscale configuration. |

### Parameter: `autoScaleConfiguration.bounds.max`

Maximum Scale Units for autoscale configuration.

- Required: Yes
- Type: int

### Parameter: `autoScaleConfiguration.bounds.min`

Minimum Scale Units for autoscale configuration.

- Required: Yes
- Type: int

### Parameter: `clientRevokedCertThumbprint`

Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet.

- Required: No
- Type: string
- Default: `''`

### Parameter: `clientRootCertData`

Client root certificate data used to authenticate VPN clients. Cannot be configured if vpnClientAadConfiguration is provided.

- Required: No
- Type: string
- Default: `''`

### Parameter: `customRoutes`

The reference to the address space resource which represents the custom routes address space specified by the customer for virtual network gateway and VpnClient. This is used to specify custom routes for Point-to-Site VPN clients.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-customroutesaddressprefixes) | array | A list of address blocks reserved for this virtual network in CIDR notation. |
| [`ipamPoolPrefixAllocations`](#parameter-customroutesipampoolprefixallocations) | array | A list of IPAM Pools allocating IP address prefixes. |

### Parameter: `customRoutes.addressPrefixes`

A list of address blocks reserved for this virtual network in CIDR notation.

- Required: No
- Type: array

### Parameter: `customRoutes.ipamPoolPrefixAllocations`

A list of IPAM Pools allocating IP address prefixes.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`pool`](#parameter-customroutesipampoolprefixallocationspool) | object | Pool configuration for IPAM. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`numberOfIpAddresses`](#parameter-customroutesipampoolprefixallocationsnumberofipaddresses) | string | Number of IP addresses to allocate. |

### Parameter: `customRoutes.ipamPoolPrefixAllocations.pool`

Pool configuration for IPAM.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-customroutesipampoolprefixallocationspoolid) | string | Resource id of the associated Azure IpamPool resource. |

### Parameter: `customRoutes.ipamPoolPrefixAllocations.pool.id`

Resource id of the associated Azure IpamPool resource.

- Required: Yes
- Type: string

### Parameter: `customRoutes.ipamPoolPrefixAllocations.numberOfIpAddresses`

Number of IP addresses to allocate.

- Required: No
- Type: string

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `disableIPSecReplayProtection`

disableIPSecReplayProtection flag. Used for VPN Gateways.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `domainNameLabel`

DNS name(s) of the Public IP resource(s). If you enabled Active-Active mode, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableBgpRouteTranslationForNat`

EnableBgpRouteTranslationForNat flag. Can only be used when "natRules" are enabled on the Virtual Network Gateway.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableDnsForwarding`

Whether DNS forwarding is enabled or not and is only supported for Express Route Gateways. The DNS forwarding feature flag must be enabled on the current subscription.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePrivateIpAddress`

Whether private IP needs to be enabled on this gateway for connections or not. Used for configuring a Site-to-Site VPN connection over ExpressRoute private peering.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `existingPrimaryPublicIPResourceId`

The Public IP resource ID to associate to the Virtual Network Gateway. If empty, then a new Public IP will be created and applied to the Virtual Network Gateway.

- Required: No
- Type: string
- Default: `''`

### Parameter: `gatewayDefaultSiteLocalNetworkGatewayResourceId`

The reference to the LocalNetworkGateway resource which represents local network site having default routes. Assign Null value in case of removing existing default site setting.

- Required: No
- Type: string
- Default: `''`

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

### Parameter: `managedIdentity`

The managed identity definition for this resource. Supports system-assigned and user-assigned identities.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitysystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentityuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentity.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentity.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `natRules`

NatRules for virtual network gateway. NAT is supported on the the following SKUs: VpnGw2~5, VpnGw2AZ~5AZ and is supported for IPsec/IKE cross-premises connections only.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-natrulesname) | string | The name of the NAT rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`externalMappings`](#parameter-natrulesexternalmappings) | array | An address prefix range of destination IPs on the outside network that source IPs will be mapped to. In other words, your post-NAT address prefix range. |
| [`internalMappings`](#parameter-natrulesinternalmappings) | array | An address prefix range of source IPs on the inside network that will be mapped to a set of external IPs. In other words, your pre-NAT address prefix range. |
| [`ipConfigurationResourceId`](#parameter-natrulesipconfigurationresourceid) | string | A NAT rule must be configured to a specific Virtual Network Gateway instance. This is applicable to Dynamic NAT only. Static NAT rules are automatically applied to both Virtual Network Gateway instances. |
| [`mode`](#parameter-natrulesmode) | string | The type of NAT rule for Virtual Network NAT. IngressSnat mode (also known as Ingress Source NAT) is applicable to traffic entering the Azure hub's site-to-site Virtual Network gateway. EgressSnat mode (also known as Egress Source NAT) is applicable to traffic leaving the Azure hub's Site-to-site Virtual Network gateway. |
| [`type`](#parameter-natrulestype) | string | The type of NAT rule for Virtual Network NAT. Static one-to-one NAT establishes a one-to-one relationship between an internal address and an external address while Dynamic NAT assigns an IP and port based on availability. |

### Parameter: `natRules.name`

The name of the NAT rule.

- Required: Yes
- Type: string

### Parameter: `natRules.externalMappings`

An address prefix range of destination IPs on the outside network that source IPs will be mapped to. In other words, your post-NAT address prefix range.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressSpace`](#parameter-natrulesexternalmappingsaddressspace) | string | Address space for Vpn NatRule mapping. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`portRange`](#parameter-natrulesexternalmappingsportrange) | string | Port range for Vpn NatRule mapping. |

### Parameter: `natRules.externalMappings.addressSpace`

Address space for Vpn NatRule mapping.

- Required: Yes
- Type: string

### Parameter: `natRules.externalMappings.portRange`

Port range for Vpn NatRule mapping.

- Required: No
- Type: string

### Parameter: `natRules.internalMappings`

An address prefix range of source IPs on the inside network that will be mapped to a set of external IPs. In other words, your pre-NAT address prefix range.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressSpace`](#parameter-natrulesinternalmappingsaddressspace) | string | Address space for Vpn NatRule mapping. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`portRange`](#parameter-natrulesinternalmappingsportrange) | string | Port range for Vpn NatRule mapping. |

### Parameter: `natRules.internalMappings.addressSpace`

Address space for Vpn NatRule mapping.

- Required: Yes
- Type: string

### Parameter: `natRules.internalMappings.portRange`

Port range for Vpn NatRule mapping.

- Required: No
- Type: string

### Parameter: `natRules.ipConfigurationResourceId`

A NAT rule must be configured to a specific Virtual Network Gateway instance. This is applicable to Dynamic NAT only. Static NAT rules are automatically applied to both Virtual Network Gateway instances.

- Required: No
- Type: string

### Parameter: `natRules.mode`

The type of NAT rule for Virtual Network NAT. IngressSnat mode (also known as Ingress Source NAT) is applicable to traffic entering the Azure hub's site-to-site Virtual Network gateway. EgressSnat mode (also known as Egress Source NAT) is applicable to traffic leaving the Azure hub's Site-to-site Virtual Network gateway.

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

The type of NAT rule for Virtual Network NAT. Static one-to-one NAT establishes a one-to-one relationship between an internal address and an external address while Dynamic NAT assigns an IP and port based on availability.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'Static'
  ]
  ```

### Parameter: `primaryPublicIPName`

Specifies the name of the Public IP to be created for the Virtual Network Gateway. This will only take effect if no existing Public IP is provided. If neither an existing Public IP nor this parameter is specified, a new Public IP will be created with a default name, using the gateway's name with the '-pip1' suffix.

- Required: No
- Type: string
- Default: `[format('{0}-pip1', parameters('name'))]`

### Parameter: `publicIpDiagnosticSettings`

The diagnostic settings of the Public IP.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-publicipdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-publicipdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-publicipdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-publicipdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-publicipdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-publicipdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-publicipdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-publicipdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-publicipdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `publicIpDiagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `publicIpDiagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `publicIpDiagnosticSettings.logAnalyticsDestinationType`

A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureDiagnostics'
    'Dedicated'
  ]
  ```

### Parameter: `publicIpDiagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-publicipdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-publicipdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-publicipdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `publicIpDiagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `publicIpDiagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `publicIpDiagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `publicIpDiagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `publicIpDiagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-publicipdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-publicipdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `publicIpDiagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `publicIpDiagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `publicIpDiagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `publicIpDiagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `publicIpDiagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `publicIPPrefixResourceId`

Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix.

- Required: No
- Type: string
- Default: `''`

### Parameter: `publicIpZones`

Specifies the zones of the Public IP address. Basic IP SKU does not support Availability Zones.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `resiliencyModel`

Property to indicate if the Express Route Gateway has resiliency model of MultiHomed or SingleHomed. Only applicable for ExpressRoute gateways.

- Required: No
- Type: string
- Default: `'SingleHomed'`
- Allowed:
  ```Bicep
  [
    'MultiHomed'
    'SingleHomed'
  ]
  ```

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `skuName`

The SKU of the Gateway.

- Required: No
- Type: string
- Default: `[if(equals(parameters('gatewayType'), 'Vpn'), 'VpnGw1AZ', 'ErGw1AZ')]`
- Allowed:
  ```Bicep
  [
    'Basic'
    'ErGw1AZ'
    'ErGw2AZ'
    'ErGw3AZ'
    'ErGwScale'
    'HighPerformance'
    'Standard'
    'UltraPerformance'
    'VpnGw1'
    'VpnGw1AZ'
    'VpnGw2'
    'VpnGw2AZ'
    'VpnGw3'
    'VpnGw3AZ'
    'VpnGw4'
    'VpnGw4AZ'
    'VpnGw5'
    'VpnGw5AZ'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `vpnClientAadConfiguration`

Configuration for AAD Authentication for P2S Tunnel Type, Cannot be configured if clientRootCertData is provided.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`aadAudience`](#parameter-vpnclientaadconfigurationaadaudience) | string | The AAD audience property for VPN client connection used for AAD authentication. |
| [`aadIssuer`](#parameter-vpnclientaadconfigurationaadissuer) | string | The AAD issuer property for VPN client connection used for AAD authentication. |
| [`aadTenant`](#parameter-vpnclientaadconfigurationaadtenant) | string | The AAD tenant property for VPN client connection used for AAD authentication. |
| [`vpnAuthenticationTypes`](#parameter-vpnclientaadconfigurationvpnauthenticationtypes) | array | VPN authentication types for the virtual network gateway. |
| [`vpnClientProtocols`](#parameter-vpnclientaadconfigurationvpnclientprotocols) | array | VPN client protocols for Virtual network gateway. |

### Parameter: `vpnClientAadConfiguration.aadAudience`

The AAD audience property for VPN client connection used for AAD authentication.

- Required: Yes
- Type: string

### Parameter: `vpnClientAadConfiguration.aadIssuer`

The AAD issuer property for VPN client connection used for AAD authentication.

- Required: Yes
- Type: string

### Parameter: `vpnClientAadConfiguration.aadTenant`

The AAD tenant property for VPN client connection used for AAD authentication.

- Required: Yes
- Type: string

### Parameter: `vpnClientAadConfiguration.vpnAuthenticationTypes`

VPN authentication types for the virtual network gateway.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'AAD'
    'Certificate'
    'Radius'
  ]
  ```

### Parameter: `vpnClientAadConfiguration.vpnClientProtocols`

VPN client protocols for Virtual network gateway.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'IkeV2'
    'OpenVPN'
    'SSTP'
  ]
  ```

### Parameter: `vpnClientAddressPoolPrefix`

The IP address range from which VPN clients will receive an IP address when connected. Range specified must not overlap with on-premise network.

- Required: No
- Type: string
- Default: `''`

### Parameter: `vpnGatewayGeneration`

The generation for this VirtualNetworkGateway. Must be None if virtualNetworkGatewayType is not VPN.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'Generation1'
    'Generation2'
    'None'
  ]
  ```

### Parameter: `vpnType`

Specifies the VPN type.

- Required: No
- Type: string
- Default: `'RouteBased'`
- Allowed:
  ```Bicep
  [
    'PolicyBased'
    'RouteBased'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `activeActive` | bool | Shows if the virtual network gateway is configured in Active-Active mode. |
| `asn` | int | The ASN (Autonomous System Number) of the virtual network gateway. |
| `customBgpIpAddresses` | string | The primary custom Azure APIPA BGP IP address. |
| `defaultBgpIpAddresses` | string | The primary default Azure BGP peer IP address. |
| `ipConfigurations` | array | The IPconfigurations object of the Virtual Network Gateway. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the virtual network gateway. |
| `primaryPublicIpAddress` | string | The primary public IP address of the virtual network gateway. |
| `resourceGroupName` | string | The resource group the virtual network gateway was deployed. |
| `resourceId` | string | The resource ID of the virtual network gateway. |
| `secondaryCustomBgpIpAddress` | string | The secondary custom Azure APIPA BGP IP address (Active-Active mode). |
| `secondaryDefaultBgpIpAddress` | string | The secondary default Azure BGP peer IP address (Active-Active mode). |
| `secondaryPublicIpAddress` | string | The secondary public IP address of the virtual network gateway (Active-Active mode). |
| `tertiaryPublicIpAddress` | string | The tertiary public IP address of the virtual network gateway (Active-Active with P2S mode). |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/public-ip-address:0.8.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
