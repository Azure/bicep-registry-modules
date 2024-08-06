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

- [AAD-VPN](#example-1-aad-vpn)
- [Using only defaults](#example-2-using-only-defaults)
- [ExpressRoute](#example-3-expressroute)
- [Using large parameter set](#example-4-using-large-parameter-set)
- [Using SKU without Availability Zones](#example-5-using-sku-without-availability-zones)
- [VPN](#example-6-vpn)
- [WAF-aligned](#example-7-waf-aligned)

### Example 1: _AAD-VPN_

This instance deploys the module with the AAD set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    gatewayType: 'Vpn'
    name: 'nvngavpn001'
    skuName: 'VpnGw2AZ'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    activeActive: false
    domainNameLabel: [
      'dm-nvngavpn'
    ]
    location: '<location>'
    publicIpZones: [
      1
      2
      3
    ]
    vpnClientAadConfiguration: {
      aadAudience: '41b23e61-6c1e-4545-b367-cd054e0ed4b4'
      aadIssuer: '<aadIssuer>'
      aadTenant: '<aadTenant>'
      vpnAuthenticationTypes: [
        'AAD'
      ]
      vpnClientProtocols: [
        'OpenVPN'
      ]
    }
    vpnType: 'RouteBased'
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
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvngavpn001"
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vNetResourceId": {
      "value": "<vNetResourceId>"
    },
    // Non-required parameters
    "activeActive": {
      "value": false
    },
    "domainNameLabel": {
      "value": [
        "dm-nvngavpn"
      ]
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
    "vpnClientAadConfiguration": {
      "value": {
        "aadAudience": "41b23e61-6c1e-4545-b367-cd054e0ed4b4",
        "aadIssuer": "<aadIssuer>",
        "aadTenant": "<aadTenant>",
        "vpnAuthenticationTypes": [
          "AAD"
        ],
        "vpnClientProtocols": [
          "OpenVPN"
        ]
      }
    },
    "vpnType": {
      "value": "RouteBased"
    }
  }
}
```

</details>
<p>

### Example 2: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    gatewayType: 'Vpn'
    name: 'nvgmin001'
    skuName: 'VpnGw2AZ'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    location: '<location>'
    publicIpZones: [
      1
      2
      3
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
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgmin001"
    },
    "skuName": {
      "value": "VpnGw2AZ"
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
    }
  }
}
```

</details>
<p>

### Example 3: _ExpressRoute_

This instance deploys the module with the ExpressRoute set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    gatewayType: 'ExpressRoute'
    name: 'nvger001'
    skuName: 'ErGw1AZ'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    domainNameLabel: [
      'dm-nvger'
    ]
    gatewayPipName: 'pip-nvger'
    location: '<location>'
    publicIpZones: [
      1
      2
      3
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
    "gatewayType": {
      "value": "ExpressRoute"
    },
    "name": {
      "value": "nvger001"
    },
    "skuName": {
      "value": "ErGw1AZ"
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
    "gatewayPipName": {
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
    }
  }
}
```

</details>
<p>

### Example 4: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    gatewayType: 'Vpn'
    name: 'nvgmax001'
    skuName: 'VpnGw2AZ'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    activeActive: true
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgmax001"
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vNetResourceId": {
      "value": "<vNetResourceId>"
    },
    // Non-required parameters
    "activeActive": {
      "value": true
    },
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

### Example 5: _Using SKU without Availability Zones_

This instance deploys the module with a SKU that does not support Availability Zones.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    gatewayType: 'Vpn'
    name: 'nvgnaz001'
    skuName: 'VpnGw1'
    vNetResourceId: '<vNetResourceId>'
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
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgnaz001"
    },
    "skuName": {
      "value": "VpnGw1"
    },
    "vNetResourceId": {
      "value": "<vNetResourceId>"
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

### Example 6: _VPN_

This instance deploys the module with the VPN set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    gatewayType: 'Vpn'
    name: 'nvgvpn001'
    skuName: 'VpnGw2AZ'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    activeActive: true
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
    vpnGatewayGeneration: 'Generation2'
    vpnType: 'RouteBased'
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
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgvpn001"
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vNetResourceId": {
      "value": "<vNetResourceId>"
    },
    // Non-required parameters
    "activeActive": {
      "value": true
    },
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

### Example 7: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetworkGateway 'br/public:avm/res/network/virtual-network-gateway:<version>' = {
  name: 'virtualNetworkGatewayDeployment'
  params: {
    // Required parameters
    gatewayType: 'Vpn'
    name: 'nvgmwaf001'
    skuName: 'VpnGw2AZ'
    vNetResourceId: '<vNetResourceId>'
    // Non-required parameters
    activeActive: true
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "gatewayType": {
      "value": "Vpn"
    },
    "name": {
      "value": "nvgmwaf001"
    },
    "skuName": {
      "value": "VpnGw2AZ"
    },
    "vNetResourceId": {
      "value": "<vNetResourceId>"
    },
    // Non-required parameters
    "activeActive": {
      "value": true
    },
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`gatewayType`](#parameter-gatewaytype) | string | Specifies the gateway type. E.g. VPN, ExpressRoute. |
| [`name`](#parameter-name) | string | Specifies the Virtual Network Gateway name. |
| [`skuName`](#parameter-skuname) | string | The SKU of the Gateway. |
| [`vNetResourceId`](#parameter-vnetresourceid) | string | Virtual Network resource ID. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`activeActive`](#parameter-activeactive) | bool | Value to specify if the Gateway should be deployed in active-active or active-passive configuration. |
| [`activeGatewayPipName`](#parameter-activegatewaypipname) | string | Specifies the name of the Public IP used by the Virtual Network Gateway when active-active configuration is required. If it's not provided, a '-pip' suffix will be appended to the gateway's name. |
| [`allowRemoteVnetTraffic`](#parameter-allowremotevnettraffic) | bool | Configure this gateway to accept traffic from other Azure Virtual Networks. This configuration does not support connectivity to Azure Virtual WAN. |
| [`allowVirtualWanTraffic`](#parameter-allowvirtualwantraffic) | bool | Configures this gateway to accept traffic from remote Virtual WAN networks. |
| [`asn`](#parameter-asn) | int | ASN value. |
| [`clientRevokedCertThumbprint`](#parameter-clientrevokedcertthumbprint) | string | Thumbprint of the revoked certificate. This would revoke VPN client certificates matching this thumbprint from connecting to the VNet. |
| [`clientRootCertData`](#parameter-clientrootcertdata) | string | Client root certificate data used to authenticate VPN clients. Cannot be configured if vpnClientAadConfiguration is provided. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`disableIPSecReplayProtection`](#parameter-disableipsecreplayprotection) | bool | disableIPSecReplayProtection flag. Used for VPN Gateways. |
| [`domainNameLabel`](#parameter-domainnamelabel) | array | DNS name(s) of the Public IP resource(s). If you enabled active-active configuration, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com. |
| [`enableBgp`](#parameter-enablebgp) | bool | Value to specify if BGP is enabled or not. |
| [`enableBgpRouteTranslationForNat`](#parameter-enablebgproutetranslationfornat) | bool | EnableBgpRouteTranslationForNat flag. Can only be used when "natRules" are enabled on the Virtual Network Gateway. |
| [`enableDnsForwarding`](#parameter-enablednsforwarding) | bool | Whether DNS forwarding is enabled or not and is only supported for Express Route Gateways. The DNS forwarding feature flag must be enabled on the current subscription. |
| [`enablePrivateIpAddress`](#parameter-enableprivateipaddress) | bool | Whether private IP needs to be enabled on this gateway for connections or not. Used for configuring a Site-to-Site VPN connection over ExpressRoute private peering. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`gatewayDefaultSiteLocalNetworkGatewayId`](#parameter-gatewaydefaultsitelocalnetworkgatewayid) | string | The reference to the LocalNetworkGateway resource which represents local network site having default routes. Assign Null value in case of removing existing default site setting. |
| [`gatewayPipName`](#parameter-gatewaypipname) | string | Specifies the name of the Public IP used by the Virtual Network Gateway. If it's not provided, a '-pip' suffix will be appended to the gateway's name. |
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

- Required: Yes
- Type: string
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

### Parameter: `activeActive`

Value to specify if the Gateway should be deployed in active-active or active-passive configuration.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `activeGatewayPipName`

Specifies the name of the Public IP used by the Virtual Network Gateway when active-active configuration is required. If it's not provided, a '-pip' suffix will be appended to the gateway's name.

- Required: No
- Type: string
- Default: `[format('{0}-pip2', parameters('name'))]`

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

### Parameter: `asn`

ASN value.

- Required: No
- Type: int
- Default: `65815`

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

DNS name(s) of the Public IP resource(s). If you enabled active-active configuration, you need to provide 2 DNS names, if you want to use this feature. A region specific suffix will be appended to it, e.g.: your-DNS-name.westeurope.cloudapp.azure.com.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableBgp`

Value to specify if BGP is enabled or not.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `gatewayDefaultSiteLocalNetworkGatewayId`

The reference to the LocalNetworkGateway resource which represents local network site having default routes. Assign Null value in case of removing existing default site setting.

- Required: No
- Type: string
- Default: `''`

### Parameter: `gatewayPipName`

Specifies the name of the Public IP used by the Virtual Network Gateway. If it's not provided, a '-pip' suffix will be appended to the gateway's name.

- Required: No
- Type: string
- Default: `[format('{0}-pip1', parameters('name'))]`

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
- Default: `[]`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

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
| `activeActive` | bool | Shows if the virtual network gateway is configured in active-active mode. |
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
