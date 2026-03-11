# Azure Firewalls `[Microsoft.Network/azureFirewalls]`

This module deploys an Azure Firewall.

You can reference the module as follows:
```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Maintenance/configurationAssignments` | 2023-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.maintenance_configurationassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Maintenance/2023-04-01/configurationAssignments)</li></ul> |
| `Microsoft.Network/azureFirewalls` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_azurefirewalls.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/azureFirewalls)</li></ul> |
| `Microsoft.Network/publicIPAddresses` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/publicIPAddresses)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/azure-firewall:<version>`.

- [Add-PIP](#example-1-add-pip)
- [Basic SKU](#example-2-basic-sku)
- [Custom-PIP](#example-3-custom-pip)
- [Using only defaults](#example-4-using-only-defaults)
- [Hub-byoip](#example-5-hub-byoip)
- [Hub-commom](#example-6-hub-commom)
- [Hub-min](#example-7-hub-min)
- [Management nic](#example-8-management-nic)
- [Using large parameter set](#example-9-using-large-parameter-set)
- [Public-IP-Prefix](#example-10-public-ip-prefix)
- [WAF-aligned](#example-11-waf-aligned)

### Example 1: _Add-PIP_

This instance deploys the module and attaches an existing public IP address.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/addpip]


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  params: {
    // Required parameters
    name: 'nafaddpip001'
    // Non-required parameters
    additionalPublicIpConfigurations: [
      {
        name: 'ipConfig01'
        properties: {
          publicIPAddress: {
            id: '<id>'
          }
        }
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

<summary>via JSON parameters file</summary>

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
          "properties": {
            "publicIPAddress": {
              "id": "<id>"
            }
          }
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/azure-firewall:<version>'

// Required parameters
param name = 'nafaddpip001'
// Non-required parameters
param additionalPublicIpConfigurations = [
  {
    name: 'ipConfig01'
    properties: {
      publicIPAddress: {
        id: '<id>'
      }
    }
  }
]
param azureSkuTier = 'Basic'
param location = '<location>'
param managementIPAddressObject = {
  publicIPAllocationMethod: 'Static'
  roleAssignments: [
    {
      principalId: '<principalId>'
      principalType: 'ServicePrincipal'
      roleDefinitionIdOrName: 'Reader'
    }
  ]
}
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
```

</details>
<p>

### Example 2: _Basic SKU_

This instance deploys the module with the Basic SKU.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/basic]


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  params: {
    // Required parameters
    name: 'nafbasic001'
    // Non-required parameters
    azureSkuTier: 'Basic'
    location: '<location>'
    networkRuleCollections: []
    threatIntelMode: 'Deny'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nafbasic001"
    },
    // Non-required parameters
    "azureSkuTier": {
      "value": "Basic"
    },
    "location": {
      "value": "<location>"
    },
    "networkRuleCollections": {
      "value": []
    },
    "threatIntelMode": {
      "value": "Deny"
    },
    "virtualNetworkResourceId": {
      "value": "<virtualNetworkResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/azure-firewall:<version>'

// Required parameters
param name = 'nafbasic001'
// Non-required parameters
param azureSkuTier = 'Basic'
param location = '<location>'
param networkRuleCollections = []
param threatIntelMode = 'Deny'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
```

</details>
<p>

### Example 3: _Custom-PIP_

This instance deploys the module and will create a public IP address.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/custompip]


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
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

<summary>via JSON parameters file</summary>

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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/azure-firewall:<version>'

// Required parameters
param name = 'nafcstpip001'
// Non-required parameters
param location = '<location>'
param publicIPAddressObject = {
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
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
```

</details>
<p>

### Example 4: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
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

<summary>via JSON parameters file</summary>

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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/azure-firewall:<version>'

// Required parameters
param name = 'nafmin001'
// Non-required parameters
param location = '<location>'
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
```

</details>
<p>

### Example 5: _Hub-byoip_

This instance deploys the module a vWAN with an existing IP.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/hubbyoip]


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  params: {
    // Required parameters
    name: 'nafhubbyoip001'
    // Non-required parameters
    publicIPResourceID: '<publicIPResourceID>'
    virtualHubResourceId: '<virtualHubResourceId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "nafhubbyoip001"
    },
    // Non-required parameters
    "publicIPResourceID": {
      "value": "<publicIPResourceID>"
    },
    "virtualHubResourceId": {
      "value": "<virtualHubResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/azure-firewall:<version>'

// Required parameters
param name = 'nafhubbyoip001'
// Non-required parameters
param publicIPResourceID = '<publicIPResourceID>'
param virtualHubResourceId = '<virtualHubResourceId>'
```

</details>
<p>

### Example 6: _Hub-commom_

This instance deploys the module a vWAN in a typical hub setting.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/hubcommon]


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
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
    virtualHubResourceId: '<virtualHubResourceId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

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
    "virtualHubResourceId": {
      "value": "<virtualHubResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/azure-firewall:<version>'

// Required parameters
param name = 'nafhubcom001'
// Non-required parameters
param firewallPolicyId = '<firewallPolicyId>'
param hubIPAddresses = {
  publicIPs: {
    count: 1
  }
}
param location = '<location>'
param virtualHubResourceId = '<virtualHubResourceId>'
```

</details>
<p>

### Example 7: _Hub-min_

This instance deploys the module a vWAN minimum hub setting.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/hubmin]


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
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
    virtualHubResourceId: '<virtualHubResourceId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

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
    "virtualHubResourceId": {
      "value": "<virtualHubResourceId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/azure-firewall:<version>'

// Required parameters
param name = 'nafhubmin001'
// Non-required parameters
param hubIPAddresses = {
  publicIPs: {
    count: 1
  }
}
param location = '<location>'
param virtualHubResourceId = '<virtualHubResourceId>'
```

</details>
<p>

### Example 8: _Management nic_

This instance deploys the module and sets up a Firewall management nic to support features such as Forced Tunneling and Packet Capture.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/managementnic]


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  params: {
    // Required parameters
    name: 'naftunn001'
    // Non-required parameters
    additionalPublicIpConfigurations: [
      {
        name: 'ipConfig01'
        properties: {
          publicIPAddress: {
            id: '<id>'
          }
        }
      }
    ]
    azureSkuTier: 'Standard'
    enableManagementNic: true
    location: '<location>'
    managementIPAddressObject: {
      publicIPAllocationMethod: 'Static'
    }
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "naftunn001"
    },
    // Non-required parameters
    "additionalPublicIpConfigurations": {
      "value": [
        {
          "name": "ipConfig01",
          "properties": {
            "publicIPAddress": {
              "id": "<id>"
            }
          }
        }
      ]
    },
    "azureSkuTier": {
      "value": "Standard"
    },
    "enableManagementNic": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "managementIPAddressObject": {
      "value": {
        "publicIPAllocationMethod": "Static"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/azure-firewall:<version>'

// Required parameters
param name = 'naftunn001'
// Non-required parameters
param additionalPublicIpConfigurations = [
  {
    name: 'ipConfig01'
    properties: {
      publicIPAddress: {
        id: '<id>'
      }
    }
  }
]
param azureSkuTier = 'Standard'
param enableManagementNic = true
param location = '<location>'
param managementIPAddressObject = {
  publicIPAllocationMethod: 'Static'
}
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
```

</details>
<p>

### Example 9: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
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
    availabilityZones: [
      1
      2
      3
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
    maintenanceConfiguration: {
      assignmentName: 'myMaintenanceAssignment'
      maintenanceConfigurationResourceId: '<maintenanceConfigurationResourceId>'
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
        name: '3a8da184-d6d8-4bea-b992-e27cc053ef21'
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
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

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
    "availabilityZones": {
      "value": [
        1,
        2,
        3
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
    "maintenanceConfiguration": {
      "value": {
        "assignmentName": "myMaintenanceAssignment",
        "maintenanceConfigurationResourceId": "<maintenanceConfigurationResourceId>"
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
          "name": "3a8da184-d6d8-4bea-b992-e27cc053ef21",
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
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/azure-firewall:<version>'

// Required parameters
param name = 'nafmax001'
// Non-required parameters
param applicationRuleCollections = [
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
param availabilityZones = [
  1
  2
  3
]
param diagnosticSettings = [
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
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param maintenanceConfiguration = {
  assignmentName: 'myMaintenanceAssignment'
  maintenanceConfigurationResourceId: '<maintenanceConfigurationResourceId>'
}
param networkRuleCollections = [
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
param publicIPResourceID = '<publicIPResourceID>'
param roleAssignments = [
  {
    name: '3a8da184-d6d8-4bea-b992-e27cc053ef21'
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
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
```

</details>
<p>

### Example 10: _Public-IP-Prefix_

This instance deploys the module and will use a public IP prefix.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/publicipprefix]


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
  params: {
    // Required parameters
    name: 'nafpip001'
    // Non-required parameters
    availabilityZones: []
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
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

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
    "availabilityZones": {
      "value": []
    },
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
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/azure-firewall:<version>'

// Required parameters
param name = 'nafpip001'
// Non-required parameters
param availabilityZones = []
param azureSkuTier = 'Basic'
param location = '<location>'
param managementIPAddressObject = {
  managementIPAllocationMethod: 'Static'
  managementIPPrefixResourceId: '<managementIPPrefixResourceId>'
  name: 'managementIP01'
  skuName: 'Standard'
  skuTier: 'Regional'
}
param publicIPAddressObject = {
  name: 'publicIP01'
  publicIPAllocationMethod: 'Static'
  publicIPPrefixResourceId: '<publicIPPrefixResourceId>'
  skuName: 'Standard'
  skuTier: 'Regional'
}
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
```

</details>
<p>

### Example 11: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module azureFirewall 'br/public:avm/res/network/azure-firewall:<version>' = {
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
    availabilityZones: [
      1
      2
      3
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
  }
}
```

</details>
<p>

<details>

<summary>via JSON parameters file</summary>

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
    "availabilityZones": {
      "value": [
        1,
        2,
        3
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
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/azure-firewall:<version>'

// Required parameters
param name = 'nafwaf001'
// Non-required parameters
param applicationRuleCollections = [
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
param availabilityZones = [
  1
  2
  3
]
param diagnosticSettings = [
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
param location = '<location>'
param networkRuleCollections = [
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
param publicIPResourceID = '<publicIPResourceID>'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param virtualNetworkResourceId = '<virtualNetworkResourceId>'
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
| [`hubIPAddresses`](#parameter-hubipaddresses) | object | IP addresses associated with AzureFirewall. Required if `virtualHubId` is supplied & `publicIPResourceID` is empty. |
| [`virtualHubResourceId`](#parameter-virtualhubresourceid) | string | The virtualHub resource ID to which the firewall belongs. Required if `virtualNetworkId` is empty. |
| [`virtualNetworkResourceId`](#parameter-virtualnetworkresourceid) | string | Shared services Virtual Network resource ID. The virtual network ID containing AzureFirewallSubnet. If a Public IP is not provided, then the Public IP that is created as part of this module will be applied with the subnet provided in this variable. Required if `virtualHubId` is empty. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalProperties`](#parameter-additionalproperties) | object | The additional properties used to further config this azure firewall. Used for DNS proxy configuration (e.g., `Network.DNS.EnableProxy`). |
| [`additionalPublicIpConfigurations`](#parameter-additionalpublicipconfigurations) | array | This is to add any additional Public IP configurations on top of the Public IP with subnet IP configuration. |
| [`applicationRuleCollections`](#parameter-applicationrulecollections) | array | Collection of application rule collections used by Azure Firewall. |
| [`autoscaleMaxCapacity`](#parameter-autoscalemaxcapacity) | int | The maximum number of capacity units for this azure firewall. Use null to reset the value to the service default. |
| [`autoscaleMinCapacity`](#parameter-autoscalemincapacity) | int | The minimum number of capacity units for this azure firewall. Use null to reset the value to the service default. |
| [`availabilityZones`](#parameter-availabilityzones) | array | The list of Availability zones to use for the zone-redundant resources. |
| [`azureSkuTier`](#parameter-azureskutier) | string | Tier of an Azure Firewall. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableManagementNic`](#parameter-enablemanagementnic) | bool | Enable/Disable to support Forced Tunneling and Packet capture scenarios. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`extendedLocation`](#parameter-extendedlocation) | object | The extended location of type local virtual network gateway. |
| [`firewallPolicyId`](#parameter-firewallpolicyid) | string | Resource ID of the Firewall Policy that should be attached. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maintenanceConfiguration`](#parameter-maintenanceconfiguration) | object | The maintenance configuration to assign to the Azure Firewall. |
| [`managementIPAddressObject`](#parameter-managementipaddressobject) | object | Specifies the properties of the Management Public IP to create and be used by Azure Firewall. If it's not provided and managementIPResourceID is empty, a '-mip' suffix will be appended to the Firewall's name. |
| [`managementIPResourceID`](#parameter-managementipresourceid) | string | The Management Public IP resource ID to associate to the AzureFirewallManagementSubnet. If empty, then the Management Public IP that is created as part of this module will be applied to the AzureFirewallManagementSubnet. |
| [`natRuleCollections`](#parameter-natrulecollections) | array | Collection of NAT rule collections used by Azure Firewall. |
| [`networkRuleCollections`](#parameter-networkrulecollections) | array | Collection of network rule collections used by Azure Firewall. |
| [`publicIPAddressObject`](#parameter-publicipaddressobject) | object | Specifies the properties of the Public IP to create and be used by the Firewall, if no existing public IP was provided. |
| [`publicIPResourceID`](#parameter-publicipresourceid) | string | The Public IP resource ID to associate to the Azure Firewall. If empty, then the Public IP that is created as part of this module will be applied to the Azure Firewall. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the Azure Firewall resource. |
| [`threatIntelMode`](#parameter-threatintelmode) | string | The operation mode for Threat Intel. |

### Parameter: `name`

Name of the Azure Firewall.

- Required: Yes
- Type: string

### Parameter: `hubIPAddresses`

IP addresses associated with AzureFirewall. Required if `virtualHubId` is supplied & `publicIPResourceID` is empty.

- Required: No
- Type: object

### Parameter: `virtualHubResourceId`

The virtualHub resource ID to which the firewall belongs. Required if `virtualNetworkId` is empty.

- Required: No
- Type: string
- Default: `''`

### Parameter: `virtualNetworkResourceId`

Shared services Virtual Network resource ID. The virtual network ID containing AzureFirewallSubnet. If a Public IP is not provided, then the Public IP that is created as part of this module will be applied with the subnet provided in this variable. Required if `virtualHubId` is empty.

- Required: No
- Type: string
- Default: `''`

### Parameter: `additionalProperties`

The additional properties used to further config this azure firewall. Used for DNS proxy configuration (e.g., `Network.DNS.EnableProxy`).

- Required: No
- Type: object

### Parameter: `additionalPublicIpConfigurations`

This is to add any additional Public IP configurations on top of the Public IP with subnet IP configuration.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `applicationRuleCollections`

Collection of application rule collections used by Azure Firewall.

- Required: No
- Type: array

### Parameter: `autoscaleMaxCapacity`

The maximum number of capacity units for this azure firewall. Use null to reset the value to the service default.

- Required: No
- Type: int

### Parameter: `autoscaleMinCapacity`

The minimum number of capacity units for this azure firewall. Use null to reset the value to the service default.

- Required: No
- Type: int

### Parameter: `availabilityZones`

The list of Availability zones to use for the zone-redundant resources.

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
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `azureSkuTier`

Tier of an Azure Firewall.

- Required: No
- Type: string
- Default: `'Standard'`

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
| [`name`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting. |
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

The name of the diagnostic setting.

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

### Parameter: `enableManagementNic`

Enable/Disable to support Forced Tunneling and Packet capture scenarios.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `extendedLocation`

The extended location of type local virtual network gateway.

- Required: No
- Type: object

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
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

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

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `maintenanceConfiguration`

The maintenance configuration to assign to the Azure Firewall.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assignmentName`](#parameter-maintenanceconfigurationassignmentname) | string | The name of the maintenance configuration assignment. |
| [`maintenanceConfigurationResourceId`](#parameter-maintenanceconfigurationmaintenanceconfigurationresourceid) | string | The resource ID of the maintenance configuration to assign to the Azure Firewall. |

### Parameter: `maintenanceConfiguration.assignmentName`

The name of the maintenance configuration assignment.

- Required: Yes
- Type: string

### Parameter: `maintenanceConfiguration.maintenanceConfigurationResourceId`

The resource ID of the maintenance configuration to assign to the Azure Firewall.

- Required: Yes
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

### Parameter: `networkRuleCollections`

Collection of network rule collections used by Azure Firewall.

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

The Public IP resource ID to associate to the Azure Firewall. If empty, then the Public IP that is created as part of this module will be applied to the Azure Firewall.

- Required: No
- Type: string
- Default: `''`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

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

### Parameter: `tags`

Tags of the Azure Firewall resource.

- Required: No
- Type: object

### Parameter: `threatIntelMode`

The operation mode for Threat Intel.

- Required: No
- Type: string
- Default: `'Deny'`

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
| `br/public:avm/res/network/public-ip-address:0.12.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
