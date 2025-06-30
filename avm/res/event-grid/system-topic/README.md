# Event Grid System Topics `[Microsoft.EventGrid/systemTopics]`

This module deploys an Event Grid System Topic.

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
| `Microsoft.EventGrid/systemTopics` | [2025-02-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2025-02-15/systemTopics) |
| `Microsoft.EventGrid/systemTopics/eventSubscriptions` | [2025-02-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2025-02-15/systemTopics/eventSubscriptions) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/event-grid/system-topic:<version>`.

- [Using only defaults with managed identity](#example-1-using-only-defaults-with-managed-identity)
- [Using managed identity authentication](#example-2-using-managed-identity-authentication)
- [Using large parameter set](#example-3-using-large-parameter-set)
- [WAF-aligned with managed identity](#example-4-waf-aligned-with-managed-identity)

### Example 1: _Using only defaults with managed identity_

This instance deploys the module with the minimum set of required parameters and uses managed identities to deliver Event Grid Topic events.


<details>

<summary>via Bicep module</summary>

```bicep
module systemTopic 'br/public:avm/res/event-grid/system-topic:<version>' = {
  name: 'systemTopicDeployment'
  params: {
    // Required parameters
    name: 'egstmin001'
    source: '<source>'
    topicType: 'Microsoft.Storage.StorageAccounts'
    // Non-required parameters
    location: '<location>'
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
      "value": "egstmin001"
    },
    "source": {
      "value": "<source>"
    },
    "topicType": {
      "value": "Microsoft.Storage.StorageAccounts"
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

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/event-grid/system-topic:<version>'

// Required parameters
param name = 'egstmin001'
param source = '<source>'
param topicType = 'Microsoft.Storage.StorageAccounts'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using managed identity authentication_

This instance deploys the module testing delivery with resource identity (managed identity authentication).


<details>

<summary>via Bicep module</summary>

```bicep
module systemTopic 'br/public:avm/res/event-grid/system-topic:<version>' = {
  name: 'systemTopicDeployment'
  params: {
    // Required parameters
    name: 'egstid001'
    source: '<source>'
    topicType: 'Microsoft.Storage.StorageAccounts'
    // Non-required parameters
    eventSubscriptions: [
      {
        deliveryWithResourceIdentity: {
          destination: {
            endpointType: 'ServiceBusTopic'
            properties: {
              resourceId: '<resourceId>'
            }
          }
          identity: {
            type: 'UserAssigned'
            userAssignedIdentity: '<userAssignedIdentity>'
          }
        }
        eventDeliverySchema: 'CloudEventSchemaV1_0'
        expirationTimeUtc: '2099-01-01T11:00:21.715Z'
        filter: {
          enableAdvancedFilteringOnArrays: true
          isSubjectCaseSensitive: false
        }
        name: 'egstidSub'
        retryPolicy: {
          eventTimeToLive: '120'
          maxDeliveryAttempts: 10
        }
      }
    ]
    location: '<location>'
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    tags: {
      Environment: 'Non-Prod'
      'fix-verification': 'true'
      Role: 'DeploymentValidation'
      'test-scenario': 'delivery-with-resource-identity'
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
      "value": "egstid001"
    },
    "source": {
      "value": "<source>"
    },
    "topicType": {
      "value": "Microsoft.Storage.StorageAccounts"
    },
    // Non-required parameters
    "eventSubscriptions": {
      "value": [
        {
          "deliveryWithResourceIdentity": {
            "destination": {
              "endpointType": "ServiceBusTopic",
              "properties": {
                "resourceId": "<resourceId>"
              }
            },
            "identity": {
              "type": "UserAssigned",
              "userAssignedIdentity": "<userAssignedIdentity>"
            }
          },
          "eventDeliverySchema": "CloudEventSchemaV1_0",
          "expirationTimeUtc": "2099-01-01T11:00:21.715Z",
          "filter": {
            "enableAdvancedFilteringOnArrays": true,
            "isSubjectCaseSensitive": false
          },
          "name": "egstidSub",
          "retryPolicy": {
            "eventTimeToLive": "120",
            "maxDeliveryAttempts": 10
          }
        }
      ]
    },
    "location": {
      "value": "<location>"
    },
    "managedIdentities": {
      "value": {
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "fix-verification": "true",
        "Role": "DeploymentValidation",
        "test-scenario": "delivery-with-resource-identity"
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
using 'br/public:avm/res/event-grid/system-topic:<version>'

// Required parameters
param name = 'egstid001'
param source = '<source>'
param topicType = 'Microsoft.Storage.StorageAccounts'
// Non-required parameters
param eventSubscriptions = [
  {
    deliveryWithResourceIdentity: {
      destination: {
        endpointType: 'ServiceBusTopic'
        properties: {
          resourceId: '<resourceId>'
        }
      }
      identity: {
        type: 'UserAssigned'
        userAssignedIdentity: '<userAssignedIdentity>'
      }
    }
    eventDeliverySchema: 'CloudEventSchemaV1_0'
    expirationTimeUtc: '2099-01-01T11:00:21.715Z'
    filter: {
      enableAdvancedFilteringOnArrays: true
      isSubjectCaseSensitive: false
    }
    name: 'egstidSub'
    retryPolicy: {
      eventTimeToLive: '120'
      maxDeliveryAttempts: 10
    }
  }
]
param location = '<location>'
param managedIdentities = {
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param tags = {
  Environment: 'Non-Prod'
  'fix-verification': 'true'
  Role: 'DeploymentValidation'
  'test-scenario': 'delivery-with-resource-identity'
}
```

</details>
<p>

### Example 3: _Using large parameter set_

This instance deploys the module with most of its features enabled.


<details>

<summary>via Bicep module</summary>

```bicep
module systemTopic 'br/public:avm/res/event-grid/system-topic:<version>' = {
  name: 'systemTopicDeployment'
  params: {
    // Required parameters
    name: 'egstmax001'
    source: '<source>'
    topicType: 'Microsoft.Storage.StorageAccounts'
    // Non-required parameters
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
    eventSubscriptions: [
      {
        destination: {
          endpointType: 'StorageQueue'
          properties: {
            queueMessageTimeToLiveInSeconds: 86400
            queueName: '<queueName>'
            resourceId: '<resourceId>'
          }
        }
        eventDeliverySchema: 'CloudEventSchemaV1_0'
        expirationTimeUtc: '2099-01-01T11:00:21.715Z'
        filter: {
          enableAdvancedFilteringOnArrays: true
          isSubjectCaseSensitive: false
        }
        name: 'egstmax001'
        retryPolicy: {
          eventTimeToLiveInMinutes: 120
          maxDeliveryAttempts: 10
        }
      }
    ]
    externalResourceRoleAssignments: [
      {
        description: 'Allow Event Grid System Topic to write to storage queue'
        resourceId: '<resourceId>'
        roleDefinitionId: '974c5e8b-45b9-4653-ba55-5f855dd0fb88'
      }
      {
        description: 'Allow Event Grid System Topic to send messages to storage queue'
        resourceId: '<resourceId>'
        roleDefinitionId: 'c6a89b2d-59bc-44d0-9896-0f6e12d7b80a'
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
    }
    roleAssignments: [
      {
        name: 'c9beca28-efcf-4d1d-99aa-8f334484a2c2'
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
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
    "name": {
      "value": "egstmax001"
    },
    "source": {
      "value": "<source>"
    },
    "topicType": {
      "value": "Microsoft.Storage.StorageAccounts"
    },
    // Non-required parameters
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
    "eventSubscriptions": {
      "value": [
        {
          "destination": {
            "endpointType": "StorageQueue",
            "properties": {
              "queueMessageTimeToLiveInSeconds": 86400,
              "queueName": "<queueName>",
              "resourceId": "<resourceId>"
            }
          },
          "eventDeliverySchema": "CloudEventSchemaV1_0",
          "expirationTimeUtc": "2099-01-01T11:00:21.715Z",
          "filter": {
            "enableAdvancedFilteringOnArrays": true,
            "isSubjectCaseSensitive": false
          },
          "name": "egstmax001",
          "retryPolicy": {
            "eventTimeToLiveInMinutes": 120,
            "maxDeliveryAttempts": 10
          }
        }
      ]
    },
    "externalResourceRoleAssignments": {
      "value": [
        {
          "description": "Allow Event Grid System Topic to write to storage queue",
          "resourceId": "<resourceId>",
          "roleDefinitionId": "974c5e8b-45b9-4653-ba55-5f855dd0fb88"
        },
        {
          "description": "Allow Event Grid System Topic to send messages to storage queue",
          "resourceId": "<resourceId>",
          "roleDefinitionId": "c6a89b2d-59bc-44d0-9896-0f6e12d7b80a"
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
    "managedIdentities": {
      "value": {
        "systemAssigned": true
      }
    },
    "roleAssignments": {
      "value": [
        {
          "name": "c9beca28-efcf-4d1d-99aa-8f334484a2c2",
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
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
using 'br/public:avm/res/event-grid/system-topic:<version>'

// Required parameters
param name = 'egstmax001'
param source = '<source>'
param topicType = 'Microsoft.Storage.StorageAccounts'
// Non-required parameters
param diagnosticSettings = [
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
param eventSubscriptions = [
  {
    destination: {
      endpointType: 'StorageQueue'
      properties: {
        queueMessageTimeToLiveInSeconds: 86400
        queueName: '<queueName>'
        resourceId: '<resourceId>'
      }
    }
    eventDeliverySchema: 'CloudEventSchemaV1_0'
    expirationTimeUtc: '2099-01-01T11:00:21.715Z'
    filter: {
      enableAdvancedFilteringOnArrays: true
      isSubjectCaseSensitive: false
    }
    name: 'egstmax001'
    retryPolicy: {
      eventTimeToLiveInMinutes: 120
      maxDeliveryAttempts: 10
    }
  }
]
param externalResourceRoleAssignments = [
  {
    description: 'Allow Event Grid System Topic to write to storage queue'
    resourceId: '<resourceId>'
    roleDefinitionId: '974c5e8b-45b9-4653-ba55-5f855dd0fb88'
  }
  {
    description: 'Allow Event Grid System Topic to send messages to storage queue'
    resourceId: '<resourceId>'
    roleDefinitionId: 'c6a89b2d-59bc-44d0-9896-0f6e12d7b80a'
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
}
param roleAssignments = [
  {
    name: 'c9beca28-efcf-4d1d-99aa-8f334484a2c2'
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: '8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
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

### Example 4: _WAF-aligned with managed identity_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework and uses managed identities to deliver Event Grid Topic events.


<details>

<summary>via Bicep module</summary>

```bicep
module systemTopic 'br/public:avm/res/event-grid/system-topic:<version>' = {
  name: 'systemTopicDeployment'
  params: {
    // Required parameters
    name: 'egstwaf001'
    source: '<source>'
    topicType: 'Microsoft.Storage.StorageAccounts'
    // Non-required parameters
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
    eventSubscriptions: [
      {
        destination: {
          endpointType: 'StorageQueue'
          properties: {
            queueName: '<queueName>'
            resourceId: '<resourceId>'
          }
        }
        eventDeliverySchema: 'CloudEventSchemaV1_0'
        expirationTimeUtc: '2099-01-01T11:00:21.715Z'
        filter: {
          enableAdvancedFilteringOnArrays: true
          isSubjectCaseSensitive: false
        }
        name: 'egstwaf001'
        retryPolicy: {
          eventTimeToLiveInMinutes: 120
          maxDeliveryAttempts: 10
        }
      }
    ]
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
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
    "name": {
      "value": "egstwaf001"
    },
    "source": {
      "value": "<source>"
    },
    "topicType": {
      "value": "Microsoft.Storage.StorageAccounts"
    },
    // Non-required parameters
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
    "eventSubscriptions": {
      "value": [
        {
          "destination": {
            "endpointType": "StorageQueue",
            "properties": {
              "queueName": "<queueName>",
              "resourceId": "<resourceId>"
            }
          },
          "eventDeliverySchema": "CloudEventSchemaV1_0",
          "expirationTimeUtc": "2099-01-01T11:00:21.715Z",
          "filter": {
            "enableAdvancedFilteringOnArrays": true,
            "isSubjectCaseSensitive": false
          },
          "name": "egstwaf001",
          "retryPolicy": {
            "eventTimeToLiveInMinutes": 120,
            "maxDeliveryAttempts": 10
          }
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
using 'br/public:avm/res/event-grid/system-topic:<version>'

// Required parameters
param name = 'egstwaf001'
param source = '<source>'
param topicType = 'Microsoft.Storage.StorageAccounts'
// Non-required parameters
param diagnosticSettings = [
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
param eventSubscriptions = [
  {
    destination: {
      endpointType: 'StorageQueue'
      properties: {
        queueName: '<queueName>'
        resourceId: '<resourceId>'
      }
    }
    eventDeliverySchema: 'CloudEventSchemaV1_0'
    expirationTimeUtc: '2099-01-01T11:00:21.715Z'
    filter: {
      enableAdvancedFilteringOnArrays: true
      isSubjectCaseSensitive: false
    }
    name: 'egstwaf001'
    retryPolicy: {
      eventTimeToLiveInMinutes: 120
      maxDeliveryAttempts: 10
    }
  }
]
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
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
| [`name`](#parameter-name) | string | The name of the Event Grid Topic. |
| [`source`](#parameter-source) | string | Source for the system topic. |
| [`topicType`](#parameter-topictype) | string | TopicType for the system topic. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`eventSubscriptions`](#parameter-eventsubscriptions) | array | Event subscriptions to deploy. |
| [`externalResourceRoleAssignments`](#parameter-externalresourceroleassignments) | array | Array of role assignments to create on external resources. This is useful for scenarios where the system topic needs permissions on delivery or dead letter destinations (e.g., Storage Account, Service Bus). Each assignment specifies the target resource ID and role definition ID (GUID). |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

The name of the Event Grid Topic.

- Required: Yes
- Type: string

### Parameter: `source`

Source for the system topic.

- Required: Yes
- Type: string

### Parameter: `topicType`

TopicType for the system topic.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings`

The diagnostic settings of the service.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubAuthorizationRuleResourceId`](#parameter-diagnosticsettingseventhubauthorizationruleresourceid) | string | Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to. |
| [`eventHubName`](#parameter-diagnosticsettingseventhubname) | string | Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`logAnalyticsDestinationType`](#parameter-diagnosticsettingsloganalyticsdestinationtype) | string | A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type. |
| [`logCategoriesAndGroups`](#parameter-diagnosticsettingslogcategoriesandgroups) | array | The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection. |
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of the diagnostic setting. |
| [`storageAccountResourceId`](#parameter-diagnosticsettingsstorageaccountresourceid) | string | Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |
| [`workspaceResourceId`](#parameter-diagnosticsettingsworkspaceresourceid) | string | Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub. |

### Parameter: `diagnosticSettings.eventHubAuthorizationRuleResourceId`

Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.eventHubName`

Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logAnalyticsDestinationType`

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

### Parameter: `diagnosticSettings.logCategoriesAndGroups`

The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingslogcategoriesandgroupscategory) | string | Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here. |
| [`categoryGroup`](#parameter-diagnosticsettingslogcategoriesandgroupscategorygroup) | string | Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs. |
| [`enabled`](#parameter-diagnosticsettingslogcategoriesandgroupsenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.logCategoriesAndGroups.category`

Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.categoryGroup`

Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.logCategoriesAndGroups.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.marketplacePartnerResourceId`

The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.metricCategories`

The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`category`](#parameter-diagnosticsettingsmetriccategoriescategory) | string | Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-diagnosticsettingsmetriccategoriesenabled) | bool | Enable or disable the category explicitly. Default is `true`. |

### Parameter: `diagnosticSettings.metricCategories.category`

Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.

- Required: Yes
- Type: string

### Parameter: `diagnosticSettings.metricCategories.enabled`

Enable or disable the category explicitly. Default is `true`.

- Required: No
- Type: bool

### Parameter: `diagnosticSettings.name`

The name of the diagnostic setting.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.storageAccountResourceId`

Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `diagnosticSettings.workspaceResourceId`

Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.

- Required: No
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `eventSubscriptions`

Event subscriptions to deploy.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-eventsubscriptionsname) | string | The name of the event subscription. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`destination`](#parameter-eventsubscriptionsdestination) | object | Required if deliveryWithResourceIdentity is not provided. The destination for the event subscription. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`deadLetterDestination`](#parameter-eventsubscriptionsdeadletterdestination) | object | Dead Letter Destination. |
| [`deadLetterWithResourceIdentity`](#parameter-eventsubscriptionsdeadletterwithresourceidentity) | object | Dead Letter with Resource Identity Configuration. |
| [`deliveryWithResourceIdentity`](#parameter-eventsubscriptionsdeliverywithresourceidentity) | object | Delivery with Resource Identity Configuration. |
| [`eventDeliverySchema`](#parameter-eventsubscriptionseventdeliveryschema) | string | The event delivery schema for the event subscription. |
| [`expirationTimeUtc`](#parameter-eventsubscriptionsexpirationtimeutc) | string | The expiration time for the event subscription. Format is ISO-8601 (yyyy-MM-ddTHH:mm:ssZ). |
| [`filter`](#parameter-eventsubscriptionsfilter) | object | The filter for the event subscription. |
| [`labels`](#parameter-eventsubscriptionslabels) | array | The list of user defined labels. |
| [`retryPolicy`](#parameter-eventsubscriptionsretrypolicy) | object | The retry policy for events. |

### Parameter: `eventSubscriptions.name`

The name of the event subscription.

- Required: Yes
- Type: string

### Parameter: `eventSubscriptions.destination`

Required if deliveryWithResourceIdentity is not provided. The destination for the event subscription.

- Required: No
- Type: object

### Parameter: `eventSubscriptions.deadLetterDestination`

Dead Letter Destination.

- Required: No
- Type: object

### Parameter: `eventSubscriptions.deadLetterWithResourceIdentity`

Dead Letter with Resource Identity Configuration.

- Required: No
- Type: object

### Parameter: `eventSubscriptions.deliveryWithResourceIdentity`

Delivery with Resource Identity Configuration.

- Required: No
- Type: object

### Parameter: `eventSubscriptions.eventDeliverySchema`

The event delivery schema for the event subscription.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CloudEventSchemaV1_0'
    'CustomInputSchema'
    'EventGridEvent'
    'EventGridSchema'
  ]
  ```

### Parameter: `eventSubscriptions.expirationTimeUtc`

The expiration time for the event subscription. Format is ISO-8601 (yyyy-MM-ddTHH:mm:ssZ).

- Required: No
- Type: string

### Parameter: `eventSubscriptions.filter`

The filter for the event subscription.

- Required: No
- Type: object

### Parameter: `eventSubscriptions.labels`

The list of user defined labels.

- Required: No
- Type: array

### Parameter: `eventSubscriptions.retryPolicy`

The retry policy for events.

- Required: No
- Type: object

### Parameter: `externalResourceRoleAssignments`

Array of role assignments to create on external resources. This is useful for scenarios where the system topic needs permissions on delivery or dead letter destinations (e.g., Storage Account, Service Bus). Each assignment specifies the target resource ID and role definition ID (GUID).

- Required: No
- Type: array
- Default: `[]`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`resourceId`](#parameter-externalresourceroleassignmentsresourceid) | string | The resource ID of the target resource to assign permissions to. |
| [`roleDefinitionId`](#parameter-externalresourceroleassignmentsroledefinitionid) | string | The role definition ID (GUID) or full role definition resource ID. Example: "ba92f5b4-2d11-453d-a403-e96b0029c9fe" or "/subscriptions/{sub}/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-externalresourceroleassignmentsdescription) | string | Description of the role assignment. |
| [`roleName`](#parameter-externalresourceroleassignmentsrolename) | string | Name of the role for logging purposes. |

### Parameter: `externalResourceRoleAssignments.resourceId`

The resource ID of the target resource to assign permissions to.

- Required: Yes
- Type: string

### Parameter: `externalResourceRoleAssignments.roleDefinitionId`

The role definition ID (GUID) or full role definition resource ID. Example: "ba92f5b4-2d11-453d-a403-e96b0029c9fe" or "/subscriptions/{sub}/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe".

- Required: Yes
- Type: string

### Parameter: `externalResourceRoleAssignments.description`

Description of the role assignment.

- Required: No
- Type: string

### Parameter: `externalResourceRoleAssignments.roleName`

Name of the role for logging purposes.

- Required: No
- Type: string

### Parameter: `location`

Location for all Resources.

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

The managed identity definition for this resource.

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

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'EventGrid Contributor'`
  - `'EventGrid Data Sender'`
  - `'EventGrid EventSubscription Contributor'`
  - `'EventGrid EventSubscription Reader'`
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

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the event grid system topic. |
| `resourceGroupName` | string | The name of the resource group the event grid system topic was deployed into. |
| `resourceId` | string | The resource ID of the event grid system topic. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/ptn/authorization/resource-role-assignment:0.1.2` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
