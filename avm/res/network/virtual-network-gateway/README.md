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
| `Microsoft.Network/publicIPAddresses` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/publicIPAddresses) |
| `Microsoft.Network/virtualNetworkGateways` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworkGateways) |
| `Microsoft.Network/virtualNetworkGateways/natRules` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworkGateways/natRules) |

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
- [Using only defaults](#example-8-using-only-defaults)
- [ExpressRoute](#example-9-expressroute)
- [Using large parameter set](#example-10-using-large-parameter-set)
- [Using SKU without Availability Zones](#example-11-using-sku-without-availability-zones)
- [VPN](#example-12-vpn)
- [WAF-aligned](#example-13-waf-aligned)

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
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgaab'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayId: '<gatewayDefaultSiteLocalNetworkGatewayId>'
    location: '<location>'
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
    "vNetResourceId": {
      "value": "<vNetResourceId>"
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
    "gatewayDefaultSiteLocalNetworkGatewayId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayId>"
    },
    "location": {
      "value": "<location>"
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
param vNetResourceId = '<vNetResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgaab'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayId = '<gatewayDefaultSiteLocalNetworkGatewayId>'
param location = '<location>'
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
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgaaa'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayId: '<gatewayDefaultSiteLocalNetworkGatewayId>'
    location: '<location>'
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
    "vNetResourceId": {
      "value": "<vNetResourceId>"
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
    "gatewayDefaultSiteLocalNetworkGatewayId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayId>"
    },
    "location": {
      "value": "<location>"
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
param vNetResourceId = '<vNetResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgaaa'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayId = '<gatewayDefaultSiteLocalNetworkGatewayId>'
param location = '<location>'
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
      existingSecondPipResourceId: '<existingSecondPipResourceId>'
    }
    gatewayType: 'Vpn'
    name: 'nvgaaep001'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgaaep'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    existingFirstPipResourceId: '<existingFirstPipResourceId>'
    gatewayDefaultSiteLocalNetworkGatewayId: '<gatewayDefaultSiteLocalNetworkGatewayId>'
    location: '<location>'
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
        "existingSecondPipResourceId": "<existingSecondPipResourceId>"
      }
    },
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgaaep001"
    },
    "vNetResourceId": {
      "value": "<vNetResourceId>"
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
    "existingFirstPipResourceId": {
      "value": "<existingFirstPipResourceId>"
    },
    "gatewayDefaultSiteLocalNetworkGatewayId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayId>"
    },
    "location": {
      "value": "<location>"
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
  existingSecondPipResourceId: '<existingSecondPipResourceId>'
}
param gatewayType = 'Vpn'
param name = 'nvgaaep001'
param vNetResourceId = '<vNetResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgaaep'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param existingFirstPipResourceId = '<existingFirstPipResourceId>'
param gatewayDefaultSiteLocalNetworkGatewayId = '<gatewayDefaultSiteLocalNetworkGatewayId>'
param location = '<location>'
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
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgaa'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayId: '<gatewayDefaultSiteLocalNetworkGatewayId>'
    location: '<location>'
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
    "vNetResourceId": {
      "value": "<vNetResourceId>"
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
    "gatewayDefaultSiteLocalNetworkGatewayId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayId>"
    },
    "location": {
      "value": "<location>"
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
param vNetResourceId = '<vNetResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgaa'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayId = '<gatewayDefaultSiteLocalNetworkGatewayId>'
param location = '<location>'
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
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgapb'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayId: '<gatewayDefaultSiteLocalNetworkGatewayId>'
    location: '<location>'
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
    "vNetResourceId": {
      "value": "<vNetResourceId>"
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
    "gatewayDefaultSiteLocalNetworkGatewayId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayId>"
    },
    "location": {
      "value": "<location>"
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
param vNetResourceId = '<vNetResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgapb'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayId = '<gatewayDefaultSiteLocalNetworkGatewayId>'
param location = '<location>'
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
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgapep'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    existingFirstPipResourceId: '<existingFirstPipResourceId>'
    gatewayDefaultSiteLocalNetworkGatewayId: '<gatewayDefaultSiteLocalNetworkGatewayId>'
    location: '<location>'
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
    "vNetResourceId": {
      "value": "<vNetResourceId>"
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
    "existingFirstPipResourceId": {
      "value": "<existingFirstPipResourceId>"
    },
    "gatewayDefaultSiteLocalNetworkGatewayId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayId>"
    },
    "location": {
      "value": "<location>"
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
param vNetResourceId = '<vNetResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgapep'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param existingFirstPipResourceId = '<existingFirstPipResourceId>'
param gatewayDefaultSiteLocalNetworkGatewayId = '<gatewayDefaultSiteLocalNetworkGatewayId>'
param location = '<location>'
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
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgap'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayId: '<gatewayDefaultSiteLocalNetworkGatewayId>'
    location: '<location>'
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
    "vNetResourceId": {
      "value": "<vNetResourceId>"
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
    "gatewayDefaultSiteLocalNetworkGatewayId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayId>"
    },
    "location": {
      "value": "<location>"
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
param vNetResourceId = '<vNetResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgap'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayId = '<gatewayDefaultSiteLocalNetworkGatewayId>'
param location = '<location>'
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

### Example 8: _Using only defaults_

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
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    location: '<location>'
    publicIpZones: [
      1
      2
      3
    ]
    skuName: 'VpnGw2AZ'
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
    "vNetResourceId": {
      "value": "<vNetResourceId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
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
param vNetResourceId = '<vNetResourceId>'
// Non-required parameters
param location = '<location>'
param publicIpZones = [
  1
  2
  3
]
param skuName = 'VpnGw2AZ'
```

</details>
<p>

### Example 9: _ExpressRoute_

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
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    domainNameLabel: [
      'dm-nvger'
    ]
    firstPipName: 'pip-nvger'
    location: '<location>'
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
    "vNetResourceId": {
      "value": "<vNetResourceId>"
    },
    // Non-required parameters
    "domainNameLabel": {
      "value": [
        "dm-nvger"
      ]
    },
    "firstPipName": {
      "value": "pip-nvger"
    },
    "location": {
      "value": "<location>"
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
param vNetResourceId = '<vNetResourceId>'
// Non-required parameters
param domainNameLabel = [
  'dm-nvger'
]
param firstPipName = 'pip-nvger'
param location = '<location>'
param publicIpZones = [
  1
  2
  3
]
param skuName = 'ErGw1AZ'
```

</details>
<p>

### Example 10: _Using large parameter set_

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
    vNetResourceId: '<vNetResourceId>'
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
    gatewayDefaultSiteLocalNetworkGatewayId: '<gatewayDefaultSiteLocalNetworkGatewayId>'
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
    "vNetResourceId": {
      "value": "<vNetResourceId>"
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
    "gatewayDefaultSiteLocalNetworkGatewayId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayId>"
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
param vNetResourceId = '<vNetResourceId>'
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
param gatewayDefaultSiteLocalNetworkGatewayId = '<gatewayDefaultSiteLocalNetworkGatewayId>'
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

### Example 11: _Using SKU without Availability Zones_

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
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    location: '<location>'
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
    "vNetResourceId": {
      "value": "<vNetResourceId>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
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
param vNetResourceId = '<vNetResourceId>'
// Non-required parameters
param location = '<location>'
param publicIpZones = []
param skuName = 'VpnGw1'
```

</details>
<p>

### Example 12: _VPN_

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
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    allowRemoteVnetTraffic: true
    disableIPSecReplayProtection: true
    domainNameLabel: [
      'dm-nvgvpn'
    ]
    enableBgpRouteTranslationForNat: true
    enablePrivateIpAddress: true
    gatewayDefaultSiteLocalNetworkGatewayId: '<gatewayDefaultSiteLocalNetworkGatewayId>'
    location: '<location>'
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
    "vNetResourceId": {
      "value": "<vNetResourceId>"
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
    "gatewayDefaultSiteLocalNetworkGatewayId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayId>"
    },
    "location": {
      "value": "<location>"
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
param vNetResourceId = '<vNetResourceId>'
// Non-required parameters
param allowRemoteVnetTraffic = true
param disableIPSecReplayProtection = true
param domainNameLabel = [
  'dm-nvgvpn'
]
param enableBgpRouteTranslationForNat = true
param enablePrivateIpAddress = true
param gatewayDefaultSiteLocalNetworkGatewayId = '<gatewayDefaultSiteLocalNetworkGatewayId>'
param location = '<location>'
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

### Example 13: _WAF-aligned_

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
    vNetResourceId: '<vNetResourceId>'
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
    gatewayDefaultSiteLocalNetworkGatewayId: '<gatewayDefaultSiteLocalNetworkGatewayId>'
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
    "vNetResourceId": {
      "value": "<vNetResourceId>"
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
    "gatewayDefaultSiteLocalNetworkGatewayId": {
      "value": "<gatewayDefaultSiteLocalNetworkGatewayId>"
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
param vNetResourceId = '<vNetResourceId>'
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
param gatewayDefaultSiteLocalNetworkGatewayId = '<gatewayDefaultSiteLocalNetworkGatewayId>'
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
| [`skuName`](#parameter-skuname) | string | The SKU of the Gateway. |
| [`vNetResourceId`](#parameter-vnetresourceid) | string | Virtual Network resource ID. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowRemoteVnetTraffic`](#parameter-allowremotevnettraffic) | bool | Configure this gateway to accept traffic from other Azure Virtual Networks. This configuration does not support connectivity to Azure Virtual WAN. |
| [`allowVirtualWanTraffic`](#parameter-allowvirtualwantraffic) | bool | Configures this gateway to accept traffic from remote Virtual WAN networks. |
| [`clientRevokedCertThumbprint`](#parameter-clientrevokedcertthumbprint) | string | Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet. |
| [`clientRootCertData`](#parameter-clientrootcertdata) | string | Client root certificate data used to authenticate VPN clients. Cannot be configured if vpnClientAadConfiguration is provided. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableIPSecReplayProtection`](#parameter-disableipsecreplayprotection) | bool | disableIPSecReplayProtection flag. Used for VPN Gateways. |
| [`domainNameLabel`](#parameter-domainnamelabel) | array | DNS name(s) of the Public IP resource(s). If you enabled Active-Active mode, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com. |
| [`enableBgpRouteTranslationForNat`](#parameter-enablebgproutetranslationfornat) | bool | EnableBgpRouteTranslationForNat flag. Can only be used when "natRules" are enabled on the Virtual Network Gateway. |
| [`enableDnsForwarding`](#parameter-enablednsforwarding) | bool | Whether DNS forwarding is enabled or not and is only supported for Express Route Gateways. The DNS forwarding feature flag must be enabled on the current subscription. |
| [`enablePrivateIpAddress`](#parameter-enableprivateipaddress) | bool | Whether private IP needs to be enabled on this gateway for connections or not. Used for configuring a Site-to-Site VPN connection over ExpressRoute private peering. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`existingFirstPipResourceId`](#parameter-existingfirstpipresourceid) | string | The Public IP resource ID to associate to the Virtual Network Gateway. If empty, then a new Public IP will be created and applied to the Virtual Network Gateway. |
| [`firstPipName`](#parameter-firstpipname) | string | Specifies the name of the Public IP to be created for the Virtual Network Gateway. This will only take effect if no existing Public IP is provided. If neither an existing Public IP nor this parameter is specified, a new Public IP will be created with a default name, using the gateway's name with the '-pip1' suffix. |
| [`gatewayDefaultSiteLocalNetworkGatewayId`](#parameter-gatewaydefaultsitelocalnetworkgatewayid) | string | The reference to the LocalNetworkGateway resource which represents local network site having default routes. Assign Null value in case of removing existing default site setting. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`natRules`](#parameter-natrules) | array | NatRules for virtual network gateway. NAT is supported on the the following SKUs: VpnGw2~5, VpnGw2AZ~5AZ and is supported for IPsec/IKE cross-premises connections only. |
| [`publicIpDiagnosticSettings`](#parameter-publicipdiagnosticsettings) | array | The diagnostic settings of the Public IP. |
| [`publicIPPrefixResourceId`](#parameter-publicipprefixresourceid) | string | Resource ID of the Public IP Prefix object. This is only needed if you want your Public IPs created in a PIP Prefix. |
| [`publicIpZones`](#parameter-publicipzones) | array | Specifies the zones of the Public IP address. Basic IP SKU does not support Availability Zones. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`vpnClientAadConfiguration`](#parameter-vpnclientaadconfiguration) | object | Configuration for AAD Authentication for P2S Tunnel Type, Cannot be configured if clientRootCertData is provided. |
| [`vpnClientAddressPoolPrefix`](#parameter-vpnclientaddresspoolprefix) | string | The IP address range from which VPN clients will receive an IP address when connected. Range specified must not overlap with on-premise network. |
| [`vpnGatewayGeneration`](#parameter-vpngatewaygeneration) | string | The generation for this VirtualNetworkGateway. Must be None if virtualNetworkGatewayType is not VPN. |
| [`vpnType`](#parameter-vpntype) | string | Specifies the VPN type. |

### Parameter: `clusterSettings`

Specifies one of the following four configurations: Active-Active with (clusterMode = activeActiveBgp) or without (clusterMode = activeActiveNoBgp) BGP, Active-Passive with (clusterMode = activePassiveBgp) or without (clusterMode = activePassiveNoBgp) BGP.

- Required: Yes
- Type: object

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

### Parameter: `skuName`

The SKU of the Gateway.

- Required: No
- Type: string
- Default: `[if(equals(parameters('gatewayType'), 'VPN'), 'VpnGw1AZ', 'ErGw1AZ')]`
- Allowed:
  ```Bicep
  [
    'Basic'
    'ErGw1AZ'
    'ErGw2AZ'
    'ErGw3AZ'
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

### Parameter: `vNetResourceId`

Virtual Network resource ID.

- Required: Yes
- Type: string

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
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
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

The name of diagnostic setting.

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

### Parameter: `existingFirstPipResourceId`

The Public IP resource ID to associate to the Virtual Network Gateway. If empty, then a new Public IP will be created and applied to the Virtual Network Gateway.

- Required: No
- Type: string
- Default: `''`

### Parameter: `firstPipName`

Specifies the name of the Public IP to be created for the Virtual Network Gateway. This will only take effect if no existing Public IP is provided. If neither an existing Public IP nor this parameter is specified, a new Public IP will be created with a default name, using the gateway's name with the '-pip1' suffix.

- Required: No
- Type: string
- Default: `[format('{0}-pip1', parameters('name'))]`

### Parameter: `gatewayDefaultSiteLocalNetworkGatewayId`

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

### Parameter: `natRules`

NatRules for virtual network gateway. NAT is supported on the the following SKUs: VpnGw2~5, VpnGw2AZ~5AZ and is supported for IPsec/IKE cross-premises connections only.

- Required: No
- Type: array
- Default: `[]`

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
| [`name`](#parameter-publicipdiagnosticsettingsname) | string | The name of diagnostic setting. |
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

The name of diagnostic setting.

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

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `vpnClientAadConfiguration`

Configuration for AAD Authentication for P2S Tunnel Type, Cannot be configured if clientRootCertData is provided.

- Required: No
- Type: object
- Default: `{}`

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
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the virtual network gateway. |
| `resourceGroupName` | string | The resource group the virtual network gateway was deployed. |
| `resourceId` | string | The resource ID of the virtual network gateway. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/public-ip-address:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
