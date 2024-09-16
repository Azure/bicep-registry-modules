# Hub Networking `[Network/HubNetworking]`

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
| `Microsoft.Network/publicIPAddresses` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/publicIPAddresses) |
| `Microsoft.Network/routeTables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/routeTables) |
| `Microsoft.Network/routeTables/routes` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/routeTables/routes) |
| `Microsoft.Network/virtualNetworks` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/virtualNetworks/virtualNetworkPeerings) |

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
          azureSkuTier: 'Standard'
          enableTelemetry: true
          location: '<location>'
          publicIPAddressObject: {
            name: 'hub1-waf-pip'
          }
          threatIntelMode: 'Alert'
        }
        bastionHost: {
          disableCopyPaste: true
          enableFileCopy: false
          enableIpConnect: false
          enableShareableLink: false
          scaleUnits: 2
          skuName: 'Standard'
        }
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
        location: '<location>'
        lock: {
          kind: 'CanNotDelete'
          name: 'hub1Lock'
        }
        peeringSettings: [
          {
            allowForwardedTraffic: true
            allowGatewayTransit: false
            allowVirtualNetworkAccess: true
            remoteVirtualNetworkName: 'hub2'
            useRemoteGateways: false
          }
        ]
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
          azureSkuTier: 'Standard'
          enableTelemetry: true
          location: '<location>'
          publicIPAddressObject: {
            name: 'hub2-waf-pip'
          }
          threatIntelMode: 'Alert'
          zones: [
            1
            2
            3
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
        enableAzureFirewall: true
        enableBastion: true
        enablePeering: false
        enableTelemetry: false
        flowTimeoutInMinutes: 10
        location: '<location>'
        lock: {
          kind: 'CanNotDelete'
          name: 'hub2Lock'
        }
        peeringSettings: [
          {
            allowForwardedTraffic: true
            allowGatewayTransit: false
            allowVirtualNetworkAccess: true
            remoteVirtualNetworkName: 'hub1'
            useRemoteGateways: false
          }
        ]
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
            "azureSkuTier": "Standard",
            "enableTelemetry": true,
            "location": "<location>",
            "publicIPAddressObject": {
              "name": "hub1-waf-pip"
            },
            "threatIntelMode": "Alert"
          },
          "bastionHost": {
            "disableCopyPaste": true,
            "enableFileCopy": false,
            "enableIpConnect": false,
            "enableShareableLink": false,
            "scaleUnits": 2,
            "skuName": "Standard"
          },
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
          "location": "<location>",
          "lock": {
            "kind": "CanNotDelete",
            "name": "hub1Lock"
          },
          "peeringSettings": [
            {
              "allowForwardedTraffic": true,
              "allowGatewayTransit": false,
              "allowVirtualNetworkAccess": true,
              "remoteVirtualNetworkName": "hub2",
              "useRemoteGateways": false
            }
          ],
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
            "azureSkuTier": "Standard",
            "enableTelemetry": true,
            "location": "<location>",
            "publicIPAddressObject": {
              "name": "hub2-waf-pip"
            },
            "threatIntelMode": "Alert",
            "zones": [
              1,
              2,
              3
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
          "enableAzureFirewall": true,
          "enableBastion": true,
          "enablePeering": false,
          "enableTelemetry": false,
          "flowTimeoutInMinutes": 10,
          "location": "<location>",
          "lock": {
            "kind": "CanNotDelete",
            "name": "hub2Lock"
          },
          "peeringSettings": [
            {
              "allowForwardedTraffic": true,
              "allowGatewayTransit": false,
              "allowVirtualNetworkAccess": true,
              "remoteVirtualNetworkName": "hub1",
              "useRemoteGateways": false
            }
          ],
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
          azureSkuTier: 'Standard'
          enableTelemetry: true
          location: '<location>'
          publicIPAddressObject: {
            name: 'hub1PublicIp'
          }
          threatIntelMode: 'Alert'
          zones: [
            1
            2
            3
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
        location: '<location>'
        lock: {
          kind: 'CanNotDelete'
          name: 'hub1Lock'
        }
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
            "azureSkuTier": "Standard",
            "enableTelemetry": true,
            "location": "<location>",
            "publicIPAddressObject": {
              "name": "hub1PublicIp"
            },
            "threatIntelMode": "Alert",
            "zones": [
              1,
              2,
              3
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
          "location": "<location>",
          "lock": {
            "kind": "CanNotDelete",
            "name": "hub1Lock"
          },
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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-hubvirtualnetworks>any_other_property<) | object | The hub virtual networks to create. |

### Parameter: `hubVirtualNetworks.>Any_other_property<`

The hub virtual networks to create.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-hubvirtualnetworks>any_other_property<addressprefixes) | array | The address prefixes for the virtual network. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureFirewallSettings`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettings) | object | The Azure Firewall config. |
| [`bastionHost`](#parameter-hubvirtualnetworks>any_other_property<bastionhost) | object | The Azure Bastion config. |
| [`ddosProtectionPlanResourceId`](#parameter-hubvirtualnetworks>any_other_property<ddosprotectionplanresourceid) | string | The DDoS protection plan resource ID. |
| [`diagnosticSettings`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettings) | array | The diagnostic settings of the virtual network. |
| [`dnsServers`](#parameter-hubvirtualnetworks>any_other_property<dnsservers) | array | The DNS servers of the virtual network. |
| [`enableAzureFirewall`](#parameter-hubvirtualnetworks>any_other_property<enableazurefirewall) | bool | Enable/Disable Azure Firewall for the virtual network. |
| [`enableBastion`](#parameter-hubvirtualnetworks>any_other_property<enablebastion) | bool | Enable/Disable Azure Bastion for the virtual network. |
| [`enablePeering`](#parameter-hubvirtualnetworks>any_other_property<enablepeering) | bool | Enable/Disable peering for the virtual network. |
| [`enableTelemetry`](#parameter-hubvirtualnetworks>any_other_property<enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`flowTimeoutInMinutes`](#parameter-hubvirtualnetworks>any_other_property<flowtimeoutinminutes) | int | The flow timeout in minutes. |
| [`location`](#parameter-hubvirtualnetworks>any_other_property<location) | string | The location of the virtual network. Defaults to the location of the resource group. |
| [`lock`](#parameter-hubvirtualnetworks>any_other_property<lock) | object | The lock settings of the virtual network. |
| [`peeringSettings`](#parameter-hubvirtualnetworks>any_other_property<peeringsettings) | array | The peerings of the virtual network. |
| [`roleAssignments`](#parameter-hubvirtualnetworks>any_other_property<roleassignments) | array | The role assignments to create. |
| [`routes`](#parameter-hubvirtualnetworks>any_other_property<routes) | array | Routes to add to the virtual network route table. |
| [`subnets`](#parameter-hubvirtualnetworks>any_other_property<subnets) | array | The subnets of the virtual network. |
| [`tags`](#parameter-hubvirtualnetworks>any_other_property<tags) | object | The tags of the virtual network. |
| [`vnetEncryption`](#parameter-hubvirtualnetworks>any_other_property<vnetencryption) | bool | Enable/Disable VNet encryption. |
| [`vnetEncryptionEnforcement`](#parameter-hubvirtualnetworks>any_other_property<vnetencryptionenforcement) | string | The VNet encryption enforcement settings of the virtual network. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.addressPrefixes`

The address prefixes for the virtual network.

- Required: Yes
- Type: array

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings`

The Azure Firewall config.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalPublicIpConfigurations`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsadditionalpublicipconfigurations) | array | Additional public IP configurations. |
| [`applicationRuleCollections`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsapplicationrulecollections) | array | Application rule collections. |
| [`azureSkuTier`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsazureskutier) | string | Azure Firewall SKU. |
| [`diagnosticSettings`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettings) | array | Diagnostic settings. |
| [`enableTelemetry`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`firewallPolicyId`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsfirewallpolicyid) | string | Firewall policy ID. |
| [`hubIpAddresses`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingshubipaddresses) | object | Hub IP addresses. |
| [`location`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingslocation) | string | The location of the virtual network. Defaults to the location of the resource group. |
| [`lock`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingslock) | object | Lock settings. |
| [`managementIPAddressObject`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsmanagementipaddressobject) | object | Management IP address configuration. |
| [`managementIPResourceID`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsmanagementipresourceid) | string | Management IP resource ID. |
| [`natRuleCollections`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsnatrulecollections) | array | NAT rule collections. |
| [`networkRuleCollections`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsnetworkrulecollections) | array | Network rule collections. |
| [`publicIPAddressObject`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingspublicipaddressobject) | object | Public IP address object. |
| [`publicIPResourceID`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingspublicipresourceid) | string | Public IP resource ID. |
| [`roleAssignments`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsroleassignments) | array | Role assignments. |
| [`tags`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingstags) | object | Tags of the resource. |
| [`threatIntelMode`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsthreatintelmode) | string | Threat Intel mode. |
| [`virtualHub`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsvirtualhub) | string | Virtual Hub ID. |
| [`zones`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingszones) | array | Zones. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.additionalPublicIpConfigurations`

Additional public IP configurations.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.applicationRuleCollections`

Application rule collections.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.azureSkuTier`

Azure Firewall SKU.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings`

Diagnostic settings.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |
| [`logAnalyticsDestinationType`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |
| [`workspaceResourceId`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.firewallPolicyId`

Firewall policy ID.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.hubIpAddresses`

Hub IP addresses.

- Required: No
- Type: object

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.location`

The location of the virtual network. Defaults to the location of the resource group.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.lock`

Lock settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingslockname) | string | Specify the name of lock. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.lock.kind`

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

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.managementIPAddressObject`

Management IP address configuration.

- Required: No
- Type: object

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.managementIPResourceID`

Management IP resource ID.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.natRuleCollections`

NAT rule collections.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.networkRuleCollections`

Network rule collections.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.publicIPAddressObject`

Public IP address object.

- Required: No
- Type: object

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.publicIPResourceID`

Public IP resource ID.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.roleAssignments`

Role assignments.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-hubvirtualnetworks>any_other_property<azurefirewallsettingsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.roleAssignments.principalType`

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

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.threatIntelMode`

Threat Intel mode.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.virtualHub`

Virtual Hub ID.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.azureFirewallSettings.zones`

Zones.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.>Any_other_property<.bastionHost`

The Azure Bastion config.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`disableCopyPaste`](#parameter-hubvirtualnetworks>any_other_property<bastionhostdisablecopypaste) | bool | Enable/Disable copy/paste functionality. |
| [`enableFileCopy`](#parameter-hubvirtualnetworks>any_other_property<bastionhostenablefilecopy) | bool | Enable/Disable file copy functionality. |
| [`enableIpConnect`](#parameter-hubvirtualnetworks>any_other_property<bastionhostenableipconnect) | bool | Enable/Disable IP connect functionality. |
| [`enableShareableLink`](#parameter-hubvirtualnetworks>any_other_property<bastionhostenableshareablelink) | bool | Enable/Disable shareable link functionality. |
| [`scaleUnits`](#parameter-hubvirtualnetworks>any_other_property<bastionhostscaleunits) | int | The number of scale units for the Bastion host. Defaults to 4. |
| [`skuName`](#parameter-hubvirtualnetworks>any_other_property<bastionhostskuname) | string | The SKU name of the Bastion host. Defaults to Standard. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.bastionHost.disableCopyPaste`

Enable/Disable copy/paste functionality.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.bastionHost.enableFileCopy`

Enable/Disable file copy functionality.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.bastionHost.enableIpConnect`

Enable/Disable IP connect functionality.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.bastionHost.enableShareableLink`

Enable/Disable shareable link functionality.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.bastionHost.scaleUnits`

The number of scale units for the Bastion host. Defaults to 4.

- Required: No
- Type: int

### Parameter: `hubVirtualNetworks.>Any_other_property<.bastionHost.skuName`

The SKU name of the Bastion host. Defaults to Standard.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.ddosProtectionPlanResourceId`

The DDoS protection plan resource ID.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings`

The diagnostic settings of the virtual network.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |
| [`logAnalyticsDestinationType`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |
| [`workspaceResourceId`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-hubvirtualnetworks>any_other_property<diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.name`

The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.dnsServers`

The DNS servers of the virtual network.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.>Any_other_property<.enableAzureFirewall`

Enable/Disable Azure Firewall for the virtual network.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.enableBastion`

Enable/Disable Azure Bastion for the virtual network.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.enablePeering`

Enable/Disable peering for the virtual network.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.flowTimeoutInMinutes`

The flow timeout in minutes.

- Required: No
- Type: int

### Parameter: `hubVirtualNetworks.>Any_other_property<.location`

The location of the virtual network. Defaults to the location of the resource group.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.lock`

The lock settings of the virtual network.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-hubvirtualnetworks>any_other_property<lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-hubvirtualnetworks>any_other_property<lockname) | string | Specify the name of lock. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.lock.kind`

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

### Parameter: `hubVirtualNetworks.>Any_other_property<.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.peeringSettings`

The peerings of the virtual network.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allowForwardedTraffic`](#parameter-hubvirtualnetworks>any_other_property<peeringsettingsallowforwardedtraffic) | bool | Allow forwarded traffic. |
| [`allowGatewayTransit`](#parameter-hubvirtualnetworks>any_other_property<peeringsettingsallowgatewaytransit) | bool | Allow gateway transit. |
| [`allowVirtualNetworkAccess`](#parameter-hubvirtualnetworks>any_other_property<peeringsettingsallowvirtualnetworkaccess) | bool | Allow virtual network access. |
| [`remoteVirtualNetworkName`](#parameter-hubvirtualnetworks>any_other_property<peeringsettingsremotevirtualnetworkname) | string | Remote virtual network name. |
| [`useRemoteGateways`](#parameter-hubvirtualnetworks>any_other_property<peeringsettingsuseremotegateways) | bool | Use remote gateways. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.peeringSettings.allowForwardedTraffic`

Allow forwarded traffic.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.peeringSettings.allowGatewayTransit`

Allow gateway transit.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.peeringSettings.allowVirtualNetworkAccess`

Allow virtual network access.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.peeringSettings.remoteVirtualNetworkName`

Remote virtual network name.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.peeringSettings.useRemoteGateways`

Use remote gateways.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.roleAssignments`

The role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-hubvirtualnetworks>any_other_property<roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-hubvirtualnetworks>any_other_property<roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-hubvirtualnetworks>any_other_property<roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-hubvirtualnetworks>any_other_property<roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-hubvirtualnetworks>any_other_property<roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-hubvirtualnetworks>any_other_property<roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-hubvirtualnetworks>any_other_property<roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-hubvirtualnetworks>any_other_property<roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `hubVirtualNetworks.>Any_other_property<.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `hubVirtualNetworks.>Any_other_property<.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `hubVirtualNetworks.>Any_other_property<.roleAssignments.principalType`

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

### Parameter: `hubVirtualNetworks.>Any_other_property<.routes`

Routes to add to the virtual network route table.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.>Any_other_property<.subnets`

The subnets of the virtual network.

- Required: No
- Type: array

### Parameter: `hubVirtualNetworks.>Any_other_property<.tags`

The tags of the virtual network.

- Required: No
- Type: object

### Parameter: `hubVirtualNetworks.>Any_other_property<.vnetEncryption`

Enable/Disable VNet encryption.

- Required: No
- Type: bool

### Parameter: `hubVirtualNetworks.>Any_other_property<.vnetEncryptionEnforcement`

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
| `hubAzureFirewalls` | array | Array of hub Azure Firewall resources. |
| `hubBastions` | array | Array of hub bastion resources. |
| `hubVirtualNetworks` | array | Array of hub virtual network resources. |
| `hubVirtualNetworkSubnets` | array | The subnets of the hub virtual network. |
| `resourceGroupName` | string | The resource group the resources were deployed into. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/azure-firewall:0.5.0` | Remote reference |
| `br/public:avm/res/network/bastion-host:0.4.0` | Remote reference |
| `br/public:avm/res/network/route-table:0.4.0` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.4.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
