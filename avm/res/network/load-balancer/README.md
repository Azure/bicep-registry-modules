# Load Balancers `[Microsoft.Network/loadBalancers]`

This module deploys a Load Balancer.

You can reference the module as follows:
```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
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
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |
| `Microsoft.Network/loadBalancers` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_loadbalancers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/loadBalancers)</li></ul> |
| `Microsoft.Network/loadBalancers/backendAddressPools` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_loadbalancers_backendaddresspools.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/loadBalancers/backendAddressPools)</li></ul> |
| `Microsoft.Network/loadBalancers/inboundNatRules` | 2024-10-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_loadbalancers_inboundnatrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-10-01/loadBalancers/inboundNatRules)</li></ul> |
| `Microsoft.Network/publicIPAddresses` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/publicIPAddresses)</li></ul> |
| `Microsoft.Network/publicIPPrefixes` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipprefixes.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/publicIPPrefixes)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/load-balancer:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using public IP load balancer parameter - public IP addresses](#example-2-using-public-ip-load-balancer-parameter---public-ip-addresses)
- [Using public IP load balancer parameter - public IP address prefixes](#example-3-using-public-ip-load-balancer-parameter---public-ip-address-prefixes)
- [Using external load balancer parameter - VNet backend addresses](#example-4-using-external-load-balancer-parameter---vnet-backend-addresses)
- [Using external load balancer parameter - NIC backend addresses](#example-5-using-external-load-balancer-parameter---nic-backend-addresses)
- [Using internal load balancer parameter](#example-6-using-internal-load-balancer-parameter)
- [Using large parameter set](#example-7-using-large-parameter-set)
- [WAF-aligned](#example-8-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressResourceId: '<publicIPAddressResourceId>'
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

<summary>via JSON parameters file</summary>

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
          "publicIPAddressResourceId": "<publicIPAddressResourceId>"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/load-balancer:<version>'

// Required parameters
param frontendIPConfigurations = [
  {
    name: 'publicIPConfig1'
    publicIPAddressResourceId: '<publicIPAddressResourceId>'
  }
]
param name = 'nlbmin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using public IP load balancer parameter - public IP addresses_

This instance deploys the module with the minimum set of required parameters and creates an external public IP for the frontend.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/external-pip-creation]


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressConfiguration: {
          name: 'nlbpip-pip-001'
          publicIPAllocationMethod: 'Static'
          skuName: 'Standard'
          skuTier: 'Regional'
        }
      }
      {
        name: 'publicIPConfig2'
        publicIPAddressConfiguration: {
          name: 'nlbpip-pip-002'
          publicIPAllocationMethod: 'Static'
          skuName: 'Standard'
          skuTier: 'Regional'
        }
      }
    ]
    name: 'nlbpip001'
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
    "frontendIPConfigurations": {
      "value": [
        {
          "name": "publicIPConfig1",
          "publicIPAddressConfiguration": {
            "name": "nlbpip-pip-001",
            "publicIPAllocationMethod": "Static",
            "skuName": "Standard",
            "skuTier": "Regional"
          }
        },
        {
          "name": "publicIPConfig2",
          "publicIPAddressConfiguration": {
            "name": "nlbpip-pip-002",
            "publicIPAllocationMethod": "Static",
            "skuName": "Standard",
            "skuTier": "Regional"
          }
        }
      ]
    },
    "name": {
      "value": "nlbpip001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/load-balancer:<version>'

// Required parameters
param frontendIPConfigurations = [
  {
    name: 'publicIPConfig1'
    publicIPAddressConfiguration: {
      name: 'nlbpip-pip-001'
      publicIPAllocationMethod: 'Static'
      skuName: 'Standard'
      skuTier: 'Regional'
    }
  }
  {
    name: 'publicIPConfig2'
    publicIPAddressConfiguration: {
      name: 'nlbpip-pip-002'
      publicIPAllocationMethod: 'Static'
      skuName: 'Standard'
      skuTier: 'Regional'
    }
  }
]
param name = 'nlbpip001'
```

</details>
<p>

### Example 3: _Using public IP load balancer parameter - public IP address prefixes_

This instance deploys the module with the minimum set of required parameters and creates an external public IP prefix for the frontend.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/external-pipprefix-creation]


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'publicIPprefix1'
        publicIPPrefixConfiguration: {
          name: 'nlbpipfix-pipfix-001'
          prefixLength: 28
          publicIPAddressVersion: 'IPv4'
          tier: 'Regional'
        }
      }
    ]
    name: 'nlbpipfix001'
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
    "frontendIPConfigurations": {
      "value": [
        {
          "name": "publicIPprefix1",
          "publicIPPrefixConfiguration": {
            "name": "nlbpipfix-pipfix-001",
            "prefixLength": 28,
            "publicIPAddressVersion": "IPv4",
            "tier": "Regional"
          }
        }
      ]
    },
    "name": {
      "value": "nlbpipfix001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/load-balancer:<version>'

// Required parameters
param frontendIPConfigurations = [
  {
    name: 'publicIPprefix1'
    publicIPPrefixConfiguration: {
      name: 'nlbpipfix-pipfix-001'
      prefixLength: 28
      publicIPAddressVersion: 'IPv4'
      tier: 'Regional'
    }
  }
]
param name = 'nlbpipfix001'
```

</details>
<p>

### Example 4: _Using external load balancer parameter - VNet backend addresses_

This instance deploys the module with an externally facing load balancer with a public IP address and VNet backend address pool.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/external-vnet]


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressResourceId: '<publicIPAddressResourceId>'
      }
    ]
    name: 'nlbnet001'
    // Non-required parameters
    backendAddressPools: [
      {
        backendMembershipMode: 'BackendAddress'
        loadBalancerBackendAddresses: [
          {
            name: 'beAddress1'
            properties: {
              ipAddress: '10.0.0.15'
            }
          }
          {
            name: 'beAddress2'
            properties: {
              ipAddress: '10.0.0.16'
            }
          }
        ]
        name: 'backendAddressPool1'
        virtualNetworkResourceId: '<virtualNetworkResourceId>'
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

<summary>via JSON parameters file</summary>

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
          "publicIPAddressResourceId": "<publicIPAddressResourceId>"
        }
      ]
    },
    "name": {
      "value": "nlbnet001"
    },
    // Non-required parameters
    "backendAddressPools": {
      "value": [
        {
          "backendMembershipMode": "BackendAddress",
          "loadBalancerBackendAddresses": [
            {
              "name": "beAddress1",
              "properties": {
                "ipAddress": "10.0.0.15"
              }
            },
            {
              "name": "beAddress2",
              "properties": {
                "ipAddress": "10.0.0.16"
              }
            }
          ],
          "name": "backendAddressPool1",
          "virtualNetworkResourceId": "<virtualNetworkResourceId>"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/load-balancer:<version>'

// Required parameters
param frontendIPConfigurations = [
  {
    name: 'publicIPConfig1'
    publicIPAddressResourceId: '<publicIPAddressResourceId>'
  }
]
param name = 'nlbnet001'
// Non-required parameters
param backendAddressPools = [
  {
    backendMembershipMode: 'BackendAddress'
    loadBalancerBackendAddresses: [
      {
        name: 'beAddress1'
        properties: {
          ipAddress: '10.0.0.15'
        }
      }
      {
        name: 'beAddress2'
        properties: {
          ipAddress: '10.0.0.16'
        }
      }
    ]
    name: 'backendAddressPool1'
    virtualNetworkResourceId: '<virtualNetworkResourceId>'
  }
  {
    name: 'backendAddressPool2'
  }
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
param inboundNatRules = [
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
param loadBalancingRules = [
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
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param outboundRules = [
  {
    allocatedOutboundPorts: 63984
    backendAddressPoolName: 'backendAddressPool1'
    frontendIPConfigurationName: 'publicIPConfig1'
    name: 'outboundRule1'
  }
]
param probes = [
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
param roleAssignments = [
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
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 5: _Using external load balancer parameter - NIC backend addresses_

This instance deploys the module with an externally facing load balancer with a public IP address and NIC backend address pool.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/external]


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressResourceId: '<publicIPAddressResourceId>'
      }
    ]
    name: 'nlbext001'
    // Non-required parameters
    backendAddressPools: [
      {
        backendMembershipMode: 'NIC'
        name: 'backendAddressPool1'
      }
      {
        backendMembershipMode: 'None'
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

<summary>via JSON parameters file</summary>

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
          "publicIPAddressResourceId": "<publicIPAddressResourceId>"
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
          "backendMembershipMode": "NIC",
          "name": "backendAddressPool1"
        },
        {
          "backendMembershipMode": "None",
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/load-balancer:<version>'

// Required parameters
param frontendIPConfigurations = [
  {
    name: 'publicIPConfig1'
    publicIPAddressResourceId: '<publicIPAddressResourceId>'
  }
]
param name = 'nlbext001'
// Non-required parameters
param backendAddressPools = [
  {
    backendMembershipMode: 'NIC'
    name: 'backendAddressPool1'
  }
  {
    backendMembershipMode: 'None'
    name: 'backendAddressPool2'
  }
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
param inboundNatRules = [
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
param loadBalancingRules = [
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
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param outboundRules = [
  {
    allocatedOutboundPorts: 63984
    backendAddressPoolName: 'backendAddressPool1'
    frontendIPConfigurationName: 'publicIPConfig1'
    name: 'outboundRule1'
  }
]
param probes = [
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
param roleAssignments = [
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
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 6: _Using internal load balancer parameter_

This instance deploys the module with the minimum set of required parameters to deploy an internal load balancer with a private IP address and empty backend address pool.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/internal]


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'privateIPConfig1'
        subnetResourceId: '<subnetResourceId>'
      }
    ]
    name: 'nlbint001'
    // Non-required parameters
    backendAddressPools: [
      {
        backendMembershipMode: 'NIC'
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

<summary>via JSON parameters file</summary>

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
          "subnetResourceId": "<subnetResourceId>"
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
          "backendMembershipMode": "NIC",
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/load-balancer:<version>'

// Required parameters
param frontendIPConfigurations = [
  {
    name: 'privateIPConfig1'
    subnetResourceId: '<subnetResourceId>'
  }
]
param name = 'nlbint001'
// Non-required parameters
param backendAddressPools = [
  {
    backendMembershipMode: 'NIC'
    name: 'servers'
  }
]
param inboundNatRules = [
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
param loadBalancingRules = [
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
param location = '<location>'
param probes = [
  {
    intervalInSeconds: 5
    name: 'probe1'
    numberOfProbes: 2
    port: '62000'
    protocol: 'Tcp'
  }
]
param roleAssignments = [
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
param skuName = 'Standard'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 7: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressResourceId: '<publicIPAddressResourceId>'
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
    skuTier: 'Regional'
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

<summary>via JSON parameters file</summary>

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
          "publicIPAddressResourceId": "<publicIPAddressResourceId>"
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
    "skuTier": {
      "value": "Regional"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/load-balancer:<version>'

// Required parameters
param frontendIPConfigurations = [
  {
    name: 'publicIPConfig1'
    publicIPAddressResourceId: '<publicIPAddressResourceId>'
  }
]
param name = 'nlbmax001'
// Non-required parameters
param backendAddressPools = [
  {
    name: 'backendAddressPool1'
  }
  {
    name: 'backendAddressPool2'
  }
]
param diagnosticSettings = [
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
param inboundNatRules = [
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
param loadBalancingRules = [
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
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param outboundRules = [
  {
    allocatedOutboundPorts: 63984
    backendAddressPoolName: 'backendAddressPool1'
    frontendIPConfigurationName: 'publicIPConfig1'
    name: 'outboundRule1'
  }
]
param probes = [
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
param roleAssignments = [
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
param skuTier = 'Regional'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
```

</details>
<p>

### Example 8: _WAF-aligned_

This instance deploys the module with the minimum set of required parameters to deploy a WAF-aligned internal load balancer.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm/res/network/load-balancer:<version>' = {
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        availabilityZones: [
          1
          2
          3
        ]
        name: 'privateIPConfig1'
        subnetResourceId: '<subnetResourceId>'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "frontendIPConfigurations": {
      "value": [
        {
          "availabilityZones": [
            1,
            2,
            3
          ],
          "name": "privateIPConfig1",
          "subnetResourceId": "<subnetResourceId>"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/load-balancer:<version>'

// Required parameters
param frontendIPConfigurations = [
  {
    availabilityZones: [
      1
      2
      3
    ]
    name: 'privateIPConfig1'
    subnetResourceId: '<subnetResourceId>'
  }
]
param name = 'nlbwaf001'
// Non-required parameters
param backendAddressPools = [
  {
    name: 'servers'
  }
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
param inboundNatRules = [
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
param loadBalancingRules = [
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
param location = '<location>'
param probes = [
  {
    intervalInSeconds: 5
    name: 'probe1'
    numberOfProbes: 2
    port: '62000'
    protocol: 'Tcp'
  }
]
param skuName = 'Standard'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
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
| [`skuTier`](#parameter-skutier) | string | Tier of a load balancer SKU. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `frontendIPConfigurations`

Array of objects containing all frontend IP configurations.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-frontendipconfigurationsname) | string | The name of the frontend IP configuration. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-frontendipconfigurationsavailabilityzones) | array | A list of availability zones denoting the IP allocated for the resource needs to come from. |
| [`gatewayLoadBalancerResourceId`](#parameter-frontendipconfigurationsgatewayloadbalancerresourceid) | string | The resource ID of the gateway load balancer. |
| [`privateIPAddress`](#parameter-frontendipconfigurationsprivateipaddress) | string | The private IP address to use for a private frontend IP configuration. Requires subnetResourceId. |
| [`privateIPAddressVersion`](#parameter-frontendipconfigurationsprivateipaddressversion) | string | The private IP address version. Only applicable for private frontend IP configurations. |
| [`publicIPAddressConfiguration`](#parameter-frontendipconfigurationspublicipaddressconfiguration) | object | The configuration to create a new public IP address. Cannot be used together with publicIPAddressResourceId. |
| [`publicIPAddressResourceId`](#parameter-frontendipconfigurationspublicipaddressresourceid) | string | The resource ID of an existing public IP address to use. Cannot be used together with publicIPAddressConfiguration. |
| [`publicIPPrefixConfiguration`](#parameter-frontendipconfigurationspublicipprefixconfiguration) | object | The configuration to create a new public IP prefix. Cannot be used together with publicIPPrefixResourceId. |
| [`publicIPPrefixResourceId`](#parameter-frontendipconfigurationspublicipprefixresourceid) | string | The resource ID of an existing public IP prefix to use. Cannot be used together with publicIPPrefixConfiguration. |
| [`subnetResourceId`](#parameter-frontendipconfigurationssubnetresourceid) | string | The resource ID of the subnet to use for a private frontend IP configuration. |
| [`tags`](#parameter-frontendipconfigurationstags) | object | Tags of the frontend IP configuration. |

### Parameter: `frontendIPConfigurations.name`

The name of the frontend IP configuration.

- Required: Yes
- Type: string

### Parameter: `frontendIPConfigurations.availabilityZones`

A list of availability zones denoting the IP allocated for the resource needs to come from.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `frontendIPConfigurations.gatewayLoadBalancerResourceId`

The resource ID of the gateway load balancer.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.privateIPAddress`

The private IP address to use for a private frontend IP configuration. Requires subnetResourceId.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.privateIPAddressVersion`

The private IP address version. Only applicable for private frontend IP configurations.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IPv4'
    'IPv6'
  ]
  ```

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration`

The configuration to create a new public IP address. Cannot be used together with publicIPAddressResourceId.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-frontendipconfigurationspublicipaddressconfigurationavailabilityzones) | array | A list of availability zones denoting the IP allocated for the resource needs to come from. |
| [`ddosSettings`](#parameter-frontendipconfigurationspublicipaddressconfigurationddossettings) | object | The DDoS protection plan configuration associated with the public IP address. |
| [`diagnosticSettings`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettings) | array | The diagnostic settings of the public IP address. |
| [`dnsSettings`](#parameter-frontendipconfigurationspublicipaddressconfigurationdnssettings) | object | The DNS settings of the public IP address. |
| [`enableTelemetry`](#parameter-frontendipconfigurationspublicipaddressconfigurationenabletelemetry) | bool | Enable/Disable usage telemetry for the public IP address module. |
| [`idleTimeoutInMinutes`](#parameter-frontendipconfigurationspublicipaddressconfigurationidletimeoutinminutes) | int | The idle timeout of the public IP address. |
| [`ipTags`](#parameter-frontendipconfigurationspublicipaddressconfigurationiptags) | array | The list of tags associated with the public IP address. |
| [`name`](#parameter-frontendipconfigurationspublicipaddressconfigurationname) | string | The name of the Public IP Address. If not provided, a default name will be generated. |
| [`publicIPAddressVersion`](#parameter-frontendipconfigurationspublicipaddressconfigurationpublicipaddressversion) | string | IP address version. |
| [`publicIPAllocationMethod`](#parameter-frontendipconfigurationspublicipaddressconfigurationpublicipallocationmethod) | string | The public IP address allocation method. |
| [`publicIpPrefixResourceId`](#parameter-frontendipconfigurationspublicipaddressconfigurationpublicipprefixresourceid) | string | Resource ID of the Public IP Prefix. This is only needed if you want your Public IPs created in a PIP Prefix. |
| [`roleAssignments`](#parameter-frontendipconfigurationspublicipaddressconfigurationroleassignments) | array | Array of role assignments to create for the public IP address. |
| [`skuName`](#parameter-frontendipconfigurationspublicipaddressconfigurationskuname) | string | Name of a public IP address SKU. |
| [`skuTier`](#parameter-frontendipconfigurationspublicipaddressconfigurationskutier) | string | Tier of a public IP address SKU. |
| [`tags`](#parameter-frontendipconfigurationspublicipaddressconfigurationtags) | object | Tags of the public IP address resource. |

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.availabilityZones`

A list of availability zones denoting the IP allocated for the resource needs to come from.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.ddosSettings`

The DDoS protection plan configuration associated with the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`protectionMode`](#parameter-frontendipconfigurationspublicipaddressconfigurationddossettingsprotectionmode) | string | The DDoS protection policy customizations. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ddosProtectionPlan`](#parameter-frontendipconfigurationspublicipaddressconfigurationddossettingsddosprotectionplan) | object | The DDoS protection plan associated with the public IP address. |

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.ddosSettings.protectionMode`

The DDoS protection policy customizations.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Enabled'
  ]
  ```

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.ddosSettings.ddosProtectionPlan`

The DDoS protection plan associated with the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-frontendipconfigurationspublicipaddressconfigurationddossettingsddosprotectionplanid) | string | The resource ID of the DDOS protection plan associated with the public IP address. |

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.ddosSettings.ddosProtectionPlan.id`

The resource ID of the DDOS protection plan associated with the public IP address.

- Required: Yes
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings`

The diagnostic settings of the public IP address.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-frontendipconfigurationspublicipaddressconfigurationdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.dnsSettings`

The DNS settings of the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainNameLabel`](#parameter-frontendipconfigurationspublicipaddressconfigurationdnssettingsdomainnamelabel) | string | The domain name label. The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainNameLabelScope`](#parameter-frontendipconfigurationspublicipaddressconfigurationdnssettingsdomainnamelabelscope) | string | The domain name label scope. If a domain name label and a domain name label scope are specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system with a hashed value includes in FQDN. |
| [`fqdn`](#parameter-frontendipconfigurationspublicipaddressconfigurationdnssettingsfqdn) | string | The Fully Qualified Domain Name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone. |
| [`reverseFqdn`](#parameter-frontendipconfigurationspublicipaddressconfigurationdnssettingsreversefqdn) | string | The reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN. |

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.dnsSettings.domainNameLabel`

The domain name label. The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.

- Required: Yes
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.dnsSettings.domainNameLabelScope`

The domain name label scope. If a domain name label and a domain name label scope are specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system with a hashed value includes in FQDN.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'NoReuse'
    'ResourceGroupReuse'
    'SubscriptionReuse'
    'TenantReuse'
  ]
  ```

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.dnsSettings.fqdn`

The Fully Qualified Domain Name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.dnsSettings.reverseFqdn`

The reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.enableTelemetry`

Enable/Disable usage telemetry for the public IP address module.

- Required: No
- Type: bool

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.idleTimeoutInMinutes`

The idle timeout of the public IP address.

- Required: No
- Type: int

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.ipTags`

The list of tags associated with the public IP address.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipTagType`](#parameter-frontendipconfigurationspublicipaddressconfigurationiptagsiptagtype) | string | The IP tag type. |
| [`tag`](#parameter-frontendipconfigurationspublicipaddressconfigurationiptagstag) | string | The IP tag. |

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.ipTags.ipTagType`

The IP tag type.

- Required: Yes
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.ipTags.tag`

The IP tag.

- Required: Yes
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.name`

The name of the Public IP Address. If not provided, a default name will be generated.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.publicIPAddressVersion`

IP address version.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IPv4'
    'IPv6'
  ]
  ```

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.publicIPAllocationMethod`

The public IP address allocation method.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Dynamic'
    'Static'
  ]
  ```

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.publicIpPrefixResourceId`

Resource ID of the Public IP Prefix. This is only needed if you want your Public IPs created in a PIP Prefix.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.roleAssignments`

Array of role assignments to create for the public IP address.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-frontendipconfigurationspublicipaddressconfigurationroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-frontendipconfigurationspublicipaddressconfigurationroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-frontendipconfigurationspublicipaddressconfigurationroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-frontendipconfigurationspublicipaddressconfigurationroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-frontendipconfigurationspublicipaddressconfigurationroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-frontendipconfigurationspublicipaddressconfigurationroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-frontendipconfigurationspublicipaddressconfigurationroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-frontendipconfigurationspublicipaddressconfigurationroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.roleAssignments.principalType`

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

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.skuName`

Name of a public IP address SKU.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Standard'
  ]
  ```

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.skuTier`

Tier of a public IP address SKU.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Global'
    'Regional'
  ]
  ```

### Parameter: `frontendIPConfigurations.publicIPAddressConfiguration.tags`

Tags of the public IP address resource.

- Required: No
- Type: object

### Parameter: `frontendIPConfigurations.publicIPAddressResourceId`

The resource ID of an existing public IP address to use. Cannot be used together with publicIPAddressConfiguration.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration`

The configuration to create a new public IP prefix. Cannot be used together with publicIPPrefixResourceId.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-frontendipconfigurationspublicipprefixconfigurationavailabilityzones) | array | A list of availability zones denoting the IP allocated for the resource needs to come from. This is only applicable for regional public IP prefixes and must be empty for global public IP prefixes. |
| [`customIPPrefix`](#parameter-frontendipconfigurationspublicipprefixconfigurationcustomipprefix) | object | The custom IP address prefix that this prefix is associated with. A custom IP address prefix is a contiguous range of IP addresses owned by an external customer and provisioned into a subscription. When a custom IP prefix is in Provisioned, Commissioning, or Commissioned state, a linked public IP prefix can be created. Either as a subset of the custom IP prefix range or the entire range. |
| [`enableTelemetry`](#parameter-frontendipconfigurationspublicipprefixconfigurationenabletelemetry) | bool | Enable/Disable usage telemetry for the public IP prefix module. |
| [`ipTags`](#parameter-frontendipconfigurationspublicipprefixconfigurationiptags) | array | The list of tags associated with the public IP prefix. |
| [`lock`](#parameter-frontendipconfigurationspublicipprefixconfigurationlock) | object | The lock settings of the public IP prefix. |
| [`name`](#parameter-frontendipconfigurationspublicipprefixconfigurationname) | string | The name of the Public IP Prefix. If not provided, a default name will be generated. |
| [`prefixLength`](#parameter-frontendipconfigurationspublicipprefixconfigurationprefixlength) | int | Length of the Public IP Prefix. |
| [`publicIPAddressVersion`](#parameter-frontendipconfigurationspublicipprefixconfigurationpublicipaddressversion) | string | The public IP address version. |
| [`roleAssignments`](#parameter-frontendipconfigurationspublicipprefixconfigurationroleassignments) | array | Array of role assignments to create for the public IP prefix. |
| [`tags`](#parameter-frontendipconfigurationspublicipprefixconfigurationtags) | object | Tags of the public IP prefix resource. |
| [`tier`](#parameter-frontendipconfigurationspublicipprefixconfigurationtier) | string | Tier of a public IP prefix SKU. If set to `Global`, the `zones` property must be empty. |

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.availabilityZones`

A list of availability zones denoting the IP allocated for the resource needs to come from. This is only applicable for regional public IP prefixes and must be empty for global public IP prefixes.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    1
    2
    3
  ]
  ```

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.customIPPrefix`

The custom IP address prefix that this prefix is associated with. A custom IP address prefix is a contiguous range of IP addresses owned by an external customer and provisioned into a subscription. When a custom IP prefix is in Provisioned, Commissioning, or Commissioned state, a linked public IP prefix can be created. Either as a subset of the custom IP prefix range or the entire range.

- Required: No
- Type: object

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.enableTelemetry`

Enable/Disable usage telemetry for the public IP prefix module.

- Required: No
- Type: bool

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.ipTags`

The list of tags associated with the public IP prefix.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipTagType`](#parameter-frontendipconfigurationspublicipprefixconfigurationiptagsiptagtype) | string | The IP tag type. |
| [`tag`](#parameter-frontendipconfigurationspublicipprefixconfigurationiptagstag) | string | The IP tag. |

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.ipTags.ipTagType`

The IP tag type.

- Required: Yes
- Type: string

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.ipTags.tag`

The IP tag.

- Required: Yes
- Type: string

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.lock`

The lock settings of the public IP prefix.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-frontendipconfigurationspublicipprefixconfigurationlockkind) | string | Specify the type of lock. |
| [`name`](#parameter-frontendipconfigurationspublicipprefixconfigurationlockname) | string | Specify the name of lock. |
| [`notes`](#parameter-frontendipconfigurationspublicipprefixconfigurationlocknotes) | string | Specify the notes of the lock. |

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.lock.kind`

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

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.name`

The name of the Public IP Prefix. If not provided, a default name will be generated.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.prefixLength`

Length of the Public IP Prefix.

- Required: No
- Type: int
- MinValue: 28
- MaxValue: 127

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.publicIPAddressVersion`

The public IP address version.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'IPv4'
    'IPv6'
  ]
  ```

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.roleAssignments`

Array of role assignments to create for the public IP prefix.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-frontendipconfigurationspublicipprefixconfigurationroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-frontendipconfigurationspublicipprefixconfigurationroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-frontendipconfigurationspublicipprefixconfigurationroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-frontendipconfigurationspublicipprefixconfigurationroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-frontendipconfigurationspublicipprefixconfigurationroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-frontendipconfigurationspublicipprefixconfigurationroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-frontendipconfigurationspublicipprefixconfigurationroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-frontendipconfigurationspublicipprefixconfigurationroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.roleAssignments.principalType`

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

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.tags`

Tags of the public IP prefix resource.

- Required: No
- Type: object

### Parameter: `frontendIPConfigurations.publicIPPrefixConfiguration.tier`

Tier of a public IP prefix SKU. If set to `Global`, the `zones` property must be empty.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Global'
    'Regional'
  ]
  ```

### Parameter: `frontendIPConfigurations.publicIPPrefixResourceId`

The resource ID of an existing public IP prefix to use. Cannot be used together with publicIPPrefixConfiguration.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.subnetResourceId`

The resource ID of the subnet to use for a private frontend IP configuration.

- Required: No
- Type: string

### Parameter: `frontendIPConfigurations.tags`

Tags of the frontend IP configuration.

- Required: No
- Type: object

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
- Roles configurable by name:
  - `'Contributor'`
  - `'Network Contributor'`
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

### Parameter: `skuTier`

Tier of a load balancer SKU.

- Required: No
- Type: string
- Default: `'Regional'`
- Allowed:
  ```Bicep
  [
    'Global'
    'Regional'
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

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/public-ip-address:0.10.0` | Remote reference |
| `br/public:avm/res/network/public-ip-address:0.9.1` | Remote reference |
| `br/public:avm/res/network/public-ip-prefix:0.7.1` | Remote reference |
| `br/public:avm/res/network/public-ip-prefix:0.7.2` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.0` | Remote reference |

## Notes

### Parameter Usage: `backendAddressPools`

The following example represents three different configurations for backendAddressPools:

- `BackendNICPool` - Network Interface deployments.
- `BackendIPPool` - Represents the assignment of IP addresses to a backend address pool.
- `BackendUnassociatedPool` - Represents a backend address pool that doesn't currently have any resources like a backend address or Network Interface assigned.

`NOTE` - Each of the backend address pools have a new parameter called `backendMembershipMode` which is used with the AVM module to assist in resolving idempotency issues.

<details>

<summary>Bicep format</summary>

```bicep
backendAddressPools: [
      {
        name: 'BackendNICPool'
        backendMembershipMode: 'NIC'
      }
      {
        name: 'BackendIPPool'
        backendMembershipMode: 'BackendAddress'
        loadBalancerBackendAddresses: [
          {
            name: 'addr1'
            properties: {
              virtualNetwork: {
                id: virtualNetwork.id
              }
              ipAddress: '10.0.2.52'
            }
          }
          {
            name: 'addr2'
            properties: {
              virtualNetwork: {
                id: virtualNetwork.id
              }
              ipAddress: '10.0.2.53'
            }
          }
        ]
      }
      {
        name: 'BackendUnassociatedPool'
        backendMembershipMode: 'None'
      }
    ]
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
