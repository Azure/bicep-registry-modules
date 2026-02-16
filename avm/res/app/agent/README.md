# SRE Agents `[Microsoft.App/agents]`

This module deploys an Azure SRE Agent (Microsoft.App/agents).

You can reference the module as follows:
```bicep
module agent 'br/public:avm/res/app/agent:<version>' = {
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
| `Microsoft.App/agents` | 2025-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_agents.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates)</li></ul> |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.Insights/diagnosticSettings` | 2021-05-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.insights_diagnosticsettings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings)</li></ul> |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/app/agent:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/defaults]


<details>

<summary>via Bicep module</summary>

```bicep
module agent 'br/public:avm/res/app/agent:<version>' = {
  params: {
    // Required parameters
    name: 'aagmin001'
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
      "value": "aagmin001"
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
using 'br/public:avm/res/app/agent:<version>'

// Required parameters
param name = 'aagmin001'
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _Using large parameter set_

This instance deploys the module with most of its features enabled.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/max]


<details>

<summary>via Bicep module</summary>

```bicep
module agent 'br/public:avm/res/app/agent:<version>' = {
  params: {
    // Required parameters
    name: 'aagmax001'
    // Non-required parameters
    accessLevel: 'High'
    actionIdentityResourceId: '<actionIdentityResourceId>'
    agentMode: 'Review'
    applicationInsightsAppId: '<applicationInsightsAppId>'
    applicationInsightsConnectionString: '<applicationInsightsConnectionString>'
    incidentManagementConfigurationType: 'AzMonitor'
    knowledgeGraphIdentityResourceId: '<knowledgeGraphIdentityResourceId>'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    monthlyAgentUnitLimit: 10000
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    upgradeChannel: 'Stable'
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
      "value": "aagmax001"
    },
    // Non-required parameters
    "accessLevel": {
      "value": "High"
    },
    "actionIdentityResourceId": {
      "value": "<actionIdentityResourceId>"
    },
    "agentMode": {
      "value": "Review"
    },
    "applicationInsightsAppId": {
      "value": "<applicationInsightsAppId>"
    },
    "applicationInsightsConnectionString": {
      "value": "<applicationInsightsConnectionString>"
    },
    "incidentManagementConfigurationType": {
      "value": "AzMonitor"
    },
    "knowledgeGraphIdentityResourceId": {
      "value": "<knowledgeGraphIdentityResourceId>"
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
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "monthlyAgentUnitLimit": {
      "value": 10000
    },
    "roleAssignments": {
      "value": [
        {
          "principalId": "<principalId>",
          "principalType": "ServicePrincipal",
          "roleDefinitionIdOrName": "Reader"
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
    "upgradeChannel": {
      "value": "Stable"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/app/agent:<version>'

// Required parameters
param name = 'aagmax001'
// Non-required parameters
param accessLevel = 'High'
param actionIdentityResourceId = '<actionIdentityResourceId>'
param agentMode = 'Review'
param applicationInsightsAppId = '<applicationInsightsAppId>'
param applicationInsightsConnectionString = '<applicationInsightsConnectionString>'
param incidentManagementConfigurationType = 'AzMonitor'
param knowledgeGraphIdentityResourceId = '<knowledgeGraphIdentityResourceId>'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'myCustomLockName'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param monthlyAgentUnitLimit = 10000
param roleAssignments = [
  {
    principalId: '<principalId>'
    principalType: 'ServicePrincipal'
    roleDefinitionIdOrName: 'Reader'
  }
]
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param upgradeChannel = 'Stable'
```

</details>
<p>

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.

You can find the full example and the setup of its dependencies in the deployment test folder path [/tests/e2e/waf-aligned]


<details>

<summary>via Bicep module</summary>

```bicep
module agent 'br/public:avm/res/app/agent:<version>' = {
  params: {
    // Required parameters
    name: 'aagwaf001'
    // Non-required parameters
    accessLevel: 'High'
    actionIdentityResourceId: '<actionIdentityResourceId>'
    agentMode: 'Review'
    applicationInsightsAppId: '<applicationInsightsAppId>'
    applicationInsightsConnectionString: '<applicationInsightsConnectionString>'
    incidentManagementConfigurationType: 'AzMonitor'
    knowledgeGraphIdentityResourceId: '<knowledgeGraphIdentityResourceId>'
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'agentLock'
    }
    managedIdentities: {
      systemAssigned: true
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    monthlyAgentUnitLimit: 10000
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    upgradeChannel: 'Stable'
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
      "value": "aagwaf001"
    },
    // Non-required parameters
    "accessLevel": {
      "value": "High"
    },
    "actionIdentityResourceId": {
      "value": "<actionIdentityResourceId>"
    },
    "agentMode": {
      "value": "Review"
    },
    "applicationInsightsAppId": {
      "value": "<applicationInsightsAppId>"
    },
    "applicationInsightsConnectionString": {
      "value": "<applicationInsightsConnectionString>"
    },
    "incidentManagementConfigurationType": {
      "value": "AzMonitor"
    },
    "knowledgeGraphIdentityResourceId": {
      "value": "<knowledgeGraphIdentityResourceId>"
    },
    "location": {
      "value": "<location>"
    },
    "lock": {
      "value": {
        "kind": "CanNotDelete",
        "name": "agentLock"
      }
    },
    "managedIdentities": {
      "value": {
        "systemAssigned": true,
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "monthlyAgentUnitLimit": {
      "value": 10000
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "upgradeChannel": {
      "value": "Stable"
    }
  }
}
```

</details>
<p>

<details>

<summary>via Bicep parameters file</summary>

```bicep-params
using 'br/public:avm/res/app/agent:<version>'

// Required parameters
param name = 'aagwaf001'
// Non-required parameters
param accessLevel = 'High'
param actionIdentityResourceId = '<actionIdentityResourceId>'
param agentMode = 'Review'
param applicationInsightsAppId = '<applicationInsightsAppId>'
param applicationInsightsConnectionString = '<applicationInsightsConnectionString>'
param incidentManagementConfigurationType = 'AzMonitor'
param knowledgeGraphIdentityResourceId = '<knowledgeGraphIdentityResourceId>'
param location = '<location>'
param lock = {
  kind: 'CanNotDelete'
  name: 'agentLock'
}
param managedIdentities = {
  systemAssigned: true
  userAssignedResourceIds: [
    '<managedIdentityResourceId>'
  ]
}
param monthlyAgentUnitLimit = 10000
param tags = {
  Environment: 'Non-Prod'
  'hidden-title': 'This is visible in the resource name'
  Role: 'DeploymentValidation'
}
param upgradeChannel = 'Stable'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the SRE Agent. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessLevel`](#parameter-accesslevel) | string | THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The access level for the SRE Agent managed identity. Determines which RBAC roles are available for tool execution. |
| [`actionIdentityResourceId`](#parameter-actionidentityresourceid) | string | THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The resource ID of an existing User-Assigned Managed Identity to use for action execution. If not provided, falls back to knowledgeGraphIdentityResourceId or the first user-assigned identity. |
| [`agentMode`](#parameter-agentmode) | string | THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The agent execution mode. Review requires human approval, Autonomous auto-executes, ReadOnly is observation-only. |
| [`applicationInsightsAppId`](#parameter-applicationinsightsappid) | string | THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The Application Insights App ID for agent telemetry. Required for log configuration. |
| [`applicationInsightsConnectionString`](#parameter-applicationinsightsconnectionstring) | string | THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The Application Insights connection string for agent telemetry. Required for log configuration. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`incidentManagementConfigurationType`](#parameter-incidentmanagementconfigurationtype) | string | THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The incident management configuration type for the SRE Agent. |
| [`knowledgeGraphIdentityResourceId`](#parameter-knowledgegraphidentityresourceid) | string | THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The resource ID of an existing User-Assigned Managed Identity to use for the knowledge graph and action configuration. If not provided and a user-assigned identity is specified in managedIdentities, the first one will be used. |
| [`knowledgeGraphManagedResources`](#parameter-knowledgegraphmanagedresources) | array | THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The managed resources array for the knowledge graph configuration. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. The SRE Agent requires a User-Assigned Managed Identity for knowledge graph and action execution. |
| [`monthlyAgentUnitLimit`](#parameter-monthlyagentunitlimit) | int | THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The monthly Agent Activity Unit (AAU) limit for the SRE Agent. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`upgradeChannel`](#parameter-upgradechannel) | string | THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The upgrade channel for the SRE Agent. |

### Parameter: `name`

Name of the SRE Agent.

- Required: Yes
- Type: string

### Parameter: `accessLevel`

THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The access level for the SRE Agent managed identity. Determines which RBAC roles are available for tool execution.

- Required: No
- Type: string
- Default: `'High'`
- Allowed:
  ```Bicep
  [
    'High'
    'Low'
  ]
  ```

### Parameter: `actionIdentityResourceId`

THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The resource ID of an existing User-Assigned Managed Identity to use for action execution. If not provided, falls back to knowledgeGraphIdentityResourceId or the first user-assigned identity.

- Required: No
- Type: string
- Default: `''`

### Parameter: `agentMode`

THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The agent execution mode. Review requires human approval, Autonomous auto-executes, ReadOnly is observation-only.

- Required: No
- Type: string
- Default: `'Review'`
- Allowed:
  ```Bicep
  [
    'Autonomous'
    'ReadOnly'
    'Review'
  ]
  ```

### Parameter: `applicationInsightsAppId`

THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The Application Insights App ID for agent telemetry. Required for log configuration.

- Required: No
- Type: string
- Default: `''`

### Parameter: `applicationInsightsConnectionString`

THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The Application Insights connection string for agent telemetry. Required for log configuration.

- Required: No
- Type: string
- Default: `''`

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
| [`marketplacePartnerResourceId`](#parameter-diagnosticsettingsmarketplacepartnerresourceid) | string | The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs. |
| [`metricCategories`](#parameter-diagnosticsettingsmetriccategories) | array | The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection. |
| [`name`](#parameter-diagnosticsettingsname) | string | The name of diagnostic setting. |
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

The name of diagnostic setting.

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

### Parameter: `incidentManagementConfigurationType`

THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The incident management configuration type for the SRE Agent.

- Required: No
- Type: string
- Default: `'AzMonitor'`
- Allowed:
  ```Bicep
  [
    'AzMonitor'
    'None'
  ]
  ```

### Parameter: `knowledgeGraphIdentityResourceId`

THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The resource ID of an existing User-Assigned Managed Identity to use for the knowledge graph and action configuration. If not provided and a user-assigned identity is specified in managedIdentities, the first one will be used.

- Required: No
- Type: string
- Default: `''`

### Parameter: `knowledgeGraphManagedResources`

THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The managed resources array for the knowledge graph configuration.

- Required: No
- Type: array
- Default: `[]`

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

### Parameter: `managedIdentities`

The managed identity definition for this resource. The SRE Agent requires a User-Assigned Managed Identity for knowledge graph and action execution.

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

### Parameter: `monthlyAgentUnitLimit`

THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The monthly Agent Activity Unit (AAU) limit for the SRE Agent.

- Required: No
- Type: int
- Default: `10000`

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
  - `'SRE Agent Administrator'`

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

### Parameter: `upgradeChannel`

THIS IS A PARAMETER USED FOR A PREVIEW SERVICE/FEATURE. The upgrade channel for the SRE Agent.

- Required: No
- Type: string
- Default: `'Stable'`
- Allowed:
  ```Bicep
  [
    'Preview'
    'Stable'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `agentEndpoint` | string | The endpoint of the SRE Agent. |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the SRE Agent. |
| `provisioningState` | string | The provisioning state of the SRE Agent. |
| `resourceGroupName` | string | The name of the resource group the SRE Agent was deployed into. |
| `resourceId` | string | The resource ID of the SRE Agent. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.6.1` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
