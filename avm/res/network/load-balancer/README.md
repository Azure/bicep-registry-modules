# Load Balancers `[Microsoft.Network/loadBalancers]`

This module deploys a Load Balancer.

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
| `Microsoft.Network/loadBalancers` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/loadBalancers) |
| `Microsoft.Network/loadBalancers/backendAddressPools` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/loadBalancers/backendAddressPools) |
| `Microsoft.Network/loadBalancers/inboundNatRules` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-11-01/loadBalancers/inboundNatRules) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/load-balancer:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using external load balancer parameter](#example-2-using-external-load-balancer-parameter)
- [Using internal load balancer parameter](#example-3-using-internal-load-balancer-parameter)
- [Using large parameter set](#example-4-using-large-parameter-set)
- [WAF-aligned](#example-5-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
  name: 'loadBalancerDeployment'
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressId: '<publicIPAddressId>'
      }
    ]
    name: 'nlbmin001'
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
    "frontendIPConfigurations": {
      "value": [
        {
          "name": "publicIPConfig1",
          "publicIPAddressId": "<publicIPAddressId>"
        }
      ]
    },
    "name": {
      "value": "nlbmin001"
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

### Example 2: _Using external load balancer parameter_

This instance deploys the module with an externally facing load balancer.


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
  name: 'loadBalancerDeployment'
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressId: '<publicIPAddressId>'
      }
    ]
    name: 'nlbext001'
    // Non-required parameters
    backendAddressPools: [
      {
        name: 'backendAddressPool1'
      }
      {
        name: 'backendAddressPool2'
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
    inboundNatRules: [
      {
        backendPort: 443
        enableFloatingIP: false
        enableTcpReset: false
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 443
        idleTimeoutInMinutes: 4
        name: 'inboundNatRule1'
        protocol: 'Tcp'
      }
      {
        backendPort: 3389
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 3389
        name: 'inboundNatRule2'
      }
    ]
    loadBalancingRules: [
      {
        backendAddressPoolName: 'backendAddressPool1'
        backendPort: 80
        disableOutboundSnat: true
        enableFloatingIP: false
        enableTcpReset: false
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 80
        idleTimeoutInMinutes: 5
        loadDistribution: 'Default'
        name: 'publicIPLBRule1'
        probeName: 'probe1'
        protocol: 'Tcp'
      }
      {
        backendAddressPoolName: 'backendAddressPool2'
        backendPort: 8080
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 8080
        loadDistribution: 'Default'
        name: 'publicIPLBRule2'
        probeName: 'probe2'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    outboundRules: [
      {
        allocatedOutboundPorts: 63984
        backendAddressPoolName: 'backendAddressPool1'
        frontendIPConfigurationName: 'publicIPConfig1'
        name: 'outboundRule1'
      }
    ]
    probes: [
      {
        intervalInSeconds: 10
        name: 'probe1'
        numberOfProbes: 5
        port: 80
        protocol: 'Http'
        requestPath: '/http-probe'
      }
      {
        name: 'probe2'
        port: 443
        protocol: 'Https'
        requestPath: '/https-probe'
      }
    ]
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
    "frontendIPConfigurations": {
      "value": [
        {
          "name": "publicIPConfig1",
          "publicIPAddressId": "<publicIPAddressId>"
        }
      ]
    },
    "name": {
      "value": "nlbext001"
    },
    // Non-required parameters
    "backendAddressPools": {
      "value": [
        {
          "name": "backendAddressPool1"
        },
        {
          "name": "backendAddressPool2"
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
    "inboundNatRules": {
      "value": [
        {
          "backendPort": 443,
          "enableFloatingIP": false,
          "enableTcpReset": false,
          "frontendIPConfigurationName": "publicIPConfig1",
          "frontendPort": 443,
          "idleTimeoutInMinutes": 4,
          "name": "inboundNatRule1",
          "protocol": "Tcp"
        },
        {
          "backendPort": 3389,
          "frontendIPConfigurationName": "publicIPConfig1",
          "frontendPort": 3389,
          "name": "inboundNatRule2"
        }
      ]
    },
    "loadBalancingRules": {
      "value": [
        {
          "backendAddressPoolName": "backendAddressPool1",
          "backendPort": 80,
          "disableOutboundSnat": true,
          "enableFloatingIP": false,
          "enableTcpReset": false,
          "frontendIPConfigurationName": "publicIPConfig1",
          "frontendPort": 80,
          "idleTimeoutInMinutes": 5,
          "loadDistribution": "Default",
          "name": "publicIPLBRule1",
          "probeName": "probe1",
          "protocol": "Tcp"
        },
        {
          "backendAddressPoolName": "backendAddressPool2",
          "backendPort": 8080,
          "frontendIPConfigurationName": "publicIPConfig1",
          "frontendPort": 8080,
          "loadDistribution": "Default",
          "name": "publicIPLBRule2",
          "probeName": "probe2"
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
    "outboundRules": {
      "value": [
        {
          "allocatedOutboundPorts": 63984,
          "backendAddressPoolName": "backendAddressPool1",
          "frontendIPConfigurationName": "publicIPConfig1",
          "name": "outboundRule1"
        }
      ]
    },
    "probes": {
      "value": [
        {
          "intervalInSeconds": 10,
          "name": "probe1",
          "numberOfProbes": 5,
          "port": 80,
          "protocol": "Http",
          "requestPath": "/http-probe"
        },
        {
          "name": "probe2",
          "port": 443,
          "protocol": "Https",
          "requestPath": "/https-probe"
        }
      ]
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
    }
  }
}
```

</details>
<p>

### Example 3: _Using internal load balancer parameter_

This instance deploys the module with the minimum set of required parameters to deploy an internal load balancer.


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
  name: 'loadBalancerDeployment'
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'privateIPConfig1'
        subnetId: '<subnetId>'
      }
    ]
    name: 'nlbint001'
    // Non-required parameters
    backendAddressPools: [
      {
        name: 'servers'
      }
    ]
    inboundNatRules: [
      {
        backendPort: 443
        enableFloatingIP: false
        enableTcpReset: false
        frontendIPConfigurationName: 'privateIPConfig1'
        frontendPort: 443
        idleTimeoutInMinutes: 4
        name: 'inboundNatRule1'
        protocol: 'Tcp'
      }
      {
        backendPort: 3389
        frontendIPConfigurationName: 'privateIPConfig1'
        frontendPort: 3389
        name: 'inboundNatRule2'
      }
    ]
    loadBalancingRules: [
      {
        backendAddressPoolName: 'servers'
        backendPort: 0
        disableOutboundSnat: true
        enableFloatingIP: true
        enableTcpReset: false
        frontendIPConfigurationName: 'privateIPConfig1'
        frontendPort: 0
        idleTimeoutInMinutes: 4
        loadDistribution: 'Default'
        name: 'privateIPLBRule1'
        probeName: 'probe1'
        protocol: 'All'
      }
    ]
    location: '<location>'
    probes: [
      {
        intervalInSeconds: 5
        name: 'probe1'
        numberOfProbes: 2
        port: '62000'
        protocol: 'Tcp'
      }
    ]
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
    skuName: 'Standard'
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
    "frontendIPConfigurations": {
      "value": [
        {
          "name": "privateIPConfig1",
          "subnetId": "<subnetId>"
        }
      ]
    },
    "name": {
      "value": "nlbint001"
    },
    // Non-required parameters
    "backendAddressPools": {
      "value": [
        {
          "name": "servers"
        }
      ]
    },
    "inboundNatRules": {
      "value": [
        {
          "backendPort": 443,
          "enableFloatingIP": false,
          "enableTcpReset": false,
          "frontendIPConfigurationName": "privateIPConfig1",
          "frontendPort": 443,
          "idleTimeoutInMinutes": 4,
          "name": "inboundNatRule1",
          "protocol": "Tcp"
        },
        {
          "backendPort": 3389,
          "frontendIPConfigurationName": "privateIPConfig1",
          "frontendPort": 3389,
          "name": "inboundNatRule2"
        }
      ]
    },
    "loadBalancingRules": {
      "value": [
        {
          "backendAddressPoolName": "servers",
          "backendPort": 0,
          "disableOutboundSnat": true,
          "enableFloatingIP": true,
          "enableTcpReset": false,
          "frontendIPConfigurationName": "privateIPConfig1",
          "frontendPort": 0,
          "idleTimeoutInMinutes": 4,
          "loadDistribution": "Default",
          "name": "privateIPLBRule1",
          "probeName": "probe1",
          "protocol": "All"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "probes": {
      "value": [
        {
          "intervalInSeconds": 5,
          "name": "probe1",
          "numberOfProbes": 2,
          "port": "62000",
          "protocol": "Tcp"
        }
      ]
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
    "skuName": {
      "value": "Standard"
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

### Example 4: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
  name: 'loadBalancerDeployment'
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressId: '<publicIPAddressId>'
      }
    ]
    name: 'nlbmax001'
    // Non-required parameters
    backendAddressPools: [
      {
        name: 'backendAddressPool1'
      }
      {
        name: 'backendAddressPool2'
      }
    ]
    diagnosticSettings: [
      {
        eventHubAuthorizationRuleResourceId: '<eventHubAuthorizationRuleResourceId>'
        eventHubName: '<eventHubName>'
        logCategoriesAndGroups: [
          {
            categoryGroup: 'allLogs'
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
    inboundNatRules: [
      {
        backendPort: 443
        enableFloatingIP: false
        enableTcpReset: false
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 443
        idleTimeoutInMinutes: 4
        name: 'inboundNatRule1'
        protocol: 'Tcp'
      }
      {
        backendPort: 3389
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 3389
        name: 'inboundNatRule2'
      }
    ]
    loadBalancingRules: [
      {
        backendAddressPoolName: 'backendAddressPool1'
        backendPort: 80
        disableOutboundSnat: true
        enableFloatingIP: false
        enableTcpReset: false
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 80
        idleTimeoutInMinutes: 5
        loadDistribution: 'Default'
        name: 'publicIPLBRule1'
        probeName: 'probe1'
        protocol: 'Tcp'
      }
      {
        backendAddressPoolName: 'backendAddressPool2'
        backendPort: 8080
        frontendIPConfigurationName: 'publicIPConfig1'
        frontendPort: 8080
        loadDistribution: 'Default'
        name: 'publicIPLBRule2'
        probeName: 'probe2'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    outboundRules: [
      {
        allocatedOutboundPorts: 63984
        backendAddressPoolName: 'backendAddressPool1'
        frontendIPConfigurationName: 'publicIPConfig1'
        name: 'outboundRule1'
      }
    ]
    probes: [
      {
        intervalInSeconds: 10
        name: 'probe1'
        numberOfProbes: 5
        port: 80
        protocol: 'Tcp'
      }
      {
        name: 'probe2'
        port: 443
        protocol: 'Https'
        requestPath: '/'
      }
    ]
    roleAssignments: [
      {
        name: '3a5b2a4a-3584-4d6b-9cf0-ceb1e4f88a5d'
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
    "frontendIPConfigurations": {
      "value": [
        {
          "name": "publicIPConfig1",
          "publicIPAddressId": "<publicIPAddressId>"
        }
      ]
    },
    "name": {
      "value": "nlbmax001"
    },
    // Non-required parameters
    "backendAddressPools": {
      "value": [
        {
          "name": "backendAddressPool1"
        },
        {
          "name": "backendAddressPool2"
        }
      ]
    },
    "diagnosticSettings": {
      "value": [
        {
          "eventHubAuthorizationRuleResourceId": "<eventHubAuthorizationRuleResourceId>",
          "eventHubName": "<eventHubName>",
          "logCategoriesAndGroups": [
            {
              "categoryGroup": "allLogs"
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
    "inboundNatRules": {
      "value": [
        {
          "backendPort": 443,
          "enableFloatingIP": false,
          "enableTcpReset": false,
          "frontendIPConfigurationName": "publicIPConfig1",
          "frontendPort": 443,
          "idleTimeoutInMinutes": 4,
          "name": "inboundNatRule1",
          "protocol": "Tcp"
        },
        {
          "backendPort": 3389,
          "frontendIPConfigurationName": "publicIPConfig1",
          "frontendPort": 3389,
          "name": "inboundNatRule2"
        }
      ]
    },
    "loadBalancingRules": {
      "value": [
        {
          "backendAddressPoolName": "backendAddressPool1",
          "backendPort": 80,
          "disableOutboundSnat": true,
          "enableFloatingIP": false,
          "enableTcpReset": false,
          "frontendIPConfigurationName": "publicIPConfig1",
          "frontendPort": 80,
          "idleTimeoutInMinutes": 5,
          "loadDistribution": "Default",
          "name": "publicIPLBRule1",
          "probeName": "probe1",
          "protocol": "Tcp"
        },
        {
          "backendAddressPoolName": "backendAddressPool2",
          "backendPort": 8080,
          "frontendIPConfigurationName": "publicIPConfig1",
          "frontendPort": 8080,
          "loadDistribution": "Default",
          "name": "publicIPLBRule2",
          "probeName": "probe2"
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
    "outboundRules": {
      "value": [
        {
          "allocatedOutboundPorts": 63984,
          "backendAddressPoolName": "backendAddressPool1",
          "frontendIPConfigurationName": "publicIPConfig1",
          "name": "outboundRule1"
        }
      ]
    },
    "probes": {
      "value": [
        {
          "intervalInSeconds": 10,
          "name": "probe1",
          "numberOfProbes": 5,
          "port": 80,
          "protocol": "Tcp"
        },
        {
          "name": "probe2",
          "port": 443,
          "protocol": "Https",
          "requestPath": "/"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "3a5b2a4a-3584-4d6b-9cf0-ceb1e4f88a5d",
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
    }
  }
}
```

</details>
<p>

### Example 5: _WAF-aligned_

This instance deploys the module with the minimum set of required parameters to deploy a WAF-aligned internal load balancer.


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
  name: 'loadBalancerDeployment'
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'privateIPConfig1'
        subnetId: '<subnetId>'
        zones: [
          1
          2
          3
        ]
      }
    ]
    name: 'nlbwaf001'
    // Non-required parameters
    backendAddressPools: [
      {
        name: 'servers'
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
    inboundNatRules: [
      {
        backendPort: 443
        enableFloatingIP: false
        enableTcpReset: false
        frontendIPConfigurationName: 'privateIPConfig1'
        frontendPort: 443
        idleTimeoutInMinutes: 4
        name: 'inboundNatRule1'
        protocol: 'Tcp'
      }
      {
        backendAddressPoolName: 'servers'
        backendPort: 3389
        frontendIPConfigurationName: 'privateIPConfig1'
        frontendPortRangeEnd: 5010
        frontendPortRangeStart: 5000
        loadDistribution: 'Default'
        name: 'inboundNatRule2'
        probeName: 'probe2'
      }
    ]
    loadBalancingRules: [
      {
        backendAddressPoolName: 'servers'
        backendPort: 0
        disableOutboundSnat: true
        enableFloatingIP: true
        enableTcpReset: false
        frontendIPConfigurationName: 'privateIPConfig1'
        frontendPort: 0
        idleTimeoutInMinutes: 4
        loadDistribution: 'Default'
        name: 'privateIPLBRule1'
        probeName: 'probe1'
        protocol: 'All'
      }
    ]
    location: '<location>'
    probes: [
      {
        intervalInSeconds: 5
        name: 'probe1'
        numberOfProbes: 2
        port: '62000'
        protocol: 'Tcp'
      }
    ]
    skuName: 'Standard'
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
    "frontendIPConfigurations": {
      "value": [
        {
          "name": "privateIPConfig1",
          "subnetId": "<subnetId>",
          "zones": [
            1,
            2,
            3
          ]
        }
      ]
    },
    "name": {
      "value": "nlbwaf001"
    },
    // Non-required parameters
    "backendAddressPools": {
      "value": [
        {
          "name": "servers"
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
    "inboundNatRules": {
      "value": [
        {
          "backendPort": 443,
          "enableFloatingIP": false,
          "enableTcpReset": false,
          "frontendIPConfigurationName": "privateIPConfig1",
          "frontendPort": 443,
          "idleTimeoutInMinutes": 4,
          "name": "inboundNatRule1",
          "protocol": "Tcp"
        },
        {
          "backendAddressPoolName": "servers",
          "backendPort": 3389,
          "frontendIPConfigurationName": "privateIPConfig1",
          "frontendPortRangeEnd": 5010,
          "frontendPortRangeStart": 5000,
          "loadDistribution": "Default",
          "name": "inboundNatRule2",
          "probeName": "probe2"
        }
      ]
    },
    "loadBalancingRules": {
      "value": [
        {
          "backendAddressPoolName": "servers",
          "backendPort": 0,
          "disableOutboundSnat": true,
          "enableFloatingIP": true,
          "enableTcpReset": false,
          "frontendIPConfigurationName": "privateIPConfig1",
          "frontendPort": 0,
          "idleTimeoutInMinutes": 4,
          "loadDistribution": "Default",
          "name": "privateIPLBRule1",
          "probeName": "probe1",
          "protocol": "All"
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "probes": {
      "value": [
        {
          "intervalInSeconds": 5,
          "name": "probe1",
          "numberOfProbes": 2,
          "port": "62000",
          "protocol": "Tcp"
        }
      ]
    },
    "skuName": {
      "value": "Standard"
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
| [`frontendIPConfigurations`](#parameter-frontendipconfigurations) | array | Array of objects containing all frontend IP configurations. |
| [`name`](#parameter-name) | string | The Proximity Placement Groups Name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backendAddressPools`](#parameter-backendaddresspools) | array | Collection of backend address pools used by a load balancer. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`inboundNatRules`](#parameter-inboundnatrules) | array | Collection of inbound NAT Rules used by a load balancer. Defining inbound NAT rules on your load balancer is mutually exclusive with defining an inbound NAT pool. Inbound NAT pools are referenced from virtual machine scale sets. NICs that are associated with individual virtual machines cannot reference an Inbound NAT pool. They have to reference individual inbound NAT rules. |
| [`loadBalancingRules`](#parameter-loadbalancingrules) | array | Array of objects containing all load balancing rules. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`outboundRules`](#parameter-outboundrules) | array | The outbound rules. |
| [`probes`](#parameter-probes) | array | Array of objects containing all probes, these are references in the load balancing rules. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`skuName`](#parameter-skuname) | string | Name of a load balancer SKU. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `frontendIPConfigurations`

Array of objects containing all frontend IP configurations.

- Required: Yes
- Type: array

### Parameter: `name`

The Proximity Placement Groups Name.

- Required: Yes
- Type: string

### Parameter: `backendAddressPools`

Collection of backend address pools used by a load balancer.

- Required: No
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `inboundNatRules`

Collection of inbound NAT Rules used by a load balancer. Defining inbound NAT rules on your load balancer is mutually exclusive with defining an inbound NAT pool. Inbound NAT pools are referenced from virtual machine scale sets. NICs that are associated with individual virtual machines cannot reference an Inbound NAT pool. They have to reference individual inbound NAT rules.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `loadBalancingRules`

Array of objects containing all load balancing rules.

- Required: No
- Type: array

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

### Parameter: `outboundRules`

The outbound rules.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `probes`

Array of objects containing all probes, these are references in the load balancing rules.

- Required: No
- Type: array

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

### Parameter: `skuName`

Name of a load balancer SKU.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Basic'
    'Standard'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `backendpools` | array | The backend address pools available in the load balancer. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the load balancer. |
| `resourceGroupName` | string | The resource group the load balancer was deployed into. |
| `resourceId` | string | The resource ID of the load balancer. |

## Cross-referenced modules

_None_

## Notes

### Parameter Usage: `backendAddressPools`

<details>

<summary>Parameter JSON format</summary>

```json
"backendAddressPools": {
    "value": [
        {
            "name": "p_hub-bfw-server-bepool",
            "properties": {
                "loadBalancerBackendAddresses": [
                    {
                        "name": "iacs-sh-main-pd-01-euw-rg-network_awefwa01p-nic-int-01ipconfig-internal",
                        "properties": {
                            "virtualNetwork": {
                                "id": "[reference(variables('deploymentVNET')).outputs.vNetResourceId.value]"
                            },
                            "ipAddress": "172.22.232.5"
                        }
                    },
                    {
                        "name": "iacs-sh-main-pd-01-euw-rg-network_awefwa01p-ha-nic-int-01ipconfig-internal",
                        "properties": {
                            "virtualNetwork": {
                                "id": "[reference(variables('deploymentVNET')).outputs.vNetResourceId.value]"
                            },
                            "ipAddress": "172.22.232.6"
                        }
                    }
                ]
            }
        }
    ]
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
backendAddressPools: [
    {
        name: 'p_hub-bfw-server-bepool'
        properties: {
            loadBalancerBackendAddresses: [
                {
                    name: 'iacs-sh-main-pd-01-euw-rg-network_awefwa01p-nic-int-01ipconfig-internal'
                    properties: {
                        virtualNetwork: {
                            id: '[reference(variables('deploymentVNET')).outputs.vNetResourceId.value]'
                        }
                        ipAddress: '172.22.232.5'
                    }
                }
                {
                    name: 'iacs-sh-main-pd-01-euw-rg-network_awefwa01p-ha-nic-int-01ipconfig-internal'
                    properties: {
                        virtualNetwork: {
                            id: '[reference(variables('deploymentVNET')).outputs.vNetResourceId.value]'
                        }
                        ipAddress: '172.22.232.6'
                    }
                }
            ]
        }
    }
]
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
