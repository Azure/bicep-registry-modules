# Virtual Networks `[Microsoft.Network/virtualNetworks]`

This module deploys a Virtual Network (vNet).

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/virtualNetworks` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/subnets) |
| `Microsoft.Network/virtualNetworks/virtualNetworkPeerings` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/virtualNetworkPeerings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/virtual-network:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [Deploying a bi-directional peering](#example-3-deploying-a-bi-directional-peering)
- [WAF-aligned](#example-4-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetwork 'br/public:avm/res/network/virtual-network:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-nvnmin'
  params: {
    // Required parameters
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    name: 'nvnmin001'
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
    "addressPrefixes": {
      "value": [
        "10.0.0.0/16"
      ]
    },
    "name": {
      "value": "nvnmin001"
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
module virtualNetwork 'br/public:avm/res/network/virtual-network:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-nvnmax'
  params: {
    // Required parameters
    addressPrefixes: [
      '<addressPrefix>'
    ]
    name: 'nvnmax001'
    // Non-required parameters
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
    flowTimeoutInMinutes: 20
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    subnets: [
      {
        addressPrefix: '<addressPrefix>'
        name: 'GatewaySubnet'
      }
      {
        addressPrefix: '<addressPrefix>'
        name: 'az-subnet-x-001'
        networkSecurityGroupResourceId: '<networkSecurityGroupResourceId>'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        routeTableResourceId: '<routeTableResourceId>'
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.Sql'
          }
        ]
      }
      {
        addressPrefix: '<addressPrefix>'
        delegations: [
          {
            name: 'netappDel'
            properties: {
              serviceName: 'Microsoft.Netapp/volumes'
            }
          }
        ]
        name: 'az-subnet-x-002'
        networkSecurityGroupResourceId: '<networkSecurityGroupResourceId>'
      }
      {
        addressPrefix: '<addressPrefix>'
        name: 'az-subnet-x-003'
        networkSecurityGroupResourceId: '<networkSecurityGroupResourceId>'
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
      {
        addressPrefix: '<addressPrefix>'
        name: 'AzureBastionSubnet'
        networkSecurityGroupResourceId: '<networkSecurityGroupResourceId>'
      }
      {
        addressPrefix: '<addressPrefix>'
        name: 'AzureFirewallSubnet'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "addressPrefixes": {
      "value": [
        "<addressPrefix>"
      ]
    },
    "name": {
      "value": "nvnmax001"
    },
    // Non-required parameters
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
    "dnsServers": {
      "value": [
        "10.0.1.4",
        "10.0.1.5"
      ]
    },
    "flowTimeoutInMinutes": {
      "value": 20
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
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
        }
      ]
    },
    "subnets": {
      "value": [
        {
          "addressPrefix": "<addressPrefix>",
          "name": "GatewaySubnet"
        },
        {
          "addressPrefix": "<addressPrefix>",
          "name": "az-subnet-x-001",
          "networkSecurityGroupResourceId": "<networkSecurityGroupResourceId>",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "routeTableResourceId": "<routeTableResourceId>",
          "serviceEndpoints": [
            {
              "service": "Microsoft.Storage"
            },
            {
              "service": "Microsoft.Sql"
            }
          ]
        },
        {
          "addressPrefix": "<addressPrefix>",
          "delegations": [
            {
              "name": "netappDel",
              "properties": {
                "serviceName": "Microsoft.Netapp/volumes"
              }
            }
          ],
          "name": "az-subnet-x-002",
          "networkSecurityGroupResourceId": "<networkSecurityGroupResourceId>"
        },
        {
          "addressPrefix": "<addressPrefix>",
          "name": "az-subnet-x-003",
          "networkSecurityGroupResourceId": "<networkSecurityGroupResourceId>",
          "privateEndpointNetworkPolicies": "Disabled",
          "privateLinkServiceNetworkPolicies": "Enabled"
        },
        {
          "addressPrefix": "<addressPrefix>",
          "name": "AzureBastionSubnet",
          "networkSecurityGroupResourceId": "<networkSecurityGroupResourceId>"
        },
        {
          "addressPrefix": "<addressPrefix>",
          "name": "AzureFirewallSubnet"
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

### Example 3: _Deploying a bi-directional peering_

This instance deploys the module with both an inbound and outbound peering.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetwork 'br/public:avm/res/network/virtual-network:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-nvnpeer'
  params: {
    // Required parameters
    addressPrefixes: [
      '10.1.0.0/24'
    ]
    name: 'nvnpeer001'
    // Non-required parameters
    location: '<location>'
    peerings: [
      {
        allowForwardedTraffic: true
        allowGatewayTransit: false
        allowVirtualNetworkAccess: true
        remotePeeringAllowForwardedTraffic: true
        remotePeeringAllowVirtualNetworkAccess: true
        remotePeeringEnabled: true
        remotePeeringName: 'customName'
        remoteVirtualNetworkId: '<remoteVirtualNetworkId>'
        useRemoteGateways: false
      }
    ]
    subnets: [
      {
        addressPrefix: '10.1.0.0/26'
        name: 'GatewaySubnet'
      }
      {
        addressPrefix: '10.1.0.64/26'
        name: 'AzureBastionSubnet'
        networkSecurityGroupResourceId: '<networkSecurityGroupResourceId>'
      }
      {
        addressPrefix: '10.1.0.128/26'
        name: 'AzureFirewallSubnet'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "addressPrefixes": {
      "value": [
        "10.1.0.0/24"
      ]
    },
    "name": {
      "value": "nvnpeer001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "peerings": {
      "value": [
        {
          "allowForwardedTraffic": true,
          "allowGatewayTransit": false,
          "allowVirtualNetworkAccess": true,
          "remotePeeringAllowForwardedTraffic": true,
          "remotePeeringAllowVirtualNetworkAccess": true,
          "remotePeeringEnabled": true,
          "remotePeeringName": "customName",
          "remoteVirtualNetworkId": "<remoteVirtualNetworkId>",
          "useRemoteGateways": false
        }
      ]
    },
    "subnets": {
      "value": [
        {
          "addressPrefix": "10.1.0.0/26",
          "name": "GatewaySubnet"
        },
        {
          "addressPrefix": "10.1.0.64/26",
          "name": "AzureBastionSubnet",
          "networkSecurityGroupResourceId": "<networkSecurityGroupResourceId>"
        },
        {
          "addressPrefix": "10.1.0.128/26",
          "name": "AzureFirewallSubnet"
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

### Example 4: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module virtualNetwork 'br/public:avm/res/network/virtual-network:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-nvnwaf'
  params: {
    // Required parameters
    addressPrefixes: [
      '<addressPrefix>'
    ]
    name: 'nvnwaf001'
    // Non-required parameters
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
    flowTimeoutInMinutes: 20
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    subnets: [
      {
        addressPrefix: '<addressPrefix>'
        name: 'GatewaySubnet'
      }
      {
        addressPrefix: '<addressPrefix>'
        name: 'az-subnet-x-001'
        networkSecurityGroupResourceId: '<networkSecurityGroupResourceId>'
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        routeTableResourceId: '<routeTableResourceId>'
        serviceEndpoints: [
          {
            service: 'Microsoft.Storage'
          }
          {
            service: 'Microsoft.Sql'
          }
        ]
      }
      {
        addressPrefix: '<addressPrefix>'
        delegations: [
          {
            name: 'netappDel'
            properties: {
              serviceName: 'Microsoft.Netapp/volumes'
            }
          }
        ]
        name: 'az-subnet-x-002'
        networkSecurityGroupResourceId: '<networkSecurityGroupResourceId>'
      }
      {
        addressPrefix: '<addressPrefix>'
        name: 'az-subnet-x-003'
        networkSecurityGroupResourceId: '<networkSecurityGroupResourceId>'
        privateEndpointNetworkPolicies: 'Disabled'
        privateLinkServiceNetworkPolicies: 'Enabled'
      }
      {
        addressPrefix: '<addressPrefix>'
        name: 'AzureBastionSubnet'
        networkSecurityGroupResourceId: '<networkSecurityGroupResourceId>'
      }
      {
        addressPrefix: '<addressPrefix>'
        name: 'AzureFirewallSubnet'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "addressPrefixes": {
      "value": [
        "<addressPrefix>"
      ]
    },
    "name": {
      "value": "nvnwaf001"
    },
    // Non-required parameters
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
    "dnsServers": {
      "value": [
        "10.0.1.4",
        "10.0.1.5"
      ]
    },
    "flowTimeoutInMinutes": {
      "value": 20
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
    "subnets": {
      "value": [
        {
          "addressPrefix": "<addressPrefix>",
          "name": "GatewaySubnet"
        },
        {
          "addressPrefix": "<addressPrefix>",
          "name": "az-subnet-x-001",
          "networkSecurityGroupResourceId": "<networkSecurityGroupResourceId>",
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "routeTableResourceId": "<routeTableResourceId>",
          "serviceEndpoints": [
            {
              "service": "Microsoft.Storage"
            },
            {
              "service": "Microsoft.Sql"
            }
          ]
        },
        {
          "addressPrefix": "<addressPrefix>",
          "delegations": [
            {
              "name": "netappDel",
              "properties": {
                "serviceName": "Microsoft.Netapp/volumes"
              }
            }
          ],
          "name": "az-subnet-x-002",
          "networkSecurityGroupResourceId": "<networkSecurityGroupResourceId>"
        },
        {
          "addressPrefix": "<addressPrefix>",
          "name": "az-subnet-x-003",
          "networkSecurityGroupResourceId": "<networkSecurityGroupResourceId>",
          "privateEndpointNetworkPolicies": "Disabled",
          "privateLinkServiceNetworkPolicies": "Enabled"
        },
        {
          "addressPrefix": "<addressPrefix>",
          "name": "AzureBastionSubnet",
          "networkSecurityGroupResourceId": "<networkSecurityGroupResourceId>"
        },
        {
          "addressPrefix": "<addressPrefix>",
          "name": "AzureFirewallSubnet"
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


## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-addressprefixes) | array | An Array of 1 or more IP Address Prefixes for the Virtual Network. |
| [`name`](#parameter-name) | string | The name of the Virtual Network (vNet). |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ddosProtectionPlanResourceId`](#parameter-ddosprotectionplanresourceid) | string | Resource ID of the DDoS protection plan to assign the VNET to. If it's left blank, DDoS protection will not be configured. If it's provided, the VNET created by this template will be attached to the referenced DDoS protection plan. The DDoS protection plan can exist in the same or in a different subscription. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`dnsServers`](#parameter-dnsservers) | array | DNS Servers associated to the Virtual Network. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`flowTimeoutInMinutes`](#parameter-flowtimeoutinminutes) | int | The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes. Default value 0 will set the property to null. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`peerings`](#parameter-peerings) | array | Virtual Network Peerings configurations. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`subnets`](#parameter-subnets) | array | An Array of subnets to deploy to the Virtual Network. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`vnetEncryption`](#parameter-vnetencryption) | bool | Indicates if encryption is enabled on virtual network and if VM without encryption is allowed in encrypted VNet. Requires the EnableVNetEncryption feature to be registered for the subscription and a supported region to use this property. |
| [`vnetEncryptionEnforcement`](#parameter-vnetencryptionenforcement) | string | If the encrypted VNet allows VM that does not support encryption. Can only be used when vnetEncryption is enabled. |

### Parameter: `addressPrefixes`

An Array of 1 or more IP Address Prefixes for the Virtual Network.

- Required: Yes
- Type: array

### Parameter: `name`

The name of the Virtual Network (vNet).

- Required: Yes
- Type: string

### Parameter: `ddosProtectionPlanResourceId`

Resource ID of the DDoS protection plan to assign the VNET to. If it's left blank, DDoS protection will not be configured. If it's provided, the VNET created by this template will be attached to the referenced DDoS protection plan. The DDoS protection plan can exist in the same or in a different subscription.

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

### Parameter: `dnsServers`

DNS Servers associated to the Virtual Network.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `flowTimeoutInMinutes`

The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes. Default value 0 will set the property to null.

- Required: No
- Type: int
- Default: `0`

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

### Parameter: `peerings`

Virtual Network Peerings configurations.

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

### Parameter: `subnets`

An Array of subnets to deploy to the Virtual Network.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `vnetEncryption`

Indicates if encryption is enabled on virtual network and if VM without encryption is allowed in encrypted VNet. Requires the EnableVNetEncryption feature to be registered for the subscription and a supported region to use this property.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `vnetEncryptionEnforcement`

If the encrypted VNet allows VM that does not support encryption. Can only be used when vnetEncryption is enabled.

- Required: No
- Type: string
- Default: `'AllowUnencrypted'`
- Allowed:
  ```Bicep
  [
    'AllowUnencrypted'
    'DropUnencrypted'
  ]
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the virtual network. |
| `resourceGroupName` | string | The resource group the virtual network was deployed into. |
| `resourceId` | string | The resource ID of the virtual network. |
| `subnetNames` | array | The names of the deployed subnets. |
| `subnetResourceIds` | array | The resource IDs of the deployed subnets. |

## Cross-referenced modules

_None_

## Notes

### Considerations

The network security group and route table resources must reside in the same resource group as the virtual network.

### Parameter Usage: `peerings`

As the virtual network peering array allows you to deploy not only a one-way but also two-way peering (i.e reverse), you can use the following ***additional*** properties on top of what is documented in _[virtualNetworkPeering](virtual-network-peering/README.md)_.

| Parameter Name | Type | Default Value | Possible Values | Description |
| :-- | :-- | :-- | :-- | :-- |
| `remotePeeringEnabled` | bool | `false` |  | Optional. Set to true to also deploy the reverse peering for the configured remote virtual networks to the local network |
| `remotePeeringName` | string | `'${last(split(peering.remoteVirtualNetworkId, '/'))}-${name}'` | | Optional. The Name of Vnet Peering resource. If not provided, default value will be <remoteVnetName>-<localVnetName> |
| `remotePeeringAllowForwardedTraffic` | bool | `true` | | Optional. Whether the forwarded traffic from the VMs in the local virtual network will be allowed/disallowed in remote virtual network. |
| `remotePeeringAllowGatewayTransit` | bool | `false` | | Optional. If gateway links can be used in remote virtual networking to link to this virtual network. |
| `remotePeeringAllowVirtualNetworkAccess` | bool | `true` | | Optional. Whether the VMs in the local virtual network space would be able to access the VMs in remote virtual network space. |
| `remotePeeringDoNotVerifyRemoteGateways` | bool | `true` | | Optional. If we need to verify the provisioning state of the remote gateway. |
| `remotePeeringUseRemoteGateways` | bool | `false` | |  Optional. If remote gateways can be used on this virtual network. If the flag is set to `true`, and allowGatewayTransit on local peering is also `true`, virtual network will use gateways of local virtual network for transit. Only one peering can have this flag set to `true`. This flag cannot be set if virtual network already has a gateway.  |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
