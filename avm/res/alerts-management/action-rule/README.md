# Action Rules `[Microsoft.AlertsManagement/actionRules]`

This module deploys an Alert Processing Rule.

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
| `Microsoft.AlertsManagement/actionRules` | [2021-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.AlertsManagement/2021-08-08/actionRules) |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/alerts-management/action-rule:<version>`.

- [Using small parameter set](#example-1-using-small-parameter-set)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using small parameter set_

This instance deploys the module with min features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module actionRule 'br/public:avm/res/alerts-management/action-rule:<version>' = {
  name: 'actionRuleDeployment'
  params: {
    // Required parameters
    name: 'aprmin001'
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
    "name": {
      "value": "aprmin001"
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

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module actionRule 'br/public:avm/res/alerts-management/action-rule:<version>' = {
  name: 'actionRuleDeployment'
  params: {
    // Required parameters
    name: 'aprmax001'
    // Non-required parameters
    actions: [
      {
        actionGroupIds: [
          '<actionGroupResourceId>'
        ]
        actionType: 'AddActionGroups'
      }
    ]
    aprDescription: 'Test deployment of the module with the max set of parameters.'
    conditions: [
      {
        field: 'AlertContext'
        operator: 'NotEquals'
        values: [
          'myAlertContext'
        ]
      }
      {
        field: 'AlertRuleId'
        operator: 'Equals'
        values: [
          '<activityLogAlertResourceId>'
        ]
      }
      {
        field: 'AlertRuleName'
        operator: 'Equals'
        values: [
          '<activityLogAlertResourceName>'
        ]
      }
      {
        field: 'Description'
        operator: 'Contains'
        values: [
          'myAlertRuleDescription'
        ]
      }
      {
        field: 'MonitorService'
        operator: 'Equals'
        values: [
          'ActivityLog Administrative'
        ]
      }
      {
        field: 'MonitorCondition'
        operator: 'Equals'
        values: [
          'Fired'
        ]
      }
      {
        field: 'TargetResourceType'
        operator: 'DoesNotContain'
        values: [
          'myAlertResourceType'
        ]
      }
      {
        field: 'TargetResource'
        operator: 'Equals'
        values: [
          'myAlertResource1'
          'myAlertResource2'
        ]
      }
      {
        field: 'TargetResourceGroup'
        operator: 'Equals'
        values: [
          '<id>'
        ]
      }
      {
        field: 'Severity'
        operator: 'Equals'
        values: [
          'Sev0'
          'Sev1'
          'Sev2'
          'Sev3'
          'Sev4'
        ]
      }
      {
        field: 'SignalType'
        operator: 'Equals'
        values: [
          'Health'
          'Log'
          'Metric'
          'Unknown'
        ]
      }
    ]
    enabled: true
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    roleAssignments: [
      {
        name: 'a66da6bc-b3ee-484e-9bdb-9294938bb327'
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
    scopes: [
      '<id>'
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
    "name": {
      "value": "aprmax001"
    },
    // Non-required parameters
    "actions": {
      "value": [
        {
          "actionGroupIds": [
            "<actionGroupResourceId>"
          ],
          "actionType": "AddActionGroups"
        }
      ]
    },
    "aprDescription": {
      "value": "Test deployment of the module with the max set of parameters."
    },
    "conditions": {
      "value": [
        {
          "field": "AlertContext",
          "operator": "NotEquals",
          "values": [
            "myAlertContext"
          ]
        },
        {
          "field": "AlertRuleId",
          "operator": "Equals",
          "values": [
            "<activityLogAlertResourceId>"
          ]
        },
        {
          "field": "AlertRuleName",
          "operator": "Equals",
          "values": [
            "<activityLogAlertResourceName>"
          ]
        },
        {
          "field": "Description",
          "operator": "Contains",
          "values": [
            "myAlertRuleDescription"
          ]
        },
        {
          "field": "MonitorService",
          "operator": "Equals",
          "values": [
            "ActivityLog Administrative"
          ]
        },
        {
          "field": "MonitorCondition",
          "operator": "Equals",
          "values": [
            "Fired"
          ]
        },
        {
          "field": "TargetResourceType",
          "operator": "DoesNotContain",
          "values": [
            "myAlertResourceType"
          ]
        },
        {
          "field": "TargetResource",
          "operator": "Equals",
          "values": [
            "myAlertResource1",
            "myAlertResource2"
          ]
        },
        {
          "field": "TargetResourceGroup",
          "operator": "Equals",
          "values": [
            "<id>"
          ]
        },
        {
          "field": "Severity",
          "operator": "Equals",
          "values": [
            "Sev0",
            "Sev1",
            "Sev2",
            "Sev3",
            "Sev4"
          ]
        },
        {
          "field": "SignalType",
          "operator": "Equals",
          "values": [
            "Health",
            "Log",
            "Metric",
            "Unknown"
          ]
        }
      ]
    },
    "enabled": {
      "value": true
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
    "roleAssignments": {
      "value": [
        {
          "name": "a66da6bc-b3ee-484e-9bdb-9294938bb327",
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
    "scopes": {
      "value": [
        "<id>"
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module actionRule 'br/public:avm/res/alerts-management/action-rule:<version>' = {
  name: 'actionRuleDeployment'
  params: {
    // Required parameters
    name: 'aprwaf001'
    // Non-required parameters
    actions: [
      {
        actionGroupIds: [
          '<actionGroupResourceId>'
        ]
        actionType: 'AddActionGroups'
      }
    ]
    aprDescription: 'Test deployment of the module with the waf aligned set of parameters.'
    location: '<location>'
    scopes: [
      '<id>'
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
      "value": "aprwaf001"
    },
    // Non-required parameters
    "actions": {
      "value": [
        {
          "actionGroupIds": [
            "<actionGroupResourceId>"
          ],
          "actionType": "AddActionGroups"
        }
      ]
    },
    "aprDescription": {
      "value": "Test deployment of the module with the waf aligned set of parameters."
    },
    "location": {
      "value": "<location>"
    },
    "scopes": {
      "value": [
        "<id>"
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
| [`name`](#parameter-name) | string | Name of the alert processing rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-actions) | array |  Actions to be applied. |
| [`aprDescription`](#parameter-aprdescription) | string | Description of the alert processing rule. |
| [`conditions`](#parameter-conditions) | array |  Conditions on which alerts will be filtered. |
| [`enabled`](#parameter-enabled) | bool | Indicates if the given alert processing rule is enabled or disabled. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`schedule`](#parameter-schedule) | object | Scheduling for alert processing rule. |
| [`scopes`](#parameter-scopes) | array | Scopes on which alert processing rule will apply. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `name`

Name of the alert processing rule.

- Required: Yes
- Type: string

### Parameter: `actions`

 Actions to be applied.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      actionType: 'RemoveAllActionGroups'
    }
  ]
  ```

### Parameter: `aprDescription`

Description of the alert processing rule.

- Required: No
- Type: string
- Default: `''`

### Parameter: `conditions`

 Conditions on which alerts will be filtered.

- Required: No
- Type: array

### Parameter: `enabled`

Indicates if the given alert processing rule is enabled or disabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `'global'`

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

### Parameter: `schedule`

Scheduling for alert processing rule.

- Required: No
- Type: object

### Parameter: `scopes`

Scopes on which alert processing rule will apply.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    '[subscription().id]'
  ]
  ```

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the Alert Processing Rule. |
| `resourceGroupName` | string | The resource group the action group was deployed into. |
| `resourceId` | string | The resource ID of the Alert Processing Rule. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
