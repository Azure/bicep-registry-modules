# Virtual Hubs `[Microsoft.Network/virtualHubs]`

This module deploys a Virtual Hub.
If you are planning to deploy a Secure Virtual Hub (with an Azure Firewall integrated), please refer to the Azure Firewall module.

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
| `Microsoft.Network/virtualHubs` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualHubs) |
| `Microsoft.Network/virtualHubs/hubRouteTables` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualHubs/hubRouteTables) |
| `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualHubs/hubVirtualNetworkConnections) |
| `Microsoft.Network/virtualHubs/routingIntent` | [2024-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-05-01/virtualHubs/routingIntent) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/virtual-hub:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [Using Routing Intent](#example-3-using-routing-intent)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualHub 'br/public:avm/res/network/virtual-hub:<version>' = {
  name: 'virtualHubDeployment'
  params: {
    // Required parameters
    addressPrefix: '10.0.0.0/16'
    name: 'nvhmin'
    virtualWanResourceId: '<virtualWanResourceId>'
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
    "addressPrefix": {
      "value": "10.0.0.0/16"
    },
    "name": {
      "value": "nvhmin"
    },
    "virtualWanResourceId": {
      "value": "<virtualWanResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/virtual-hub:<version>'

// Required parameters
param addressPrefix = '10.0.0.0/16'
param name = 'nvhmin'
param virtualWanResourceId = '<virtualWanResourceId>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualHub 'br/public:avm/res/network/virtual-hub:<version>' = {
  name: 'virtualHubDeployment'
  params: {
    // Required parameters
    addressPrefix: '10.1.0.0/16'
    name: 'nvhmax'
    virtualWanResourceId: '<virtualWanResourceId>'
    // Non-required parameters
    hubRouteTables: [
      {
        name: 'routeTable1'
        routes: []
      }
    ]
    hubVirtualNetworkConnections: [
      {
        name: 'connection1'
        remoteVirtualNetworkResourceId: '<remoteVirtualNetworkResourceId>'
        routingConfiguration: {
          associatedRouteTable: {
            id: '<id>'
          }
          propagatedRouteTables: {
            ids: [
              {
                id: '<id>'
              }
            ]
            labels: []
          }
          vnetRoutes: {
            staticRoutes: [
              {
                addressPrefixes: [
                  '10.150.0.0/24'
                ]
                name: 'route1'
                nextHopIpAddress: '10.150.0.5'
              }
            ]
            staticRoutesConfig: {
              vnetLocalRouteOverrideCriteria: 'Contains'
            }
          }
        }
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    sku: 'Standard'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    virtualRouterAutoScaleConfiguration: {
      minCount: 2
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
    "addressPrefix": {
      "value": "10.1.0.0/16"
    },
    "name": {
      "value": "nvhmax"
    },
    "virtualWanResourceId": {
      "value": "<virtualWanResourceId>"
    },
    // Non-required parameters
    "hubRouteTables": {
      "value": [
        {
          "name": "routeTable1",
          "routes": []
        }
      ]
    },
    "hubVirtualNetworkConnections": {
      "value": [
        {
          "name": "connection1",
          "remoteVirtualNetworkResourceId": "<remoteVirtualNetworkResourceId>",
          "routingConfiguration": {
            "associatedRouteTable": {
              "id": "<id>"
            },
            "propagatedRouteTables": {
              "ids": [
                {
                  "id": "<id>"
                }
              ],
              "labels": []
            },
            "vnetRoutes": {
              "staticRoutes": [
                {
                  "addressPrefixes": [
                    "10.150.0.0/24"
                  ],
                  "name": "route1",
                  "nextHopIpAddress": "10.150.0.5"
                }
              ],
              "staticRoutesConfig": {
                "vnetLocalRouteOverrideCriteria": "Contains"
              }
            }
          }
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
    "sku": {
      "value": "Standard"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "virtualRouterAutoScaleConfiguration": {
      "value": {
        "minCount": 2
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
using 'br/public:avm/res/network/virtual-hub:<version>'

// Required parameters
param addressPrefix = '10.1.0.0/16'
param name = 'nvhmax'
param virtualWanResourceId = '<virtualWanResourceId>'
// Non-required parameters
param hubRouteTables = [
  {
    name: 'routeTable1'
    routes: []
  }
]
param hubVirtualNetworkConnections = [
  {
    name: 'connection1'
    remoteVirtualNetworkResourceId: '<remoteVirtualNetworkResourceId>'
    routingConfiguration: {
      associatedRouteTable: {
        id: '<id>'
      }
      propagatedRouteTables: {
        ids: [
          {
            id: '<id>'
          }
        ]
        labels: []
      }
      vnetRoutes: {
        staticRoutes: [
          {
            addressPrefixes: [
              '10.150.0.0/24'
            ]
            name: 'route1'
            nextHopIpAddress: '10.150.0.5'
          }
        ]
        staticRoutesConfig: {
          vnetLocalRouteOverrideCriteria: 'Contains'
        }
      }
    }
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param sku = 'Standard'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param virtualRouterAutoScaleConfiguration = {
  minCount: 2
}
```

</details>
<p>

### Example 3: _Using Routing Intent_

This instance deploys the module the Virtual WAN hub with Routing Intent enabled; requires an existing Virtual Hub, as well the firewall Resource ID.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualHub 'br/public:avm/res/network/virtual-hub:<version>' = {
  name: 'virtualHubDeployment'
  params: {
    // Required parameters
    addressPrefix: '10.10.0.0/23'
    name: 'nvhrtint'
    virtualWanResourceId: '<virtualWanResourceId>'
    // Non-required parameters
    azureFirewallResourceId: '<azureFirewallResourceId>'
    hubRoutingPreference: 'ASPath'
    hubVirtualNetworkConnections: [
      {
        name: 'connection1'
        remoteVirtualNetworkResourceId: '<remoteVirtualNetworkResourceId>'
      }
    ]
    routingIntent: {
      internetToFirewall: false
      privateToFirewall: true
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
    "addressPrefix": {
      "value": "10.10.0.0/23"
    },
    "name": {
      "value": "nvhrtint"
    },
    "virtualWanResourceId": {
      "value": "<virtualWanResourceId>"
    },
    // Non-required parameters
    "azureFirewallResourceId": {
      "value": "<azureFirewallResourceId>"
    },
    "hubRoutingPreference": {
      "value": "ASPath"
    },
    "hubVirtualNetworkConnections": {
      "value": [
        {
          "name": "connection1",
          "remoteVirtualNetworkResourceId": "<remoteVirtualNetworkResourceId>"
        }
      ]
    },
    "routingIntent": {
      "value": {
        "internetToFirewall": false,
        "privateToFirewall": true
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
using 'br/public:avm/res/network/virtual-hub:<version>'

// Required parameters
param addressPrefix = '10.10.0.0/23'
param name = 'nvhrtint'
param virtualWanResourceId = '<virtualWanResourceId>'
// Non-required parameters
param azureFirewallResourceId = '<azureFirewallResourceId>'
param hubRoutingPreference = 'ASPath'
param hubVirtualNetworkConnections = [
  {
    name: 'connection1'
    remoteVirtualNetworkResourceId: '<remoteVirtualNetworkResourceId>'
  }
]
param routingIntent = {
  internetToFirewall: false
  privateToFirewall: true
}
```

</details>
<p>

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualHub 'br/public:avm/res/network/virtual-hub:<version>' = {
  name: 'virtualHubDeployment'
  params: {
    // Required parameters
    addressPrefix: '10.1.0.0/16'
    name: 'nvhwaf'
    virtualWanResourceId: '<virtualWanResourceId>'
    // Non-required parameters
    hubRouteTables: [
      {
        name: 'routeTable1'
      }
    ]
    hubVirtualNetworkConnections: [
      {
        name: 'connection1'
        remoteVirtualNetworkResourceId: '<remoteVirtualNetworkResourceId>'
        routingConfiguration: {
          associatedRouteTable: {
            id: '<id>'
          }
          propagatedRouteTables: {
            ids: [
              {
                id: '<id>'
              }
            ]
            labels: [
              'none'
            ]
          }
        }
      }
    ]
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
    "addressPrefix": {
      "value": "10.1.0.0/16"
    },
    "name": {
      "value": "nvhwaf"
    },
    "virtualWanResourceId": {
      "value": "<virtualWanResourceId>"
    },
    // Non-required parameters
    "hubRouteTables": {
      "value": [
        {
          "name": "routeTable1"
        }
      ]
    },
    "hubVirtualNetworkConnections": {
      "value": [
        {
          "name": "connection1",
          "remoteVirtualNetworkResourceId": "<remoteVirtualNetworkResourceId>",
          "routingConfiguration": {
            "associatedRouteTable": {
              "id": "<id>"
            },
            "propagatedRouteTables": {
              "ids": [
                {
                  "id": "<id>"
                }
              ],
              "labels": [
                "none"
              ]
            }
          }
        }
      ]
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
using 'br/public:avm/res/network/virtual-hub:<version>'

// Required parameters
param addressPrefix = '10.1.0.0/16'
param name = 'nvhwaf'
param virtualWanResourceId = '<virtualWanResourceId>'
// Non-required parameters
param hubRouteTables = [
  {
    name: 'routeTable1'
  }
]
param hubVirtualNetworkConnections = [
  {
    name: 'connection1'
    remoteVirtualNetworkResourceId: '<remoteVirtualNetworkResourceId>'
    routingConfiguration: {
      associatedRouteTable: {
        id: '<id>'
      }
      propagatedRouteTables: {
        ids: [
          {
            id: '<id>'
          }
        ]
        labels: [
          'none'
        ]
      }
    }
  }
]
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
| [`addressPrefix`](#parameter-addressprefix) | string | Address-prefix for this VirtualHub. |
| [`name`](#parameter-name) | string | The virtual hub name. |
| [`virtualWanResourceId`](#parameter-virtualwanresourceid) | string | Resource ID of the virtual WAN to link to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowBranchToBranchTraffic`](#parameter-allowbranchtobranchtraffic) | bool | Flag to control transit for VirtualRouter hub. |
| [`azureFirewallResourceId`](#parameter-azurefirewallresourceid) | string | Resource ID of the Azure Firewall to link to. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`expressRouteGatewayResourceId`](#parameter-expressroutegatewayresourceid) | string | Resource ID of the Express Route Gateway to link to. |
| [`hubRouteTables`](#parameter-hubroutetables) | array | Route tables to create for the virtual hub. |
| [`hubRoutingPreference`](#parameter-hubroutingpreference) | string | The preferred routing preference for this virtual hub. |
| [`hubVirtualNetworkConnections`](#parameter-hubvirtualnetworkconnections) | array | Virtual network connections to create for the virtual hub. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`p2SVpnGatewayResourceId`](#parameter-p2svpngatewayresourceid) | string | Resource ID of the Point-to-Site VPN Gateway to link to. |
| [`preferredRoutingGateway`](#parameter-preferredroutinggateway) | string | The preferred routing gateway types. |
| [`routeTableRoutes`](#parameter-routetableroutes) | array | VirtualHub route tables. |
| [`routingIntent`](#parameter-routingintent) | object | The routing intent configuration to create for the virtual hub. |
| [`securityPartnerProviderResourceId`](#parameter-securitypartnerproviderresourceid) | string | ID of the Security Partner Provider to link to. |
| [`securityProviderName`](#parameter-securityprovidername) | string | The Security Provider name. |
| [`sku`](#parameter-sku) | string | The sku of this VirtualHub. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`virtualHubRouteTableV2s`](#parameter-virtualhubroutetablev2s) | array | List of all virtual hub route table v2s associated with this VirtualHub. |
| [`virtualRouterAsn`](#parameter-virtualrouterasn) | int | VirtualRouter ASN. |
| [`virtualRouterAutoScaleConfiguration`](#parameter-virtualrouterautoscaleconfiguration) | object | The auto scale configuration for the virtual router. |
| [`virtualRouterIps`](#parameter-virtualrouterips) | array | VirtualRouter IPs. |
| [`vpnGatewayResourceId`](#parameter-vpngatewayresourceid) | string | Resource ID of the VPN Gateway to link to. |

### Parameter: `addressPrefix`

Address-prefix for this VirtualHub.

- Required: Yes
- Type: string

### Parameter: `name`

The virtual hub name.

- Required: Yes
- Type: string

### Parameter: `virtualWanResourceId`

Resource ID of the virtual WAN to link to.

- Required: Yes
- Type: string

### Parameter: `allowBranchToBranchTraffic`

Flag to control transit for VirtualRouter hub.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `azureFirewallResourceId`

Resource ID of the Azure Firewall to link to.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `expressRouteGatewayResourceId`

Resource ID of the Express Route Gateway to link to.

- Required: No
- Type: string

### Parameter: `hubRouteTables`

Route tables to create for the virtual hub.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-hubroutetablesname) | string | The route table name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`labels`](#parameter-hubroutetableslabels) | array | List of labels associated with this route table. |
| [`routes`](#parameter-hubroutetablesroutes) | array | List of all routes. |

### Parameter: `hubRouteTables.name`

The route table name.

- Required: Yes
- Type: string

### Parameter: `hubRouteTables.labels`

List of labels associated with this route table.

- Required: No
- Type: array

### Parameter: `hubRouteTables.routes`

List of all routes.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destinations`](#parameter-hubroutetablesroutesdestinations) | array | The address prefix for the route. |
| [`destinationType`](#parameter-hubroutetablesroutesdestinationtype) | string | The destination type for the route. |
| [`name`](#parameter-hubroutetablesroutesname) | string | The name of the route. |
| [`nextHop`](#parameter-hubroutetablesroutesnexthop) | string | The next hop IP address for the route. |
| [`nextHopType`](#parameter-hubroutetablesroutesnexthoptype) | string | The next hop type for the route. |

### Parameter: `hubRouteTables.routes.destinations`

The address prefix for the route.

- Required: Yes
- Type: array

### Parameter: `hubRouteTables.routes.destinationType`

The destination type for the route.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'CIDR'
  ]
  ```

### Parameter: `hubRouteTables.routes.name`

The name of the route.

- Required: Yes
- Type: string

### Parameter: `hubRouteTables.routes.nextHop`

The next hop IP address for the route.

- Required: Yes
- Type: string

### Parameter: `hubRouteTables.routes.nextHopType`

The next hop type for the route.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ResourceId'
  ]
  ```

### Parameter: `hubRoutingPreference`

The preferred routing preference for this virtual hub.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ASPath'
    'ExpressRoute'
    'VpnGateway'
  ]
  ```

### Parameter: `hubVirtualNetworkConnections`

Virtual network connections to create for the virtual hub.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-hubvirtualnetworkconnectionsname) | string | The connection name. |
| [`remoteVirtualNetworkResourceId`](#parameter-hubvirtualnetworkconnectionsremotevirtualnetworkresourceid) | string | Resource ID of the virtual network to link to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableInternetSecurity`](#parameter-hubvirtualnetworkconnectionsenableinternetsecurity) | bool | Enable internet security. |
| [`routingConfiguration`](#parameter-hubvirtualnetworkconnectionsroutingconfiguration) | object | Routing Configuration indicating the associated and propagated route tables for this connection. |

### Parameter: `hubVirtualNetworkConnections.name`

The connection name.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworkConnections.remoteVirtualNetworkResourceId`

Resource ID of the virtual network to link to.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworkConnections.enableInternetSecurity`

Enable internet security.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworkConnections.routingConfiguration`

Routing Configuration indicating the associated and propagated route tables for this connection.

- Required: No
- Type: object

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

### Parameter: `p2SVpnGatewayResourceId`

Resource ID of the Point-to-Site VPN Gateway to link to.

- Required: No
- Type: string

### Parameter: `preferredRoutingGateway`

The preferred routing gateway types.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ExpressRoute'
    'None'
    'VpnGateway'
  ]
  ```

### Parameter: `routeTableRoutes`

VirtualHub route tables.

- Required: No
- Type: array

### Parameter: `routingIntent`

The routing intent configuration to create for the virtual hub.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`internetToFirewall`](#parameter-routingintentinternettofirewall) | bool | Configures Routing Intent to Forward Internet traffic to the firewall (0.0.0.0/0). |
| [`privateToFirewall`](#parameter-routingintentprivatetofirewall) | bool | Configures Routing Intent to forward Private traffic to the firewall (RFC1918). |

### Parameter: `routingIntent.internetToFirewall`

Configures Routing Intent to Forward Internet traffic to the firewall (0.0.0.0/0).

- Required: No
- Type: bool

### Parameter: `routingIntent.privateToFirewall`

Configures Routing Intent to forward Private traffic to the firewall (RFC1918).

- Required: No
- Type: bool

### Parameter: `securityPartnerProviderResourceId`

ID of the Security Partner Provider to link to.

- Required: No
- Type: string
- Default: `''`

### Parameter: `securityProviderName`

The Security Provider name.

- Required: No
- Type: string
- Default: `''`

### Parameter: `sku`

The sku of this VirtualHub.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Standard'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `virtualHubRouteTableV2s`

List of all virtual hub route table v2s associated with this VirtualHub.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `virtualRouterAsn`

VirtualRouter ASN.

- Required: No
- Type: int

### Parameter: `virtualRouterAutoScaleConfiguration`

The auto scale configuration for the virtual router.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`minCount`](#parameter-virtualrouterautoscaleconfigurationmincount) | int | The minimum number of virtual routers in the scale set. |

### Parameter: `virtualRouterAutoScaleConfiguration.minCount`

The minimum number of virtual routers in the scale set.

- Required: Yes
- Type: int

### Parameter: `virtualRouterIps`

VirtualRouter IPs.

- Required: No
- Type: array

### Parameter: `vpnGatewayResourceId`

Resource ID of the VPN Gateway to link to.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the virtual hub. |
| `resourceGroupName` | string | The resource group the virtual hub was deployed into. |
| `resourceId` | string | The resource ID of the virtual hub. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
