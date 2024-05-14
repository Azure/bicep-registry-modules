# Azure Front Doors `[Microsoft.Network/frontDoors]`

This module deploys an Azure Front Door.

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
| `Microsoft.Network/frontDoors` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-05-01/frontDoors) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/front-door:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module frontDoor 'br/public:avm/res/network/front-door:<version>' = {
  name: 'frontDoorDeployment'
  params: {
    // Required parameters
    backendPools: [
      {
        name: 'backendPool'
        properties: {
          backends: [
            {
              address: 'biceptest.local'
              backendHostHeader: 'backendAddress'
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              weight: 50
            }
          ]
          HealthProbeSettings: {
            id: '<id>'
          }
          LoadBalancingSettings: {
            id: '<id>'
          }
        }
      }
    ]
    frontendEndpoints: [
      {
        name: 'frontEnd'
        properties: {
          hostName: '<hostName>'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 60
        }
      }
    ]
    healthProbeSettings: [
      {
        name: 'heathProbe'
        properties: {
          intervalInSeconds: 60
          path: '/'
          protocol: 'Https'
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: 'loadBalancer'
        properties: {
          additionalLatencyMilliseconds: 0
          sampleSize: 50
          successfulSamplesRequired: 1
        }
      }
    ]
    name: '<name>'
    routingRules: [
      {
        name: 'routingRule'
        properties: {
          acceptedProtocols: [
            'Https'
          ]
          enabledState: 'Enabled'
          frontendEndpoints: [
            {
              id: '<id>'
            }
          ]
          patternsToMatch: [
            '/*'
          ]
          routeConfiguration: {
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
            backendPool: {
              id: '<id>'
            }
          }
        }
      }
    ]
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
    "backendPools": {
      "value": [
        {
          "name": "backendPool",
          "properties": {
            "backends": [
              {
                "address": "biceptest.local",
                "backendHostHeader": "backendAddress",
                "enabledState": "Enabled",
                "httpPort": 80,
                "httpsPort": 443,
                "priority": 1,
                "weight": 50
              }
            ],
            "HealthProbeSettings": {
              "id": "<id>"
            },
            "LoadBalancingSettings": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "frontendEndpoints": {
      "value": [
        {
          "name": "frontEnd",
          "properties": {
            "hostName": "<hostName>",
            "sessionAffinityEnabledState": "Disabled",
            "sessionAffinityTtlSeconds": 60
          }
        }
      ]
    },
    "healthProbeSettings": {
      "value": [
        {
          "name": "heathProbe",
          "properties": {
            "intervalInSeconds": 60,
            "path": "/",
            "protocol": "Https"
          }
        }
      ]
    },
    "loadBalancingSettings": {
      "value": [
        {
          "name": "loadBalancer",
          "properties": {
            "additionalLatencyMilliseconds": 0,
            "sampleSize": 50,
            "successfulSamplesRequired": 1
          }
        }
      ]
    },
    "name": {
      "value": "<name>"
    },
    "routingRules": {
      "value": [
        {
          "name": "routingRule",
          "properties": {
            "acceptedProtocols": [
              "Https"
            ],
            "enabledState": "Enabled",
            "frontendEndpoints": [
              {
                "id": "<id>"
              }
            ],
            "patternsToMatch": [
              "/*"
            ],
            "routeConfiguration": {
              "@odata.type": "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration",
              "backendPool": {
                "id": "<id>"
              }
            }
          }
        }
      ]
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
module frontDoor 'br/public:avm/res/network/front-door:<version>' = {
  name: 'frontDoorDeployment'
  params: {
    // Required parameters
    backendPools: [
      {
        name: 'backendPool'
        properties: {
          backends: [
            {
              address: 'biceptest.local'
              backendHostHeader: 'backendAddress'
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              privateLinkAlias: ''
              privateLinkApprovalMessage: ''
              privateLinkLocation: ''
              weight: 50
            }
          ]
          HealthProbeSettings: {
            id: '<id>'
          }
          LoadBalancingSettings: {
            id: '<id>'
          }
        }
      }
    ]
    frontendEndpoints: [
      {
        name: 'frontEnd'
        properties: {
          hostName: '<hostName>'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 60
        }
      }
    ]
    healthProbeSettings: [
      {
        name: 'heathProbe'
        properties: {
          enabledState: ''
          healthProbeMethod: ''
          intervalInSeconds: 60
          path: '/'
          protocol: 'Https'
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: 'loadBalancer'
        properties: {
          additionalLatencyMilliseconds: 0
          sampleSize: 50
          successfulSamplesRequired: 1
        }
      }
    ]
    name: '<name>'
    routingRules: [
      {
        name: 'routingRule'
        properties: {
          acceptedProtocols: [
            'Http'
            'Https'
          ]
          enabledState: 'Enabled'
          frontendEndpoints: [
            {
              id: '<id>'
            }
          ]
          patternsToMatch: [
            '/*'
          ]
          routeConfiguration: {
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
            backendPool: {
              id: '<id>'
            }
            forwardingProtocol: 'MatchRequest'
          }
        }
      }
    ]
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            category: 'FrontdoorAccessLog'
          }
        ]
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
    enforceCertificateNameCheck: 'Disabled'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Owner'
      }
      {
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
    sendRecvTimeoutSeconds: 10
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
    "backendPools": {
      "value": [
        {
          "name": "backendPool",
          "properties": {
            "backends": [
              {
                "address": "biceptest.local",
                "backendHostHeader": "backendAddress",
                "enabledState": "Enabled",
                "httpPort": 80,
                "httpsPort": 443,
                "priority": 1,
                "privateLinkAlias": "",
                "privateLinkApprovalMessage": "",
                "privateLinkLocation": "",
                "weight": 50
              }
            ],
            "HealthProbeSettings": {
              "id": "<id>"
            },
            "LoadBalancingSettings": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "frontendEndpoints": {
      "value": [
        {
          "name": "frontEnd",
          "properties": {
            "hostName": "<hostName>",
            "sessionAffinityEnabledState": "Disabled",
            "sessionAffinityTtlSeconds": 60
          }
        }
      ]
    },
    "healthProbeSettings": {
      "value": [
        {
          "name": "heathProbe",
          "properties": {
            "enabledState": "",
            "healthProbeMethod": "",
            "intervalInSeconds": 60,
            "path": "/",
            "protocol": "Https"
          }
        }
      ]
    },
    "loadBalancingSettings": {
      "value": [
        {
          "name": "loadBalancer",
          "properties": {
            "additionalLatencyMilliseconds": 0,
            "sampleSize": 50,
            "successfulSamplesRequired": 1
          }
        }
      ]
    },
    "name": {
      "value": "<name>"
    },
    "routingRules": {
      "value": [
        {
          "name": "routingRule",
          "properties": {
            "acceptedProtocols": [
              "Http",
              "Https"
            ],
            "enabledState": "Enabled",
            "frontendEndpoints": [
              {
                "id": "<id>"
              }
            ],
            "patternsToMatch": [
              "/*"
            ],
            "routeConfiguration": {
              "@odata.type": "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration",
              "backendPool": {
                "id": "<id>"
              },
              "forwardingProtocol": "MatchRequest"
            }
          }
        }
      ]
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "category": "FrontdoorAccessLog"
            }
          ],
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
    "enforceCertificateNameCheck": {
      "value": "Disabled"
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
          "roleDefinitionIdOrName": "Owner"
        },
        {
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
    "sendRecvTimeoutSeconds": {
      "value": 10
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
module frontDoor 'br/public:avm/res/network/front-door:<version>' = {
  name: 'frontDoorDeployment'
  params: {
    // Required parameters
    backendPools: [
      {
        name: 'backendPool'
        properties: {
          backends: [
            {
              address: 'biceptest.local'
              backendHostHeader: 'backendAddress'
              enabledState: 'Enabled'
              httpPort: 80
              httpsPort: 443
              priority: 1
              privateLinkAlias: ''
              privateLinkApprovalMessage: ''
              privateLinkLocation: ''
              weight: 50
            }
          ]
          HealthProbeSettings: {
            id: '<id>'
          }
          LoadBalancingSettings: {
            id: '<id>'
          }
        }
      }
    ]
    frontendEndpoints: [
      {
        name: 'frontEnd'
        properties: {
          hostName: '<hostName>'
          sessionAffinityEnabledState: 'Disabled'
          sessionAffinityTtlSeconds: 60
        }
      }
    ]
    healthProbeSettings: [
      {
        name: 'heathProbe'
        properties: {
          enabledState: 'Enabled'
          healthProbeMethod: 'HEAD'
          intervalInSeconds: 60
          path: '/healthz'
          protocol: 'Https'
        }
      }
    ]
    loadBalancingSettings: [
      {
        name: 'loadBalancer'
        properties: {
          additionalLatencyMilliseconds: 0
          sampleSize: 50
          successfulSamplesRequired: 1
        }
      }
    ]
    name: '<name>'
    routingRules: [
      {
        name: 'routingRule'
        properties: {
          acceptedProtocols: [
            'Http'
            'Https'
          ]
          enabledState: 'Enabled'
          frontendEndpoints: [
            {
              id: '<id>'
            }
          ]
          patternsToMatch: [
            '/*'
          ]
          routeConfiguration: {
            '@odata.type': '#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration'
            backendPool: {
              id: '<id>'
            }
            forwardingProtocol: 'MatchRequest'
          }
        }
      }
    ]
    // Non-required parameters
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        storageAccountResourceId: '<storageAccountResourceId>'
        workspaceResourceId: '<workspaceResourceId>'
      }
    ]
    enforceCertificateNameCheck: 'Disabled'
    location: '<location>'
    sendRecvTimeoutSeconds: 10
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
    "backendPools": {
      "value": [
        {
          "name": "backendPool",
          "properties": {
            "backends": [
              {
                "address": "biceptest.local",
                "backendHostHeader": "backendAddress",
                "enabledState": "Enabled",
                "httpPort": 80,
                "httpsPort": 443,
                "priority": 1,
                "privateLinkAlias": "",
                "privateLinkApprovalMessage": "",
                "privateLinkLocation": "",
                "weight": 50
              }
            ],
            "HealthProbeSettings": {
              "id": "<id>"
            },
            "LoadBalancingSettings": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "frontendEndpoints": {
      "value": [
        {
          "name": "frontEnd",
          "properties": {
            "hostName": "<hostName>",
            "sessionAffinityEnabledState": "Disabled",
            "sessionAffinityTtlSeconds": 60
          }
        }
      ]
    },
    "healthProbeSettings": {
      "value": [
        {
          "name": "heathProbe",
          "properties": {
            "enabledState": "Enabled",
            "healthProbeMethod": "HEAD",
            "intervalInSeconds": 60,
            "path": "/healthz",
            "protocol": "Https"
          }
        }
      ]
    },
    "loadBalancingSettings": {
      "value": [
        {
          "name": "loadBalancer",
          "properties": {
            "additionalLatencyMilliseconds": 0,
            "sampleSize": 50,
            "successfulSamplesRequired": 1
          }
        }
      ]
    },
    "name": {
      "value": "<name>"
    },
    "routingRules": {
      "value": [
        {
          "name": "routingRule",
          "properties": {
            "acceptedProtocols": [
              "Http",
              "Https"
            ],
            "enabledState": "Enabled",
            "frontendEndpoints": [
              {
                "id": "<id>"
              }
            ],
            "patternsToMatch": [
              "/*"
            ],
            "routeConfiguration": {
              "@odata.type": "#Microsoft.Azure.FrontDoor.Models.FrontdoorForwardingConfiguration",
              "backendPool": {
                "id": "<id>"
              },
              "forwardingProtocol": "MatchRequest"
            }
          }
        }
      ]
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "storageAccountResourceId": "<storageAccountResourceId>",
          "workspaceResourceId": "<workspaceResourceId>"
        }
      ]
    },
    "enforceCertificateNameCheck": {
      "value": "Disabled"
    },
    "location": {
      "value": "<location>"
    },
    "sendRecvTimeoutSeconds": {
      "value": 10
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
| [`backendPools`](#parameter-backendpools) | array | Backend address pool of the frontdoor resource. |
| [`frontendEndpoints`](#parameter-frontendendpoints) | array | Frontend endpoints of the frontdoor resource. |
| [`healthProbeSettings`](#parameter-healthprobesettings) | array | Heath probe settings of the frontdoor resource. |
| [`loadBalancingSettings`](#parameter-loadbalancingsettings) | array | Load balancing settings of the frontdoor resource. |
| [`name`](#parameter-name) | string | The name of the frontDoor. |
| [`routingRules`](#parameter-routingrules) | array | Routing rules settings of the frontdoor resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enabledState`](#parameter-enabledstate) | string | State of the frontdoor resource. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`enforceCertificateNameCheck`](#parameter-enforcecertificatenamecheck) | string | Enforce certificate name check of the frontdoor resource. |
| [`friendlyName`](#parameter-friendlyname) | string | Friendly name of the frontdoor resource. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`sendRecvTimeoutSeconds`](#parameter-sendrecvtimeoutseconds) | int | Certificate name check time of the frontdoor resource. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `backendPools`

Backend address pool of the frontdoor resource.

- Required: Yes
- Type: array

### Parameter: `frontendEndpoints`

Frontend endpoints of the frontdoor resource.

- Required: Yes
- Type: array

### Parameter: `healthProbeSettings`

Heath probe settings of the frontdoor resource.

- Required: Yes
- Type: array

### Parameter: `loadBalancingSettings`

Load balancing settings of the frontdoor resource.

- Required: Yes
- Type: array

### Parameter: `name`

The name of the frontDoor.

- Required: Yes
- Type: string

### Parameter: `routingRules`

Routing rules settings of the frontdoor resource.

- Required: Yes
- Type: array

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

### Parameter: `enabledState`

State of the frontdoor resource.

- Required: No
- Type: string
- Default: `'Enabled'`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enforceCertificateNameCheck`

Enforce certificate name check of the frontdoor resource.

- Required: No
- Type: string
- Default: `'Disabled'`

### Parameter: `friendlyName`

Friendly name of the frontdoor resource.

- Required: No
- Type: string

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

### Parameter: `sendRecvTimeoutSeconds`

Certificate name check time of the frontdoor resource.

- Required: No
- Type: int
- Default: `240`

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the front door. |
| `resourceGroupName` | string | The resource group the front door was deployed into. |
| `resourceId` | string | The resource ID of the front door. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
