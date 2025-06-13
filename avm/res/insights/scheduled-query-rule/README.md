# Scheduled Query Rules `[Microsoft.Insights/scheduledQueryRules]`

> ⚠️THIS MODULE IS CURRENTLY ORPHANED.⚠️
> 
> - Only security and bug fixes are being handled by the AVM core team at present.
> - If interested in becoming the module owner of this orphaned module (must be Microsoft FTE), please look for the related "orphaned module" GitHub issue [here](https://aka.ms/AVM/OrphanedModules)!

This module deploys a Scheduled Query Rule.

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
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/scheduledQueryRules` | [2025-01-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2025-01-01-preview/scheduledQueryRules) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/insights/scheduled-query-rule:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module scheduledQueryRule 'br/public:avm/res/insights/scheduled-query-rule:<version>' = {
  name: 'scheduledQueryRuleDeployment'
  params: {
    // Required parameters
    criterias: {
      allOf: [
        {
          dimensions: [
            {
              name: 'Computer'
              operator: 'Include'
              values: [
                '*'
              ]
            }
            {
              name: 'InstanceName'
              operator: 'Include'
              values: [
                '*'
              ]
            }
          ]
          metricMeasureColumn: 'AggregatedValue'
          operator: 'GreaterThan'
          query: 'Perf | where ObjectName == \'LogicalDisk\' | where CounterName == \'% Free Space\' | where InstanceName <> \'HarddiskVolume1\' and InstanceName <> \'_Total\' | summarize AggregatedValue = min(CounterValue) by Computer, InstanceName, bin(TimeGenerated,5m)'
          threshold: 0
          timeAggregation: 'Average'
        }
      ]
    }
    name: 'isqrmin001'
    scopes: [
      '<logAnalyticsWorkspaceResourceId>'
    ]
    // Non-required parameters
    evaluationFrequency: 'PT5M'
    windowSize: 'PT5M'
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
    "criterias": {
      "value": {
        "allOf": [
          {
            "dimensions": [
              {
                "name": "Computer",
                "operator": "Include",
                "values": [
                  "*"
                ]
              },
              {
                "name": "InstanceName",
                "operator": "Include",
                "values": [
                  "*"
                ]
              }
            ],
            "metricMeasureColumn": "AggregatedValue",
            "operator": "GreaterThan",
            "query": "Perf | where ObjectName == \"LogicalDisk\" | where CounterName == \"% Free Space\" | where InstanceName <> \"HarddiskVolume1\" and InstanceName <> \"_Total\" | summarize AggregatedValue = min(CounterValue) by Computer, InstanceName, bin(TimeGenerated,5m)",
            "threshold": 0,
            "timeAggregation": "Average"
          }
        ]
      }
    },
    "name": {
      "value": "isqrmin001"
    },
    "scopes": {
      "value": [
        "<logAnalyticsWorkspaceResourceId>"
      ]
    },
    // Non-required parameters
    "evaluationFrequency": {
      "value": "PT5M"
    },
    "windowSize": {
      "value": "PT5M"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/insights/scheduled-query-rule:<version>'

// Required parameters
param criterias = {
  allOf: [
    {
      dimensions: [
        {
          name: 'Computer'
          operator: 'Include'
          values: [
            '*'
          ]
        }
        {
          name: 'InstanceName'
          operator: 'Include'
          values: [
            '*'
          ]
        }
      ]
      metricMeasureColumn: 'AggregatedValue'
      operator: 'GreaterThan'
      query: 'Perf | where ObjectName == \'LogicalDisk\' | where CounterName == \'% Free Space\' | where InstanceName <> \'HarddiskVolume1\' and InstanceName <> \'_Total\' | summarize AggregatedValue = min(CounterValue) by Computer, InstanceName, bin(TimeGenerated,5m)'
      threshold: 0
      timeAggregation: 'Average'
    }
  ]
}
param name = 'isqrmin001'
param scopes = [
  '<logAnalyticsWorkspaceResourceId>'
]
// Non-required parameters
param evaluationFrequency = 'PT5M'
param windowSize = 'PT5M'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module scheduledQueryRule 'br/public:avm/res/insights/scheduled-query-rule:<version>' = {
  name: 'scheduledQueryRuleDeployment'
  params: {
    // Required parameters
    criterias: {
      allOf: [
        {
          dimensions: [
            {
              name: 'Computer'
              operator: 'Include'
              values: [
                '*'
              ]
            }
            {
              name: 'InstanceName'
              operator: 'Include'
              values: [
                '*'
              ]
            }
          ]
          metricMeasureColumn: 'AggregatedValue'
          operator: 'GreaterThan'
          query: 'Perf | where ObjectName == \'LogicalDisk\' | where CounterName == \'% Free Space\' | where InstanceName <> \'HarddiskVolume1\' and InstanceName <> \'_Total\' | summarize AggregatedValue = min(CounterValue) by Computer, InstanceName, bin(TimeGenerated,5m)'
          threshold: 0
          timeAggregation: 'Average'
        }
      ]
    }
    name: 'isqrmax001'
    scopes: [
      '<logAnalyticsWorkspaceResourceId>'
    ]
    // Non-required parameters
    actions: {
      actionGroupResourceIds: [
        '<actionGroupResourceId>'
      ]
      customProperties: {
        'Additional Details': 'Evaluation windowStartTime: \${data.alertContext.condition.windowStartTime}. windowEndTime: \${data.alertContext.condition.windowEndTime}'
        'Alert \${data.essentials.monitorCondition} reason': '\${data.alertContext.condition.allOf[0].metricName} \${data.alertContext.condition.allOf[0].operator} \${data.alertContext.condition.allOf[0].threshold} \${data.essentials.monitorCondition}. The value is \${data.alertContext.condition.allOf[0].metricValue}'
      }
    }
    alertDescription: 'My sample Alert'
    alertDisplayName: '<alertDisplayName>'
    autoMitigate: false
    evaluationFrequency: 'PT5M'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: false
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    queryTimeRange: 'PT5M'
    roleAssignments: [
      {
        name: 'fa8868c7-33d3-4cd5-86a5-cbf76261035b'
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
    ruleResolveConfiguration: {
      autoResolved: true
      timeToResolve: 'PT5M'
    }
    suppressForMinutes: 'PT5M'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "criterias": {
      "value": {
        "allOf": [
          {
            "dimensions": [
              {
                "name": "Computer",
                "operator": "Include",
                "values": [
                  "*"
                ]
              },
              {
                "name": "InstanceName",
                "operator": "Include",
                "values": [
                  "*"
                ]
              }
            ],
            "metricMeasureColumn": "AggregatedValue",
            "operator": "GreaterThan",
            "query": "Perf | where ObjectName == \"LogicalDisk\" | where CounterName == \"% Free Space\" | where InstanceName <> \"HarddiskVolume1\" and InstanceName <> \"_Total\" | summarize AggregatedValue = min(CounterValue) by Computer, InstanceName, bin(TimeGenerated,5m)",
            "threshold": 0,
            "timeAggregation": "Average"
          }
        ]
      }
    },
    "name": {
      "value": "isqrmax001"
    },
    "scopes": {
      "value": [
        "<logAnalyticsWorkspaceResourceId>"
      ]
    },
    // Non-required parameters
    "actions": {
      "value": {
        "actionGroupResourceIds": [
          "<actionGroupResourceId>"
        ],
        "customProperties": {
          "Additional Details": "Evaluation windowStartTime: \\${data.alertContext.condition.windowStartTime}. windowEndTime: \\${data.alertContext.condition.windowEndTime}",
          "Alert \\${data.essentials.monitorCondition} reason": "\\${data.alertContext.condition.allOf[0].metricName} \\${data.alertContext.condition.allOf[0].operator} \\${data.alertContext.condition.allOf[0].threshold} \\${data.essentials.monitorCondition}. The value is \\${data.alertContext.condition.allOf[0].metricValue}"
        }
      }
    },
    "alertDescription": {
      "value": "My sample Alert"
    },
    "alertDisplayName": {
      "value": "<alertDisplayName>"
    },
    "autoMitigate": {
      "value": false
    },
    "evaluationFrequency": {
      "value": "PT5M"
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
    "managedIdentities": {
      "value": {
        "systemAssigned": false,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "queryTimeRange": {
      "value": "PT5M"
    },
    "roleAssignments": {
      "value": [
        {
          "name": "fa8868c7-33d3-4cd5-86a5-cbf76261035b",
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
    "ruleResolveConfiguration": {
      "value": {
        "autoResolved": true,
        "timeToResolve": "PT5M"
      }
    },
    "suppressForMinutes": {
      "value": "PT5M"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/insights/scheduled-query-rule:<version>'

// Required parameters
param criterias = {
  allOf: [
    {
      dimensions: [
        {
          name: 'Computer'
          operator: 'Include'
          values: [
            '*'
          ]
        }
        {
          name: 'InstanceName'
          operator: 'Include'
          values: [
            '*'
          ]
        }
      ]
      metricMeasureColumn: 'AggregatedValue'
      operator: 'GreaterThan'
      query: 'Perf | where ObjectName == \'LogicalDisk\' | where CounterName == \'% Free Space\' | where InstanceName <> \'HarddiskVolume1\' and InstanceName <> \'_Total\' | summarize AggregatedValue = min(CounterValue) by Computer, InstanceName, bin(TimeGenerated,5m)'
      threshold: 0
      timeAggregation: 'Average'
    }
  ]
}
param name = 'isqrmax001'
param scopes = [
  '<logAnalyticsWorkspaceResourceId>'
]
// Non-required parameters
param actions = {
  actionGroupResourceIds: [
    '<actionGroupResourceId>'
  ]
  customProperties: {
    'Additional Details': 'Evaluation windowStartTime: \${data.alertContext.condition.windowStartTime}. windowEndTime: \${data.alertContext.condition.windowEndTime}'
    'Alert \${data.essentials.monitorCondition} reason': '\${data.alertContext.condition.allOf[0].metricName} \${data.alertContext.condition.allOf[0].operator} \${data.alertContext.condition.allOf[0].threshold} \${data.essentials.monitorCondition}. The value is \${data.alertContext.condition.allOf[0].metricValue}'
  }
}
param alertDescription = 'My sample Alert'
param alertDisplayName = '<alertDisplayName>'
param autoMitigate = false
param evaluationFrequency = 'PT5M'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: false
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param queryTimeRange = 'PT5M'
param roleAssignments = [
  {
    name: 'fa8868c7-33d3-4cd5-86a5-cbf76261035b'
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
param ruleResolveConfiguration = {
  autoResolved: true
  timeToResolve: 'PT5M'
}
param suppressForMinutes = 'PT5M'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param windowSize = 'PT5M'
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module scheduledQueryRule 'br/public:avm/res/insights/scheduled-query-rule:<version>' = {
  name: 'scheduledQueryRuleDeployment'
  params: {
    // Required parameters
    criterias: {
      allOf: [
        {
          dimensions: [
            {
              name: 'Computer'
              operator: 'Include'
              values: [
                '*'
              ]
            }
            {
              name: 'InstanceName'
              operator: 'Include'
              values: [
                '*'
              ]
            }
          ]
          metricMeasureColumn: 'AggregatedValue'
          operator: 'GreaterThan'
          query: 'Perf | where ObjectName == \'LogicalDisk\' | where CounterName == \'% Free Space\' | where InstanceName <> \'HarddiskVolume1\' and InstanceName <> \'_Total\' | summarize AggregatedValue = min(CounterValue) by Computer, InstanceName, bin(TimeGenerated,5m)'
          threshold: 0
          timeAggregation: 'Average'
        }
      ]
    }
    name: 'isqrwaf001'
    scopes: [
      '<logAnalyticsWorkspaceResourceId>'
    ]
    // Non-required parameters
    alertDescription: 'My sample Alert'
    autoMitigate: false
    evaluationFrequency: 'PT5M'
    queryTimeRange: 'PT5M'
    suppressForMinutes: 'PT5M'
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

<summary>via JSON parameters file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "criterias": {
      "value": {
        "allOf": [
          {
            "dimensions": [
              {
                "name": "Computer",
                "operator": "Include",
                "values": [
                  "*"
                ]
              },
              {
                "name": "InstanceName",
                "operator": "Include",
                "values": [
                  "*"
                ]
              }
            ],
            "metricMeasureColumn": "AggregatedValue",
            "operator": "GreaterThan",
            "query": "Perf | where ObjectName == \"LogicalDisk\" | where CounterName == \"% Free Space\" | where InstanceName <> \"HarddiskVolume1\" and InstanceName <> \"_Total\" | summarize AggregatedValue = min(CounterValue) by Computer, InstanceName, bin(TimeGenerated,5m)",
            "threshold": 0,
            "timeAggregation": "Average"
          }
        ]
      }
    },
    "name": {
      "value": "isqrwaf001"
    },
    "scopes": {
      "value": [
        "<logAnalyticsWorkspaceResourceId>"
      ]
    },
    // Non-required parameters
    "alertDescription": {
      "value": "My sample Alert"
    },
    "autoMitigate": {
      "value": false
    },
    "evaluationFrequency": {
      "value": "PT5M"
    },
    "queryTimeRange": {
      "value": "PT5M"
    },
    "suppressForMinutes": {
      "value": "PT5M"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/insights/scheduled-query-rule:<version>'

// Required parameters
param criterias = {
  allOf: [
    {
      dimensions: [
        {
          name: 'Computer'
          operator: 'Include'
          values: [
            '*'
          ]
        }
        {
          name: 'InstanceName'
          operator: 'Include'
          values: [
            '*'
          ]
        }
      ]
      metricMeasureColumn: 'AggregatedValue'
      operator: 'GreaterThan'
      query: 'Perf | where ObjectName == \'LogicalDisk\' | where CounterName == \'% Free Space\' | where InstanceName <> \'HarddiskVolume1\' and InstanceName <> \'_Total\' | summarize AggregatedValue = min(CounterValue) by Computer, InstanceName, bin(TimeGenerated,5m)'
      threshold: 0
      timeAggregation: 'Average'
    }
  ]
}
param name = 'isqrwaf001'
param scopes = [
  '<logAnalyticsWorkspaceResourceId>'
]
// Non-required parameters
param alertDescription = 'My sample Alert'
param autoMitigate = false
param evaluationFrequency = 'PT5M'
param queryTimeRange = 'PT5M'
param suppressForMinutes = 'PT5M'
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param windowSize = 'PT5M'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`criterias`](#parameter-criterias) | object | The rule criteria that defines the conditions of the scheduled query rule. |
| [`name`](#parameter-name) | string | The name of the Alert. |
| [`scopes`](#parameter-scopes) | array | The list of resource IDs that this scheduled query rule is scoped to. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`windowSize`](#parameter-windowsize) | string | The period of time (in ISO 8601 duration format) on which the Alert query will be executed (bin size). Required if the kind is set to 'LogAlert', otherwise not relevant. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actions`](#parameter-actions) | object | Actions to invoke when the alert fires. |
| [`alertDescription`](#parameter-alertdescription) | string | The description of the scheduled query rule. |
| [`alertDisplayName`](#parameter-alertdisplayname) | string | The display name of the scheduled query rule. |
| [`autoMitigate`](#parameter-automitigate) | bool | The flag that indicates whether the alert should be automatically resolved or not. Relevant only for rules of the kind LogAlert. Note, ResolveConfiguration can't be used together with AutoMitigate. |
| [`enabled`](#parameter-enabled) | bool | The flag which indicates whether this scheduled query rule is enabled. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`evaluationFrequency`](#parameter-evaluationfrequency) | string | How often the scheduled query rule is evaluated represented in ISO 8601 duration format. Relevant and required only for rules of the kind LogAlert. |
| [`kind`](#parameter-kind) | string | Indicates the type of scheduled query rule. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. You can only configure either a system-assigned or user-assigned identities, not both. |
| [`queryTimeRange`](#parameter-querytimerange) | string | If specified (in ISO 8601 duration format) then overrides the query time range. Relevant only for rules of the kind LogAlert. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`ruleResolveConfiguration`](#parameter-ruleresolveconfiguration) | object | Defines the configuration for resolving fired alerts. Relevant only for rules of the kind LogAlert. Note, ResolveConfiguration can't be used together with AutoMitigate. |
| [`severity`](#parameter-severity) | int | Severity of the alert. Should be an integer between [0-4]. Value of 0 is severest. Relevant and required only for rules of the kind LogAlert. |
| [`skipQueryValidation`](#parameter-skipqueryvalidation) | bool | The flag which indicates whether the provided query should be validated or not. Relevant only for rules of the kind LogAlert. |
| [`suppressForMinutes`](#parameter-suppressforminutes) | string | Mute actions for the chosen period of time (in ISO 8601 duration format) after the alert is fired. If set, autoMitigate must be disabled. Relevant only for rules of the kind LogAlert. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`targetResourceTypes`](#parameter-targetresourcetypes) | array | List of resource type of the target resource(s) on which the alert is created/updated. For example if the scope is a resource group and targetResourceTypes is Microsoft.Compute/virtualMachines, then a different alert will be fired for each virtual machine in the resource group which meet the alert criteria. Relevant only for rules of the kind LogAlert. |

### Parameter: `criterias`

The rule criteria that defines the conditions of the scheduled query rule.

- Required: Yes
- Type: object

### Parameter: `name`

The name of the Alert.

- Required: Yes
- Type: string

### Parameter: `scopes`

The list of resource IDs that this scheduled query rule is scoped to.

- Required: Yes
- Type: array

### Parameter: `windowSize`

The period of time (in ISO 8601 duration format) on which the Alert query will be executed (bin size). Required if the kind is set to 'LogAlert', otherwise not relevant.

- Required: No
- Type: string

### Parameter: `actions`

Actions to invoke when the alert fires.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actionGroupResourceIds`](#parameter-actionsactiongroupresourceids) | array | Action Group resource Ids to invoke when the alert fires. |
| [`actionProperties`](#parameter-actionsactionproperties) | object | The properties of an action properties. |
| [`customProperties`](#parameter-actionscustomproperties) | object | The properties of an alert payload. |

### Parameter: `actions.actionGroupResourceIds`

Action Group resource Ids to invoke when the alert fires.

- Required: No
- Type: array

### Parameter: `actions.actionProperties`

The properties of an action properties.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-actionsactionproperties>any_other_property<) | string | A property of an action payload. |

### Parameter: `actions.actionProperties.>Any_other_property<`

A property of an action payload.

- Required: Yes
- Type: string

### Parameter: `actions.customProperties`

The properties of an alert payload.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`>Any_other_property<`](#parameter-actionscustomproperties>any_other_property<) | string | A custom property of an action payload. |

### Parameter: `actions.customProperties.>Any_other_property<`

A custom property of an action payload.

- Required: Yes
- Type: string

### Parameter: `alertDescription`

The description of the scheduled query rule.

- Required: No
- Type: string
- Default: `''`

### Parameter: `alertDisplayName`

The display name of the scheduled query rule.

- Required: No
- Type: string

### Parameter: `autoMitigate`

The flag that indicates whether the alert should be automatically resolved or not. Relevant only for rules of the kind LogAlert. Note, ResolveConfiguration can't be used together with AutoMitigate.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enabled`

The flag which indicates whether this scheduled query rule is enabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `evaluationFrequency`

How often the scheduled query rule is evaluated represented in ISO 8601 duration format. Relevant and required only for rules of the kind LogAlert.

- Required: No
- Type: string

### Parameter: `kind`

Indicates the type of scheduled query rule.

- Required: No
- Type: string
- Default: `'LogAlert'`
- Allowed:
  ```Bicep
  [
    'LogAlert'
    'LogToMetric'
  ]
  ```

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

### Parameter: `managedIdentities`

The managed identity definition for this resource. You can only configure either a system-assigned or user-assigned identities, not both.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.

- Required: No
- Type: array

### Parameter: `queryTimeRange`

If specified (in ISO 8601 duration format) then overrides the query time range. Relevant only for rules of the kind LogAlert.

- Required: No
- Type: string

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

### Parameter: `ruleResolveConfiguration`

Defines the configuration for resolving fired alerts. Relevant only for rules of the kind LogAlert. Note, ResolveConfiguration can't be used together with AutoMitigate.

- Required: No
- Type: object

### Parameter: `severity`

Severity of the alert. Should be an integer between [0-4]. Value of 0 is severest. Relevant and required only for rules of the kind LogAlert.

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

### Parameter: `skipQueryValidation`

The flag which indicates whether the provided query should be validated or not. Relevant only for rules of the kind LogAlert.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `suppressForMinutes`

Mute actions for the chosen period of time (in ISO 8601 duration format) after the alert is fired. If set, autoMitigate must be disabled. Relevant only for rules of the kind LogAlert.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `targetResourceTypes`

List of resource type of the target resource(s) on which the alert is created/updated. For example if the scope is a resource group and targetResourceTypes is Microsoft.Compute/virtualMachines, then a different alert will be fired for each virtual machine in the resource group which meet the alert criteria. Relevant only for rules of the kind LogAlert.

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The Name of the created scheduled query rule. |
| `resourceGroupName` | string | The Resource Group of the created scheduled query rule. |
| `resourceId` | string | The resource ID of the created scheduled query rule. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
