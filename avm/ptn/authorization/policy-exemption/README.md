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

- [Mg.Defaults](#example-1-mgdefaults)
- [Mg.Max](#example-2-mgmax)
- [Rg.Defaults](#example-3-rgdefaults)
- [Rg.Max](#example-4-rgmax)
- [Sub.Defaults](#example-5-subdefaults)
- [Sub.Max](#example-6-submax)

### Example 1: _Mg.Defaults_

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br/public:avm/ptn/authorization/policy-exemption:<version>' = {
  name: 'policyExemptionDeployment'
  params: {
    // Required parameters
    assignmentScopeValidation: 'Default'
    exemptionCategory: 'Mitigated'
    expiresOn: '2023-10-05T14:48:00Z'
    name: 'apemgmin001'
    policyAssignmentId: 'test'
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
    "assignmentScopeValidation": {
      "value": "Default"
    },
    "exemptionCategory": {
      "value": "Mitigated"
    },
    "expiresOn": {
      "value": "2023-10-05T14:48:00Z"
    },
    "name": {
      "value": "apemgmin001"
    },
    "policyAssignmentId": {
      "value": "test"
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
param assignmentScopeValidation = 'Default'
param exemptionCategory = 'Mitigated'
param expiresOn = '2023-10-05T14:48:00Z'
param name = 'apemgmin001'
param policyAssignmentId = 'test'
```

</details>
<p>

### Example 2: _Mg.Max_

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br/public:avm/ptn/authorization/policy-exemption:<version>' = {
  name: 'policyExemptionDeployment'
  params: {
    // Required parameters
    // Non-required parameters
    name: 'apamgmax001'
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
      '/subscriptions/<value>/resourceGroups/validation-rg'
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
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "apamgmax001"
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
        "/subscriptions/<value>/resourceGroups/validation-rg"
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
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/authorization/policy-exemption:<version>'

// Required parameters
// Non-required parameters
param name = 'apamgmax001'
param description = '[Description] Policy Assignment at the management group scope'
param displayName = '[Display Name] Policy Assignment at the management group scope'
param enforcementMode = 'DoNotEnforce'
param identity = 'SystemAssigned'
param location = '<location>'
param managementGroupId = '<managementGroupId>'
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
  '/subscriptions/<value>/resourceGroups/validation-rg'
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
    value: 'Disabled'
  }
  enableCollectionOfSqlQueriesForSecurityResearch: {
    value: false
  }
}
param policyDefinitionId = '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
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
  '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
]
```

</details>
<p>

### Example 3: _Rg.Defaults_

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br/public:avm/ptn/authorization/policy-exemption:<version>' = {
  name: 'policyExemptionDeployment'
  params: {
    // Required parameters
    // Non-required parameters
    name: 'apargmin001'
    location: '<location>'
    metadata: {
      assignedBy: 'Bicep'
    }
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
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
    "name": {
      "value": "apargmin001"
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
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/authorization/policy-exemption:<version>'

// Required parameters
// Non-required parameters
param name = 'apargmin001'
param location = '<location>'
param metadata = {
  assignedBy: 'Bicep'
}
param policyDefinitionId = '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
param resourceGroupName = '<resourceGroupName>'
param subscriptionId = '<subscriptionId>'
```

</details>
<p>

### Example 4: _Rg.Max_

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br/public:avm/ptn/authorization/policy-exemption:<version>' = {
  name: 'policyExemptionDeployment'
  params: {
    // Required parameters
    // Non-required parameters
    name: 'apargmax001'
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
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "apargmax001"
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
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/authorization/policy-exemption:<version>'

// Required parameters
// Non-required parameters
param name = 'apargmax001'
param description = '[Description] Policy Assignment at the resource group scope'
param displayName = '[Display Name] Policy Assignment at the resource group scope'
param enforcementMode = 'DoNotEnforce'
param identity = 'UserAssigned'
param location = '<location>'
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
  '<keyVaultResourceId>'
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
    value: 'Disabled'
  }
  enableCollectionOfSqlQueriesForSecurityResearch: {
    value: false
  }
}
param policyDefinitionId = '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
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
param roleDefinitionIds = [
  '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
]
param subscriptionId = '<subscriptionId>'
param userAssignedIdentityId = '<userAssignedIdentityId>'
```

</details>
<p>

### Example 5: _Sub.Defaults_

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br/public:avm/ptn/authorization/policy-exemption:<version>' = {
  name: 'policyExemptionDeployment'
  params: {
    // Required parameters
    name: 'apasubmin001'
    location: '<location>'
    metadata: {
      assignedBy: 'Bicep'
      category: 'Security'
      version: '1.0'
    }
    policyDefinitionId: '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
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
    "name": {
      "value": "apasubmin001"
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
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d"
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
param name = 'apasubmin001'
param location = '<location>'
param metadata = {
  assignedBy: 'Bicep'
  category: 'Security'
  version: '1.0'
}
param policyDefinitionId = '/providers/Microsoft.Authorization/policyDefinitions/06a78e20-9358-41c9-923c-fb736d382a4d'
param subscriptionId = '<subscriptionId>'
```

</details>
<p>

### Example 6: _Sub.Max_

<details>

<summary>via Bicep module</summary>

```bicep
module policyExemption 'br/public:avm/ptn/authorization/policy-exemption:<version>' = {
  name: 'policyExemptionDeployment'
  params: {
    // Required parameters
    // Non-required parameters
    name: 'apasubmax001'
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
      '/subscriptions/<value>/resourceGroups/validation-rg'
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
    policyDefinitionId: '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "name": {
      "value": "apasubmax001"
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
        "/subscriptions/<value>/resourceGroups/validation-rg"
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
    "policyDefinitionId": {
      "value": "/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/ptn/authorization/policy-exemption:<version>'

// Required parameters
// Non-required parameters
param name = 'apasubmax001'
param description = '[Description] Policy Assignment at the subscription scope'
param displayName = '[Display Name] Policy Assignment at the subscription scope'
param enforcementMode = 'DoNotEnforce'
param identity = 'UserAssigned'
param location = '<location>'
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
  '/subscriptions/<value>/resourceGroups/validation-rg'
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
    value: 'Disabled'
  }
  enableCollectionOfSqlQueriesForSecurityResearch: {
    value: false
  }
}
param policyDefinitionId = '/providers/Microsoft.Authorization/policySetDefinitions/39a366e6-fdde-4f41-bbf8-3757f46d1611'
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
param subscriptionId = '<subscriptionId>'
param userAssignedIdentityId = '<userAssignedIdentityId>'
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

- Required: Yes
- Type: string
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
- Default: `''`

### Parameter: `displayName`

The display name of the policy exemption. Maximum length is 128 characters.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `expiresOn`

The expiration date and time (in UTC ISO 8601 format yyyy-MM-ddTHH:mm:ssZ) of the policy exemption.

- Required: Yes
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
- Default: `{}`

### Parameter: `policyDefinitionReferenceIds`

The policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `resourceGroupName`

The Target Scope for the Policy. The name of the resource group for the policy exemption.

- Required: No
- Type: string
- Default: `''`

### Parameter: `resourceSelectors`

The resource selector list to filter policies by resource properties. Facilitates safe deployment practices (SDP) by enabling gradual roll out Policy exemptions based on factors like resource location, resource type, or whether a resource has a location.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `subscriptionId`

The Target Scope for the Policy. The subscription ID of the subscription for the policy exemption.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Policy Exemption Name. |
| `resourceId` | string | Policy Exemption resource ID. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
