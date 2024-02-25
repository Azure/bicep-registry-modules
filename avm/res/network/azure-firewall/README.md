# Azure Firewalls `[Microsoft.Network/azureFirewalls]`

This module deploys an Azure Firewall.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Network/azureFirewalls` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/azureFirewalls) |
| `Microsoft.Network/publicIPAddresses` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/publicIPAddresses) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br:bicep/modules/network.azure-firewall:1.0.0`.

- [Addpip](#example-1-addpip)
- [Custompip](#example-2-custompip)
- [Using only defaults](#example-3-using-only-defaults)
- [Hubcommon](#example-4-hubcommon)
- [Hubmin](#example-5-hubmin)
- [Using large parameter set](#example-6-using-large-parameter-set)
- [WAF-aligned](#example-7-waf-aligned)

### Example 1: _Addpip_

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br:bicep/modules/network.azure-firewall:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nafaddpip'
  params: {
    // Required parameters
    name: 'nafaddpip001'
    // Non-required parameters
    additionalPublicIpConfigurations: [
      {
        name: 'ipConfig01'
        publicIPAddressResourceId: '<publicIPAddressResourceId>'
      }
    ]
    azureSkuTier: 'Basic'
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    managementIPAddressObject: {
      publicIPAllocationMethod: 'Static'
      roleAssignments: [
        {
          principalId: '<principalId>'
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Reader'
        }
      ]
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vNetId: '<vNetId>'
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
      "value": "nafaddpip001"
    },
    // Non-required parameters
    "additionalPublicIpConfigurations": {
      "value": [
        {
          "name": "ipConfig01",
          "publicIPAddressResourceId": "<publicIPAddressResourceId>"
        }
      ]
    },
    "azureSkuTier": {
      "value": "Basic"
    },
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "managementIPAddressObject": {
      "value": {
        "publicIPAllocationMethod": "Static",
        "roleAssignments": [
          {
            "principalId": "<principalId>",
            "principalType": "ServicePrincipal",
            "roleDefinitionIdOrName": "Reader"
          }
        ]
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vNetId": {
      "value": "<vNetId>"
    }
  }
}
```

</details>
<p>

### Example 2: _Custompip_

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br:bicep/modules/network.azure-firewall:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nafcstpip'
  params: {
    // Required parameters
    name: 'nafcstpip001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    publicIPAddressObject: {
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
      name: 'new-pip-nafcstpip'
      publicIPAllocationMethod: 'Static'
      publicIPPrefixResourceId: ''
      roleAssignments: [
        {
          principalId: '<principalId>'
          principalType: 'ServicePrincipal'
          roleDefinitionIdOrName: 'Reader'
        }
      ]
      skuName: 'Standard'
      skuTier: 'Regional'
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vNetId: '<vNetId>'
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
      "value": "nafcstpip001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "publicIPAddressObject": {
      "value": {
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
        "name": "new-pip-nafcstpip",
        "publicIPAllocationMethod": "Static",
        "publicIPPrefixResourceId": "",
        "roleAssignments": [
          {
            "principalId": "<principalId>",
            "principalType": "ServicePrincipal",
            "roleDefinitionIdOrName": "Reader"
          }
        ],
        "skuName": "Standard",
        "skuTier": "Regional"
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vNetId": {
      "value": "<vNetId>"
    }
  }
}
```

</details>
<p>

### Example 3: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br:bicep/modules/network.azure-firewall:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nafmin'
  params: {
    // Required parameters
    name: 'nafmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    vNetId: '<vNetId>'
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
      "value": "nafmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "vNetId": {
      "value": "<vNetId>"
    }
  }
}
```

</details>
<p>

### Example 4: _Hubcommon_

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br:bicep/modules/network.azure-firewall:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nafhubcom'
  params: {
    // Required parameters
    name: 'nafhubcom001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    firewallPolicyId: '<firewallPolicyId>'
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    virtualHubId: '<virtualHubId>'
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
      "value": "nafhubcom001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "firewallPolicyId": {
      "value": "<firewallPolicyId>"
    },
    "hubIPAddresses": {
      "value": {
        "publicIPs": {
          "count": 1
        }
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "virtualHubId": {
      "value": "<virtualHubId>"
    }
  }
}
```

</details>
<p>

### Example 5: _Hubmin_

<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br:bicep/modules/network.azure-firewall:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nafhubmin'
  params: {
    // Required parameters
    name: 'nafhubmin001'
    // Non-required parameters
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    virtualHubId: '<virtualHubId>'
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
      "value": "nafhubmin001"
    },
    // Non-required parameters
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "hubIPAddresses": {
      "value": {
        "publicIPs": {
          "count": 1
        }
      }
    },
    "virtualHubId": {
      "value": "<virtualHubId>"
    }
  }
}
```

</details>
<p>

### Example 6: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br:bicep/modules/network.azure-firewall:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nafmax'
  params: {
    // Required parameters
    name: 'nafmax001'
    // Non-required parameters
    applicationRuleCollections: [
      {
        name: 'allow-app-rules'
        properties: {
          action: {
            type: 'allow'
          }
          priority: 100
          rules: [
            {
              fqdnTags: [
                'AppServiceEnvironment'
                'WindowsUpdate'
              ]
              name: 'allow-ase-tags'
              protocols: [
                {
                  port: '80'
                  protocolType: 'HTTP'
                }
                {
                  port: '443'
                  protocolType: 'HTTPS'
                }
              ]
              sourceAddresses: [
                '*'
              ]
            }
            {
              name: 'allow-ase-management'
              protocols: [
                {
                  port: '80'
                  protocolType: 'HTTP'
                }
                {
                  port: '443'
                  protocolType: 'HTTPS'
                }
              ]
              sourceAddresses: [
                '*'
              ]
              targetFqdns: [
                'bing.com'
              ]
            }
          ]
        }
      }
    ]
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
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    networkRuleCollections: [
      {
        name: 'allow-network-rules'
        properties: {
          action: {
            type: 'allow'
          }
          priority: 100
          rules: [
            {
              destinationAddresses: [
                '*'
              ]
              destinationPorts: [
                '12000'
                '123'
              ]
              name: 'allow-ntp'
              protocols: [
                'Any'
              ]
              sourceAddresses: [
                '*'
              ]
            }
          ]
        }
      }
    ]
    publicIPResourceID: '<publicIPResourceID>'
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
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vNetId: '<vNetId>'
    zones: [
      '1'
      '2'
      '3'
    ]
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
      "value": "nafmax001"
    },
    // Non-required parameters
    "applicationRuleCollections": {
      "value": [
        {
          "name": "allow-app-rules",
          "properties": {
            "action": {
              "type": "allow"
            },
            "priority": 100,
            "rules": [
              {
                "fqdnTags": [
                  "AppServiceEnvironment",
                  "WindowsUpdate"
                ],
                "name": "allow-ase-tags",
                "protocols": [
                  {
                    "port": "80",
                    "protocolType": "HTTP"
                  },
                  {
                    "port": "443",
                    "protocolType": "HTTPS"
                  }
                ],
                "sourceAddresses": [
                  "*"
                ]
              },
              {
                "name": "allow-ase-management",
                "protocols": [
                  {
                    "port": "80",
                    "protocolType": "HTTP"
                  },
                  {
                    "port": "443",
                    "protocolType": "HTTPS"
                  }
                ],
                "sourceAddresses": [
                  "*"
                ],
                "targetFqdns": [
                  "bing.com"
                ]
              }
            ]
          }
        }
      ]
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "networkRuleCollections": {
      "value": [
        {
          "name": "allow-network-rules",
          "properties": {
            "action": {
              "type": "allow"
            },
            "priority": 100,
            "rules": [
              {
                "destinationAddresses": [
                  "*"
                ],
                "destinationPorts": [
                  "12000",
                  "123"
                ],
                "name": "allow-ntp",
                "protocols": [
                  "Any"
                ],
                "sourceAddresses": [
                  "*"
                ]
              }
            ]
          }
        }
      ]
    },
    "publicIPResourceID": {
      "value": "<publicIPResourceID>"
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
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vNetId": {
      "value": "<vNetId>"
    },
    "zones": {
      "value": [
        "1",
        "2",
        "3"
      ]
    }
  }
}
```

</details>
<p>

### Example 7: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br:bicep/modules/network.azure-firewall:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nafwaf'
  params: {
    // Required parameters
    name: 'nafwaf001'
    // Non-required parameters
    applicationRuleCollections: [
      {
        name: 'allow-app-rules'
        properties: {
          action: {
            type: 'allow'
          }
          priority: 100
          rules: [
            {
              fqdnTags: [
                'AppServiceEnvironment'
                'WindowsUpdate'
              ]
              name: 'allow-ase-tags'
              protocols: [
                {
                  port: '80'
                  protocolType: 'HTTP'
                }
                {
                  port: '443'
                  protocolType: 'HTTPS'
                }
              ]
              sourceAddresses: [
                '*'
              ]
            }
            {
              name: 'allow-ase-management'
              protocols: [
                {
                  port: '80'
                  protocolType: 'HTTP'
                }
                {
                  port: '443'
                  protocolType: 'HTTPS'
                }
              ]
              sourceAddresses: [
                '*'
              ]
              targetFqdns: [
                'bing.com'
              ]
            }
          ]
        }
      }
    ]
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
    enableDefaultTelemetry: '<enableDefaultTelemetry>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    networkRuleCollections: [
      {
        name: 'allow-network-rules'
        properties: {
          action: {
            type: 'allow'
          }
          priority: 100
          rules: [
            {
              destinationAddresses: [
                '*'
              ]
              destinationPorts: [
                '12000'
                '123'
              ]
              name: 'allow-ntp'
              protocols: [
                'Any'
              ]
              sourceAddresses: [
                '*'
              ]
            }
          ]
        }
      }
    ]
    publicIPResourceID: '<publicIPResourceID>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    vNetId: '<vNetId>'
    zones: [
      '1'
      '2'
      '3'
    ]
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
      "value": "nafwaf001"
    },
    // Non-required parameters
    "applicationRuleCollections": {
      "value": [
        {
          "name": "allow-app-rules",
          "properties": {
            "action": {
              "type": "allow"
            },
            "priority": 100,
            "rules": [
              {
                "fqdnTags": [
                  "AppServiceEnvironment",
                  "WindowsUpdate"
                ],
                "name": "allow-ase-tags",
                "protocols": [
                  {
                    "port": "80",
                    "protocolType": "HTTP"
                  },
                  {
                    "port": "443",
                    "protocolType": "HTTPS"
                  }
                ],
                "sourceAddresses": [
                  "*"
                ]
              },
              {
                "name": "allow-ase-management",
                "protocols": [
                  {
                    "port": "80",
                    "protocolType": "HTTP"
                  },
                  {
                    "port": "443",
                    "protocolType": "HTTPS"
                  }
                ],
                "sourceAddresses": [
                  "*"
                ],
                "targetFqdns": [
                  "bing.com"
                ]
              }
            ]
          }
        }
      ]
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
    "enableDefaultTelemetry": {
      "value": "<enableDefaultTelemetry>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "networkRuleCollections": {
      "value": [
        {
          "name": "allow-network-rules",
          "properties": {
            "action": {
              "type": "allow"
            },
            "priority": 100,
            "rules": [
              {
                "destinationAddresses": [
                  "*"
                ],
                "destinationPorts": [
                  "12000",
                  "123"
                ],
                "name": "allow-ntp",
                "protocols": [
                  "Any"
                ],
                "sourceAddresses": [
                  "*"
                ]
              }
            ]
          }
        }
      ]
    },
    "publicIPResourceID": {
      "value": "<publicIPResourceID>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "vNetId": {
      "value": "<vNetId>"
    },
    "zones": {
      "value": [
        "1",
        "2",
        "3"
      ]
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
| [`name`](#parameter-name) | string | Name of the Azure Firewall. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hubIPAddresses`](#parameter-hubipaddresses) | object | IP addresses associated with AzureFirewall. Required if `virtualHubId` is supplied. |
| [`virtualHubId`](#parameter-virtualhubid) | string | The virtualHub resource ID to which the firewall belongs. Required if `vNetId` is empty. |
| [`vNetId`](#parameter-vnetid) | string | Shared services Virtual Network resource ID. The virtual network ID containing AzureFirewallSubnet. If a Public IP is not provided, then the Public IP that is created as part of this module will be applied with the subnet provided in this variable. Required if `virtualHubId` is empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalPublicIpConfigurations`](#parameter-additionalpublicipconfigurations) | array | This is to add any additional Public IP configurations on top of the Public IP with subnet IP configuration. |
| [`applicationRuleCollections`](#parameter-applicationrulecollections) | array | Collection of application rule collections used by Azure Firewall. |
| [`azureSkuTier`](#parameter-azureskutier) | string | Tier of an Azure Firewall. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`firewallPolicyId`](#parameter-firewallpolicyid) | string | Resource ID of the Firewall Policy that should be attached. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managementIPAddressObject`](#parameter-managementipaddressobject) | object | Specifies the properties of the Management Public IP to create and be used by Azure Firewall. If it's not provided and managementIPResourceID is empty, a '-mip' suffix will be appended to the Firewall's name. |
| [`managementIPResourceID`](#parameter-managementipresourceid) | string | The Management Public IP resource ID to associate to the AzureFirewallManagementSubnet. If empty, then the Management Public IP that is created as part of this module will be applied to the AzureFirewallManagementSubnet. |
| [`natRuleCollections`](#parameter-natrulecollections) | array | Collection of NAT rule collections used by Azure Firewall. |
| [`networkRuleCollections`](#parameter-networkrulecollections) | array | Collection of network rule collections used by Azure Firewall. |
| [`publicIPAddressObject`](#parameter-publicipaddressobject) | object | Specifies the properties of the Public IP to create and be used by the Firewall, if no existing public IP was provided. |
| [`publicIPResourceID`](#parameter-publicipresourceid) | string | The Public IP resource ID to associate to the AzureFirewallSubnet. If empty, then the Public IP that is created as part of this module will be applied to the AzureFirewallSubnet. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the Azure Firewall resource. |
| [`threatIntelMode`](#parameter-threatintelmode) | string | The operation mode for Threat Intel. |
| [`zones`](#parameter-zones) | array | Zone numbers e.g. 1,2,3. |

### Parameter: `name`

Name of the Azure Firewall.

- Required: Yes
- Type: string

### Parameter: `hubIPAddresses`

IP addresses associated with AzureFirewall. Required if `virtualHubId` is supplied.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `virtualHubId`

The virtualHub resource ID to which the firewall belongs. Required if `vNetId` is empty.

- Required: No
- Type: string
- Default: `''`

### Parameter: `vNetId`

Shared services Virtual Network resource ID. The virtual network ID containing AzureFirewallSubnet. If a Public IP is not provided, then the Public IP that is created as part of this module will be applied with the subnet provided in this variable. Required if `virtualHubId` is empty.

- Required: No
- Type: string
- Default: `''`

### Parameter: `additionalPublicIpConfigurations`

This is to add any additional Public IP configurations on top of the Public IP with subnet IP configuration.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `applicationRuleCollections`

Collection of application rule collections used by Azure Firewall.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `azureSkuTier`

Tier of an Azure Firewall.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Premium'
    'Standard'
  ]
  ```

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
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
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

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

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

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`

### Parameter: `firewallPolicyId`

Resource ID of the Firewall Policy that should be attached.

- Required: No
- Type: string
- Default: `''`

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

### Parameter: `managementIPAddressObject`

Specifies the properties of the Management Public IP to create and be used by Azure Firewall. If it's not provided and managementIPResourceID is empty, a '-mip' suffix will be appended to the Firewall's name.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `managementIPResourceID`

The Management Public IP resource ID to associate to the AzureFirewallManagementSubnet. If empty, then the Management Public IP that is created as part of this module will be applied to the AzureFirewallManagementSubnet.

- Required: No
- Type: string
- Default: `''`

### Parameter: `natRuleCollections`

Collection of NAT rule collections used by Azure Firewall.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `networkRuleCollections`

Collection of network rule collections used by Azure Firewall.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `publicIPAddressObject`

Specifies the properties of the Public IP to create and be used by the Firewall, if no existing public IP was provided.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      name: '[format(\'{0}-pip\', parameters(\'name\'))]'
  }
  ```

### Parameter: `publicIPResourceID`

The Public IP resource ID to associate to the AzureFirewallSubnet. If empty, then the Public IP that is created as part of this module will be applied to the AzureFirewallSubnet.

- Required: No
- Type: string
- Default: `''`

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
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
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

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

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

### Parameter: `tags`

Tags of the Azure Firewall resource.

- Required: No
- Type: object

### Parameter: `threatIntelMode`

The operation mode for Threat Intel.

- Required: No
- Type: string
- Default: `'Deny'`
- Allowed:
  ```Bicep
  [
    'Alert'
    'Deny'
    'Off'
  ]
  ```

### Parameter: `zones`

Zone numbers e.g. 1,2,3.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    '1'
    '2'
    '3'
  ]
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `applicationRuleCollections` | array | List of Application Rule Collections. |
| `ipConfAzureFirewallSubnet` | object | The Public IP configuration object for the Azure Firewall Subnet. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Azure Firewall. |
| `natRuleCollections` | array | Collection of NAT rule collections used by Azure Firewall. |
| `networkRuleCollections` | array | List of Network Rule Collections. |
| `privateIp` | string | The private IP of the Azure firewall. |
| `resourceGroupName` | string | The resource group the Azure firewall was deployed into. |
| `resourceId` | string | The resource ID of the Azure Firewall. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other CARML modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `modules/network/public-ip-address` | Local reference |
