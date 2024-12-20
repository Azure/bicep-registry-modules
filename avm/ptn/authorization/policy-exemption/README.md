# Policy Exemptions (All scopes) `[Authorization/PolicyExemption]`

This module deploys a Policy Exemption at a Management Group, Subscription or Resource Group scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/policyExemptions` | [2022-07-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-07-01-preview/policyExemptions) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/authorization/policy-exemption:<version>`.

- [Policy Exemptions (Management Group scope)](#example-1-policy-exemptions-management-group-scope)
- [Policy Exemptions (Management Group scope)](#example-2-policy-exemptions-management-group-scope)
- [Policy Exemption (Resource Group)](#example-3-policy-exemption-resource-group)
- [Policy Exemption (Resource Group)](#example-4-policy-exemption-resource-group)
- [Policy Exemption (Subscription)](#example-5-policy-exemption-subscription)
- [Policy Exemption (Subscription)](#example-6-policy-exemption-subscription)

### Example 1: _Policy Exemptions (Management Group scope)_

This module deploys a Policy Exemption at a Management Group scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br/public:avm/ptn/authorization/policy-exemption:<version>' = {
  name: 'policyExemptionDeployment'
  params: {
    // Required parameters
    exemptionCategory: 'Mitigated'
    name: 'apemgmin001'
    policyAssignmentId: '<policyAssignmentId>'
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
    "exemptionCategory": {
      "value": "Mitigated"
    },
    "name": {
      "value": "apemgmin001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/authorization/policy-exemption:<version>'

// Required parameters
param exemptionCategory = 'Mitigated'
param name = 'apemgmin001'
param policyAssignmentId = '<policyAssignmentId>'
```

</details>
<p>

### Example 2: _Policy Exemptions (Management Group scope)_

This module deploys a Policy Exemption at a Management Group scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br/public:avm/ptn/authorization/policy-exemption:<version>' = {
  name: 'policyExemptionDeployment'
  params: {
    // Required parameters
    exemptionCategory: 'Mitigated'
    name: 'apemgmax001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    assignmentScopeValidation: 'Default'
    description: '[Description] Policy Exemption at the management group scope'
    displayName: '[DisplayName] Policy Exemption at the management group scope'
    enableTelemetry: true
    location: '<location>'
    managementGroupId: '<managementGroupId>'
    metadata: {
      assignedBy: 'Bicep'
      category: 'Security'
    }
    resourceSelectors: [
      {
        name: 'resourceSelector-test'
        selectors: [
          {
            in: [
              'Microsoft.Compute/virtualMachines'
            ]
            kind: 'resourceType'
          }
          {
            in: [
              'westeurope'
            ]
            kind: 'resourceLocation'
          }
        ]
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
    "exemptionCategory": {
      "value": "Mitigated"
    },
    "name": {
      "value": "apemgmax001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "assignmentScopeValidation": {
      "value": "Default"
    },
    "description": {
      "value": "[Description] Policy Exemption at the management group scope"
    },
    "displayName": {
      "value": "[DisplayName] Policy Exemption at the management group scope"
    },
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "managementGroupId": {
      "value": "<managementGroupId>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep",
        "category": "Security"
      }
    },
    "resourceSelectors": {
      "value": [
        {
          "name": "resourceSelector-test",
          "selectors": [
            {
              "in": [
                "Microsoft.Compute/virtualMachines"
              ],
              "kind": "resourceType"
            },
            {
              "in": [
                "westeurope"
              ],
              "kind": "resourceLocation"
            }
          ]
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
using 'br/public:avm/ptn/authorization/policy-exemption:<version>'

// Required parameters
param exemptionCategory = 'Mitigated'
param name = 'apemgmax001'
param policyAssignmentId = '<policyAssignmentId>'
// Non-required parameters
param assignmentScopeValidation = 'Default'
param description = '[Description] Policy Exemption at the management group scope'
param displayName = '[DisplayName] Policy Exemption at the management group scope'
param enableTelemetry = true
param location = '<location>'
param managementGroupId = '<managementGroupId>'
param metadata = {
  assignedBy: 'Bicep'
  category: 'Security'
}
param resourceSelectors = [
  {
    name: 'resourceSelector-test'
    selectors: [
      {
        in: [
          'Microsoft.Compute/virtualMachines'
        ]
        kind: 'resourceType'
      }
      {
        in: [
          'westeurope'
        ]
        kind: 'resourceLocation'
      }
    ]
  }
]
```

</details>
<p>

### Example 3: _Policy Exemption (Resource Group)_

This module deploys a Policy Exemption at a Resource Group scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br/public:avm/ptn/authorization/policy-exemption:<version>' = {
  name: 'policyExemptionDeployment'
  params: {
    // Required parameters
    exemptionCategory: 'Mitigated'
    name: 'apergmin001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    resourceGroupName: '<resourceGroupName>'
    subscriptionId: '<subscriptionId>'
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
    "exemptionCategory": {
      "value": "Mitigated"
    },
    "name": {
      "value": "apergmin001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/authorization/policy-exemption:<version>'

// Required parameters
param exemptionCategory = 'Mitigated'
param name = 'apergmin001'
param policyAssignmentId = '<policyAssignmentId>'
// Non-required parameters
param resourceGroupName = '<resourceGroupName>'
param subscriptionId = '<subscriptionId>'
```

</details>
<p>

### Example 4: _Policy Exemption (Resource Group)_

This module deploys a Policy Exemption at a Resource Group scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br/public:avm/ptn/authorization/policy-exemption:<version>' = {
  name: 'policyExemptionDeployment'
  params: {
    // Required parameters
    exemptionCategory: 'Mitigated'
    name: 'apergmax001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    assignmentScopeValidation: 'Default'
    description: '[Description] Policy Exemption at the management group scope'
    displayName: '[DisplayName] Policy Exemption at the management group scope'
    enableTelemetry: true
    location: '<location>'
    metadata: {
      assignedBy: 'Bicep'
      category: 'Security'
    }
    resourceGroupName: '<resourceGroupName>'
    resourceSelectors: [
      {
        name: 'resourceSelector-test'
        selectors: [
          {
            in: [
              'Microsoft.Compute/virtualMachines'
            ]
            kind: 'resourceType'
          }
          {
            in: [
              'westeurope'
            ]
            kind: 'resourceLocation'
          }
        ]
      }
    ]
    subscriptionId: '<subscriptionId>'
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
    "exemptionCategory": {
      "value": "Mitigated"
    },
    "name": {
      "value": "apergmax001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "assignmentScopeValidation": {
      "value": "Default"
    },
    "description": {
      "value": "[Description] Policy Exemption at the management group scope"
    },
    "displayName": {
      "value": "[DisplayName] Policy Exemption at the management group scope"
    },
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep",
        "category": "Security"
      }
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "resourceSelectors": {
      "value": [
        {
          "name": "resourceSelector-test",
          "selectors": [
            {
              "in": [
                "Microsoft.Compute/virtualMachines"
              ],
              "kind": "resourceType"
            },
            {
              "in": [
                "westeurope"
              ],
              "kind": "resourceLocation"
            }
          ]
        }
      ]
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/authorization/policy-exemption:<version>'

// Required parameters
param exemptionCategory = 'Mitigated'
param name = 'apergmax001'
param policyAssignmentId = '<policyAssignmentId>'
// Non-required parameters
param assignmentScopeValidation = 'Default'
param description = '[Description] Policy Exemption at the management group scope'
param displayName = '[DisplayName] Policy Exemption at the management group scope'
param enableTelemetry = true
param location = '<location>'
param metadata = {
  assignedBy: 'Bicep'
  category: 'Security'
}
param resourceGroupName = '<resourceGroupName>'
param resourceSelectors = [
  {
    name: 'resourceSelector-test'
    selectors: [
      {
        in: [
          'Microsoft.Compute/virtualMachines'
        ]
        kind: 'resourceType'
      }
      {
        in: [
          'westeurope'
        ]
        kind: 'resourceLocation'
      }
    ]
  }
]
param subscriptionId = '<subscriptionId>'
```

</details>
<p>

### Example 5: _Policy Exemption (Subscription)_

This module deploys a Policy Exemption at a Subscription scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br/public:avm/ptn/authorization/policy-exemption:<version>' = {
  name: 'policyExemptionDeployment'
  params: {
    // Required parameters
    exemptionCategory: 'Mitigated'
    name: 'apesubmin001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    subscriptionId: '<subscriptionId>'
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
    "exemptionCategory": {
      "value": "Mitigated"
    },
    "name": {
      "value": "apesubmin001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/authorization/policy-exemption:<version>'

// Required parameters
param exemptionCategory = 'Mitigated'
param name = 'apesubmin001'
param policyAssignmentId = '<policyAssignmentId>'
// Non-required parameters
param subscriptionId = '<subscriptionId>'
```

</details>
<p>

### Example 6: _Policy Exemption (Subscription)_

This module deploys a Policy Exemption at a Subscription scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br/public:avm/ptn/authorization/policy-exemption:<version>' = {
  name: 'policyExemptionDeployment'
  params: {
    // Required parameters
    exemptionCategory: 'Mitigated'
    name: 'apesubmax001'
    policyAssignmentId: '<policyAssignmentId>'
    // Non-required parameters
    assignmentScopeValidation: 'Default'
    description: '[Description] Policy Exemption at the management group scope'
    displayName: '[DisplayName] Policy Exemption at the management group scope'
    enableTelemetry: true
    location: '<location>'
    metadata: {
      assignedBy: 'Bicep'
      category: 'Security'
    }
    resourceSelectors: [
      {
        name: 'resourceSelector-test'
        selectors: [
          {
            in: [
              'Microsoft.Compute/virtualMachines'
            ]
            kind: 'resourceType'
          }
          {
            in: [
              'westeurope'
            ]
            kind: 'resourceLocation'
          }
        ]
      }
    ]
    subscriptionId: '<subscriptionId>'
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
    "exemptionCategory": {
      "value": "Mitigated"
    },
    "name": {
      "value": "apesubmax001"
    },
    "policyAssignmentId": {
      "value": "<policyAssignmentId>"
    },
    // Non-required parameters
    "assignmentScopeValidation": {
      "value": "Default"
    },
    "description": {
      "value": "[Description] Policy Exemption at the management group scope"
    },
    "displayName": {
      "value": "[DisplayName] Policy Exemption at the management group scope"
    },
    "enableTelemetry": {
      "value": true
    },
    "location": {
      "value": "<location>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep",
        "category": "Security"
      }
    },
    "resourceSelectors": {
      "value": [
        {
          "name": "resourceSelector-test",
          "selectors": [
            {
              "in": [
                "Microsoft.Compute/virtualMachines"
              ],
              "kind": "resourceType"
            },
            {
              "in": [
                "westeurope"
              ],
              "kind": "resourceLocation"
            }
          ]
        }
      ]
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/authorization/policy-exemption:<version>'

// Required parameters
param exemptionCategory = 'Mitigated'
param name = 'apesubmax001'
param policyAssignmentId = '<policyAssignmentId>'
// Non-required parameters
param assignmentScopeValidation = 'Default'
param description = '[Description] Policy Exemption at the management group scope'
param displayName = '[DisplayName] Policy Exemption at the management group scope'
param enableTelemetry = true
param location = '<location>'
param metadata = {
  assignedBy: 'Bicep'
  category: 'Security'
}
param resourceSelectors = [
  {
    name: 'resourceSelector-test'
    selectors: [
      {
        in: [
          'Microsoft.Compute/virtualMachines'
        ]
        kind: 'resourceType'
      }
      {
        in: [
          'westeurope'
        ]
        kind: 'resourceLocation'
      }
    ]
  }
]
param subscriptionId = '<subscriptionId>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`exemptionCategory`](#parameter-exemptioncategory) | string | The policy exemption category. |
| [`name`](#parameter-name) | string | Specifies the name of the policy exemption. Maximum length is 24 characters for management group scope. |
| [`policyAssignmentId`](#parameter-policyassignmentid) | string | Specifies the ID of the policy assignment that is being exempted. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`assignmentScopeValidation`](#parameter-assignmentscopevalidation) | string | The option to validate whether the exemption is at or under the assignment scope. |
| [`description`](#parameter-description) | string | This message will be part of response in case of policy violation. |
| [`displayName`](#parameter-displayname) | string | The display name of the policy exemption. Maximum length is 128 characters. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`expiresOn`](#parameter-expireson) | string | The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`managementGroupId`](#parameter-managementgroupid) | string | The Target Scope for the Policy. The name of the management group for the policy exemption. If not provided, will use the current scope for deployment. |
| [`metadata`](#parameter-metadata) | object | The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| [`policyDefinitionReferenceIds`](#parameter-policydefinitionreferenceids) | array | The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | The Target Scope for the Policy. The name of the resource group for the policy exemption. |
| [`resourceSelectors`](#parameter-resourceselectors) | array | The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out Policy exemptions based on factors like resource location, resource type, or whether a resource has a location. |
| [`subscriptionId`](#parameter-subscriptionid) | string | The Target Scope for the Policy. The subscription ID of the subscription for the policy exemption. |

### Parameter: `exemptionCategory`

The policy exemption category.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Mitigated'
    'Waiver'
  ]
  ```

### Parameter: `name`

Specifies the name of the policy exemption. Maximum length is 24 characters for management group scope.

- Required: Yes
- Type: string

### Parameter: `policyAssignmentId`

Specifies the ID of the policy assignment that is being exempted.

- Required: Yes
- Type: string

### Parameter: `assignmentScopeValidation`

The option to validate whether the exemption is at or under the assignment scope.

- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Default'
    'DoNotValidate'
  ]
  ```

### Parameter: `description`

This message will be part of response in case of policy violation.

- Required: No
- Type: string

### Parameter: `displayName`

The display name of the policy exemption. Maximum length is 128 characters.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `expiresOn`

The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption.

- Required: No
- Type: string

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `managementGroupId`

The Target Scope for the Policy. The name of the management group for the policy exemption. If not provided, will use the current scope for deployment.

- Required: No
- Type: string
- Default: `[managementGroup().name]`

### Parameter: `metadata`

The policy exemption metadata. Metadata is an open ended object and is typically a collection of key-value pairs.

- Required: No
- Type: object

### Parameter: `policyDefinitionReferenceIds`

The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.

- Required: No
- Type: array

### Parameter: `resourceGroupName`

The Target Scope for the Policy. The name of the resource group for the policy exemption.

- Required: No
- Type: string

### Parameter: `resourceSelectors`

The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out Policy exemptions based on factors like resource location, resource type, or whether a resource has a location.

- Required: No
- Type: array

### Parameter: `subscriptionId`

The Target Scope for the Policy. The subscription ID of the subscription for the policy exemption.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Exemption Name. |
| `resourceId` | string | Policy Exemption resource ID. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
