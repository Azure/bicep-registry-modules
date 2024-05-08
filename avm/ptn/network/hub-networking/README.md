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
| `Microsoft.Network/routeTables/routes` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/routeTables/routes) |
| `Microsoft.Network/virtualNetworks` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/virtualNetworks/virtualNetworkPeerings) |
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

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`<Any other property>`](#parameter-hubvirtualnetworks<any other property>) | object | Array of hub virtual networks to create. |

### Parameter: `hubVirtualNetworks.<Any other property>`

Array of hub virtual networks to create.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-hubvirtualnetworks<any other property>addressprefixes) | array | The address prefixes for the virtual network. |
| [`name`](#parameter-hubvirtualnetworks<any other property>name) | string | The name of the virtual network. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureFirewallSettings`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettings) | object | The Azure Firewall config. |
| [`bastionHost`](#parameter-hubvirtualnetworks<any other property>bastionhost) | object | The Azure Bastion config. |
| [`ddosProtectionPlanResourceId`](#parameter-hubvirtualnetworks<any other property>ddosprotectionplanresourceid) | string | The DDoS protection plan resource ID. |
| [`diagnosticSettings`](#parameter-hubvirtualnetworks<any other property>diagnosticsettings) | array | The diagnostic settings of the virtual network. |
| [`dnsServers`](#parameter-hubvirtualnetworks<any other property>dnsservers) | array | The DNS servers of the virtual network. |
| [`enableAzureFirewall`](#parameter-hubvirtualnetworks<any other property>enableazurefirewall) | bool | Enable/Disable Azure Firewall for the virtual network. |
| [`enableBastion`](#parameter-hubvirtualnetworks<any other property>enablebastion) | bool | Enable/Disable Azure Bastion for the virtual network. |
| [`enablePeering`](#parameter-hubvirtualnetworks<any other property>enablepeering) | bool | Enable/Disable peering for the virtual network. |
| [`enableTelemetry`](#parameter-hubvirtualnetworks<any other property>enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`flowTimeoutInMinutes`](#parameter-hubvirtualnetworks<any other property>flowtimeoutinminutes) | int | The flow timeout in minutes. |
| [`location`](#parameter-hubvirtualnetworks<any other property>location) | string | The location of the virtual network. Defaults to the location of the resource group. |
| [`lock`](#parameter-hubvirtualnetworks<any other property>lock) | object | The lock settings of the virtual network. |
| [`peeringSettings`](#parameter-hubvirtualnetworks<any other property>peeringsettings) | array | The peerings of the virtual network. |
| [`roleAssignments`](#parameter-hubvirtualnetworks<any other property>roleassignments) | array | The role assignments to create. |
| [`routes`](#parameter-hubvirtualnetworks<any other property>routes) | array | Routes to add to the virtual network route table. |
| [`subnets`](#parameter-hubvirtualnetworks<any other property>subnets) | array | The subnets of the virtual network. |
| [`tags`](#parameter-hubvirtualnetworks<any other property>tags) | object | The tags of the virtual network. |
| [`vnetEncryption`](#parameter-hubvirtualnetworks<any other property>vnetencryption) | bool | Enable/Disable VNet encryption. |
| [`vnetEncryptionEnforcement`](#parameter-hubvirtualnetworks<any other property>vnetencryptionenforcement) | string | The VNet encryption enforcement settings of the virtual network. |

### Parameter: `hubVirtualNetworks.<Any other property>.addressPrefixes`

The address prefixes for the virtual network.

- Required: Yes
- Type: array

### Parameter: `hubVirtualNetworks.<Any other property>.name`

The name of the virtual network.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings`

The Azure Firewall config.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalPublicIpConfigurations`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsadditionalpublicipconfigurations) | array | Additional public IP configurations. |
| [`applicationRuleCollections`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsapplicationrulecollections) | array | Application rule collections. |
| [`azureSkuTier`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsazureskutier) | string | Azure Firewall SKU. |
| [`diagnosticSettings`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettings) | array | Diagnostic settings. |
| [`enableTelemetry`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`firewallPolicyId`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsfirewallpolicyid) | string | Firewall policy ID. |
| [`hubIpAddresses`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingshubipaddresses) | object | Hub IP addresses. |
| [`location`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingslocation) | string | The location of the virtual network. Defaults to the location of the resource group. |
| [`lock`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingslock) | object | Lock settings. |
| [`managementIPAddressObject`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsmanagementipaddressobject) | object | Management IP address configuration. |
| [`managementIPResourceID`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsmanagementipresourceid) | string | Management IP resource ID. |
| [`natRuleCollections`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsnatrulecollections) | array | NAT rule collections. |
| [`networkRuleCollections`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsnetworkrulecollections) | array | Network rule collections. |
| [`publicIPAddressObject`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingspublicipaddressobject) | object | Public IP address object. |
| [`publicIPResourceID`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingspublicipresourceid) | string | Public IP resource ID. |
| [`roleAssignments`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsroleassignments) | array | Role assignments. |
| [`tags`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingstags) | object | Tags of the resource. |
| [`threatIntelMode`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsthreatintelmode) | string | Threat Intel mode. |
| [`virtualHub`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsvirtualhub) | string | Virtual Hub ID. |
| [`zones`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingszones) | array | Zones. |

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.additionalPublicIpConfigurations`

Additional public IP configurations.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.applicationRuleCollections`

Application rule collections.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.azureSkuTier`

Azure Firewall SKU.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings`

Diagnostic settings.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |
| [`logAnalyticsDestinationType`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |
| [`workspaceResourceId`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.firewallPolicyId`

Firewall policy ID.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.hubIpAddresses`

Hub IP addresses.

- Required: No
- Type: object

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.location`

The location of the virtual network. Defaults to the location of the resource group.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.lock`

Lock settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingslockname) | string | Specify the name of lock. |

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.lock.kind`

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

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.managementIPAddressObject`

Management IP address configuration.

- Required: No
- Type: object

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.managementIPResourceID`

Management IP resource ID.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.natRuleCollections`

NAT rule collections.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.networkRuleCollections`

Network rule collections.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.publicIPAddressObject`

Public IP address object.

- Required: No
- Type: object

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.publicIPResourceID`

Public IP resource ID.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.roleAssignments`

Role assignments.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-hubvirtualnetworks<any other property>azurefirewallsettingsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.roleAssignments.principalType`

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

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.threatIntelMode`

Threat Intel mode.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.virtualHub`

Virtual Hub ID.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.azureFirewallSettings.zones`

Zones.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.<Any other property>.bastionHost`

The Azure Bastion config.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`disableCopyPaste`](#parameter-hubvirtualnetworks<any other property>bastionhostdisablecopypaste) | bool | Enable/Disable copy/paste functionality. |
| [`enableFileCopy`](#parameter-hubvirtualnetworks<any other property>bastionhostenablefilecopy) | bool | Enable/Disable file copy functionality. |
| [`enableIpConnect`](#parameter-hubvirtualnetworks<any other property>bastionhostenableipconnect) | bool | Enable/Disable IP connect functionality. |
| [`enableShareableLink`](#parameter-hubvirtualnetworks<any other property>bastionhostenableshareablelink) | bool | Enable/Disable shareable link functionality. |
| [`scaleUnits`](#parameter-hubvirtualnetworks<any other property>bastionhostscaleunits) | int | The number of scale units for the Bastion host. Defaults to 4. |
| [`skuName`](#parameter-hubvirtualnetworks<any other property>bastionhostskuname) | string | The SKU name of the Bastion host. Defaults to Standard. |

### Parameter: `hubVirtualNetworks.<Any other property>.bastionHost.disableCopyPaste`

Enable/Disable copy/paste functionality.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.bastionHost.enableFileCopy`

Enable/Disable file copy functionality.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.bastionHost.enableIpConnect`

Enable/Disable IP connect functionality.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.bastionHost.enableShareableLink`

Enable/Disable shareable link functionality.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.bastionHost.scaleUnits`

The number of scale units for the Bastion host. Defaults to 4.

- Required: No
- Type: int

### Parameter: `hubVirtualNetworks.<Any other property>.bastionHost.skuName`

The SKU name of the Bastion host. Defaults to Standard.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.ddosProtectionPlanResourceId`

The DDoS protection plan resource ID.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings`

The diagnostic settings of the virtual network.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |
| [`logAnalyticsDestinationType`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |
| [`workspaceResourceId`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-hubvirtualnetworks<any other property>diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.dnsServers`

The DNS servers of the virtual network.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.<Any other property>.enableAzureFirewall`

Enable/Disable Azure Firewall for the virtual network.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.enableBastion`

Enable/Disable Azure Bastion for the virtual network.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.enablePeering`

Enable/Disable peering for the virtual network.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.flowTimeoutInMinutes`

The flow timeout in minutes.

- Required: No
- Type: int

### Parameter: `hubVirtualNetworks.<Any other property>.location`

The location of the virtual network. Defaults to the location of the resource group.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.lock`

The lock settings of the virtual network.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-hubvirtualnetworks<any other property>lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-hubvirtualnetworks<any other property>lockname) | string | Specify the name of lock. |

### Parameter: `hubVirtualNetworks.<Any other property>.lock.kind`

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

### Parameter: `hubVirtualNetworks.<Any other property>.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.peeringSettings`

The peerings of the virtual network.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowForwardedTraffic`](#parameter-hubvirtualnetworks<any other property>peeringsettingsallowforwardedtraffic) | bool | Allow forwarded traffic. |
| [`allowGatewayTransit`](#parameter-hubvirtualnetworks<any other property>peeringsettingsallowgatewaytransit) | bool | Allow gateway transit. |
| [`allowVirtualNetworkAccess`](#parameter-hubvirtualnetworks<any other property>peeringsettingsallowvirtualnetworkaccess) | bool | Allow virtual network access. |
| [`remoteVirtualNetworkName`](#parameter-hubvirtualnetworks<any other property>peeringsettingsremotevirtualnetworkname) | string | Remote virtual network name. |
| [`useRemoteGateways`](#parameter-hubvirtualnetworks<any other property>peeringsettingsuseremotegateways) | bool | Use remote gateways. |

### Parameter: `hubVirtualNetworks.<Any other property>.peeringSettings.allowForwardedTraffic`

Allow forwarded traffic.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.peeringSettings.allowGatewayTransit`

Allow gateway transit.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.peeringSettings.allowVirtualNetworkAccess`

Allow virtual network access.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.peeringSettings.remoteVirtualNetworkName`

Remote virtual network name.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.peeringSettings.useRemoteGateways`

Use remote gateways.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.roleAssignments`

The role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-hubvirtualnetworks<any other property>roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-hubvirtualnetworks<any other property>roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-hubvirtualnetworks<any other property>roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-hubvirtualnetworks<any other property>roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-hubvirtualnetworks<any other property>roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-hubvirtualnetworks<any other property>roleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-hubvirtualnetworks<any other property>roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `hubVirtualNetworks.<Any other property>.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `hubVirtualNetworks.<Any other property>.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.<Any other property>.roleAssignments.principalType`

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

### Parameter: `hubVirtualNetworks.<Any other property>.routes`

Routes to add to the virtual network route table.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.<Any other property>.subnets`

The subnets of the virtual network.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.<Any other property>.tags`

The tags of the virtual network.

- Required: No
- Type: object

### Parameter: `hubVirtualNetworks.<Any other property>.vnetEncryption`

Enable/Disable VNet encryption.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.<Any other property>.vnetEncryptionEnforcement`

The VNet encryption enforcement settings of the virtual network.

- Required: No
- Type: string

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `hubBastionName` | array | The name of the bastion host. |
| `hubBastionResourceId` | array | The resource ID of the bastion host. |
| `hubVirtualNetworkLocation` | array | The location the virtual network was deployed into. |
| `hubVirtualNetworkName` | array | The name of the hub virtual network. |
| `hubVirtualNetworkResourceId` | array | The resource ID of the hub virtual network. |
| `hubVirtualNetworkSubnets` | array | The subnets of the hub virtual network. |
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
