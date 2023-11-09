# Load Balancers `[Microsoft.Network/loadBalancers]`

This module deploys a Load Balancer.

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
| `Microsoft.Network/loadBalancers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/loadBalancers) |
| `Microsoft.Network/loadBalancers/backendAddressPools` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/loadBalancers/backendAddressPools) |
| `Microsoft.Network/loadBalancers/inboundNatRules` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/loadBalancers/inboundNatRules) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm-res-network-loadbalancer:1.0.0`.

- [Defaults](#example-1-defaults)
- [Internal](#example-2-internal)
- [Max](#example-3-max)
- [Waf-Aligned](#example-4-waf-aligned)

### Example 1: _Defaults_

<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm-res-network-loadbalancer:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nlbdef'
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressId: '<publicIPAddressId>'
      }
    ]
    name: 'nlbdef001'
    // Non-required parameters
    diagnosticSettings: []
    location: '<location>'
    lock: {}
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
      "value": "nlbdef001"
    },
    // Non-required parameters
    "diagnosticSettings": {
      "value": []
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {}
    }
  }
}
```

</details>
<p>

### Example 2: _Internal_

<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm-res-network-loadbalancer:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nlbint'
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
        roleDefinitionIdOrName: 'Reader'
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
          "roleDefinitionIdOrName": "Reader"
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

### Example 3: _Max_

<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm-res-network-loadbalancer:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nlbmax'
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
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
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
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
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

### Example 4: _Waf-Aligned_

<details>

<summary>via Bicep module</summary>

```bicep
module loadBalancer 'br/public:avm-res-network-loadbalancer:1.0.0' = {
  name: '${uniqueString(deployment().name, location)}-test-nlbwaf'
  params: {
    // Required parameters
    frontendIPConfigurations: [
      {
        name: 'publicIPConfig1'
        publicIPAddressId: '<publicIPAddressId>'
      }
    ]
    name: 'nlbwaf001'
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
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
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
      "value": "nlbwaf001"
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
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
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
| [`frontendIPConfigurations`](#parameter-frontendipconfigurations) | array | Array of objects containing all frontend IP configurations. |
| [`name`](#parameter-name) | string | The Proximity Placement Groups Name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backendAddressPools`](#parameter-backendaddresspools) | array | Collection of backend address pools used by a load balancer. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |
| [`inboundNatRules`](#parameter-inboundnatrules) | array | Collection of inbound NAT Rules used by a load balancer. Defining inbound NAT rules on your load balancer is mutually exclusive with defining an inbound NAT pool. Inbound NAT pools are referenced from virtual machine scale sets. NICs that are associated with individual virtual machines cannot reference an Inbound NAT pool. They have to reference individual inbound NAT rules. |
| [`loadBalancingRules`](#parameter-loadbalancingrules) | array | Array of objects containing all load balancing rules. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`outboundRules`](#parameter-outboundrules) | array | The outbound rules. |
| [`probes`](#parameter-probes) | array | Array of objects containing all probes, these are references in the load balancing rules. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`skuName`](#parameter-skuname) | string | Name of a load balancer SKU. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `backendAddressPools`

Collection of backend address pools used by a load balancer.
- Required: No
- Type: array

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | No | string | Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | No | string | Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | No | string | Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | No | string | Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | No | array | Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection. |
| [`name`](#parameter-diagnosticsettingsname) | No | string | Optional. The name of diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | No | string | Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | No | string | Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.

- Required: No
- Type: string
- Allowed: `[AzureDiagnostics, Dedicated]`

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to '' to disable log collection.

- Required: No
- Type: array

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | Yes | string | Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to 'AllMetrics' to collect all metrics. |

### Parameter: `diagnosticSettings.metricCategories.category`

Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to 'AllMetrics' to collect all metrics.

- Required: Yes
- Type: string


### Parameter: `diagnosticSettings.name`

Optional. The name of diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).
- Required: No
- Type: bool
- Default: `True`

### Parameter: `frontendIPConfigurations`

Array of objects containing all frontend IP configurations.
- Required: Yes
- Type: array

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


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`kind`](#parameter-lockkind) | No | string | Optional. Specify the type of lock. |
| [`name`](#parameter-lockname) | No | string | Optional. Specify the name of lock. |

### Parameter: `lock.kind`

Optional. Specify the type of lock.

- Required: No
- Type: string
- Allowed: `[CanNotDelete, None, ReadOnly]`

### Parameter: `lock.name`

Optional. Specify the name of lock.

- Required: No
- Type: string

### Parameter: `name`

The Proximity Placement Groups Name.
- Required: Yes
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

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

### Parameter: `skuName`

Name of a load balancer SKU.
- Required: No
- Type: string
- Default: `'Standard'`
- Allowed: `[Basic, Standard]`

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
