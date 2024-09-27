# Logic Apps (Workflows) `[Microsoft.Logic/workflows]`

This module deploys a Logic App (Workflow).

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Notes](#Notes)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/diagnosticSettings` | [2021-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2021-05-01-preview/diagnosticSettings) |
| `Microsoft.Logic/workflows` | [2019-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/workflows) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/logic/workflow:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module workflow 'br/public:avm/res/logic/workflow:<version>' = {
  name: 'workflowDeployment'
  params: {
    // Required parameters
    name: 'lwmin001'
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
      "value": "lwmin001"
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
module workflow 'br/public:avm/res/logic/workflow:<version>' = {
  name: 'workflowDeployment'
  params: {
    // Required parameters
    name: 'lwmax001'
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
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    roleAssignments: [
      {
        name: '1f98c16b-ea00-4686-8b81-05353b594ea3'
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
    workflowActions: {
      HTTP: {
        inputs: {
          body: {
            BeginPeakTime: '<BeginPeakTime>'
            EndPeakTime: '<EndPeakTime>'
            HostPoolName: '<HostPoolName>'
            LAWorkspaceName: '<LAWorkspaceName>'
            LimitSecondsToForceLogOffUser: '<LimitSecondsToForceLogOffUser>'
            LogOffMessageBody: '<LogOffMessageBody>'
            LogOffMessageTitle: '<LogOffMessageTitle>'
            MinimumNumberOfRDSH: 1
            ResourceGroupName: '<ResourceGroupName>'
            SessionThresholdPerCPU: 1
            UtcOffset: '<UtcOffset>'
          }
          method: 'POST'
          uri: 'https://testStringForValidation.com'
        }
        type: 'Http'
      }
    }
    workflowTriggers: {
      Recurrence: {
        recurrence: {
          frequency: 'Minute'
          interval: 15
        }
        type: 'Recurrence'
      }
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
      "value": "lwmax001"
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
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "roleAssignments": {
      "value": [
        {
          "name": "1f98c16b-ea00-4686-8b81-05353b594ea3",
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
    "workflowActions": {
      "value": {
        "HTTP": {
          "inputs": {
            "body": {
              "BeginPeakTime": "<BeginPeakTime>",
              "EndPeakTime": "<EndPeakTime>",
              "HostPoolName": "<HostPoolName>",
              "LAWorkspaceName": "<LAWorkspaceName>",
              "LimitSecondsToForceLogOffUser": "<LimitSecondsToForceLogOffUser>",
              "LogOffMessageBody": "<LogOffMessageBody>",
              "LogOffMessageTitle": "<LogOffMessageTitle>",
              "MinimumNumberOfRDSH": 1,
              "ResourceGroupName": "<ResourceGroupName>",
              "SessionThresholdPerCPU": 1,
              "UtcOffset": "<UtcOffset>"
            },
            "method": "POST",
            "uri": "https://testStringForValidation.com"
          },
          "type": "Http"
        }
      }
    },
    "workflowTriggers": {
      "value": {
        "Recurrence": {
          "recurrence": {
            "frequency": "Minute",
            "interval": 15
          },
          "type": "Recurrence"
        }
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
module workflow 'br/public:avm/res/logic/workflow:<version>' = {
  name: 'workflowDeployment'
  params: {
    // Required parameters
    name: 'lwwaf001'
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
    location: '<location>'
    lock: {
      kind: 'CanNotDelete'
      name: 'myCustomLockName'
    }
    managedIdentities: {
      userAssignedResourceIds: [
        '<managedIdentityResourceId>'
      ]
    }
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    workflowActions: {
      HTTP: {
        inputs: {
          body: {
            BeginPeakTime: '<BeginPeakTime>'
            EndPeakTime: '<EndPeakTime>'
            HostPoolName: '<HostPoolName>'
            LAWorkspaceName: '<LAWorkspaceName>'
            LimitSecondsToForceLogOffUser: '<LimitSecondsToForceLogOffUser>'
            LogOffMessageBody: '<LogOffMessageBody>'
            LogOffMessageTitle: '<LogOffMessageTitle>'
            MinimumNumberOfRDSH: 1
            ResourceGroupName: '<ResourceGroupName>'
            SessionThresholdPerCPU: 1
            UtcOffset: '<UtcOffset>'
          }
          method: 'POST'
          uri: 'https://testStringForValidation.com'
        }
        type: 'Http'
      }
    }
    workflowTriggers: {
      Recurrence: {
        recurrence: {
          frequency: 'Minute'
          interval: 15
        }
        type: 'Recurrence'
      }
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
      "value": "lwwaf001"
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
        "userAssignedResourceIds": [
          "<managedIdentityResourceId>"
        ]
      }
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "workflowActions": {
      "value": {
        "HTTP": {
          "inputs": {
            "body": {
              "BeginPeakTime": "<BeginPeakTime>",
              "EndPeakTime": "<EndPeakTime>",
              "HostPoolName": "<HostPoolName>",
              "LAWorkspaceName": "<LAWorkspaceName>",
              "LimitSecondsToForceLogOffUser": "<LimitSecondsToForceLogOffUser>",
              "LogOffMessageBody": "<LogOffMessageBody>",
              "LogOffMessageTitle": "<LogOffMessageTitle>",
              "MinimumNumberOfRDSH": 1,
              "ResourceGroupName": "<ResourceGroupName>",
              "SessionThresholdPerCPU": 1,
              "UtcOffset": "<UtcOffset>"
            },
            "method": "POST",
            "uri": "https://testStringForValidation.com"
          },
          "type": "Http"
        }
      }
    },
    "workflowTriggers": {
      "value": {
        "Recurrence": {
          "recurrence": {
            "frequency": "Minute",
            "interval": 15
          },
          "type": "Recurrence"
        }
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
| [`name`](#parameter-name) | string | The logic app workflow name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`actionsAccessControlConfiguration`](#parameter-actionsaccesscontrolconfiguration) | object | The access control configuration for workflow actions. |
| [`connectorEndpointsConfiguration`](#parameter-connectorendpointsconfiguration) | object | The endpoints configuration:  Access endpoint and outgoing IP addresses for the connector. |
| [`contentsAccessControlConfiguration`](#parameter-contentsaccesscontrolconfiguration) | object | The access control configuration for accessing workflow run contents. |
| [`definitionParameters`](#parameter-definitionparameters) | object | Parameters for the definition template. |
| [`diagnosticSettings`](#parameter-diagnosticsettings) | array | The diagnostic settings of the service. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`integrationAccount`](#parameter-integrationaccount) | object | The integration account. |
| [`integrationServiceEnvironment`](#parameter-integrationserviceenvironment) | object | The integration service environment settings. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`state`](#parameter-state) | string | The state. - NotSpecified, Completed, Enabled, Disabled, Deleted, Suspended. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`triggersAccessControlConfiguration`](#parameter-triggersaccesscontrolconfiguration) | object | The access control configuration for invoking workflow triggers. |
| [`workflowActions`](#parameter-workflowactions) | object | The definitions for one or more actions to execute at workflow runtime. |
| [`workflowEndpointsConfiguration`](#parameter-workflowendpointsconfiguration) | object | The endpoints configuration:  Access endpoint and outgoing IP addresses for the workflow. |
| [`workflowManagementAccessControlConfiguration`](#parameter-workflowmanagementaccesscontrolconfiguration) | object | The access control configuration for workflow management. |
| [`workflowOutputs`](#parameter-workflowoutputs) | object | The definitions for the outputs to return from a workflow run. |
| [`workflowParameters`](#parameter-workflowparameters) | object | The definitions for one or more parameters that pass the values to use at your logic app's runtime. |
| [`workflowStaticResults`](#parameter-workflowstaticresults) | object | The definitions for one or more static results returned by actions as mock outputs when static results are enabled on those actions. In each action definition, the runtimeConfiguration.staticResult.name attribute references the corresponding definition inside staticResults. |
| [`workflowTriggers`](#parameter-workflowtriggers) | object | The definitions for one or more triggers that instantiate your workflow. You can define more than one trigger, but only with the Workflow Definition Language, not visually through the Logic Apps Designer. |

### Parameter: `name`

The logic app workflow name.

- Required: Yes
- Type: string

### Parameter: `actionsAccessControlConfiguration`

The access control configuration for workflow actions.

- Required: No
- Type: object

### Parameter: `connectorEndpointsConfiguration`

The endpoints configuration:  Access endpoint and outgoing IP addresses for the connector.

- Required: No
- Type: object

### Parameter: `contentsAccessControlConfiguration`

The access control configuration for accessing workflow run contents.

- Required: No
- Type: object

### Parameter: `definitionParameters`

Parameters for the definition template.

- Required: No
- Type: object

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

### Parameter: `integrationAccount`

The integration account.

- Required: No
- Type: object

### Parameter: `integrationServiceEnvironment`

The integration service environment settings.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-integrationserviceenvironmentid) | string | The integration service environment Id. |

### Parameter: `integrationServiceEnvironment.id`

The integration service environment Id.

- Required: No
- Type: string

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

The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`systemAssigned`](#parameter-managedidentitiessystemassigned) | bool | Enables system assigned managed identity on the resource. |
| [`userAssignedResourceIds`](#parameter-managedidentitiesuserassignedresourceids) | array | The resource ID(s) to assign to the resource. |

### Parameter: `managedIdentities.systemAssigned`

Enables system assigned managed identity on the resource.

- Required: No
- Type: bool

### Parameter: `managedIdentities.userAssignedResourceIds`

The resource ID(s) to assign to the resource.

- Required: No
- Type: array

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Logic App Contributor'`
  - `'Logic App Operator'`
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

### Parameter: `state`

The state. - NotSpecified, Completed, Enabled, Disabled, Deleted, Suspended.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Completed'
    'Deleted'
    'Disabled'
    'Enabled'
    'NotSpecified'
    'Suspended'
  ]
  ```

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `triggersAccessControlConfiguration`

The access control configuration for invoking workflow triggers.

- Required: No
- Type: object

### Parameter: `workflowActions`

The definitions for one or more actions to execute at workflow runtime.

- Required: No
- Type: object

### Parameter: `workflowEndpointsConfiguration`

The endpoints configuration:  Access endpoint and outgoing IP addresses for the workflow.

- Required: No
- Type: object

### Parameter: `workflowManagementAccessControlConfiguration`

The access control configuration for workflow management.

- Required: No
- Type: object

### Parameter: `workflowOutputs`

The definitions for the outputs to return from a workflow run.

- Required: No
- Type: object

### Parameter: `workflowParameters`

The definitions for one or more parameters that pass the values to use at your logic app's runtime.

- Required: No
- Type: object

### Parameter: `workflowStaticResults`

The definitions for one or more static results returned by actions as mock outputs when static results are enabled on those actions. In each action definition, the runtimeConfiguration.staticResult.name attribute references the corresponding definition inside staticResults.

- Required: No
- Type: object

### Parameter: `workflowTriggers`

The definitions for one or more triggers that instantiate your workflow. You can define more than one trigger, but only with the Workflow Definition Language, not visually through the Logic Apps Designer.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the logic app. |
| `resourceGroupName` | string | The resource group the logic app was deployed into. |
| `resourceId` | string | The resource ID of the logic app. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Notes

### Parameter Usage `<accessControl>AccessControlConfiguration`

- `actionsAccessControlConfiguration`
- `contentsAccessControlConfiguration`
- `triggersAccessControlConfiguration`
- `workflowManagementAccessControlConfiguration`

<details>

<summary>Parameter JSON format</summary>

```json
"<accessControl>AccessControlConfiguration": {
    "value": {
        "allowedCallerIpAddresses": [
            {
                "addressRange": "string"
            }
        ],
        "openAuthenticationPolicies": {
            "policies": {}
        }
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
'<accessControl>AccessControlConfiguration': {
    allowedCallerIpAddresses: [
        {
            addressRange: 'string'
        }
    ]
    openAuthenticationPolicies: {
        policies: {}
    }
}
```

</details>
<p>

### Parameter Usage `<flow>EndpointsConfiguration`

- `connectorEndpointsConfiguration`
- `workflowEndpointsConfiguration`

<details>

<summary>Parameter JSON format</summary>

```json
"<flow>EndpointsConfiguration": {
    "value": {
        "outgoingIpAddresses": [
            {
                "address": "string"
            }
        ],
            "accessEndpointIpAddresses": [
            {
                "address": "string"
            }
        ]
    }
}
```

</details>

<details>

<summary>Bicep format</summary>

```bicep
'<flow>EndpointsConfiguration': {
    outgoingIpAddresses: [
        {
            address: 'string'
        }
    ]
    accessEndpointIpAddresses: [
        {
            address: 'string'
        }
    ]
}
```

</details>
<p>

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
