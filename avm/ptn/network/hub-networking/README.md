# Hub Networking `[Microsoft.Network/hubnetworking]`

This module is designed to simplify the creation of multi-region hub networks in Azure. It will create a number of virtual networks and subnets, and optionally peer them together in a mesh topology with routing.

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
| `Microsoft.Network/azureFirewalls` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/azureFirewalls) |
| `Microsoft.Network/bastionHosts` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/bastionHosts) |
| `Microsoft.Network/publicIPAddresses` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/publicIPAddresses) |
| `Microsoft.Network/routeTables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/routeTables) |
| `Microsoft.Network/routeTables/routes` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/routeTables/routes) |
| `Microsoft.Network/virtualNetworks` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/virtualNetworks/virtualNetworkPeerings) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/virtualNetworkPeerings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/network/hub-networking:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module hubNetworking 'br/public:avm/ptn/network/hub-networking:<version>' = {
  name: 'hubNetworkingDeployment'
  params: {
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
module hubNetworking 'br/public:avm/ptn/network/hub-networking:<version>' = {
  name: 'hubNetworkingDeployment'
  params: {
    hubVirtualNetworks: {
      hub1: {
        addressPrefixes: '<addressPrefixes>'
        azureFirewallSettings: {
          additionalPublicIpConfigurations: []
          applicationRuleCollections: []
          azureSkuTier: 'Standard'
          diagnosticSettings: []
          enableTelemetry: true
          firewallPolicyId: ''
          hubIpAddresses: {}
          location: 'westus'
          lock: {}
          managementIPAddressObject: {}
          managementIPResourceID: ''
          natRuleCollections: []
          networkRuleCollections: []
          publicIPAddressObject: {
            name: 'hub1PublicIp'
          }
          publicIPResourceID: ''
          roleAssignments: []
          tags: {}
          threatIntelMode: 'Alert'
          virtualHub: ''
          zones: []
        }
        bastionHost: {
          disableCopyPaste: true
          enableFileCopy: false
          enableIpConnect: false
          enableShareableLink: false
          scaleUnits: 2
          skuName: 'Standard'
        }
        ddosProtectionPlanResourceId: ''
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
        dnsServers: [
          '10.0.1.4'
          '10.0.1.5'
        ]
        enableAzureFirewall: true
        enableBastion: true
        enablePeering: false
        enableTelemetry: true
        flowTimeoutInMinutes: 30
        location: 'westus'
        lock: {
          kind: 'CanNotDelete'
          name: 'hub1Lock'
        }
        name: 'hub1'
        peeringSettings: [
          {
            allowForwardedTraffic: true
            allowGatewayTransit: false
            allowVirtualNetworkAccess: true
            remoteVirtualNetworkName: 'hub2'
            useRemoteGateways: false
          }
        ]
        roleAssignments: []
        routes: [
          {
            name: 'defaultRoute'
            properties: {
              addressPrefix: '0.0.0.0/0'
              nextHopType: 'Internet'
            }
          }
        ]
        subnets: [
          {
            addressPrefix: '<addressPrefix>'
            name: 'GatewaySubnet'
          }
          {
            addressPrefix: '<addressPrefix>'
            name: 'AzureFirewallSubnet'
          }
          {
            addressPrefix: '<addressPrefix>'
            name: 'AzureBastionSubnet'
          }
        ]
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
        vnetEncryption: false
        vnetEncryptionEnforcement: 'AllowUnencrypted'
      }
      hub2: {
        addressPrefixes: '<addressPrefixes>'
        azureFirewallSettings: {
          additionalPublicIpConfigurations: []
          applicationRuleCollections: []
          azureSkuTier: 'Standard'
          diagnosticSettings: []
          enableTelemetry: true
          firewallPolicyId: ''
          hubIpAddresses: {}
          location: 'westus2'
          lock: {}
          managementIPAddressObject: {}
          managementIPResourceID: ''
          natRuleCollections: []
          networkRuleCollections: []
          publicIPAddressObject: {
            name: 'hub2PublicIp'
          }
          publicIPResourceID: ''
          roleAssignments: []
          tags: {}
          threatIntelMode: 'Alert'
          virtualHub: ''
          zones: [
            '1'
            '2'
            '3'
          ]
        }
        bastionHost: {
          disableCopyPaste: true
          enableFileCopy: false
          enableIpConnect: false
          enableShareableLink: false
          scaleUnits: 2
          skuName: 'Standard'
        }
        ddosProtectionPlanResourceId: ''
        diagnosticSettings: []
        dnsServers: []
        enableAzureFirewall: true
        enableBastion: true
        enablePeering: false
        enableTelemetry: false
        flowTimeoutInMinutes: 10
        location: 'westus2'
        lock: {
          kind: 'CanNotDelete'
          name: 'hub2Lock'
        }
        name: 'hub2'
        peeringSettings: [
          {
            allowForwardedTraffic: true
            allowGatewayTransit: false
            allowVirtualNetworkAccess: true
            remoteVirtualNetworkName: 'hub1'
            useRemoteGateways: false
          }
        ]
        roleAssignments: []
        routes: [
          {
            name: 'defaultRoute'
            properties: {
              addressPrefix: '0.0.0.0/0'
              nextHopType: 'Internet'
            }
          }
        ]
        subnets: [
          {
            addressPrefix: '<addressPrefix>'
            name: 'GatewaySubnet'
          }
          {
            addressPrefix: '<addressPrefix>'
            name: 'AzureFirewallSubnet'
          }
          {
            addressPrefix: '<addressPrefix>'
            name: 'AzureBastionSubnet'
          }
        ]
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
        vnetEncryption: false
        vnetEncryptionEnforcement: 'AllowUnencrypted'
      }
    }
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
    "hubVirtualNetworks": {
      "value": {
        "hub1": {
          "addressPrefixes": "<addressPrefixes>",
          "azureFirewallSettings": {
            "additionalPublicIpConfigurations": [],
            "applicationRuleCollections": [],
            "azureSkuTier": "Standard",
            "diagnosticSettings": [],
            "enableTelemetry": true,
            "firewallPolicyId": "",
            "hubIpAddresses": {},
            "location": "westus",
            "lock": {},
            "managementIPAddressObject": {},
            "managementIPResourceID": "",
            "natRuleCollections": [],
            "networkRuleCollections": [],
            "publicIPAddressObject": {
              "name": "hub1PublicIp"
            },
            "publicIPResourceID": "",
            "roleAssignments": [],
            "tags": {},
            "threatIntelMode": "Alert",
            "virtualHub": "",
            "zones": []
          },
          "bastionHost": {
            "disableCopyPaste": true,
            "enableFileCopy": false,
            "enableIpConnect": false,
            "enableShareableLink": false,
            "scaleUnits": 2,
            "skuName": "Standard"
          },
          "ddosProtectionPlanResourceId": "",
          "diagnosticSettings": [
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
          ],
          "dnsServers": [
            "10.0.1.4",
            "10.0.1.5"
          ],
          "enableAzureFirewall": true,
          "enableBastion": true,
          "enablePeering": false,
          "enableTelemetry": true,
          "flowTimeoutInMinutes": 30,
          "location": "westus",
          "lock": {
            "kind": "CanNotDelete",
            "name": "hub1Lock"
          },
          "name": "hub1",
          "peeringSettings": [
            {
              "allowForwardedTraffic": true,
              "allowGatewayTransit": false,
              "allowVirtualNetworkAccess": true,
              "remoteVirtualNetworkName": "hub2",
              "useRemoteGateways": false
            }
          ],
          "roleAssignments": [],
          "routes": [
            {
              "name": "defaultRoute",
              "properties": {
                "addressPrefix": "0.0.0.0/0",
                "nextHopType": "Internet"
              }
            }
          ],
          "subnets": [
            {
              "addressPrefix": "<addressPrefix>",
              "name": "GatewaySubnet"
            },
            {
              "addressPrefix": "<addressPrefix>",
              "name": "AzureFirewallSubnet"
            },
            {
              "addressPrefix": "<addressPrefix>",
              "name": "AzureBastionSubnet"
            }
          ],
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          },
          "vnetEncryption": false,
          "vnetEncryptionEnforcement": "AllowUnencrypted"
        },
        "hub2": {
          "addressPrefixes": "<addressPrefixes>",
          "azureFirewallSettings": {
            "additionalPublicIpConfigurations": [],
            "applicationRuleCollections": [],
            "azureSkuTier": "Standard",
            "diagnosticSettings": [],
            "enableTelemetry": true,
            "firewallPolicyId": "",
            "hubIpAddresses": {},
            "location": "westus2",
            "lock": {},
            "managementIPAddressObject": {},
            "managementIPResourceID": "",
            "natRuleCollections": [],
            "networkRuleCollections": [],
            "publicIPAddressObject": {
              "name": "hub2PublicIp"
            },
            "publicIPResourceID": "",
            "roleAssignments": [],
            "tags": {},
            "threatIntelMode": "Alert",
            "virtualHub": "",
            "zones": [
              "1",
              "2",
              "3"
            ]
          },
          "bastionHost": {
            "disableCopyPaste": true,
            "enableFileCopy": false,
            "enableIpConnect": false,
            "enableShareableLink": false,
            "scaleUnits": 2,
            "skuName": "Standard"
          },
          "ddosProtectionPlanResourceId": "",
          "diagnosticSettings": [],
          "dnsServers": [],
          "enableAzureFirewall": true,
          "enableBastion": true,
          "enablePeering": false,
          "enableTelemetry": false,
          "flowTimeoutInMinutes": 10,
          "location": "westus2",
          "lock": {
            "kind": "CanNotDelete",
            "name": "hub2Lock"
          },
          "name": "hub2",
          "peeringSettings": [
            {
              "allowForwardedTraffic": true,
              "allowGatewayTransit": false,
              "allowVirtualNetworkAccess": true,
              "remoteVirtualNetworkName": "hub1",
              "useRemoteGateways": false
            }
          ],
          "roleAssignments": [],
          "routes": [
            {
              "name": "defaultRoute",
              "properties": {
                "addressPrefix": "0.0.0.0/0",
                "nextHopType": "Internet"
              }
            }
          ],
          "subnets": [
            {
              "addressPrefix": "<addressPrefix>",
              "name": "GatewaySubnet"
            },
            {
              "addressPrefix": "<addressPrefix>",
              "name": "AzureFirewallSubnet"
            },
            {
              "addressPrefix": "<addressPrefix>",
              "name": "AzureBastionSubnet"
            }
          ],
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          },
          "vnetEncryption": false,
          "vnetEncryptionEnforcement": "AllowUnencrypted"
        }
      }
    },
    "location": {
      "value": "<location>"
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
module hubNetworking 'br/public:avm/ptn/network/hub-networking:<version>' = {
  name: 'hubNetworkingDeployment'
  params: {
    hubVirtualNetworks: {
      hub1: {
        addressPrefixes: '<addressPrefixes>'
        azureFirewallSettings: {
          additionalPublicIpConfigurations: []
          applicationRuleCollections: []
          azureSkuTier: 'Standard'
          diagnosticSettings: []
          enableTelemetry: true
          firewallPolicyId: ''
          hubIpAddresses: {}
          location: 'westus'
          lock: {}
          managementIPAddressObject: {}
          managementIPResourceID: ''
          natRuleCollections: []
          networkRuleCollections: []
          publicIPAddressObject: {
            name: 'hub1PublicIp'
          }
          publicIPResourceID: ''
          roleAssignments: []
          tags: {}
          threatIntelMode: 'Alert'
          virtualHub: ''
          zones: []
        }
        bastionHost: {
          disableCopyPaste: true
          enableFileCopy: false
          enableIpConnect: false
          enableShareableLink: false
          scaleUnits: 2
          skuName: 'Standard'
        }
        ddosProtectionPlanResourceId: ''
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
        dnsServers: [
          '10.0.1.6'
          '10.0.1.7'
        ]
        enableAzureFirewall: true
        enableBastion: true
        enablePeering: false
        enableTelemetry: true
        flowTimeoutInMinutes: 30
        location: 'westus'
        lock: {
          kind: 'CanNotDelete'
          name: 'hub1Lock'
        }
        name: 'hub1'
        peeringSettings: []
        roleAssignments: []
        routes: []
        subnets: [
          {
            addressPrefix: '<addressPrefix>'
            name: 'GatewaySubnet'
          }
          {
            addressPrefix: '<addressPrefix>'
            name: 'AzureFirewallSubnet'
          }
          {
            addressPrefix: '<addressPrefix>'
            name: 'AzureBastionSubnet'
          }
        ]
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
        vnetEncryption: false
        vnetEncryptionEnforcement: 'AllowUnencrypted'
      }
    }
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
    "hubVirtualNetworks": {
      "value": {
        "hub1": {
          "addressPrefixes": "<addressPrefixes>",
          "azureFirewallSettings": {
            "additionalPublicIpConfigurations": [],
            "applicationRuleCollections": [],
            "azureSkuTier": "Standard",
            "diagnosticSettings": [],
            "enableTelemetry": true,
            "firewallPolicyId": "",
            "hubIpAddresses": {},
            "location": "westus",
            "lock": {},
            "managementIPAddressObject": {},
            "managementIPResourceID": "",
            "natRuleCollections": [],
            "networkRuleCollections": [],
            "publicIPAddressObject": {
              "name": "hub1PublicIp"
            },
            "publicIPResourceID": "",
            "roleAssignments": [],
            "tags": {},
            "threatIntelMode": "Alert",
            "virtualHub": "",
            "zones": []
          },
          "bastionHost": {
            "disableCopyPaste": true,
            "enableFileCopy": false,
            "enableIpConnect": false,
            "enableShareableLink": false,
            "scaleUnits": 2,
            "skuName": "Standard"
          },
          "ddosProtectionPlanResourceId": "",
          "diagnosticSettings": [
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
          ],
          "dnsServers": [
            "10.0.1.6",
            "10.0.1.7"
          ],
          "enableAzureFirewall": true,
          "enableBastion": true,
          "enablePeering": false,
          "enableTelemetry": true,
          "flowTimeoutInMinutes": 30,
          "location": "westus",
          "lock": {
            "kind": "CanNotDelete",
            "name": "hub1Lock"
          },
          "name": "hub1",
          "peeringSettings": [],
          "roleAssignments": [],
          "routes": [],
          "subnets": [
            {
              "addressPrefix": "<addressPrefix>",
              "name": "GatewaySubnet"
            },
            {
              "addressPrefix": "<addressPrefix>",
              "name": "AzureFirewallSubnet"
            },
            {
              "addressPrefix": "<addressPrefix>",
              "name": "AzureBastionSubnet"
            }
          ],
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          },
          "vnetEncryption": false,
          "vnetEncryptionEnforcement": "AllowUnencrypted"
        }
      }
    },
    "location": {
      "value": "<location>"
    }
  }
}
```

</details>
<p>


## Parameters

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`hubVirtualNetworks`](#parameter-hubvirtualnetworks) | object | A map of the hub virtual networks to create. |
| [`location`](#parameter-location) | string | Location for all Resources. |

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `hubVirtualNetworks`

A map of the hub virtual networks to create.

- Required: No
- Type: object

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `hubAzureFirewallSubnetAssociationSubnets` | array |  |
| `hubBastionName` | array | The name of the bastion host. |
| `hubBastionResourceId` | array | The resource ID of the bastion host. |
| `hubVirtualNetworkName` | array | The name of the hub virtual network. |
| `hubVirtualNetworkNames` | array | The names of the hub virtual network. |
| `hubVirtualNetworkPeers` | array | The peers of the hub virtual network. |
| `hubVirtualNetworkResourceId` | array | The resource ID of the hub virtual network. |
| `hubVirtualNetworkSubnets` | array | The subnets of the hub virtual network. |
| `location` | array | The location the virtual network was deployed into. |
| `resourceGroupName` | array | The resource group the virtual network was deployed into. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/azure-firewall:0.1.1` | Remote reference |
| `br/public:avm/res/network/bastion-host:0.2.0` | Remote reference |
| `br/public:avm/res/network/route-table:0.2.2` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.1.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
