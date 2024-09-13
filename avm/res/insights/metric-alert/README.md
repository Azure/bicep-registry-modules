# Metric Alerts `[Microsoft.Insights/metricAlerts]`

This module deploys a Metric Alert.

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
| `Microsoft.Insights/metricAlerts` | [2018-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2018-03-01/metricAlerts) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/insights/metric-alert:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module metricAlert 'br/public:avm/res/insights/metric-alert:<version>' = {
  name: 'metricAlertDeployment'
  params: {
    // Required parameters
    criteria: {
      allof: [
        {
          criterionType: 'StaticThresholdCriterion'
          dimensions: []
          metricName: 'Percentage CPU'
          name: '1st criterion'
          operator: 'GreaterThan'
          threshold: 80
          timeAggregation: 'Average'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
    }
    name: 'imamin001'
    // Non-required parameters
    location: 'Global'
    scopes: [
      '<virtualMachineResourceId>'
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
    "criteria": {
      "value": {
        "allof": [
          {
            "criterionType": "StaticThresholdCriterion",
            "dimensions": [],
            "metricName": "Percentage CPU",
            "name": "1st criterion",
            "operator": "GreaterThan",
            "threshold": 80,
            "timeAggregation": "Average"
          }
        ],
        "odata.type": "Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria"
      }
    },
    "name": {
      "value": "imamin001"
    },
    // Non-required parameters
    "location": {
      "value": "Global"
    },
    "scopes": {
      "value": [
        "<virtualMachineResourceId>"
      ]
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
module metricAlert 'br/public:avm/res/insights/metric-alert:<version>' = {
  name: 'metricAlertDeployment'
  params: {
    // Required parameters
    criteria: {
      allof: [
        {
          criterionType: 'StaticThresholdCriterion'
          metricName: 'Percentage CPU'
          metricNamespace: 'microsoft.compute/virtualmachines'
          name: 'HighCPU'
          operator: 'GreaterThan'
          threshold: '90'
          timeAggregation: 'Average'
        }
      ]
      'odata.type': 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
    }
    name: 'imamax001'
    // Non-required parameters
    actions: [
      '<actionGroupResourceId>'
    ]
    location: 'Global'
    roleAssignments: [
      {
        name: '3ab52119-85d9-4374-a454-2410b84f19f9'
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
    targetResourceRegion: 'westeurope'
    targetResourceType: 'microsoft.compute/virtualmachines'
    windowSize: 'PT15M'
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
    "criteria": {
      "value": {
        "allof": [
          {
            "criterionType": "StaticThresholdCriterion",
            "metricName": "Percentage CPU",
            "metricNamespace": "microsoft.compute/virtualmachines",
            "name": "HighCPU",
            "operator": "GreaterThan",
            "threshold": "90",
            "timeAggregation": "Average"
          }
        ],
        "odata.type": "Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria"
      }
    },
    "name": {
      "value": "imamax001"
    },
    // Non-required parameters
    "actions": {
      "value": [
        "<actionGroupResourceId>"
      ]
    },
    "location": {
      "value": "Global"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "3ab52119-85d9-4374-a454-2410b84f19f9",
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
    },
    "targetResourceRegion": {
      "value": "westeurope"
    },
    "targetResourceType": {
      "value": "microsoft.compute/virtualmachines"
    },
    "windowSize": {
      "value": "PT15M"
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
module metricAlert 'br/public:avm/res/insights/metric-alert:<version>' = {
  name: 'metricAlertDeployment'
  params: {
    // Required parameters
    criteria: {
      componentResourceId: '<componentResourceId>'
      failedLocationCount: 3
      'odata.type': 'Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria'
      webTestResourceId: '<webTestResourceId>'
    }
    name: 'imawaf001'
    // Non-required parameters
    actions: [
      '<actionGroupResourceId>'
    ]
    evaluationFrequency: 'PT5M'
    location: 'global'
    scopes: [
      '<appInsightsResourceId>'
      '<pingTestResourceId>'
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    windowSize: 'PT5M'
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
    "criteria": {
      "value": {
        "componentResourceId": "<componentResourceId>",
        "failedLocationCount": 3,
        "odata.type": "Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria",
        "webTestResourceId": "<webTestResourceId>"
      }
    },
    "name": {
      "value": "imawaf001"
    },
    // Non-required parameters
    "actions": {
      "value": [
        "<actionGroupResourceId>"
      ]
    },
    "evaluationFrequency": {
      "value": "PT5M"
    },
    "location": {
      "value": "global"
    },
    "scopes": {
      "value": [
        "<appInsightsResourceId>",
        "<pingTestResourceId>"
      ]
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "windowSize": {
      "value": "PT5M"
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
| [`criteria`](#parameter-criteria) | object | Maps to the 'odata.type' field. Specifies the type of the alert criteria. |
| [`name`](#parameter-name) | string | The name of the alert. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`targetResourceRegion`](#parameter-targetresourceregion) | string | The region of the target resource(s) on which the alert is created/updated. Required if alertCriteriaType is MultipleResourceMultipleMetricCriteria. |
| [`targetResourceType`](#parameter-targetresourcetype) | string | The resource type of the target resource(s) on which the alert is created/updated. Required if alertCriteriaType is MultipleResourceMultipleMetricCriteria. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-actions) | array | The list of actions to take when alert triggers. |
| [`alertDescription`](#parameter-alertdescription) | string | Description of the alert. |
| [`autoMitigate`](#parameter-automitigate) | bool | The flag that indicates whether the alert should be auto resolved or not. |
| [`enabled`](#parameter-enabled) | bool | Indicates whether this alert is enabled. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`evaluationFrequency`](#parameter-evaluationfrequency) | string | how often the metric alert is evaluated represented in ISO 8601 duration format. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`scopes`](#parameter-scopes) | array | the list of resource IDs that this metric alert is scoped to. |
| [`severity`](#parameter-severity) | int | The severity of the alert. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`windowSize`](#parameter-windowsize) | string | the period of time (in ISO 8601 duration format) that is used to monitor alert activity based on the threshold. |

### Parameter: `criteria`

Maps to the 'odata.type' field. Specifies the type of the alert criteria.

- Required: Yes
- Type: object

### Parameter: `name`

The name of the alert.

- Required: Yes
- Type: string

### Parameter: `targetResourceRegion`

The region of the target resource(s) on which the alert is created/updated. Required if alertCriteriaType is MultipleResourceMultipleMetricCriteria.

- Required: No
- Type: string

### Parameter: `targetResourceType`

The resource type of the target resource(s) on which the alert is created/updated. Required if alertCriteriaType is MultipleResourceMultipleMetricCriteria.

- Required: No
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

### Parameter: `autoMitigate`

The flag that indicates whether the alert should be auto resolved or not.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `evaluationFrequency`

how often the metric alert is evaluated represented in ISO 8601 duration format.

- Required: No
- Type: string
- Default: `'PT5M'`
- Allowed:
  ```Bicep
  [
    'PT15M'
    'PT1H'
    'PT1M'
    'PT30M'
    'PT5M'
  ]
  ```

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

the list of resource IDs that this metric alert is scoped to.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    '[subscription().id]'
  ]
  ```

### Parameter: `severity`

The severity of the alert.

- Required: No
- Type: int
- Default: `3`
- Allowed:
  ```Bicep
  [
    0
    1
    2
    3
    4
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `windowSize`

the period of time (in ISO 8601 duration format) that is used to monitor alert activity based on the threshold.

- Required: No
- Type: string
- Default: `'PT15M'`
- Allowed:
  ```Bicep
  [
    'P1D'
    'PT12H'
    'PT15M'
    'PT1H'
    'PT1M'
    'PT30M'
    'PT5M'
    'PT6H'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the metric alert. |
| `resourceGroupName` | string | The resource group the metric alert was deployed into. |
| `resourceId` | string | The resource ID of the metric alert. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
