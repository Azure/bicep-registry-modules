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
| `Microsoft.Network/virtualHubs` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/virtualHubs) |
| `Microsoft.Network/virtualHubs/hubRouteTables` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/virtualHubs/hubRouteTables) |
| `Microsoft.Network/virtualHubs/hubVirtualNetworkConnections` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/virtualHubs/hubVirtualNetworkConnections) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/virtual-hub:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

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
    virtualWanId: '<virtualWanId>'
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
    "addressPrefix": {
      "value": "10.0.0.0/16"
    },
    "name": {
      "value": "nvhmin"
    },
    "virtualWanId": {
      "value": "<virtualWanId>"
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
module virtualHub 'br/public:avm/res/network/virtual-hub:<version>' = {
  name: 'virtualHubDeployment'
  params: {
    // Required parameters
    addressPrefix: '10.1.0.0/16'
    name: 'nvhmax'
    virtualWanId: '<virtualWanId>'
    // Non-required parameters
    hubRouteTables: [
      {
        name: 'routeTable1'
      }
    ]
    hubVirtualNetworkConnections: [
      {
        name: 'connection1'
        remoteVirtualNetworkId: '<remoteVirtualNetworkId>'
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
    "addressPrefix": {
      "value": "10.1.0.0/16"
    },
    "name": {
      "value": "nvhmax"
    },
    "virtualWanId": {
      "value": "<virtualWanId>"
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
          "remoteVirtualNetworkId": "<remoteVirtualNetworkId>",
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
module virtualHub 'br/public:avm/res/network/virtual-hub:<version>' = {
  name: 'virtualHubDeployment'
  params: {
    // Required parameters
    addressPrefix: '10.1.0.0/16'
    name: 'nvhwaf'
    virtualWanId: '<virtualWanId>'
    // Non-required parameters
    hubRouteTables: [
      {
        name: 'routeTable1'
      }
    ]
    hubVirtualNetworkConnections: [
      {
        name: 'connection1'
        remoteVirtualNetworkId: '<remoteVirtualNetworkId>'
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
    "addressPrefix": {
      "value": "10.1.0.0/16"
    },
    "name": {
      "value": "nvhwaf"
    },
    "virtualWanId": {
      "value": "<virtualWanId>"
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
          "remoteVirtualNetworkId": "<remoteVirtualNetworkId>",
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
| [`addressPrefix`](#parameter-addressprefix) | string | Address-prefix for this VirtualHub. |
| [`name`](#parameter-name) | string | The virtual hub name. |
| [`virtualWanId`](#parameter-virtualwanid) | string | Resource ID of the virtual WAN to link to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowBranchToBranchTraffic`](#parameter-allowbranchtobranchtraffic) | bool | Flag to control transit for VirtualRouter hub. |
| [`azureFirewallResourceId`](#parameter-azurefirewallresourceid) | string | Resource ID of the Azure Firewall to link to. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`expressRouteGatewayId`](#parameter-expressroutegatewayid) | string | Resource ID of the Express Route Gateway to link to. |
| [`hubRouteTables`](#parameter-hubroutetables) | array | Route tables to create for the virtual hub. |
| [`hubVirtualNetworkConnections`](#parameter-hubvirtualnetworkconnections) | array | Virtual network connections to create for the virtual hub. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`p2SVpnGatewayId`](#parameter-p2svpngatewayid) | string | Resource ID of the Point-to-Site VPN Gateway to link to. |
| [`preferredRoutingGateway`](#parameter-preferredroutinggateway) | string | The preferred routing gateway types. |
| [`routeTableRoutes`](#parameter-routetableroutes) | array | VirtualHub route tables. |
| [`securityPartnerProviderId`](#parameter-securitypartnerproviderid) | string | ID of the Security Partner Provider to link to. |
| [`securityProviderName`](#parameter-securityprovidername) | string | The Security Provider name. |
| [`sku`](#parameter-sku) | string | The sku of this VirtualHub. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`virtualHubRouteTableV2s`](#parameter-virtualhubroutetablev2s) | array | List of all virtual hub route table v2s associated with this VirtualHub. |
| [`virtualRouterAsn`](#parameter-virtualrouterasn) | int | VirtualRouter ASN. |
| [`virtualRouterIps`](#parameter-virtualrouterips) | array | VirtualRouter IPs. |
| [`vpnGatewayId`](#parameter-vpngatewayid) | string | Resource ID of the VPN Gateway to link to. |

### Parameter: `addressPrefix`

Address-prefix for this VirtualHub.

- Required: Yes
- Type: string

### Parameter: `name`

The virtual hub name.

- Required: Yes
- Type: string

### Parameter: `virtualWanId`

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
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `expressRouteGatewayId`

Resource ID of the Express Route Gateway to link to.

- Required: No
- Type: string
- Default: `''`

### Parameter: `hubRouteTables`

Route tables to create for the virtual hub.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `hubVirtualNetworkConnections`

Virtual network connections to create for the virtual hub.

- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `p2SVpnGatewayId`

Resource ID of the Point-to-Site VPN Gateway to link to.

- Required: No
- Type: string
- Default: `''`

### Parameter: `preferredRoutingGateway`

The preferred routing gateway types.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'ExpressRoute'
    'None'
    'VpnGateway'
  ]
  ```

### Parameter: `routeTableRoutes`

VirtualHub route tables.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `securityPartnerProviderId`

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

### Parameter: `virtualRouterIps`

VirtualRouter IPs.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `vpnGatewayId`

Resource ID of the VPN Gateway to link to.

- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the virtual hub. |
| `resourceGroupName` | string | The resource group the virtual hub was deployed into. |
| `resourceId` | string | The resource ID of the virtual hub. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
