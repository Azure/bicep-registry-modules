# Azure Monitor Private Link Scopes `[microsoft.insights/privateLinkScopes]`

This module deploys an Azure Monitor Private Link Scope.

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
| `microsoft.insights/privateLinkScopes` | [2021-07-01-preview](https://learn.microsoft.com/en-us/azure/templates/microsoft.insights/2021-07-01-preview/privateLinkScopes) |
| `Microsoft.Insights/privateLinkScopes/scopedResources` | [2021-07-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-07-01-preview/privateLinkScopes/scopedResources) |
| `Microsoft.Network/privateEndpoints` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints) |
| `Microsoft.Network/privateEndpoints/privateDnsZoneGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/privateEndpoints/privateDnsZoneGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/insights/private-link-scope:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkScope 'br/public:avm/res/insights/private-link-scope:<version>' = {
  name: 'privateLinkScopeDeployment'
  params: {
    // Required parameters
    name: 'iplsmin001'
    // Non-required parameters
    location: 'global'
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
      "value": "iplsmin001"
    },
    // Non-required parameters
    "location": {
      "value": "global"
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
module privateLinkScope 'br/public:avm/res/insights/private-link-scope:<version>' = {
  name: 'privateLinkScopeDeployment'
  params: {
    // Required parameters
    name: 'iplsmax001'
    // Non-required parameters
    accessModeSettings: {
      exclusions: [
        {
          ingestionAccessMode: 'PrivateOnly'
          privateEndpointConnectionName: 'thisisatest'
          queryAccessMode: 'PrivateOnly'
        }
      ]
      ingestionAccessMode: 'Open'
      queryAccessMode: 'Open'
    }
    location: 'global'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    privateEndpoints: [
      {
        customNetworkInterfaceName: 'nic-pe-'
        ipConfigurations: [
          {
            name: 'api'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'api'
              privateIPAddress: '10.0.0.11'
            }
          }
          {
            name: 'globalinai'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'global.in.ai'
              privateIPAddress: '10.0.0.12'
            }
          }
          {
            name: 'profiler'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'profiler'
              privateIPAddress: '10.0.0.13'
            }
          }
          {
            name: 'live'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'live'
              privateIPAddress: '10.0.0.14'
            }
          }
          {
            name: 'diagservicesquery'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'diagservicesquery'
              privateIPAddress: '10.0.0.15'
            }
          }
          {
            name: 'snapshot'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'snapshot'
              privateIPAddress: '10.0.0.16'
            }
          }
          {
            name: 'agentsolutionpackstore'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'agentsolutionpackstore'
              privateIPAddress: '10.0.0.17'
            }
          }
          {
            name: 'dce-global'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'dce-global'
              privateIPAddress: '10.0.0.18'
            }
          }
          {
            name: '<name>'
            properties: {
              groupId: 'azuremonitor'
              memberName: '<memberName>'
              privateIPAddress: '10.0.0.19'
            }
          }
          {
            name: '<name>'
            properties: {
              groupId: 'azuremonitor'
              memberName: '<memberName>'
              privateIPAddress: '10.0.0.20'
            }
          }
          {
            name: '<name>'
            properties: {
              groupId: 'azuremonitor'
              memberName: '<memberName>'
              privateIPAddress: '10.0.0.21'
            }
          }
        ]
        name: 'pe-'
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        roleAssignments: [
          {
            principalId: '<principalId>'
            principalType: 'ServicePrincipal'
            roleDefinitionIdOrName: 'Reader'
          }
        ]
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    roleAssignments: [
      {
        name: 'af62023f-9f34-4bc0-8f05-2374886daf28'
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
    scopedResources: [
      {
        linkedResourceId: '<linkedResourceId>'
        name: 'scoped1'
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
    "name": {
      "value": "iplsmax001"
    },
    // Non-required parameters
    "accessModeSettings": {
      "value": {
        "exclusions": [
          {
            "ingestionAccessMode": "PrivateOnly",
            "privateEndpointConnectionName": "thisisatest",
            "queryAccessMode": "PrivateOnly"
          }
        ],
        "ingestionAccessMode": "Open",
        "queryAccessMode": "Open"
      }
    },
    "location": {
      "value": "global"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "privateEndpoints": {
      "value": [
        {
          "customNetworkInterfaceName": "nic-pe-",
          "ipConfigurations": [
            {
              "name": "api",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "api",
                "privateIPAddress": "10.0.0.11"
              }
            },
            {
              "name": "globalinai",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "global.in.ai",
                "privateIPAddress": "10.0.0.12"
              }
            },
            {
              "name": "profiler",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "profiler",
                "privateIPAddress": "10.0.0.13"
              }
            },
            {
              "name": "live",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "live",
                "privateIPAddress": "10.0.0.14"
              }
            },
            {
              "name": "diagservicesquery",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "diagservicesquery",
                "privateIPAddress": "10.0.0.15"
              }
            },
            {
              "name": "snapshot",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "snapshot",
                "privateIPAddress": "10.0.0.16"
              }
            },
            {
              "name": "agentsolutionpackstore",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "agentsolutionpackstore",
                "privateIPAddress": "10.0.0.17"
              }
            },
            {
              "name": "dce-global",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "dce-global",
                "privateIPAddress": "10.0.0.18"
              }
            },
            {
              "name": "<name>",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "<memberName>",
                "privateIPAddress": "10.0.0.19"
              }
            },
            {
              "name": "<name>",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "<memberName>",
                "privateIPAddress": "10.0.0.20"
              }
            },
            {
              "name": "<name>",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "<memberName>",
                "privateIPAddress": "10.0.0.21"
              }
            }
          ],
          "name": "pe-",
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "roleAssignments": [
            {
              "principalId": "<principalId>",
              "principalType": "ServicePrincipal",
              "roleDefinitionIdOrName": "Reader"
            }
          ],
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "af62023f-9f34-4bc0-8f05-2374886daf28",
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
    "scopedResources": {
      "value": [
        {
          "linkedResourceId": "<linkedResourceId>",
          "name": "scoped1"
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module privateLinkScope 'br/public:avm/res/insights/private-link-scope:<version>' = {
  name: 'privateLinkScopeDeployment'
  params: {
    // Required parameters
    name: 'iplswaf001'
    // Non-required parameters
    location: 'global'
    privateEndpoints: [
      {
        customNetworkInterfaceName: 'nic-pe-'
        ipConfigurations: [
          {
            name: 'api'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'api'
              privateIPAddress: '10.0.0.11'
            }
          }
          {
            name: 'globalinai'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'global.in.ai'
              privateIPAddress: '10.0.0.12'
            }
          }
          {
            name: 'profiler'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'profiler'
              privateIPAddress: '10.0.0.13'
            }
          }
          {
            name: 'live'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'live'
              privateIPAddress: '10.0.0.14'
            }
          }
          {
            name: 'diagservicesquery'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'diagservicesquery'
              privateIPAddress: '10.0.0.15'
            }
          }
          {
            name: 'snapshot'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'snapshot'
              privateIPAddress: '10.0.0.16'
            }
          }
          {
            name: 'agentsolutionpackstore'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'agentsolutionpackstore'
              privateIPAddress: '10.0.0.17'
            }
          }
          {
            name: 'dce-global'
            properties: {
              groupId: 'azuremonitor'
              memberName: 'dce-global'
              privateIPAddress: '10.0.0.18'
            }
          }
          {
            name: '<name>'
            properties: {
              groupId: 'azuremonitor'
              memberName: '<memberName>'
              privateIPAddress: '10.0.0.19'
            }
          }
          {
            name: '<name>'
            properties: {
              groupId: 'azuremonitor'
              memberName: '<memberName>'
              privateIPAddress: '10.0.0.20'
            }
          }
          {
            name: '<name>'
            properties: {
              groupId: 'azuremonitor'
              memberName: '<memberName>'
              privateIPAddress: '10.0.0.21'
            }
          }
        ]
        name: 'pe-'
        privateDnsZoneResourceIds: [
          '<privateDNSZoneResourceId>'
        ]
        subnetResourceId: '<subnetResourceId>'
        tags: {
          Environment: 'Non-Prod'
          'hidden-title': 'This is visible in the resource name'
          Role: 'DeploymentValidation'
        }
      }
    ]
    scopedResources: [
      {
        linkedResourceId: '<linkedResourceId>'
        name: 'scoped1'
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
    "name": {
      "value": "iplswaf001"
    },
    // Non-required parameters
    "location": {
      "value": "global"
    },
    "privateEndpoints": {
      "value": [
        {
          "customNetworkInterfaceName": "nic-pe-",
          "ipConfigurations": [
            {
              "name": "api",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "api",
                "privateIPAddress": "10.0.0.11"
              }
            },
            {
              "name": "globalinai",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "global.in.ai",
                "privateIPAddress": "10.0.0.12"
              }
            },
            {
              "name": "profiler",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "profiler",
                "privateIPAddress": "10.0.0.13"
              }
            },
            {
              "name": "live",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "live",
                "privateIPAddress": "10.0.0.14"
              }
            },
            {
              "name": "diagservicesquery",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "diagservicesquery",
                "privateIPAddress": "10.0.0.15"
              }
            },
            {
              "name": "snapshot",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "snapshot",
                "privateIPAddress": "10.0.0.16"
              }
            },
            {
              "name": "agentsolutionpackstore",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "agentsolutionpackstore",
                "privateIPAddress": "10.0.0.17"
              }
            },
            {
              "name": "dce-global",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "dce-global",
                "privateIPAddress": "10.0.0.18"
              }
            },
            {
              "name": "<name>",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "<memberName>",
                "privateIPAddress": "10.0.0.19"
              }
            },
            {
              "name": "<name>",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "<memberName>",
                "privateIPAddress": "10.0.0.20"
              }
            },
            {
              "name": "<name>",
              "properties": {
                "groupId": "azuremonitor",
                "memberName": "<memberName>",
                "privateIPAddress": "10.0.0.21"
              }
            }
          ],
          "name": "pe-",
          "privateDnsZoneResourceIds": [
            "<privateDNSZoneResourceId>"
          ],
          "subnetResourceId": "<subnetResourceId>",
          "tags": {
            "Environment": "Non-Prod",
            "hidden-title": "This is visible in the resource name",
            "Role": "DeploymentValidation"
          }
        }
      ]
    },
    "scopedResources": {
      "value": [
        {
          "linkedResourceId": "<linkedResourceId>",
          "name": "scoped1"
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
| [`name`](#parameter-name) | string | Name of the private link scope. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessModeSettings`](#parameter-accessmodesettings) | object | Specifies the access mode of ingestion or queries through associated private endpoints in scope. For security reasons, it is recommended to use PrivateOnly whenever possible to avoid data exfiltration.<p><p>  * Private Only - This mode allows the connected virtual network to reach only Private Link resources. It is the most secure mode and is set as the default when the `privateEndpoints` parameter is configured.<p>  * Open - Allows the connected virtual network to reach both Private Link resources and the resources not in the AMPLS resource. Data exfiltration cannot be prevented in this mode. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The location of the private link scope. Should be global. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`privateEndpoints`](#parameter-privateendpoints) | array | Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`scopedResources`](#parameter-scopedresources) | array | Configuration details for Azure Monitor Resources. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `name`

Name of the private link scope.

- Required: Yes
- Type: string

### Parameter: `accessModeSettings`

Specifies the access mode of ingestion or queries through associated private endpoints in scope. For security reasons, it is recommended to use PrivateOnly whenever possible to avoid data exfiltration.<p><p>  * Private Only - This mode allows the connected virtual network to reach only Private Link resources. It is the most secure mode and is set as the default when the `privateEndpoints` parameter is configured.<p>  * Open - Allows the connected virtual network to reach both Private Link resources and the resources not in the AMPLS resource. Data exfiltration cannot be prevented in this mode.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`exclusions`](#parameter-accessmodesettingsexclusions) | array | List of exclusions that override the default access mode settings for specific private endpoint connections. Exclusions for the current created Private endpoints can only be applied post initial provisioning. |
| [`ingestionAccessMode`](#parameter-accessmodesettingsingestionaccessmode) | string | Specifies the default access mode of ingestion through associated private endpoints in scope. Default is "Open" if no private endpoints are configured and will be set to "PrivateOnly" if private endpoints are configured. Override default behaviour by explicitly providing a value. |
| [`queryAccessMode`](#parameter-accessmodesettingsqueryaccessmode) | string | Specifies the default access mode of queries through associated private endpoints in scope. Default is "Open" if no private endpoints are configured and will be set to "PrivateOnly" if private endpoints are configured. Override default behaviour by explicitly providing a value. |

### Parameter: `accessModeSettings.exclusions`

List of exclusions that override the default access mode settings for specific private endpoint connections. Exclusions for the current created Private endpoints can only be applied post initial provisioning.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ingestionAccessMode`](#parameter-accessmodesettingsexclusionsingestionaccessmode) | string | Specifies the access mode of ingestion through the specified private endpoint connection in the exclusion. |
| [`privateEndpointConnectionName`](#parameter-accessmodesettingsexclusionsprivateendpointconnectionname) | string | The private endpoint connection name associated to the private endpoint on which we want to apply the specific access mode settings. |
| [`queryAccessMode`](#parameter-accessmodesettingsexclusionsqueryaccessmode) | string | Specifies the access mode of queries through the specified private endpoint connection in the exclusion. |

### Parameter: `accessModeSettings.exclusions.ingestionAccessMode`

Specifies the access mode of ingestion through the specified private endpoint connection in the exclusion.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Open'
    'PrivateOnly'
  ]
  ```

### Parameter: `accessModeSettings.exclusions.privateEndpointConnectionName`

The private endpoint connection name associated to the private endpoint on which we want to apply the specific access mode settings.

- Required: Yes
- Type: string

### Parameter: `accessModeSettings.exclusions.queryAccessMode`

Specifies the access mode of queries through the specified private endpoint connection in the exclusion.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Open'
    'PrivateOnly'
  ]
  ```

### Parameter: `accessModeSettings.ingestionAccessMode`

Specifies the default access mode of ingestion through associated private endpoints in scope. Default is "Open" if no private endpoints are configured and will be set to "PrivateOnly" if private endpoints are configured. Override default behaviour by explicitly providing a value.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Open'
    'PrivateOnly'
  ]
  ```

### Parameter: `accessModeSettings.queryAccessMode`

Specifies the default access mode of queries through associated private endpoints in scope. Default is "Open" if no private endpoints are configured and will be set to "PrivateOnly" if private endpoints are configured. Override default behaviour by explicitly providing a value.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Open'
    'PrivateOnly'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The location of the private link scope. Should be global.

- Required: No
- Type: string
- Default: `'global'`

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

### Parameter: `privateEndpoints`

Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`subnetResourceId`](#parameter-privateendpointssubnetresourceid) | string | Resource ID of the subnet where the endpoint needs to be created. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationSecurityGroupResourceIds`](#parameter-privateendpointsapplicationsecuritygroupresourceids) | array | Application security groups in which the private endpoint IP configuration is included. |
| [`customDnsConfigs`](#parameter-privateendpointscustomdnsconfigs) | array | Custom DNS configurations. |
| [`customNetworkInterfaceName`](#parameter-privateendpointscustomnetworkinterfacename) | string | The custom name of the network interface attached to the private endpoint. |
| [`enableTelemetry`](#parameter-privateendpointsenabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`ipConfigurations`](#parameter-privateendpointsipconfigurations) | array | A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints. |
| [`isManualConnection`](#parameter-privateendpointsismanualconnection) | bool | If Manual Private Link Connection is required. |
| [`location`](#parameter-privateendpointslocation) | string | The location to deploy the private endpoint to. |
| [`lock`](#parameter-privateendpointslock) | object | Specify the type of lock. |
| [`manualConnectionRequestMessage`](#parameter-privateendpointsmanualconnectionrequestmessage) | string | A message passed to the owner of the remote resource with the manual connection request. |
| [`name`](#parameter-privateendpointsname) | string | The name of the private endpoint. |
| [`privateDnsZoneGroupName`](#parameter-privateendpointsprivatednszonegroupname) | string | The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided. |
| [`privateDnsZoneResourceIds`](#parameter-privateendpointsprivatednszoneresourceids) | array | The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones. |
| [`privateLinkServiceConnectionName`](#parameter-privateendpointsprivatelinkserviceconnectionname) | string | The name of the private link connection to create. |
| [`resourceGroupName`](#parameter-privateendpointsresourcegroupname) | string | Specify if you want to deploy the Private Endpoint into a different resource group than the main resource. |
| [`roleAssignments`](#parameter-privateendpointsroleassignments) | array | Array of role assignments to create. |
| [`service`](#parameter-privateendpointsservice) | string | The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory". |
| [`tags`](#parameter-privateendpointstags) | object | Tags to be applied on all resources/resource groups in this deployment. |

### Parameter: `privateEndpoints.subnetResourceId`

Resource ID of the subnet where the endpoint needs to be created.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.applicationSecurityGroupResourceIds`

Application security groups in which the private endpoint IP configuration is included.

- Required: No
- Type: array

### Parameter: `privateEndpoints.customDnsConfigs`

Custom DNS configurations.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`fqdn`](#parameter-privateendpointscustomdnsconfigsfqdn) | string | Fqdn that resolves to private endpoint IP address. |
| [`ipAddresses`](#parameter-privateendpointscustomdnsconfigsipaddresses) | array | A list of private IP addresses of the private endpoint. |

### Parameter: `privateEndpoints.customDnsConfigs.fqdn`

Fqdn that resolves to private endpoint IP address.

- Required: No
- Type: string

### Parameter: `privateEndpoints.customDnsConfigs.ipAddresses`

A list of private IP addresses of the private endpoint.

- Required: Yes
- Type: array

### Parameter: `privateEndpoints.customNetworkInterfaceName`

The custom name of the network interface attached to the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.ipConfigurations`

A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-privateendpointsipconfigurationsname) | string | The name of the resource that is unique within a resource group. |
| [`properties`](#parameter-privateendpointsipconfigurationsproperties) | object | Properties of private endpoint IP configurations. |

### Parameter: `privateEndpoints.ipConfigurations.name`

The name of the resource that is unique within a resource group.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties`

Properties of private endpoint IP configurations.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`groupId`](#parameter-privateendpointsipconfigurationspropertiesgroupid) | string | The ID of a group obtained from the remote resource that this private endpoint should connect to. |
| [`memberName`](#parameter-privateendpointsipconfigurationspropertiesmembername) | string | The member name of a group obtained from the remote resource that this private endpoint should connect to. |
| [`privateIPAddress`](#parameter-privateendpointsipconfigurationspropertiesprivateipaddress) | string | A private IP address obtained from the private endpoint's subnet. |

### Parameter: `privateEndpoints.ipConfigurations.properties.groupId`

The ID of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.memberName`

The member name of a group obtained from the remote resource that this private endpoint should connect to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.ipConfigurations.properties.privateIPAddress`

A private IP address obtained from the private endpoint's subnet.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.isManualConnection`

If Manual Private Link Connection is required.

- Required: No
- Type: bool

### Parameter: `privateEndpoints.location`

The location to deploy the private endpoint to.

- Required: No
- Type: string

### Parameter: `privateEndpoints.lock`

Specify the type of lock.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-privateendpointslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-privateendpointslockname) | string | Specify the name of lock. |

### Parameter: `privateEndpoints.lock.kind`

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

### Parameter: `privateEndpoints.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `privateEndpoints.manualConnectionRequestMessage`

A message passed to the owner of the remote resource with the manual connection request.

- Required: No
- Type: string

### Parameter: `privateEndpoints.name`

The name of the private endpoint.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneGroupName`

The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided.

- Required: No
- Type: string

### Parameter: `privateEndpoints.privateDnsZoneResourceIds`

The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.

- Required: No
- Type: array

### Parameter: `privateEndpoints.privateLinkServiceConnectionName`

The name of the private link connection to create.

- Required: No
- Type: string

### Parameter: `privateEndpoints.resourceGroupName`

Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-privateendpointsroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-privateendpointsroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-privateendpointsroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-privateendpointsroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-privateendpointsroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-privateendpointsroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-privateendpointsroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-privateendpointsroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `privateEndpoints.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `privateEndpoints.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `privateEndpoints.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `privateEndpoints.roleAssignments.principalType`

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

### Parameter: `privateEndpoints.service`

The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".

- Required: No
- Type: string

### Parameter: `privateEndpoints.tags`

Tags to be applied on all resources/resource groups in this deployment.

- Required: No
- Type: object

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

### Parameter: `scopedResources`

Configuration details for Azure Monitor Resources.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`linkedResourceId`](#parameter-scopedresourceslinkedresourceid) | string | The resource ID of the scoped Azure monitor resource. |
| [`name`](#parameter-scopedresourcesname) | string | Name of the private link scoped resource. |

### Parameter: `scopedResources.linkedResourceId`

The resource ID of the scoped Azure monitor resource.

- Required: Yes
- Type: string

### Parameter: `scopedResources.name`

Name of the private link scoped resource.

- Required: Yes
- Type: string

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the private link scope. |
| `resourceGroupName` | string | The resource group the private link scope was deployed into. |
| `resourceId` | string | The resource ID of the private link scope. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/private-endpoint:0.4.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
