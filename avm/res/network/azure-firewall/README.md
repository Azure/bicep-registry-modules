# Azure Firewalls `[Microsoft.Network/azureFirewalls]`

This module deploys an Azure Firewall.

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
| `Microsoft.Network/publicIPAddresses` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-09-01/publicIPAddresses) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/azure-firewall:<version>`.

- [Add-PIP](#example-1-add-pip)
- [Custom-PIP](#example-2-custom-pip)
- [Using only defaults](#example-3-using-only-defaults)
- [Hub-commom](#example-4-hub-commom)
- [Hub-min](#example-5-hub-min)
- [Using large parameter set](#example-6-using-large-parameter-set)
- [Public-IP-Prefix](#example-7-public-ip-prefix)
- [WAF-aligned](#example-8-waf-aligned)

### Example 1: _Add-PIP_

This instance deploys the module and attaches an existing public IP address.


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  name: 'azureFirewallDeployment'
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
    location: '<location>'
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
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
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
    "location": {
      "value": "<location>"
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
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    }
  }
}
```

</details>
<p>

### Example 2: _Custom-PIP_

This instance deploys the module and will create a public IP address.


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  name: 'azureFirewallDeployment'
  params: {
    // Required parameters
    name: 'nafcstpip001'
    // Non-required parameters
    location: '<location>'
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
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
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
    "location": {
      "value": "<location>"
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
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
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
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  name: 'azureFirewallDeployment'
  params: {
    // Required parameters
    name: 'nafmin001'
    // Non-required parameters
    location: '<location>'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
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
    "location": {
      "value": "<location>"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    }
  }
}
```

</details>
<p>

### Example 4: _Hub-commom_

This instance deploys the module a vWAN in a typical hub setting.


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  name: 'azureFirewallDeployment'
  params: {
    // Required parameters
    name: 'nafhubcom001'
    // Non-required parameters
    firewallPolicyId: '<firewallPolicyId>'
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    location: '<location>'
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
    "location": {
      "value": "<location>"
    },
    "virtualHubId": {
      "value": "<virtualHubId>"
    }
  }
}
```

</details>
<p>

### Example 5: _Hub-min_

This instance deploys the module a vWAN minimum hub setting.


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  name: 'azureFirewallDeployment'
  params: {
    // Required parameters
    name: 'nafhubmin001'
    // Non-required parameters
    hubIPAddresses: {
      publicIPs: {
        count: 1
      }
    }
    location: '<location>'
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
    "hubIPAddresses": {
      "value": {
        "publicIPs": {
          "count": 1
        }
      }
    },
    "location": {
      "value": "<location>"
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
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  name: 'azureFirewallDeployment'
  params: {
    // Required parameters
    name: 'nafmax001'
    // Non-required parameters
    applicationRuleCollections: [
      {
        name: 'allow-app-rules'
        properties: {
          action: {
            type: 'Allow'
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
                  port: 80
                  protocolType: 'Http'
                }
                {
                  port: 443
                  protocolType: 'Https'
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
                  port: 80
                  protocolType: 'Http'
                }
                {
                  port: 443
                  protocolType: 'Https'
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
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    networkRuleCollections: [
      {
        name: 'allow-network-rules'
        properties: {
          action: {
            type: 'Allow'
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
            {
              description: 'allow azure devops'
              destinationAddresses: [
                'AzureDevOps'
              ]
              destinationPorts: [
                '443'
              ]
              name: 'allow-azure-devops'
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
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
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
              "type": "Allow"
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
                    "port": 80,
                    "protocolType": "Http"
                  },
                  {
                    "port": 443,
                    "protocolType": "Https"
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
                    "port": 80,
                    "protocolType": "Http"
                  },
                  {
                    "port": 443,
                    "protocolType": "Https"
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
    "location": {
      "value": "<location>"
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
              "type": "Allow"
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
              },
              {
                "description": "allow azure devops",
                "destinationAddresses": [
                  "AzureDevOps"
                ],
                "destinationPorts": [
                  "443"
                ],
                "name": "allow-azure-devops",
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
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
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

### Example 7: _Public-IP-Prefix_

This instance deploys the module and will use a public IP prefix.


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  name: 'azureFirewallDeployment'
  params: {
    // Required parameters
    name: 'nafpip001'
    // Non-required parameters
    azureSkuTier: 'Basic'
    location: '<location>'
    managementIPAddressObject: {
      managementIPAllocationMethod: 'Static'
      managementIPPrefixResourceId: '<managementIPPrefixResourceId>'
      name: 'managementIP01'
      skuName: 'Standard'
      skuTier: 'Regional'
    }
    publicIPAddressObject: {
      name: 'publicIP01'
      publicIPAllocationMethod: 'Static'
      publicIPPrefixResourceId: '<publicIPPrefixResourceId>'
      skuName: 'Standard'
      skuTier: 'Regional'
    }
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
    zones: []
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
      "value": "nafpip001"
    },
    // Non-required parameters
    "azureSkuTier": {
      "value": "Basic"
    },
    "location": {
      "value": "<location>"
    },
    "managementIPAddressObject": {
      "value": {
        "managementIPAllocationMethod": "Static",
        "managementIPPrefixResourceId": "<managementIPPrefixResourceId>",
        "name": "managementIP01",
        "skuName": "Standard",
        "skuTier": "Regional"
      }
    },
    "publicIPAddressObject": {
      "value": {
        "name": "publicIP01",
        "publicIPAllocationMethod": "Static",
        "publicIPPrefixResourceId": "<publicIPPrefixResourceId>",
        "skuName": "Standard",
        "skuTier": "Regional"
      }
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    },
    "zones": {
      "value": []
    }
  }
}
```

</details>
<p>

### Example 8: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  name: 'azureFirewallDeployment'
  params: {
    // Required parameters
    name: 'nafwaf001'
    // Non-required parameters
    applicationRuleCollections: [
      {
        name: 'allow-app-rules'
        properties: {
          action: {
            type: 'Allow'
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
                  port: 80
                  protocolType: 'Http'
                }
                {
                  port: 443
                  protocolType: 'Https'
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
                  port: 80
                  protocolType: 'Http'
                }
                {
                  port: 443
                  protocolType: 'Https'
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
    location: '<location>'
    networkRuleCollections: [
      {
        name: 'allow-network-rules'
        properties: {
          action: {
            type: 'Allow'
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
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
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
              "type": "Allow"
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
                    "port": 80,
                    "protocolType": "Http"
                  },
                  {
                    "port": 443,
                    "protocolType": "Https"
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
                    "port": 80,
                    "protocolType": "Http"
                  },
                  {
                    "port": 443,
                    "protocolType": "Https"
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
    "location": {
      "value": "<location>"
    },
    "networkRuleCollections": {
      "value": [
        {
          "name": "allow-network-rules",
          "properties": {
            "action": {
              "type": "Allow"
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
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
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
| [`virtualHubId`](#parameter-virtualhubid) | string | The virtualHub resource ID to which the firewall belongs. Required if `virtualNetworkId` is empty. |
| [`virtualNetworkResourceId`](#parameter-virtualnetworkresourceid) | string | Shared services Virtual Network resource ID. The virtual network ID containing AzureFirewallSubnet. If a Public IP is not provided, then the Public IP that is created as part of this module will be applied with the subnet provided in this variable. Required if `virtualHubId` is empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalPublicIpConfigurations`](#parameter-additionalpublicipconfigurations) | array | This is to add any additional Public IP configurations on top of the Public IP with subnet IP configuration. |
| [`applicationRuleCollections`](#parameter-applicationrulecollections) | array | Collection of application rule collections used by Azure Firewall. |
| [`azureSkuTier`](#parameter-azureskutier) | string | Tier of an Azure Firewall. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

The virtualHub resource ID to which the firewall belongs. Required if `virtualNetworkId` is empty.

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualNetworkResourceId`

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-applicationrulecollectionsname) | string | Name of the application rule collection. |
| [`properties`](#parameter-applicationrulecollectionsproperties) | object | Properties of the azure firewall application rule collection. |

### Parameter: `applicationRuleCollections.name`

Name of the application rule collection.

- Required: Yes
- Type: string

### Parameter: `applicationRuleCollections.properties`

Properties of the azure firewall application rule collection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-applicationrulecollectionspropertiesaction) | object | The action type of a rule collection. |
| [`priority`](#parameter-applicationrulecollectionspropertiespriority) | int | Priority of the application rule collection. |
| [`rules`](#parameter-applicationrulecollectionspropertiesrules) | array | Collection of rules used by a application rule collection. |

### Parameter: `applicationRuleCollections.properties.action`

The action type of a rule collection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-applicationrulecollectionspropertiesactiontype) | string | The type of action. |

### Parameter: `applicationRuleCollections.properties.action.type`

The type of action.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `applicationRuleCollections.properties.priority`

Priority of the application rule collection.

- Required: Yes
- Type: int

### Parameter: `applicationRuleCollections.properties.rules`

Collection of rules used by a application rule collection.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-applicationrulecollectionspropertiesrulesname) | string | Name of the application rule. |
| [`protocols`](#parameter-applicationrulecollectionspropertiesrulesprotocols) | array | Array of ApplicationRuleProtocols. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-applicationrulecollectionspropertiesrulesdescription) | string | Description of the rule. |
| [`fqdnTags`](#parameter-applicationrulecollectionspropertiesrulesfqdntags) | array | List of FQDN Tags for this rule. |
| [`sourceAddresses`](#parameter-applicationrulecollectionspropertiesrulessourceaddresses) | array | List of source IP addresses for this rule. |
| [`sourceIpGroups`](#parameter-applicationrulecollectionspropertiesrulessourceipgroups) | array | List of source IpGroups for this rule. |
| [`targetFqdns`](#parameter-applicationrulecollectionspropertiesrulestargetfqdns) | array | List of FQDNs for this rule. |

### Parameter: `applicationRuleCollections.properties.rules.name`

Name of the application rule.

- Required: Yes
- Type: string

### Parameter: `applicationRuleCollections.properties.rules.protocols`

Array of ApplicationRuleProtocols.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`protocolType`](#parameter-applicationrulecollectionspropertiesrulesprotocolsprotocoltype) | string | Protocol type. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`port`](#parameter-applicationrulecollectionspropertiesrulesprotocolsport) | int | Port number for the protocol. |

### Parameter: `applicationRuleCollections.properties.rules.protocols.protocolType`

Protocol type.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Http'
    'Https'
    'Mssql'
  ]
  ```

### Parameter: `applicationRuleCollections.properties.rules.protocols.port`

Port number for the protocol.

- Required: No
- Type: int

### Parameter: `applicationRuleCollections.properties.rules.description`

Description of the rule.

- Required: No
- Type: string

### Parameter: `applicationRuleCollections.properties.rules.fqdnTags`

List of FQDN Tags for this rule.

- Required: No
- Type: array

### Parameter: `applicationRuleCollections.properties.rules.sourceAddresses`

List of source IP addresses for this rule.

- Required: No
- Type: array

### Parameter: `applicationRuleCollections.properties.rules.sourceIpGroups`

List of source IpGroups for this rule.

- Required: No
- Type: array

### Parameter: `applicationRuleCollections.properties.rules.targetFqdns`

List of FQDNs for this rule.

- Required: No
- Type: array

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-natrulecollectionsname) | string | Name of the NAT rule collection. |
| [`properties`](#parameter-natrulecollectionsproperties) | object | Properties of the azure firewall NAT rule collection. |

### Parameter: `natRuleCollections.name`

Name of the NAT rule collection.

- Required: Yes
- Type: string

### Parameter: `natRuleCollections.properties`

Properties of the azure firewall NAT rule collection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-natrulecollectionspropertiesaction) | object | The action type of a NAT rule collection. |
| [`priority`](#parameter-natrulecollectionspropertiespriority) | int | Priority of the NAT rule collection. |
| [`rules`](#parameter-natrulecollectionspropertiesrules) | array | Collection of rules used by a NAT rule collection. |

### Parameter: `natRuleCollections.properties.action`

The action type of a NAT rule collection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-natrulecollectionspropertiesactiontype) | string | The type of action. |

### Parameter: `natRuleCollections.properties.action.type`

The type of action.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Dnat'
    'Snat'
  ]
  ```

### Parameter: `natRuleCollections.properties.priority`

Priority of the NAT rule collection.

- Required: Yes
- Type: int

### Parameter: `natRuleCollections.properties.rules`

Collection of rules used by a NAT rule collection.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-natrulecollectionspropertiesrulesname) | string | Name of the NAT rule. |
| [`protocols`](#parameter-natrulecollectionspropertiesrulesprotocols) | array | Array of AzureFirewallNetworkRuleProtocols applicable to this NAT rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-natrulecollectionspropertiesrulesdescription) | string | Description of the rule. |
| [`destinationAddresses`](#parameter-natrulecollectionspropertiesrulesdestinationaddresses) | array | List of destination IP addresses for this rule. Supports IP ranges, prefixes, and service tags. |
| [`destinationPorts`](#parameter-natrulecollectionspropertiesrulesdestinationports) | array | List of destination ports. |
| [`sourceAddresses`](#parameter-natrulecollectionspropertiesrulessourceaddresses) | array | List of source IP addresses for this rule. |
| [`sourceIpGroups`](#parameter-natrulecollectionspropertiesrulessourceipgroups) | array | List of source IpGroups for this rule. |
| [`translatedAddress`](#parameter-natrulecollectionspropertiesrulestranslatedaddress) | string | The translated address for this NAT rule. |
| [`translatedFqdn`](#parameter-natrulecollectionspropertiesrulestranslatedfqdn) | string | The translated FQDN for this NAT rule. |
| [`translatedPort`](#parameter-natrulecollectionspropertiesrulestranslatedport) | string | The translated port for this NAT rule. |

### Parameter: `natRuleCollections.properties.rules.name`

Name of the NAT rule.

- Required: Yes
- Type: string

### Parameter: `natRuleCollections.properties.rules.protocols`

Array of AzureFirewallNetworkRuleProtocols applicable to this NAT rule.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'Any'
    'ICMP'
    'TCP'
    'UDP'
  ]
  ```

### Parameter: `natRuleCollections.properties.rules.description`

Description of the rule.

- Required: No
- Type: string

### Parameter: `natRuleCollections.properties.rules.destinationAddresses`

List of destination IP addresses for this rule. Supports IP ranges, prefixes, and service tags.

- Required: No
- Type: array

### Parameter: `natRuleCollections.properties.rules.destinationPorts`

List of destination ports.

- Required: No
- Type: array

### Parameter: `natRuleCollections.properties.rules.sourceAddresses`

List of source IP addresses for this rule.

- Required: No
- Type: array

### Parameter: `natRuleCollections.properties.rules.sourceIpGroups`

List of source IpGroups for this rule.

- Required: No
- Type: array

### Parameter: `natRuleCollections.properties.rules.translatedAddress`

The translated address for this NAT rule.

- Required: No
- Type: string

### Parameter: `natRuleCollections.properties.rules.translatedFqdn`

The translated FQDN for this NAT rule.

- Required: No
- Type: string

### Parameter: `natRuleCollections.properties.rules.translatedPort`

The translated port for this NAT rule.

- Required: No
- Type: string

### Parameter: `networkRuleCollections`

Collection of network rule collections used by Azure Firewall.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-networkrulecollectionsname) | string | Name of the network rule collection. |
| [`properties`](#parameter-networkrulecollectionsproperties) | object | Properties of the azure firewall network rule collection. |

### Parameter: `networkRuleCollections.name`

Name of the network rule collection.

- Required: Yes
- Type: string

### Parameter: `networkRuleCollections.properties`

Properties of the azure firewall network rule collection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-networkrulecollectionspropertiesaction) | object | The action type of a rule collection. |
| [`priority`](#parameter-networkrulecollectionspropertiespriority) | int | Priority of the network rule collection. |
| [`rules`](#parameter-networkrulecollectionspropertiesrules) | array | Collection of rules used by a network rule collection. |

### Parameter: `networkRuleCollections.properties.action`

The action type of a rule collection.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-networkrulecollectionspropertiesactiontype) | string | The type of action. |

### Parameter: `networkRuleCollections.properties.action.type`

The type of action.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `networkRuleCollections.properties.priority`

Priority of the network rule collection.

- Required: Yes
- Type: int

### Parameter: `networkRuleCollections.properties.rules`

Collection of rules used by a network rule collection.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-networkrulecollectionspropertiesrulesname) | string | Name of the network rule. |
| [`protocols`](#parameter-networkrulecollectionspropertiesrulesprotocols) | array | Array of AzureFirewallNetworkRuleProtocols. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-networkrulecollectionspropertiesrulesdescription) | string | Description of the rule. |
| [`destinationAddresses`](#parameter-networkrulecollectionspropertiesrulesdestinationaddresses) | array | List of destination IP addresses. |
| [`destinationFqdns`](#parameter-networkrulecollectionspropertiesrulesdestinationfqdns) | array | List of destination FQDNs. |
| [`destinationIpGroups`](#parameter-networkrulecollectionspropertiesrulesdestinationipgroups) | array | List of destination IP groups for this rule. |
| [`destinationPorts`](#parameter-networkrulecollectionspropertiesrulesdestinationports) | array | List of destination ports. |
| [`sourceAddresses`](#parameter-networkrulecollectionspropertiesrulessourceaddresses) | array | List of source IP addresses for this rule. |
| [`sourceIpGroups`](#parameter-networkrulecollectionspropertiesrulessourceipgroups) | array | List of source IpGroups for this rule. |

### Parameter: `networkRuleCollections.properties.rules.name`

Name of the network rule.

- Required: Yes
- Type: string

### Parameter: `networkRuleCollections.properties.rules.protocols`

Array of AzureFirewallNetworkRuleProtocols.

- Required: Yes
- Type: array
- Allowed:
  ```Bicep
  [
    'Any'
    'ICMP'
    'TCP'
    'UDP'
  ]
  ```

### Parameter: `networkRuleCollections.properties.rules.description`

Description of the rule.

- Required: No
- Type: string

### Parameter: `networkRuleCollections.properties.rules.destinationAddresses`

List of destination IP addresses.

- Required: No
- Type: array

### Parameter: `networkRuleCollections.properties.rules.destinationFqdns`

List of destination FQDNs.

- Required: No
- Type: array

### Parameter: `networkRuleCollections.properties.rules.destinationIpGroups`

List of destination IP groups for this rule.

- Required: No
- Type: array

### Parameter: `networkRuleCollections.properties.rules.destinationPorts`

List of destination ports.

- Required: No
- Type: array

### Parameter: `networkRuleCollections.properties.rules.sourceAddresses`

List of source IP addresses for this rule.

- Required: No
- Type: array

### Parameter: `networkRuleCollections.properties.rules.sourceIpGroups`

List of source IpGroups for this rule.

- Required: No
- Type: array

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
    1
    2
    3
  ]
  ```


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `applicationRuleCollections` | array | List of Application Rule Collections used by Azure Firewall. |
| `ipConfAzureFirewallSubnet` | object | The Public IP configuration object for the Azure Firewall Subnet. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Azure Firewall. |
| `natRuleCollections` | array | List of NAT rule collections used by Azure Firewall. |
| `networkRuleCollections` | array | List of Network Rule Collections used by Azure Firewall. |
| `privateIp` | string | The private IP of the Azure firewall. |
| `resourceGroupName` | string | The resource group the Azure firewall was deployed into. |
| `resourceId` | string | The resource ID of the Azure Firewall. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/public-ip-address:0.4.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
