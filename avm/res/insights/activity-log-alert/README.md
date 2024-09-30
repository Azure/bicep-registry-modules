# Activity Log Alerts `[Microsoft.Insights/activityLogAlerts]`

This module deploys an Activity Log Alert.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/activityLogAlerts` | [2020-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2020-10-01/activityLogAlerts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/insights/activity-log-alert:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module activityLogAlert 'br/public:avm/res/insights/activity-log-alert:<version>' = {
  name: 'activityLogAlertDeployment'
  params: {
    // Required parameters
    conditions: [
      {
        equals: 'ServiceHealth'
        field: 'category'
      }
      {
        anyOf: [
          {
            equals: 'Incident'
            field: 'properties.incidentType'
          }
          {
            equals: 'Maintenance'
            field: 'properties.incidentType'
          }
        ]
      }
      {
        containsAny: [
          'Storage'
        ]
        field: 'properties.impactedServices[*].ServiceName'
      }
      {
        containsAny: [
          'West Europe'
        ]
        field: 'properties.impactedServices[*].ImpactedRegions[*].RegionName'
      }
    ]
    name: 'ialamin001'
    // Non-required parameters
    location: 'global'
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
    "conditions": {
      "value": [
        {
          "equals": "ServiceHealth",
          "field": "category"
        },
        {
          "anyOf": [
            {
              "equals": "Incident",
              "field": "properties.incidentType"
            },
            {
              "equals": "Maintenance",
              "field": "properties.incidentType"
            }
          ]
        },
        {
          "containsAny": [
            "Storage"
          ],
          "field": "properties.impactedServices[*].ServiceName"
        },
        {
          "containsAny": [
            "West Europe"
          ],
          "field": "properties.impactedServices[*].ImpactedRegions[*].RegionName"
        }
      ]
    },
    "name": {
      "value": "ialamin001"
    },
    // Non-required parameters
    "location": {
      "value": "global"
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
module activityLogAlert 'br/public:avm/res/insights/activity-log-alert:<version>' = {
  name: 'activityLogAlertDeployment'
  params: {
    // Required parameters
    conditions: [
      {
        equals: 'ServiceHealth'
        field: 'category'
      }
      {
        anyOf: [
          {
            equals: 'Incident'
            field: 'properties.incidentType'
          }
          {
            equals: 'Maintenance'
            field: 'properties.incidentType'
          }
        ]
      }
      {
        containsAny: [
          'Action Groups'
          'Activity Logs & Alerts'
        ]
        field: 'properties.impactedServices[*].ServiceName'
      }
      {
        containsAny: [
          'Global'
          'West Europe'
        ]
        field: 'properties.impactedServices[*].ImpactedRegions[*].RegionName'
      }
    ]
    name: 'ialamax001'
    // Non-required parameters
    actions: [
      {
        actionGroupId: '<actionGroupId>'
      }
    ]
    location: 'global'
    roleAssignments: [
      {
        name: 'be96d7a9-6596-40c7-9acd-db6acd5cd41b'
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
    "conditions": {
      "value": [
        {
          "equals": "ServiceHealth",
          "field": "category"
        },
        {
          "anyOf": [
            {
              "equals": "Incident",
              "field": "properties.incidentType"
            },
            {
              "equals": "Maintenance",
              "field": "properties.incidentType"
            }
          ]
        },
        {
          "containsAny": [
            "Action Groups",
            "Activity Logs & Alerts"
          ],
          "field": "properties.impactedServices[*].ServiceName"
        },
        {
          "containsAny": [
            "Global",
            "West Europe"
          ],
          "field": "properties.impactedServices[*].ImpactedRegions[*].RegionName"
        }
      ]
    },
    "name": {
      "value": "ialamax001"
    },
    // Non-required parameters
    "actions": {
      "value": [
        {
          "actionGroupId": "<actionGroupId>"
        }
      ]
    },
    "location": {
      "value": "global"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "be96d7a9-6596-40c7-9acd-db6acd5cd41b",
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
module activityLogAlert 'br/public:avm/res/insights/activity-log-alert:<version>' = {
  name: 'activityLogAlertDeployment'
  params: {
    // Required parameters
    conditions: [
      {
        equals: 'ServiceHealth'
        field: 'category'
      }
      {
        anyOf: [
          {
            equals: 'Incident'
            field: 'properties.incidentType'
          }
          {
            equals: 'Maintenance'
            field: 'properties.incidentType'
          }
        ]
      }
      {
        containsAny: [
          'Action Groups'
          'Activity Logs & Alerts'
        ]
        field: 'properties.impactedServices[*].ServiceName'
      }
      {
        containsAny: [
          'Global'
          'West Europe'
        ]
        field: 'properties.impactedServices[*].ImpactedRegions[*].RegionName'
      }
    ]
    name: 'ialawaf001'
    // Non-required parameters
    actions: [
      {
        actionGroupId: '<actionGroupId>'
      }
    ]
    location: 'global'
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
    "conditions": {
      "value": [
        {
          "equals": "ServiceHealth",
          "field": "category"
        },
        {
          "anyOf": [
            {
              "equals": "Incident",
              "field": "properties.incidentType"
            },
            {
              "equals": "Maintenance",
              "field": "properties.incidentType"
            }
          ]
        },
        {
          "containsAny": [
            "Action Groups",
            "Activity Logs & Alerts"
          ],
          "field": "properties.impactedServices[*].ServiceName"
        },
        {
          "containsAny": [
            "Global",
            "West Europe"
          ],
          "field": "properties.impactedServices[*].ImpactedRegions[*].RegionName"
        }
      ]
    },
    "name": {
      "value": "ialawaf001"
    },
    // Non-required parameters
    "actions": {
      "value": [
        {
          "actionGroupId": "<actionGroupId>"
        }
      ]
    },
    "location": {
      "value": "global"
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

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`conditions`](#parameter-conditions) | array | An Array of objects containing conditions that will cause this alert to activate. Conditions can also be combined with logical operators `allOf` and `anyOf`. Each condition can specify only one field between `equals` and `containsAny`. An alert rule condition must have exactly one category (Administrative, ServiceHealth, ResourceHealth, Alert, Autoscale, Recommendation, Security, or Policy). |
| [`name`](#parameter-name) | string | The name of the alert. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-actions) | array | The list of actions to take when alert triggers. |
| [`alertDescription`](#parameter-alertdescription) | string | Description of the alert. |
| [`enabled`](#parameter-enabled) | bool | Indicates whether this alert is enabled. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`scopes`](#parameter-scopes) | array | The list of resource IDs that this Activity Log Alert is scoped to. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `conditions`

An Array of objects containing conditions that will cause this alert to activate. Conditions can also be combined with logical operators `allOf` and `anyOf`. Each condition can specify only one field between `equals` and `containsAny`. An alert rule condition must have exactly one category (Administrative, ServiceHealth, ResourceHealth, Alert, Autoscale, Recommendation, Security, or Policy).

- Required: Yes
- Type: array

### Parameter: `name`

The name of the alert.

- Required: Yes
- Type: string

### Parameter: `actions`

The list of actions to take when alert triggers.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `alertDescription`

Description of the alert.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enabled`

Indicates whether this alert is enabled.

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

### Parameter: `scopes`

The list of resource IDs that this Activity Log Alert is scoped to.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    '[subscription().id]'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the activity log alert. |
| `resourceGroupName` | string | The resource group the activity log alert was deployed into. |
| `resourceId` | string | The resource ID of the activity log alert. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
