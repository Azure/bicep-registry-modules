# ExpressRoute Circuits `[Microsoft.Network/expressRouteCircuits]`

This module deploys an Express Route Circuit.

You can reference the module as follows:
```bicep
module expressRouteCircuit 'br/public:avm/res/network/express-route-circuit:<version>' = {
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
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Network/expressRouteCircuits` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_expressroutecircuits.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/expressRouteCircuits)</li></ul> |
| `Microsoft.Network/expressRouteCircuits/peerings/connections` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_expressroutecircuits_peerings_connections.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/expressRouteCircuits/peerings/connections)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/express-route-circuit:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using Global Reach connections](#example-2-using-global-reach-connections)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module expressRouteCircuit 'br/public:avm/res/network/express-route-circuit:<version>' = {
  params: {
    // Required parameters
    name: 'nercmin001'
    // Non-required parameters
    bandwidthInMbps: 50
    location: '<location>'
    peeringLocation: 'Amsterdam'
    serviceProviderName: 'Equinix'
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
      "value": "nercmin001"
    },
    // Non-required parameters
    "bandwidthInMbps": {
      "value": 50
    },
    "location": {
      "value": "<location>"
    },
    "peeringLocation": {
      "value": "Amsterdam"
    },
    "serviceProviderName": {
      "value": "Equinix"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/express-route-circuit:<version>'

// Required parameters
param name = 'nercmin001'
// Non-required parameters
param bandwidthInMbps = 50
param location = '<location>'
param peeringLocation = 'Amsterdam'
param serviceProviderName = 'Equinix'
```

</details>
<p>

### Example 2: _Using Global Reach connections_

This instance deploys two ExpressRoute circuits with a Global Reach connection between them.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/global-reach]


<details>

<summary>via Bicep module</summary>

```bicep
module expressRouteCircuit 'br/public:avm/res/network/express-route-circuit:<version>' = {
  params: {
    // Required parameters
    name: 'nercgr002'
    // Non-required parameters
    bandwidthInGbps: 10
    connections: [
      {
        addressPrefix: '192.168.8.0/29'
        name: 'connection-to-circuit1'
        peerExpressRouteCircuitPeeringId: '<peerExpressRouteCircuitPeeringId>'
        peeringName: 'AzurePrivatePeering'
      }
    ]
    expressRoutePortResourceId: '<expressRoutePortResourceId>'
    globalReachEnabled: true
    location: '<location>'
    peeringLocation: 'Amsterdam'
    peerings: [
      {
        name: 'AzurePrivatePeering'
        properties: {
          peerASN: 65001
          peeringType: 'AzurePrivatePeering'
          primaryPeerAddressPrefix: '10.0.0.0/30'
          secondaryPeerAddressPrefix: '10.0.0.4/30'
          state: 'Enabled'
          vlanId: 100
        }
      }
    ]
    serviceProviderName: 'Equinix'
    skuFamily: 'MeteredData'
    skuTier: 'Premium'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
      "value": "nercgr002"
    },
    // Non-required parameters
    "bandwidthInGbps": {
      "value": 10
    },
    "connections": {
      "value": [
        {
          "addressPrefix": "192.168.8.0/29",
          "name": "connection-to-circuit1",
          "peerExpressRouteCircuitPeeringId": "<peerExpressRouteCircuitPeeringId>",
          "peeringName": "AzurePrivatePeering"
        }
      ]
    },
    "expressRoutePortResourceId": {
      "value": "<expressRoutePortResourceId>"
    },
    "globalReachEnabled": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "peeringLocation": {
      "value": "Amsterdam"
    },
    "peerings": {
      "value": [
        {
          "name": "AzurePrivatePeering",
          "properties": {
            "peerASN": 65001,
            "peeringType": "AzurePrivatePeering",
            "primaryPeerAddressPrefix": "10.0.0.0/30",
            "secondaryPeerAddressPrefix": "10.0.0.4/30",
            "state": "Enabled",
            "vlanId": 100
          }
        }
      ]
    },
    "serviceProviderName": {
      "value": "Equinix"
    },
    "skuFamily": {
      "value": "MeteredData"
    },
    "skuTier": {
      "value": "Premium"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/express-route-circuit:<version>'

// Required parameters
param name = 'nercgr002'
// Non-required parameters
param bandwidthInGbps = 10
param connections = [
  {
    addressPrefix: '192.168.8.0/29'
    name: 'connection-to-circuit1'
    peerExpressRouteCircuitPeeringId: '<peerExpressRouteCircuitPeeringId>'
    peeringName: 'AzurePrivatePeering'
  }
]
param expressRoutePortResourceId = '<expressRoutePortResourceId>'
param globalReachEnabled = true
param location = '<location>'
param peeringLocation = 'Amsterdam'
param peerings = [
  {
    name: 'AzurePrivatePeering'
    properties: {
      peerASN: 65001
      peeringType: 'AzurePrivatePeering'
      primaryPeerAddressPrefix: '10.0.0.0/30'
      secondaryPeerAddressPrefix: '10.0.0.4/30'
      state: 'Enabled'
      vlanId: 100
    }
  }
]
param serviceProviderName = 'Equinix'
param skuFamily = 'MeteredData'
param skuTier = 'Premium'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module expressRouteCircuit 'br/public:avm/res/network/express-route-circuit:<version>' = {
  params: {
    // Required parameters
    name: 'nercmax001'
    // Non-required parameters
    allowClassicOperations: true
    bandwidthInMbps: 50
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
    enableDirectPortRateLimit: true
    globalReachEnabled: true
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    peeringLocation: 'Amsterdam'
    peerings: [
      {
        name: 'AzurePrivatePeering'
        properties: {
          ipv6PeeringConfig: {
            primaryPeerAddressPrefix: '2001:db8::/126'
            secondaryPeerAddressPrefix: '2001:db8::8/126'
          }
          peerASN: 65001
          peeringType: 'AzurePrivatePeering'
          primaryPeerAddressPrefix: '10.0.0.0/30'
          secondaryPeerAddressPrefix: '10.0.0.4/30'
          state: 'Enabled'
          vlanId: 100
        }
      }
      {
        name: 'MicrosoftPeering'
        properties: {
          ipv6PeeringConfig: {
            microsoftPeeringConfig: {
              advertisedPublicPrefixes: [
                '2001:db8:200::/48'
              ]
              customerASN: 65002
              routingRegistryName: 'ARIN'
            }
            primaryPeerAddressPrefix: '2001:db8:100::/126'
            secondaryPeerAddressPrefix: '2001:db8:100::8/126'
          }
          microsoftPeeringConfig: {
            advertisedPublicPrefixes: [
              '203.0.113.0/24'
            ]
            customerASN: 65002
            routingRegistryName: 'ARIN'
          }
          peerASN: 65002
          peeringType: 'MicrosoftPeering'
          primaryPeerAddressPrefix: '203.0.113.0/30'
          secondaryPeerAddressPrefix: '203.0.113.4/30'
          state: 'Disabled'
          vlanId: 200
        }
      }
    ]
    roleAssignments: [
      {
        name: 'd7aa3dfa-6ba6-4ed8-b561-2164fbb1327e'
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
    serviceProviderName: 'Equinix'
    skuFamily: 'MeteredData'
    skuTier: 'Standard'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
      "value": "nercmax001"
    },
    // Non-required parameters
    "allowClassicOperations": {
      "value": true
    },
    "bandwidthInMbps": {
      "value": 50
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
    "enableDirectPortRateLimit": {
      "value": true
    },
    "globalReachEnabled": {
      "value": true
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
    "peeringLocation": {
      "value": "Amsterdam"
    },
    "peerings": {
      "value": [
        {
          "name": "AzurePrivatePeering",
          "properties": {
            "ipv6PeeringConfig": {
              "primaryPeerAddressPrefix": "2001:db8::/126",
              "secondaryPeerAddressPrefix": "2001:db8::8/126"
            },
            "peerASN": 65001,
            "peeringType": "AzurePrivatePeering",
            "primaryPeerAddressPrefix": "10.0.0.0/30",
            "secondaryPeerAddressPrefix": "10.0.0.4/30",
            "state": "Enabled",
            "vlanId": 100
          }
        },
        {
          "name": "MicrosoftPeering",
          "properties": {
            "ipv6PeeringConfig": {
              "microsoftPeeringConfig": {
                "advertisedPublicPrefixes": [
                  "2001:db8:200::/48"
                ],
                "customerASN": 65002,
                "routingRegistryName": "ARIN"
              },
              "primaryPeerAddressPrefix": "2001:db8:100::/126",
              "secondaryPeerAddressPrefix": "2001:db8:100::8/126"
            },
            "microsoftPeeringConfig": {
              "advertisedPublicPrefixes": [
                "203.0.113.0/24"
              ],
              "customerASN": 65002,
              "routingRegistryName": "ARIN"
            },
            "peerASN": 65002,
            "peeringType": "MicrosoftPeering",
            "primaryPeerAddressPrefix": "203.0.113.0/30",
            "secondaryPeerAddressPrefix": "203.0.113.4/30",
            "state": "Disabled",
            "vlanId": 200
          }
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "d7aa3dfa-6ba6-4ed8-b561-2164fbb1327e",
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
    "serviceProviderName": {
      "value": "Equinix"
    },
    "skuFamily": {
      "value": "MeteredData"
    },
    "skuTier": {
      "value": "Standard"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/express-route-circuit:<version>'

// Required parameters
param name = 'nercmax001'
// Non-required parameters
param allowClassicOperations = true
param bandwidthInMbps = 50
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
param enableDirectPortRateLimit = true
param globalReachEnabled = true
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param peeringLocation = 'Amsterdam'
param peerings = [
  {
    name: 'AzurePrivatePeering'
    properties: {
      ipv6PeeringConfig: {
        primaryPeerAddressPrefix: '2001:db8::/126'
        secondaryPeerAddressPrefix: '2001:db8::8/126'
      }
      peerASN: 65001
      peeringType: 'AzurePrivatePeering'
      primaryPeerAddressPrefix: '10.0.0.0/30'
      secondaryPeerAddressPrefix: '10.0.0.4/30'
      state: 'Enabled'
      vlanId: 100
    }
  }
  {
    name: 'MicrosoftPeering'
    properties: {
      ipv6PeeringConfig: {
        microsoftPeeringConfig: {
          advertisedPublicPrefixes: [
            '2001:db8:200::/48'
          ]
          customerASN: 65002
          routingRegistryName: 'ARIN'
        }
        primaryPeerAddressPrefix: '2001:db8:100::/126'
        secondaryPeerAddressPrefix: '2001:db8:100::8/126'
      }
      microsoftPeeringConfig: {
        advertisedPublicPrefixes: [
          '203.0.113.0/24'
        ]
        customerASN: 65002
        routingRegistryName: 'ARIN'
      }
      peerASN: 65002
      peeringType: 'MicrosoftPeering'
      primaryPeerAddressPrefix: '203.0.113.0/30'
      secondaryPeerAddressPrefix: '203.0.113.4/30'
      state: 'Disabled'
      vlanId: 200
    }
  }
]
param roleAssignments = [
  {
    name: 'd7aa3dfa-6ba6-4ed8-b561-2164fbb1327e'
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
param serviceProviderName = 'Equinix'
param skuFamily = 'MeteredData'
param skuTier = 'Standard'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module expressRouteCircuit 'br/public:avm/res/network/express-route-circuit:<version>' = {
  params: {
    // Required parameters
    name: 'nercwaf001'
    // Non-required parameters
    allowClassicOperations: true
    bandwidthInMbps: 50
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
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    peeringLocation: 'Amsterdam'
    serviceProviderName: 'Equinix'
    skuFamily: 'MeteredData'
    skuTier: 'Standard'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
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
      "value": "nercwaf001"
    },
    // Non-required parameters
    "allowClassicOperations": {
      "value": true
    },
    "bandwidthInMbps": {
      "value": 50
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
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "peeringLocation": {
      "value": "Amsterdam"
    },
    "serviceProviderName": {
      "value": "Equinix"
    },
    "skuFamily": {
      "value": "MeteredData"
    },
    "skuTier": {
      "value": "Standard"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/express-route-circuit:<version>'

// Required parameters
param name = 'nercwaf001'
// Non-required parameters
param allowClassicOperations = true
param bandwidthInMbps = 50
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
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param peeringLocation = 'Amsterdam'
param serviceProviderName = 'Equinix'
param skuFamily = 'MeteredData'
param skuTier = 'Standard'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | This is the name of the ExpressRoute circuit. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`bandwidthInGbps`](#parameter-bandwidthingbps) | int | Required if 'serviceProviderName', 'peeringLocation', and 'bandwidthInMbps' are not set. The bandwidth of the circuit when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct. Default value of 0 will set the property to null. |
| [`bandwidthInMbps`](#parameter-bandwidthinmbps) | int | Required if 'expressRoutePortResourceId' is not set. This is the bandwidth in Mbps of the circuit being created. It must exactly match one of the available bandwidth offers List ExpressRoute Service Providers API call. |
| [`expressRoutePortResourceId`](#parameter-expressrouteportresourceid) | string | Required if 'serviceProviderName', 'peeringLocation', and 'bandwidthInMbps' are not set. The reference to the ExpressRoutePort resource when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct. |
| [`peeringLocation`](#parameter-peeringlocation) | string | Required if 'expressRoutePortResourceId' is not set. This is the name of the peering location and not the ARM resource location. It must exactly match one of the available peering locations from List ExpressRoute Service Providers API call. |
| [`serviceProviderName`](#parameter-serviceprovidername) | string | Required if 'expressRoutePortResourceId' is not set. This is the name of the ExpressRoute Service Provider. It must exactly match one of the Service Providers from List ExpressRoute Service Providers API call. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowClassicOperations`](#parameter-allowclassicoperations) | bool | Allow classic operations. You can connect to virtual networks in the classic deployment model by setting allowClassicOperations to true. |
| [`authorizationNames`](#parameter-authorizationnames) | array | List of names for ExpressRoute circuit authorizations to create. To fetch the `authorizationKey` for the authorization, use the `existing` resource reference for `Microsoft.Network/expressRouteCircuits/authorizations`. |
| [`connections`](#parameter-connections) | array | Array of Global Reach connection configurations for peerings. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableDirectPortRateLimit`](#parameter-enabledirectportratelimit) | bool | Flag denoting rate-limiting status of the ExpressRoute direct-port circuit. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`globalReachEnabled`](#parameter-globalreachenabled) | bool | Flag denoting global reach status. To enable ExpressRoute Global Reach between different geopolitical regions, your circuits must be Premium SKU. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`peerings`](#parameter-peerings) | array | Array of peering configurations for the ExpressRoute circuit. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`skuFamily`](#parameter-skufamily) | string | Chosen SKU family of ExpressRoute circuit. Choose from MeteredData or UnlimitedData SKU families. |
| [`skuTier`](#parameter-skutier) | string | Chosen SKU Tier of ExpressRoute circuit. Choose from Local, Premium or Standard SKU tiers. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

This is the name of the ExpressRoute circuit.

- Required: Yes
- Type: string

### Parameter: `bandwidthInGbps`

Required if 'serviceProviderName', 'peeringLocation', and 'bandwidthInMbps' are not set. The bandwidth of the circuit when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct. Default value of 0 will set the property to null.

- Required: No
- Type: int
- Default: `0`

### Parameter: `bandwidthInMbps`

Required if 'expressRoutePortResourceId' is not set. This is the bandwidth in Mbps of the circuit being created. It must exactly match one of the available bandwidth offers List ExpressRoute Service Providers API call.

- Required: No
- Type: int

### Parameter: `expressRoutePortResourceId`

Required if 'serviceProviderName', 'peeringLocation', and 'bandwidthInMbps' are not set. The reference to the ExpressRoutePort resource when the circuit is provisioned on an ExpressRoutePort resource. Available when configuring Express Route Direct.

- Required: No
- Type: string
- Default: `''`

### Parameter: `peeringLocation`

Required if 'expressRoutePortResourceId' is not set. This is the name of the peering location and not the ARM resource location. It must exactly match one of the available peering locations from List ExpressRoute Service Providers API call.

- Required: No
- Type: string

### Parameter: `serviceProviderName`

Required if 'expressRoutePortResourceId' is not set. This is the name of the ExpressRoute Service Provider. It must exactly match one of the Service Providers from List ExpressRoute Service Providers API call.

- Required: No
- Type: string

### Parameter: `allowClassicOperations`

Allow classic operations. You can connect to virtual networks in the classic deployment model by setting allowClassicOperations to true.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `authorizationNames`

List of names for ExpressRoute circuit authorizations to create. To fetch the `authorizationKey` for the authorization, use the `existing` resource reference for `Microsoft.Network/expressRouteCircuits/authorizations`.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `connections`

Array of Global Reach connection configurations for peerings.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-connectionsname) | string | The name of the connection. |
| [`peerExpressRouteCircuitPeeringId`](#parameter-connectionspeerexpressroutecircuitpeeringid) | string | The resource ID of the peer ExpressRoute circuit peering. |
| [`peeringName`](#parameter-connectionspeeringname) | string | The name of the peering this connection belongs to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-connectionsaddressprefix) | string | The IPv4 address space (/29) to carve out customer addresses for tunnels. |
| [`authorizationKey`](#parameter-connectionsauthorizationkey) | string | The authorization key for the connection. |
| [`ipv6CircuitConnectionConfig`](#parameter-connectionsipv6circuitconnectionconfig) | object | IPv6 circuit connection configuration. |

### Parameter: `connections.name`

The name of the connection.

- Required: Yes
- Type: string

### Parameter: `connections.peerExpressRouteCircuitPeeringId`

The resource ID of the peer ExpressRoute circuit peering.

- Required: Yes
- Type: string

### Parameter: `connections.peeringName`

The name of the peering this connection belongs to.

- Required: Yes
- Type: string

### Parameter: `connections.addressPrefix`

The IPv4 address space (/29) to carve out customer addresses for tunnels.

- Required: No
- Type: string

### Parameter: `connections.authorizationKey`

The authorization key for the connection.

- Required: No
- Type: string

### Parameter: `connections.ipv6CircuitConnectionConfig`

IPv6 circuit connection configuration.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefix`](#parameter-connectionsipv6circuitconnectionconfigaddressprefix) | string | The IPv6 address space (/125) to carve out customer addresses for global reach. |

### Parameter: `connections.ipv6CircuitConnectionConfig.addressPrefix`

The IPv6 address space (/125) to carve out customer addresses for global reach.

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

### Parameter: `enableDirectPortRateLimit`

Flag denoting rate-limiting status of the ExpressRoute direct-port circuit.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `globalReachEnabled`

Flag denoting global reach status. To enable ExpressRoute Global Reach between different geopolitical regions, your circuits must be Premium SKU.

- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `peerings`

Array of peering configurations for the ExpressRoute circuit.

- Required: No
- Type: array

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

### Parameter: `skuFamily`

Chosen SKU family of ExpressRoute circuit. Choose from MeteredData or UnlimitedData SKU families.

- Required: No
- Type: string
- Default: `'MeteredData'`
- Allowed:
  ```Bicep
  [
    'MeteredData'
    'UnlimitedData'
  ]
  ```

### Parameter: `skuTier`

Chosen SKU Tier of ExpressRoute circuit. Choose from Local, Premium or Standard SKU tiers.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Local'
    'Premium'
    'Standard'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `authorizations` | array | The authorizations of the express route circuit. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of express route circuit. |
| `resourceGroupName` | string | The resource group the express route circuit was deployed into. |
| `resourceId` | string | The resource ID of express route circuit. |
| `serviceKey` | string | The service key of the express route circuit. |
| `serviceProviderProvisioningState` | string | The service provider provisioning state of the express route circuit. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
