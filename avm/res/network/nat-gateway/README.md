# NAT Gateways `[Microsoft.Network/natGateways]`

This module deploys a NAT Gateway.

You can reference the module as follows:
```bicep
module natGateway 'br/public:avm/res/network/nat-gateway:<version>' = {
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
| `Microsoft.Network/natGateways` | 2025-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_natgateways.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-05-01/natGateways)</li></ul> |
| `Microsoft.Network/publicIPAddresses` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipaddresses.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/publicIPAddresses)</li></ul> |
| `Microsoft.Network/publicIPPrefixes` | 2025-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_publicipprefixes.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2025-01-01/publicIPPrefixes)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/network/nat-gateway:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using an existing Public IP](#example-2-using-an-existing-public-ip)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [Combine a generated and provided Public IP Prefix](#example-4-combine-a-generated-and-provided-public-ip-prefix)
- [WAF-aligned](#example-5-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module natGateway 'br/public:avm/res/network/nat-gateway:<version>' = {
  params: {
    // Required parameters
    availabilityZone: 1
    name: 'nngmin001'
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
    "availabilityZone": {
      "value": 1
    },
    "name": {
      "value": "nngmin001"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/nat-gateway:<version>'

// Required parameters
param availabilityZone = 1
param name = 'nngmin001'
```

</details>
<p>

### Example 2: _Using an existing Public IP_

This instance deploys the module using an existing Public IP address.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/existingPip]


<details>

<summary>via Bicep module</summary>

```bicep
module natGateway 'br/public:avm/res/network/nat-gateway:<version>' = {
  params: {
    // Required parameters
    availabilityZone: -1
    name: 'nngepip001'
    // Non-required parameters
    publicIpResourceIds: '<publicIpResourceIds>'
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
    "availabilityZone": {
      "value": -1
    },
    "name": {
      "value": "nngepip001"
    },
    // Non-required parameters
    "publicIpResourceIds": {
      "value": "<publicIpResourceIds>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/nat-gateway:<version>'

// Required parameters
param availabilityZone = -1
param name = 'nngepip001'
// Non-required parameters
param publicIpResourceIds = '<publicIpResourceIds>'
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module natGateway 'br/public:avm/res/network/nat-gateway:<version>' = {
  params: {
    // Required parameters
    availabilityZone: 1
    name: 'nngmax001'
    // Non-required parameters
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    publicIPAddresses: [
      {
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
        name: 'nngmax001-pip'
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
        skuTier: 'Regional'
      }
    ]
    roleAssignments: [
      {
        name: '69d7ed51-8af4-4eed-bcea-bdadcccb1200'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "availabilityZone": {
      "value": 1
    },
    "name": {
      "value": "nngmax001"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "myCustomLockName"
      }
    },
    "publicIPAddresses": {
      "value": [
        {
          "availabilityZones": [
            1,
            2,
            3
          ],
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
          "name": "nngmax001-pip",
          "roleAssignments": [
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
          ],
          "skuTier": "Regional"
        }
      ]
    },
    "roleAssignments": {
      "value": [
        {
          "name": "69d7ed51-8af4-4eed-bcea-bdadcccb1200",
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/nat-gateway:<version>'

// Required parameters
param availabilityZone = 1
param name = 'nngmax001'
// Non-required parameters
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param publicIPAddresses = [
  {
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
    name: 'nngmax001-pip'
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
    skuTier: 'Regional'
  }
]
param roleAssignments = [
  {
    name: '69d7ed51-8af4-4eed-bcea-bdadcccb1200'
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
```

</details>
<p>

### Example 4: _Combine a generated and provided Public IP Prefix_

This example shows how you can provide a Public IP Prefix to the module, while also generating one in the module.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/prefixCombined]


<details>

<summary>via Bicep module</summary>

```bicep
module natGateway 'br/public:avm/res/network/nat-gateway:<version>' = {
  params: {
    // Required parameters
    availabilityZone: -1
    name: 'nngcprx001'
    // Non-required parameters
    publicIPPrefixes: [
      {
        name: 'nngcprx001-pippre'
        prefixLength: 30
        tags: {
          'hidden-title': 'CustomTag'
        }
      }
    ]
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
    "availabilityZone": {
      "value": -1
    },
    "name": {
      "value": "nngcprx001"
    },
    // Non-required parameters
    "publicIPPrefixes": {
      "value": [
        {
          "name": "nngcprx001-pippre",
          "prefixLength": 30,
          "tags": {
            "hidden-title": "CustomTag"
          }
        }
      ]
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/network/nat-gateway:<version>'

// Required parameters
param availabilityZone = -1
param name = 'nngcprx001'
// Non-required parameters
param publicIPPrefixes = [
  {
    name: 'nngcprx001-pippre'
    prefixLength: 30
    tags: {
      'hidden-title': 'CustomTag'
    }
  }
]
```

</details>
<p>

### Example 5: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module natGateway 'br/public:avm/res/network/nat-gateway:<version>' = {
  params: {
    // Required parameters
    availabilityZone: 1
    name: 'nngwaf001'
    // Non-required parameters
    publicIPAddresses: [
      {
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
        name: 'nngwaf001-pip'
        skuTier: 'Regional'
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
    "availabilityZone": {
      "value": 1
    },
    "name": {
      "value": "nngwaf001"
    },
    // Non-required parameters
    "publicIPAddresses": {
      "value": [
        {
          "availabilityZones": [
            1,
            2,
            3
          ],
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
          "name": "nngwaf001-pip",
          "skuTier": "Regional"
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
using 'br/public:avm/res/network/nat-gateway:<version>'

// Required parameters
param availabilityZone = 1
param name = 'nngwaf001'
// Non-required parameters
param publicIPAddresses = [
  {
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
    name: 'nngwaf001-pip'
    skuTier: 'Regional'
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

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZone`](#parameter-availabilityzone) | int | If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone number here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones). |
| [`name`](#parameter-name) | string | Name of the Azure Bastion resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`idleTimeoutInMinutes`](#parameter-idletimeoutinminutes) | int | The idle timeout of the NAT gateway. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`natGatewaySku`](#parameter-natgatewaysku) | string | The SKU of the NAT Gateway. |
| [`publicIPAddresses`](#parameter-publicipaddresses) | array | Specifies the properties of the Public IPs to create and be used by the NAT Gateway. |
| [`publicIPPrefixes`](#parameter-publicipprefixes) | array | Specifies the properties of the Public IP Prefixes to create and be used by the NAT Gateway. |
| [`publicIPPrefixResourceIds`](#parameter-publicipprefixresourceids) | array | Existing Public IP Prefixes resource IDs to use for the NAT Gateway. |
| [`publicIpResourceIds`](#parameter-publicipresourceids) | array | Existing Public IP Address resource IDs to use for the NAT Gateway. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags for the resource. |

### Parameter: `availabilityZone`

If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone number here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).

- Required: Yes
- Type: int
- Allowed:
  ```Bicep
  [
    -1
    1
    2
    3
  ]
  ```

### Parameter: `name`

Name of the Azure Bastion resource.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `idleTimeoutInMinutes`

The idle timeout of the NAT gateway.

- Required: No
- Type: int
- Default: `5`

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

### Parameter: `natGatewaySku`

The SKU of the NAT Gateway.

- Required: No
- Type: string
- Default: `'Standard'`
- Allowed:
  ```Bicep
  [
    'Standard'
    'StandardV2'
  ]
  ```

### Parameter: `publicIPAddresses`

Specifies the properties of the Public IPs to create and be used by the NAT Gateway.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-publicipaddressesname) | string | The name of the Public IP Address. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-publicipaddressesavailabilityzones) | array | A list of availability zones denoting the IP allocated for the resource needs to come from. |
| [`ddosSettings`](#parameter-publicipaddressesddossettings) | object | The DDoS protection plan configuration associated with the public IP address. |
| [`diagnosticSettings`](#parameter-publicipaddressesdiagnosticsettings) | array | The diagnostic settings of the service. |
| [`dnsSettings`](#parameter-publicipaddressesdnssettings) | object | The DNS settings of the public IP address. |
| [`idleTimeoutInMinutes`](#parameter-publicipaddressesidletimeoutinminutes) | int | The idle timeout of the public IP address. |
| [`ipTags`](#parameter-publicipaddressesiptags) | array | The list of tags associated with the public IP address. |
| [`location`](#parameter-publicipaddresseslocation) | string | Location for all resources. |
| [`lock`](#parameter-publicipaddresseslock) | object | The lock settings of the service. |
| [`publicIPAddressVersion`](#parameter-publicipaddressespublicipaddressversion) | string | IP address version. |
| [`publicIPAllocationMethod`](#parameter-publicipaddressespublicipallocationmethod) | string | The public IP address allocation method. |
| [`publicIpPrefixResourceId`](#parameter-publicipaddressespublicipprefixresourceid) | string | Resource ID of the Public IP Prefix. This is only needed if you want your Public IPs created in a PIP Prefix. |
| [`roleAssignments`](#parameter-publicipaddressesroleassignments) | array | Array of role assignments to create. |
| [`skuName`](#parameter-publicipaddressesskuname) | string | Name of a public IP address SKU. |
| [`skuTier`](#parameter-publicipaddressesskutier) | string | Tier of a public IP address SKU. |
| [`tags`](#parameter-publicipaddressestags) | object | Tags of the resource. |

### Parameter: `publicIPAddresses.name`

The name of the Public IP Address.

- Required: Yes
- Type: string

### Parameter: `publicIPAddresses.availabilityZones`

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

### Parameter: `publicIPAddresses.ddosSettings`

The DDoS protection plan configuration associated with the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`protectionMode`](#parameter-publicipaddressesddossettingsprotectionmode) | string | The DDoS protection policy customizations. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ddosProtectionPlan`](#parameter-publicipaddressesddossettingsddosprotectionplan) | object | The DDoS protection plan associated with the public IP address. |

### Parameter: `publicIPAddresses.ddosSettings.protectionMode`

The DDoS protection policy customizations.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Enabled'
  ]
  ```

### Parameter: `publicIPAddresses.ddosSettings.ddosProtectionPlan`

The DDoS protection plan associated with the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-publicipaddressesddossettingsddosprotectionplanid) | string | The resource ID of the DDOS protection plan associated with the public IP address. |

### Parameter: `publicIPAddresses.ddosSettings.ddosProtectionPlan.id`

The resource ID of the DDOS protection plan associated with the public IP address.

- Required: Yes
- Type: string

### Parameter: `publicIPAddresses.diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-publicipaddressesdiagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-publicipaddressesdiagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-publicipaddressesdiagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-publicipaddressesdiagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-publicipaddressesdiagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-publicipaddressesdiagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-publicipaddressesdiagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-publicipaddressesdiagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-publicipaddressesdiagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `publicIPAddresses.diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `publicIPAddresses.diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-publicipaddressesdiagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-publicipaddressesdiagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-publicipaddressesdiagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `publicIPAddresses.diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `publicIPAddresses.diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-publicipaddressesdiagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-publicipaddressesdiagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `publicIPAddresses.diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `publicIPAddresses.diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `publicIPAddresses.diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.dnsSettings`

The DNS settings of the public IP address.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainNameLabel`](#parameter-publicipaddressesdnssettingsdomainnamelabel) | string | The domain name label. The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainNameLabelScope`](#parameter-publicipaddressesdnssettingsdomainnamelabelscope) | string | The domain name label scope. If a domain name label and a domain name label scope are specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system with a hashed value includes in FQDN. |
| [`fqdn`](#parameter-publicipaddressesdnssettingsfqdn) | string | The Fully Qualified Domain Name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone. |
| [`reverseFqdn`](#parameter-publicipaddressesdnssettingsreversefqdn) | string | The reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN. |

### Parameter: `publicIPAddresses.dnsSettings.domainNameLabel`

The domain name label. The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system.

- Required: Yes
- Type: string

### Parameter: `publicIPAddresses.dnsSettings.domainNameLabelScope`

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

### Parameter: `publicIPAddresses.dnsSettings.fqdn`

The Fully Qualified Domain Name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.dnsSettings.reverseFqdn`

The reverse FQDN. A user-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in-addr.arpa domain to the reverse FQDN.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.idleTimeoutInMinutes`

The idle timeout of the public IP address.

- Required: No
- Type: int

### Parameter: `publicIPAddresses.ipTags`

The list of tags associated with the public IP address.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipTagType`](#parameter-publicipaddressesiptagsiptagtype) | string | The IP tag type. |
| [`tag`](#parameter-publicipaddressesiptagstag) | string | The IP tag. |

### Parameter: `publicIPAddresses.ipTags.ipTagType`

The IP tag type.

- Required: Yes
- Type: string

### Parameter: `publicIPAddresses.ipTags.tag`

The IP tag.

- Required: Yes
- Type: string

### Parameter: `publicIPAddresses.location`

Location for all resources.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-publicipaddresseslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-publicipaddresseslockname) | string | Specify the name of lock. |
| [`notes`](#parameter-publicipaddresseslocknotes) | string | Specify the notes of the lock. |

### Parameter: `publicIPAddresses.lock.kind`

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

### Parameter: `publicIPAddresses.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.publicIPAddressVersion`

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

### Parameter: `publicIPAddresses.publicIPAllocationMethod`

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

### Parameter: `publicIPAddresses.publicIpPrefixResourceId`

Resource ID of the Public IP Prefix. This is only needed if you want your Public IPs created in a PIP Prefix.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'DNS Resolver Contributor'`
  - `'DNS Zone Contributor'`
  - `'Domain Services Contributor'`
  - `'Domain Services Reader'`
  - `'Network Contributor'`
  - `'Owner'`
  - `'Private DNS Zone Contributor'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-publicipaddressesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-publicipaddressesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-publicipaddressesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-publicipaddressesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-publicipaddressesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-publicipaddressesroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-publicipaddressesroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-publicipaddressesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `publicIPAddresses.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `publicIPAddresses.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `publicIPAddresses.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `publicIPAddresses.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `publicIPAddresses.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `publicIPAddresses.roleAssignments.principalType`

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

### Parameter: `publicIPAddresses.skuName`

Name of a public IP address SKU.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Basic'
    'Standard'
    'StandardV2'
  ]
  ```

### Parameter: `publicIPAddresses.skuTier`

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

### Parameter: `publicIPAddresses.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `publicIPPrefixes`

Specifies the properties of the Public IP Prefixes to create and be used by the NAT Gateway.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-publicipprefixesname) | string | The name of the Public IP Prefix. |
| [`prefixLength`](#parameter-publicipprefixesprefixlength) | int | Length of the Public IP Prefix. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`availabilityZones`](#parameter-publicipprefixesavailabilityzones) | array | A list of availability zones denoting the IP allocated for the resource needs to come from. This is only applicable for regional public IP prefixes and must be empty for global public IP prefixes. |
| [`customIPPrefix`](#parameter-publicipprefixescustomipprefix) | object | The custom IP address prefix that this prefix is associated with. A custom IP address prefix is a contiguous range of IP addresses owned by an external customer and provisioned into a subscription. When a custom IP prefix is in Provisioned, Commissioning, or Commissioned state, a linked public IP prefix can be created. Either as a subset of the custom IP prefix range or the entire range. |
| [`ipTags`](#parameter-publicipprefixesiptags) | array | The list of tags associated with the public IP prefix. |
| [`location`](#parameter-publicipprefixeslocation) | string | Location for all resources. |
| [`lock`](#parameter-publicipprefixeslock) | object | The lock settings of the service. |
| [`publicIPAddressVersion`](#parameter-publicipprefixespublicipaddressversion) | string | The public IP address version. |
| [`roleAssignments`](#parameter-publicipprefixesroleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-publicipprefixestags) | object | Tags of the resource. |
| [`tier`](#parameter-publicipprefixestier) | string | Tier of a public IP prefix SKU. If set to `Global`, the `zones` property must be empty. |

### Parameter: `publicIPPrefixes.name`

The name of the Public IP Prefix.

- Required: Yes
- Type: string

### Parameter: `publicIPPrefixes.prefixLength`

Length of the Public IP Prefix.

- Required: Yes
- Type: int
- MinValue: 21
- MaxValue: 127

### Parameter: `publicIPPrefixes.availabilityZones`

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

### Parameter: `publicIPPrefixes.customIPPrefix`

The custom IP address prefix that this prefix is associated with. A custom IP address prefix is a contiguous range of IP addresses owned by an external customer and provisioned into a subscription. When a custom IP prefix is in Provisioned, Commissioning, or Commissioned state, a linked public IP prefix can be created. Either as a subset of the custom IP prefix range or the entire range.

- Required: No
- Type: object

### Parameter: `publicIPPrefixes.ipTags`

The list of tags associated with the public IP prefix.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ipTagType`](#parameter-publicipprefixesiptagsiptagtype) | string | The IP tag type. |
| [`tag`](#parameter-publicipprefixesiptagstag) | string | The IP tag. |

### Parameter: `publicIPPrefixes.ipTags.ipTagType`

The IP tag type.

- Required: Yes
- Type: string

### Parameter: `publicIPPrefixes.ipTags.tag`

The IP tag.

- Required: Yes
- Type: string

### Parameter: `publicIPPrefixes.location`

Location for all resources.

- Required: No
- Type: string

### Parameter: `publicIPPrefixes.lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-publicipprefixeslockkind) | string | Specify the type of lock. |
| [`name`](#parameter-publicipprefixeslockname) | string | Specify the name of lock. |
| [`notes`](#parameter-publicipprefixeslocknotes) | string | Specify the notes of the lock. |

### Parameter: `publicIPPrefixes.lock.kind`

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

### Parameter: `publicIPPrefixes.lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `publicIPPrefixes.lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `publicIPPrefixes.publicIPAddressVersion`

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

### Parameter: `publicIPPrefixes.roleAssignments`

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
| [`principalId`](#parameter-publicipprefixesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-publicipprefixesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-publicipprefixesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-publicipprefixesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-publicipprefixesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-publicipprefixesroleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-publicipprefixesroleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-publicipprefixesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `publicIPPrefixes.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `publicIPPrefixes.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `publicIPPrefixes.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `publicIPPrefixes.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `publicIPPrefixes.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `publicIPPrefixes.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `publicIPPrefixes.roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `publicIPPrefixes.roleAssignments.principalType`

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

### Parameter: `publicIPPrefixes.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `publicIPPrefixes.tier`

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

### Parameter: `publicIPPrefixResourceIds`

Existing Public IP Prefixes resource IDs to use for the NAT Gateway.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `publicIpResourceIds`

Existing Public IP Address resource IDs to use for the NAT Gateway.

- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `tags`

Tags for the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the NAT Gateway. |
| `resourceGroupName` | string | The resource group the NAT Gateway was deployed into. |
| `resourceId` | string | The resource ID of the NAT Gateway. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/res/network/public-ip-address:0.12.0` | Remote reference |
| `br/public:avm/res/network/public-ip-address:0.9.0` | Remote reference |
| `br/public:avm/res/network/public-ip-prefix:0.7.0` | Remote reference |
| `br/public:avm/res/network/public-ip-prefix:0.8.0` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
