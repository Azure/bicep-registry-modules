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
| `Microsoft.Network/bastionHosts` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-11-01/bastionHosts) |
| `Microsoft.Network/publicIPAddresses` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/publicIPAddresses) |
| `Microsoft.Network/routeTables` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/routeTables) |
| `Microsoft.Network/virtualNetworks` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks) |
| `Microsoft.Network/virtualNetworks/subnets` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/virtualNetworks/subnets) |
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
  name: '${uniqueString(deployment().name, resourceLocation)}-test-nhnmin'
  params: {
    // Required parameters
    name: 'nhnmin001'
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
    "name": {
      "value": "nhnmin001"
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
module hubNetworking 'br/public:avm/ptn/network/hub-networking:<version>' = {
  name: '${uniqueString(deployment().name, resourceLocation)}-test-nhnmax'
  params: {
    // Required parameters
    name: 'nhnmax001'
    // Non-required parameters
    hubVirtualNetworks: {
      hub1: {
        addressPrefixes: [
          '10.0.0.0/16'
        ]
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
        enablePeering: false
        enableTelemetry: true
        flowTimeoutInMinutes: 30
        location: 'westeurope'
        lock: {
          kind: 'CanNotDelete'
          name: 'hub1Lock'
        }
        name: 'hub1'
        peerings: [
          {
            allowForwardedTraffic: false
            allowGatewayTransit: false
            allowVirtualNetworkAccess: true
            name: 'hub1-to-hub2'
            remoteVirtualNetworkId: 'hub2'
            useRemoteGateways: false
          }
        ]
        roleAssignments: []
        subnets: [
          {
            addressPrefix: '10.0.1.0/24'
            name: 'subnet1'
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
        addressPrefixes: [
          '10.1.0.0/16'
        ]
        diagnosticSettings: []
        dnsServers: []
        enablePeering: false
        enableTelemetry: false
        flowTimeoutInMinutes: 10
        location: 'westus2'
        lock: {
          kind: 'CanNotDelete'
          name: 'hub2Lock'
        }
        name: 'hub2'
        roleAssignments: []
        subnets: [
          {
            addressPrefix: '10.1.1.0/24'
            name: 'subnet1'
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
    // Required parameters
    "name": {
      "value": "nhnmax001"
    },
    // Non-required parameters
    "hubVirtualNetworks": {
      "value": {
        "hub1": {
          "addressPrefixes": [
            "10.0.0.0/16"
          ],
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
          "enablePeering": false,
          "enableTelemetry": true,
          "flowTimeoutInMinutes": 30,
          "location": "westeurope",
          "lock": {
            "kind": "CanNotDelete",
            "name": "hub1Lock"
          },
          "name": "hub1",
          "peerings": [
            {
              "allowForwardedTraffic": false,
              "allowGatewayTransit": false,
              "allowVirtualNetworkAccess": true,
              "name": "hub1-to-hub2",
              "remoteVirtualNetworkId": "hub2",
              "useRemoteGateways": false
            }
          ],
          "roleAssignments": [],
          "subnets": [
            {
              "addressPrefix": "10.0.1.0/24",
              "name": "subnet1"
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
          "addressPrefixes": [
            "10.1.0.0/16"
          ],
          "diagnosticSettings": [],
          "dnsServers": [],
          "enablePeering": false,
          "enableTelemetry": false,
          "flowTimeoutInMinutes": 10,
          "location": "westus2",
          "lock": {
            "kind": "CanNotDelete",
            "name": "hub2Lock"
          },
          "name": "hub2",
          "roleAssignments": [],
          "subnets": [
            {
              "addressPrefix": "10.1.1.0/24",
              "name": "subnet1"
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
  name: '${uniqueString(deployment().name, resourceLocation)}-test-nhnwaf'
  params: {
    // Required parameters
    name: 'nhnwaf001'
    // Non-required parameters
    hubVirtualNetworks: {
      hub1: {
        addressPrefixes: '<addressPrefixes>'
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
        roleAssignments: []
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
    // Required parameters
    "name": {
      "value": "nhnwaf001"
    },
    // Non-required parameters
    "hubVirtualNetworks": {
      "value": {
        "hub1": {
          "addressPrefixes": "<addressPrefixes>",
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
          "roleAssignments": [],
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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the resource to create. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`hubVirtualNetworks`](#parameter-hubvirtualnetworks) | object | A map of the hub virtual networks to create. |
| [`location`](#parameter-location) | string | Location for all Resources. |

### Parameter: `name`

Name of the resource to create.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

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

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.value.

- Required: No
- Type: string

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
| `hubBastionName` | array | The name of the bastion host. |
| `hubBastionResourceId` | array | The resource ID of the bastion host. |
| `hubVirtualNetworkName` | array | The name of the hub virtual network. |
| `hubVirtualNetworkResourceId` | array | The resource ID of the hub virtual network. |
| `location` | array | The location the virtual network was deployed into. |
| `resourceGroupName` | array | The resource group the virtual network was deployed into. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/bastion-host:0.1.1` | Remote reference |
| `br/public:avm/res/network/route-table:0.2.2` | Remote reference |
| `br/public:avm/res/network/virtual-network:0.1.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
