# Policy Assignments (Subscription scope) `[Microsoft.Authorization/policyAssignments]`

This module deploys a Policy Assignment at a Subscription scope. Optionally, it further assigns permissions to the policy's identity (if configured) to various scopes. Note, if you provide any role definition ids and or define additional scopes to assign permissions to, set permissions are deployled as a permutation of the provided parameters. In other words, each role would be provided to each scope for the assignment's identity.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/policyAssignments` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_policyassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2025-03-01/policyAssignments)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/authorization/policy-assignment/sub-scope:<version>`.

- [Using only defaults (Subscription scope)](#example-1-using-only-defaults-subscription-scope)
- [Using large parameter set (Subscription scope)](#example-2-using-large-parameter-set-subscription-scope)
- [Using only defaults (Subscription scope)](#example-3-using-only-defaults-subscription-scope)

### Example 1: _Using only defaults (Subscription scope)_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment 'br/public:avm/res/authorization/policy-assignment/sub-scope:<version>' = {
  name: 'policyAssignmentDeployment'
  params: {
    // Required parameters
    name: 'rapasubmin001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    // Non-required parameters
    metadata: {
      assignedBy: 'Bicep'
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
    "name": {
      "value": "rapasubmin001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
    },
    // Non-required parameters
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/authorization/policy-assignment/sub-scope:<version>'

// Required parameters
param name = 'rapasubmin001'
param policyDefinitionId = '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
// Non-required parameters
param metadata = {
  assignedBy: 'Bicep'
}
```

</details>
<p>

### Example 2: _Using large parameter set (Subscription scope)_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment 'br/public:avm/res/authorization/policy-assignment/sub-scope:<version>' = {
  name: 'policyAssignmentDeployment'
  params: {
    // Required parameters
    name: 'rapasubmax001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
    // Non-required parameters
    additionalResourceGroupResourceIDsToAssignRbacTo: [
      '<id>'
    ]
    additionalSubscriptionIDsToAssignRbacTo: [
      '<subscriptionId>'
    ]
    definitionVersion: '1.*.*-preview'
    description: '[Description] Policy Assignment at the subscription scope'
    displayName: '[Display Name] Policy Assignment at the subscription scope'
    enforcementMode: 'DoNotEnforce'
    location: '<location>'
    managedIdentities: {
      userAssignedResourceId: '<userAssignedResourceId>'
    }
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
      '<id>'
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
        value: 'DeployIfNotExists'
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
      "value": "rapasubmax001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611"
    },
    // Non-required parameters
    "additionalResourceGroupResourceIDsToAssignRbacTo": {
      "value": [
        "<id>"
      ]
    },
    "additionalSubscriptionIDsToAssignRbacTo": {
      "value": [
        "<subscriptionId>"
      ]
    },
    "definitionVersion": {
      "value": "1.*.*-preview"
    },
    "description": {
      "value": "[Description] Policy Assignment at the subscription scope"
    },
    "displayName": {
      "value": "[Display Name] Policy Assignment at the subscription scope"
    },
    "enforcementMode": {
      "value": "DoNotEnforce"
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceId": "<userAssignedResourceId>"
      }
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
        "<id>"
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
          "value": "DeployIfNotExists"
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
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/authorization/policy-assignment/sub-scope:<version>'

// Required parameters
param name = 'rapasubmax001'
param policyDefinitionId = '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
// Non-required parameters
param additionalResourceGroupResourceIDsToAssignRbacTo = [
  '<id>'
]
param additionalSubscriptionIDsToAssignRbacTo = [
  '<subscriptionId>'
]
param definitionVersion = '1.*.*-preview'
param description = '[Description] Policy Assignment at the subscription scope'
param displayName = '[Display Name] Policy Assignment at the subscription scope'
param enforcementMode = 'DoNotEnforce'
param location = '<location>'
param managedIdentities = {
  userAssignedResourceId: '<userAssignedResourceId>'
}
param metadata = {
  assignedBy: 'Bicep'
  category: 'Security'
  version: '1.0'
}
param nonComplianceMessages = [
  {
    message: 'Violated Policy Assignment - This is a Non Compliance Message'
  }
]
param notScopes = [
  '<id>'
]
param overrides = [
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
param parameters = {
  effect: {
    value: 'DeployIfNotExists'
  }
  enableCollectionOfSqlQueriesForSecurityResearch: {
    value: false
  }
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
param roleDefinitionIds = [
  '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
]
```

</details>
<p>

### Example 3: _Using only defaults (Subscription scope)_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module policyAssignment 'br/public:avm/res/authorization/policy-assignment/sub-scope:<version>' = {
  name: 'policyAssignmentDeployment'
  params: {
    // Required parameters
    name: 'rapasubwaf001'
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
    // Non-required parameters
    additionalSubscriptionIDsToAssignRbacTo: [
      '<subscriptionId>'
    ]
    metadata: {
      assignedBy: 'Bicep'
    }
    roleDefinitionIds: [
      '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
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
    "name": {
      "value": "rapasubwaf001"
    },
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
    },
    // Non-required parameters
    "additionalSubscriptionIDsToAssignRbacTo": {
      "value": [
        "<subscriptionId>"
      ]
    },
    "metadata": {
      "value": {
        "assignedBy": "Bicep"
      }
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/authorization/policy-assignment/sub-scope:<version>'

// Required parameters
param name = 'rapasubwaf001'
param policyDefinitionId = '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
// Non-required parameters
param additionalSubscriptionIDsToAssignRbacTo = [
  '<subscriptionId>'
]
param metadata = {
  assignedBy: 'Bicep'
}
param roleDefinitionIds = [
  '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
]
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Specifies the name of the policy assignment. Maximum length is 64 characters for subscription scope. |
| [`policyDefinitionId`](#parameter-policydefinitionid) | string | Specifies the ID of the policy definition or policy set definition being assigned. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`additionalResourceGroupResourceIDsToAssignRbacTo`](#parameter-additionalresourcegroupresourceidstoassignrbacto) | array | An array of additional Resource Group Resource IDs to assign RBAC to for the policy assignment if it has an identity. |
| [`additionalSubscriptionIDsToAssignRbacTo`](#parameter-additionalsubscriptionidstoassignrbacto) | array | An array of additional Subscription IDs to assign RBAC to for the policy assignment if it has an identity. |
| [`definitionVersion`](#parameter-definitionversion) | string | The policy definition version to use for the policy assignment. If not specified, the latest version of the policy definition will be used. For more information on policy assignment definition versions see https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#policy-definition-id-and-version-preview. |
| [`description`](#parameter-description) | string | This message will be part of response in case of policy violation. |
| [`displayName`](#parameter-displayname) | string | The display name of the policy assignment. Maximum length is 128 characters. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`enforcementMode`](#parameter-enforcementmode) | string | The policy assignment enforcement mode. Possible values are Default and DoNotEnforce. - Default or DoNotEnforce. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`metadata`](#parameter-metadata) | object | The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs. |
| [`nonComplianceMessages`](#parameter-noncompliancemessages) | array | The messages that describe why a resource is non-compliant with the policy. |
| [`notScopes`](#parameter-notscopes) | array | The policy excluded scopes. |
| [`overrides`](#parameter-overrides) | array | The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition. |
| [`parameters`](#parameter-parameters) | object | Parameters for the policy assignment if needed. |
| [`resourceSelectors`](#parameter-resourceselectors) | array | The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location. |
| [`roleDefinitionIds`](#parameter-roledefinitionids) | array | The IDs Of the Azure Role Definition that are used to assign permissions to the policy's identity. You need to provide the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition. |

### Parameter: `name`

Specifies the name of the policy assignment. Maximum length is 64 characters for subscription scope.

- Required: Yes
- Type: string

### Parameter: `policyDefinitionId`

Specifies the ID of the policy definition or policy set definition being assigned.

- Required: Yes
- Type: string

### Parameter: `additionalResourceGroupResourceIDsToAssignRbacTo`

An array of additional Resource Group Resource IDs to assign RBAC to for the policy assignment if it has an identity.

- Required: No
- Type: array

### Parameter: `additionalSubscriptionIDsToAssignRbacTo`

An array of additional Subscription IDs to assign RBAC to for the policy assignment if it has an identity.

- Required: No
- Type: array

### Parameter: `definitionVersion`

The policy definition version to use for the policy assignment. If not specified, the latest version of the policy definition will be used. For more information on policy assignment definition versions see https://learn.microsoft.com/azure/governance/policy/concepts/assignment-structure#policy-definition-id-and-version-preview.

- Required: No
- Type: string

### Parameter: `description`

This message will be part of response in case of policy violation.

- Required: No
- Type: string

### Parameter: `displayName`

The display name of the policy assignment. Maximum length is 128 characters.

- Required: No
- Type: string

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

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `managedIdentities`

The managed identity definition for this resource.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      systemAssigned: true
  }
  ```

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceId`](#parameter-managedidentitiesuserassignedresourceid) | string | The resource ID of the user-assigned identity to assign to the resource.. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceId`

The resource ID of the user-assigned identity to assign to the resource..

- Required: No
- Type: string

### Parameter: `metadata`

The policy assignment metadata. Metadata is an open ended object and is typically a collection of key-value pairs.

- Required: No
- Type: object

### Parameter: `nonComplianceMessages`

The messages that describe why a resource is non-compliant with the policy.

- Required: No
- Type: array

### Parameter: `notScopes`

The policy excluded scopes.

- Required: No
- Type: array

### Parameter: `overrides`

The policy property value override. Allows changing the effect of a policy definition without modifying the underlying policy definition or using a parameterized effect in the policy definition.

- Required: No
- Type: array

### Parameter: `parameters`

Parameters for the policy assignment if needed.

- Required: No
- Type: object

### Parameter: `resourceSelectors`

The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out policy assignments based on factors like resource location, resource type, or whether a resource has a location.

- Required: No
- Type: array

### Parameter: `roleDefinitionIds`

The IDs Of the Azure Role Definition that are used to assign permissions to the policy's identity. You need to provide the fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.. See https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles for the list IDs for built-in Roles. They must match on what is on the policy definition.

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | Policy Assignment Name. |
| `resourceId` | string | Policy Assignment resource ID. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
