# Policy Assignments (All scopes) `[Authorization/PolicyAssignment]`

This module deploys a Policy Assignment at a Management Group, Subscription or Resource Group scope.

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
| `Microsoft.Authorization/policyAssignments` | [2022-06-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-06-01/policyAssignments) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/authorization/policy-assignment:<version>`.

- [Policy Assignments (Management Group scope)](#example-1-policy-assignments-management-group-scope)
- [Policy Assignments (Management Group scope)](#example-2-policy-assignments-management-group-scope)
- [Policy Assignments (Resource Group)](#example-3-policy-assignments-resource-group)
- [Policy Assignments (Resource Group)](#example-4-policy-assignments-resource-group)
- [Policy Assignments (Subscription)](#example-5-policy-assignments-subscription)
- [Policy Assignments (Subscription)](#example-6-policy-assignments-subscription)

### Example 1: _Policy Assignments (Management Group scope)_

This module deploys a Policy Assignment at a Management Group scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment 'br/public:avm/ptn/authorization/policy-assignment:<version>' = {
  name: 'policyAssignmentDeployment'
  params: {
    // Required parameters
    name: 'apamgmin001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    // Non-required parameters
    location: '<location>'
    metadata: {
      assignedBy: 'Bicep'
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
      "value": "apamgmin001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep"
      }
    }
  }
}
```

</details>
<p>

### Example 2: _Policy Assignments (Management Group scope)_

This module deploys a Policy Assignment at a Management Group scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment 'br/public:avm/ptn/authorization/policy-assignment:<version>' = {
  name: 'policyAssignmentDeployment'
  params: {
    // Required parameters
    name: 'apamgmax001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
    // Non-required parameters
    description: '[Description] Policy Assignment at the management group scope'
    displayName: '[Display Name] Policy Assignment at the management group scope'
    enforcementMode: 'DoNotEnforce'
    identity: 'SystemAssigned'
    location: '<location>'
    managementGroupId: '<managementGroupId>'
    metadata: {
      assignedBy: 'Bicep'
      category: 'Security'
      version: '1.0'
    }
    nonComplianceMessages: [
      {
        message: 'Violated Policy Assignment - This is a Non Compliance Message'
      }
    ]
    notScopes: [
      '/subscriptions/${subscriptionId}/resourceGroups/validation-rg'
    ]
    overrides: [
      {
        kind: 'policyEffect'
        selectors: [
          {
            in: [
              'ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent'
              'ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent'
            ]
            kind: 'policyDefinitionReferenceId'
          }
        ]
        value: 'Disabled'
      }
    ]
    parameters: {
      effect: {
        value: 'Disabled'
      }
      enableCollectionOfSqlQueriesForSecurityResearch: {
        value: false
      }
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
    roleDefinitionIds: [
      '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
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
      "value": "apamgmax001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611"
    },
    // Non-required parameters
    "description": {
      "value": "[Description] Policy Assignment at the management group scope"
    },
    "displayName": {
      "value": "[Display Name] Policy Assignment at the management group scope"
    },
    "enforcementMode": {
      "value": "DoNotEnforce"
    },
    "identity": {
      "value": "SystemAssigned"
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
        "category": "Security",
        "version": "1.0"
      }
    },
    "nonComplianceMessages": {
      "value": [
        {
          "message": "Violated Policy Assignment - This is a Non Compliance Message"
        }
      ]
    },
    "notScopes": {
      "value": [
        "/subscriptions/${subscriptionId}/resourceGroups/validation-rg"
      ]
    },
    "overrides": {
      "value": [
        {
          "kind": "policyEffect",
          "selectors": [
            {
              "in": [
                "ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent",
                "ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent"
              ],
              "kind": "policyDefinitionReferenceId"
            }
          ],
          "value": "Disabled"
        }
      ]
    },
    "parameters": {
      "value": {
        "effect": {
          "value": "Disabled"
        },
        "enableCollectionOfSqlQueriesForSecurityResearch": {
          "value": false
        }
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
    "roleDefinitionIds": {
      "value": [
        "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
      ]
    }
  }
}
```

</details>
<p>

### Example 3: _Policy Assignments (Resource Group)_

This module deploys a Policy Assignment at a Resource Group scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment 'br/public:avm/ptn/authorization/policy-assignment:<version>' = {
  name: 'policyAssignmentDeployment'
  params: {
    // Required parameters
    name: 'apargmin001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    // Non-required parameters
    location: '<location>'
    metadata: {
      assignedBy: 'Bicep'
    }
    resourceGroupName: '<resourceGroupName>'
    subscriptionId: '<subscriptionId>'
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
      "value": "apargmin001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep"
      }
    },
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

### Example 4: _Policy Assignments (Resource Group)_

This module deploys a Policy Assignment at a Resource Group scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment 'br/public:avm/ptn/authorization/policy-assignment:<version>' = {
  name: 'policyAssignmentDeployment'
  params: {
    // Required parameters
    name: 'apargmax001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
    // Non-required parameters
    description: '[Description] Policy Assignment at the resource group scope'
    displayName: '[Display Name] Policy Assignment at the resource group scope'
    enforcementMode: 'DoNotEnforce'
    identity: 'UserAssigned'
    location: '<location>'
    metadata: {
      assignedBy: 'Bicep'
      category: 'Security'
      version: '1.0'
    }
    nonComplianceMessages: [
      {
        message: 'Violated Policy Assignment - This is a Non Compliance Message'
      }
    ]
    notScopes: [
      '<keyVaultResourceId>'
    ]
    overrides: [
      {
        kind: 'policyEffect'
        selectors: [
          {
            in: [
              'ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent'
              'ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent'
            ]
            kind: 'policyDefinitionReferenceId'
          }
        ]
        value: 'Disabled'
      }
    ]
    parameters: {
      effect: {
        value: 'Disabled'
      }
      enableCollectionOfSqlQueriesForSecurityResearch: {
        value: false
      }
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
    roleDefinitionIds: [
      '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    ]
    subscriptionId: '<subscriptionId>'
    userAssignedIdentityId: '<userAssignedIdentityId>'
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
      "value": "apargmax001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611"
    },
    // Non-required parameters
    "description": {
      "value": "[Description] Policy Assignment at the resource group scope"
    },
    "displayName": {
      "value": "[Display Name] Policy Assignment at the resource group scope"
    },
    "enforcementMode": {
      "value": "DoNotEnforce"
    },
    "identity": {
      "value": "UserAssigned"
    },
    "location": {
      "value": "<location>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep",
        "category": "Security",
        "version": "1.0"
      }
    },
    "nonComplianceMessages": {
      "value": [
        {
          "message": "Violated Policy Assignment - This is a Non Compliance Message"
        }
      ]
    },
    "notScopes": {
      "value": [
        "<keyVaultResourceId>"
      ]
    },
    "overrides": {
      "value": [
        {
          "kind": "policyEffect",
          "selectors": [
            {
              "in": [
                "ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent",
                "ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent"
              ],
              "kind": "policyDefinitionReferenceId"
            }
          ],
          "value": "Disabled"
        }
      ]
    },
    "parameters": {
      "value": {
        "effect": {
          "value": "Disabled"
        },
        "enableCollectionOfSqlQueriesForSecurityResearch": {
          "value": false
        }
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
    "roleDefinitionIds": {
      "value": [
        "/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
      ]
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    },
    "userAssignedIdentityId": {
      "value": "<userAssignedIdentityId>"
    }
  }
}
```

</details>
<p>

### Example 5: _Policy Assignments (Subscription)_

This module deploys a Policy Assignment at a Subscription scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment 'br/public:avm/ptn/authorization/policy-assignment:<version>' = {
  name: 'policyAssignmentDeployment'
  params: {
    // Required parameters
    name: 'apasubmin001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    // Non-required parameters
    location: '<location>'
    metadata: {
      assignedBy: 'Bicep'
      category: 'Security'
      version: '1.0'
    }
    subscriptionId: '<subscriptionId>'
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
      "value": "apasubmin001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep",
        "category": "Security",
        "version": "1.0"
      }
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

### Example 6: _Policy Assignments (Subscription)_

This module deploys a Policy Assignment at a Subscription scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment 'br/public:avm/ptn/authorization/policy-assignment:<version>' = {
  name: 'policyAssignmentDeployment'
  params: {
    // Required parameters
    name: 'apasubmax001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
    // Non-required parameters
    description: '[Description] Policy Assignment at the subscription scope'
    displayName: '[Display Name] Policy Assignment at the subscription scope'
    enforcementMode: 'DoNotEnforce'
    identity: 'UserAssigned'
    location: '<location>'
    metadata: {
      assignedBy: 'Bicep'
      category: 'Security'
      version: '1.0'
    }
    nonComplianceMessages: [
      {
        message: 'Violated Policy Assignment - This is a Non Compliance Message'
      }
    ]
    notScopes: [
      '/subscriptions/${subscriptionId}/resourceGroups/validation-rg'
    ]
    overrides: [
      {
        kind: 'policyEffect'
        selectors: [
          {
            in: [
              'ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent'
              'ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent'
            ]
            kind: 'policyDefinitionReferenceId'
          }
        ]
        value: 'Disabled'
      }
    ]
    parameters: {
      effect: {
        value: 'Disabled'
      }
      enableCollectionOfSqlQueriesForSecurityResearch: {
        value: false
      }
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
    roleDefinitionIds: [
      '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
    ]
    subscriptionId: '<subscriptionId>'
    userAssignedIdentityId: '<userAssignedIdentityId>'
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
      "value": "apasubmax001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611"
    },
    // Non-required parameters
    "description": {
      "value": "[Description] Policy Assignment at the subscription scope"
    },
    "displayName": {
      "value": "[Display Name] Policy Assignment at the subscription scope"
    },
    "enforcementMode": {
      "value": "DoNotEnforce"
    },
    "identity": {
      "value": "UserAssigned"
    },
    "location": {
      "value": "<location>"
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep",
        "category": "Security",
        "version": "1.0"
      }
    },
    "nonComplianceMessages": {
      "value": [
        {
          "message": "Violated Policy Assignment - This is a Non Compliance Message"
        }
      ]
    },
    "notScopes": {
      "value": [
        "/subscriptions/${subscriptionId}/resourceGroups/validation-rg"
      ]
    },
    "overrides": {
      "value": [
        {
          "kind": "policyEffect",
          "selectors": [
            {
              "in": [
                "ASC_DeployAzureDefenderForSqlAdvancedThreatProtectionWindowsAgent",
                "ASC_DeployAzureDefenderForSqlVulnerabilityAssessmentWindowsAgent"
              ],
              "kind": "policyDefinitionReferenceId"
            }
          ],
          "value": "Disabled"
        }
      ]
    },
    "parameters": {
      "value": {
        "effect": {
          "value": "Disabled"
        },
        "enableCollectionOfSqlQueriesForSecurityResearch": {
          "value": false
        }
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
    "roleDefinitionIds": {
      "value": [
        "/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
      ]
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    },
    "userAssignedIdentityId": {
      "value": "<userAssignedIdentityId>"
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
| [`name`](#parameter-name) | string | Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope, 64 characters for subscription and resource group scopes. |
| [`policyDefinitionId`](#parameter-policydefinitionid) | string | Specifies the ID of the policy definition or policy set definition being assigned. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | This message will be part of response in case of policy violation. |
| [`displayName`](#parameter-displayname) | string | The display name of the policy assignment. Maximum length is 128 characters. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`enforcementMode`](#parameter-enforcementmode) | string | The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce. |
| [`identity`](#parameter-identity) | string | The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning 'Modify' policy definitions. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`managementGroupId`](#parameter-managementgroupid) | string | The Target Scope for the Policy. The name of the management group for the policy assignment. If not provided, will use the current scope for deployment. |
| [`metadata`](#parameter-metadata) | object | The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| [`nonComplianceMessages`](#parameter-noncompliancemessages) | array | The messages that describe why a resource is non-compliant with the policy. |
| [`notScopes`](#parameter-notscopes) | array | The policy excluded scopes. |
| [`overrides`](#parameter-overrides) | array | The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition. |
| [`parameters`](#parameter-parameters) | object | Parameters for the policy assignment if needed. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | The Target Scope for the Policy. The name of the resource group for the policy assignment. |
| [`resourceSelectors`](#parameter-resourceselectors) | array | The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location. |
| [`roleDefinitionIds`](#parameter-roledefinitionids) | array | The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition. |
| [`subscriptionId`](#parameter-subscriptionid) | string | The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment. |
| [`userAssignedIdentityId`](#parameter-userassignedidentityid) | string | The Resource ID for the user assigned identity to assign to the policy assignment. |

### Parameter: `name`

Specifies the name of the policy assignment. Maximum length is 24 characters for management group scope, 64 characters for subscription and resource group scopes.

- Required: Yes
- Type: string

### Parameter: `policyDefinitionId`

Specifies the ID of the policy definition or policy set definition being assigned.

- Required: Yes
- Type: string

### Parameter: `description`

This message will be part of response in case of policy violation.

- Required: No
- Type: string
- Default: `''`

### Parameter: `displayName`

The display name of the policy assignment. Maximum length is 128 characters.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enforcementMode`

The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce.

- Required: No
- Type: string
- Default: `'Default'`
- Allowed:
  ```Bicep
  [
    'Default'
    'DoNotEnforce'
  ]
  ```

### Parameter: `identity`

The managed identity associated with the policy assignment. Policy assignments must include a resource identity when assigning 'Modify' policy definitions.

- Required: No
- Type: string
- Default: `'SystemAssigned'`
- Allowed:
  ```Bicep
  [
    'None'
    'SystemAssigned'
    'UserAssigned'
  ]
  ```

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `managementGroupId`

The Target Scope for the Policy. The name of the management group for the policy assignment. If not provided, will use the current scope for deployment.

- Required: No
- Type: string
- Default: `[managementGroup().name]`

### Parameter: `metadata`

The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `nonComplianceMessages`

The messages that describe why a resource is non-compliant with the policy.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `notScopes`

The policy excluded scopes.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `overrides`

The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `parameters`

Parameters for the policy assignment if needed.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `resourceGroupName`

The Target Scope for the Policy. The name of the resource group for the policy assignment.

- Required: No
- Type: string
- Default: `''`

### Parameter: `resourceSelectors`

The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `roleDefinitionIds`

The IDs Of the Azure Role Definition list that is used to assign permissions to the identity. You need to provide either the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `subscriptionId`

The Target Scope for the Policy. The subscription ID of the subscription for the policy assignment.

- Required: No
- Type: string
- Default: `''`

### Parameter: `userAssignedIdentityId`

The Resource ID for the user assigned identity to assign to the policy assignment.

- Required: No
- Type: string
- Default: `''`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | Policy Assignment Name. |
| `principalId` | string | Policy Assignment principal ID. |
| `resourceId` | string | Policy Assignment resource ID. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
