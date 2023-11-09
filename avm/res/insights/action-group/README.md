# Action Groups `[Microsoft.Insights/actionGroups]`

This module deploys an Action Group.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/actionGroups` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-01-01/actionGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/insights/action-group:0.1.2`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module actionGroup 'br/public:avm/res/insights/action-group:0.1.2' = {
  name: '${uniqueString(deployment().name, location)}-test-iagmin'
  params: {
    // Required parameters
    groupShortName: 'agiagmin001'
    name: 'iagmin001'
    // Non-required parameters
    armRoleReceivers: '<armRoleReceivers>'
    automationRunbookReceivers: '<automationRunbookReceivers>'
    azureAppPushReceivers: '<azureAppPushReceivers>'
    azureFunctionReceivers: '<azureFunctionReceivers>'
    emailReceivers: '<emailReceivers>'
    itsmReceivers: '<itsmReceivers>'
    location: 'global'
    logicAppReceivers: '<logicAppReceivers>'
    roleAssignments: '<roleAssignments>'
    smsReceivers: '<smsReceivers>'
    tags: '<tags>'
    voiceReceivers: '<voiceReceivers>'
    webhookReceivers: '<webhookReceivers>'
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
    "groupShortName": {
      "value": "agiagmin001"
    },
    "name": {
      "value": "iagmin001"
    },
    // Non-required parameters
    "armRoleReceivers": {
      "value": "<armRoleReceivers>"
    },
    "automationRunbookReceivers": {
      "value": "<automationRunbookReceivers>"
    },
    "azureAppPushReceivers": {
      "value": "<azureAppPushReceivers>"
    },
    "azureFunctionReceivers": {
      "value": "<azureFunctionReceivers>"
    },
    "emailReceivers": {
      "value": "<emailReceivers>"
    },
    "itsmReceivers": {
      "value": "<itsmReceivers>"
    },
    "location": {
      "value": "global"
    },
    "logicAppReceivers": {
      "value": "<logicAppReceivers>"
    },
    "roleAssignments": {
      "value": "<roleAssignments>"
    },
    "smsReceivers": {
      "value": "<smsReceivers>"
    },
    "tags": {
      "value": "<tags>"
    },
    "voiceReceivers": {
      "value": "<voiceReceivers>"
    },
    "webhookReceivers": {
      "value": "<webhookReceivers>"
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
module actionGroup 'br/public:avm/res/insights/action-group:0.1.2' = {
  name: '${uniqueString(deployment().name, location)}-test-iagmax'
  params: {
    // Required parameters
    groupShortName: 'agiagmax001'
    name: 'iagmax001'
    // Non-required parameters
    emailReceivers: [
      {
        emailAddress: 'test.user@testcompany.com'
        name: 'TestUser_-EmailAction-'
        useCommonAlertSchema: true
      }
      {
        emailAddress: 'test.user2@testcompany.com'
        name: 'TestUser2'
        useCommonAlertSchema: true
      }
    ]
    location: 'global'
    roleAssignments: [
      {
        principalId: '<principalId>'
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
      }
    ]
    smsReceivers: [
      {
        countryCode: '1'
        name: 'TestUser_-SMSAction-'
        phoneNumber: '2345678901'
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

<summary>via JSON Parameter file</summary>

```json
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    // Required parameters
    "groupShortName": {
      "value": "agiagmax001"
    },
    "name": {
      "value": "iagmax001"
    },
    // Non-required parameters
    "emailReceivers": {
      "value": [
        {
          "emailAddress": "test.user@testcompany.com",
          "name": "TestUser_-EmailAction-",
          "useCommonAlertSchema": true
        },
        {
          "emailAddress": "test.user2@testcompany.com",
          "name": "TestUser2",
          "useCommonAlertSchema": true
        }
      ]
    },
    "location": {
      "value": "global"
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
    "smsReceivers": {
      "value": [
        {
          "countryCode": "1",
          "name": "TestUser_-SMSAction-",
          "phoneNumber": "2345678901"
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

### Example 3: _WAF-aligned_

This instance deploys the module in alignment with the best-pratices of the Well-Architectured-Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module actionGroup 'br/public:avm/res/insights/action-group:0.1.2' = {
  name: '${uniqueString(deployment().name, location)}-test-iagwaf'
  params: {
    // Required parameters
    groupShortName: 'agiagwaf001'
    name: 'iagwaf001'
    // Non-required parameters
    armRoleReceivers: '<armRoleReceivers>'
    automationRunbookReceivers: '<automationRunbookReceivers>'
    azureAppPushReceivers: '<azureAppPushReceivers>'
    azureFunctionReceivers: '<azureFunctionReceivers>'
    emailReceivers: '<emailReceivers>'
    itsmReceivers: '<itsmReceivers>'
    location: 'global'
    logicAppReceivers: '<logicAppReceivers>'
    roleAssignments: '<roleAssignments>'
    smsReceivers: '<smsReceivers>'
    tags: {
      Environment: 'Non-Prod'
      'hidden-title': 'This is visible in the resource name'
      Role: 'DeploymentValidation'
    }
    voiceReceivers: '<voiceReceivers>'
    webhookReceivers: '<webhookReceivers>'
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
    "groupShortName": {
      "value": "agiagwaf001"
    },
    "name": {
      "value": "iagwaf001"
    },
    // Non-required parameters
    "armRoleReceivers": {
      "value": "<armRoleReceivers>"
    },
    "automationRunbookReceivers": {
      "value": "<automationRunbookReceivers>"
    },
    "azureAppPushReceivers": {
      "value": "<azureAppPushReceivers>"
    },
    "azureFunctionReceivers": {
      "value": "<azureFunctionReceivers>"
    },
    "emailReceivers": {
      "value": "<emailReceivers>"
    },
    "itsmReceivers": {
      "value": "<itsmReceivers>"
    },
    "location": {
      "value": "global"
    },
    "logicAppReceivers": {
      "value": "<logicAppReceivers>"
    },
    "roleAssignments": {
      "value": "<roleAssignments>"
    },
    "smsReceivers": {
      "value": "<smsReceivers>"
    },
    "tags": {
      "value": {
        "Environment": "Non-Prod",
        "hidden-title": "This is visible in the resource name",
        "Role": "DeploymentValidation"
      }
    },
    "voiceReceivers": {
      "value": "<voiceReceivers>"
    },
    "webhookReceivers": {
      "value": "<webhookReceivers>"
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
| [`groupShortName`](#parameter-groupshortname) | string | The short name of the action group. |
| [`name`](#parameter-name) | string | The name of the action group. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`armRoleReceivers`](#parameter-armrolereceivers) | array | The list of ARM role receivers that are part of this action group. Roles are Azure RBAC roles and only built-in roles are supported. |
| [`automationRunbookReceivers`](#parameter-automationrunbookreceivers) | array | The list of AutomationRunbook receivers that are part of this action group. |
| [`azureAppPushReceivers`](#parameter-azureapppushreceivers) | array | The list of AzureAppPush receivers that are part of this action group. |
| [`azureFunctionReceivers`](#parameter-azurefunctionreceivers) | array | The list of function receivers that are part of this action group. |
| [`emailReceivers`](#parameter-emailreceivers) | array | The list of email receivers that are part of this action group. |
| [`enabled`](#parameter-enabled) | bool | Indicates whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`itsmReceivers`](#parameter-itsmreceivers) | array | The list of ITSM receivers that are part of this action group. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`logicAppReceivers`](#parameter-logicappreceivers) | array | The list of logic app receivers that are part of this action group. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`smsReceivers`](#parameter-smsreceivers) | array | The list of SMS receivers that are part of this action group. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`voiceReceivers`](#parameter-voicereceivers) | array | The list of voice receivers that are part of this action group. |
| [`webhookReceivers`](#parameter-webhookreceivers) | array | The list of webhook receivers that are part of this action group. |

### Parameter: `armRoleReceivers`

The list of ARM role receivers that are part of this action group. Roles are Azure RBAC roles and only built-in roles are supported.
- Required: No
- Type: array

### Parameter: `automationRunbookReceivers`

The list of AutomationRunbook receivers that are part of this action group.
- Required: No
- Type: array

### Parameter: `azureAppPushReceivers`

The list of AzureAppPush receivers that are part of this action group.
- Required: No
- Type: array

### Parameter: `azureFunctionReceivers`

The list of function receivers that are part of this action group.
- Required: No
- Type: array

### Parameter: `emailReceivers`

The list of email receivers that are part of this action group.
- Required: No
- Type: array

### Parameter: `enabled`

Indicates whether this action group is enabled. If an action group is not enabled, then none of its receivers will receive communications.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.
- Required: No
- Type: bool
- Default: `True`

### Parameter: `groupShortName`

The short name of the action group.
- Required: Yes
- Type: string

### Parameter: `itsmReceivers`

The list of ITSM receivers that are part of this action group.
- Required: No
- Type: array

### Parameter: `location`

Location for all resources.
- Required: No
- Type: string
- Default: `'global'`

### Parameter: `logicAppReceivers`

The list of logic app receivers that are part of this action group.
- Required: No
- Type: array

### Parameter: `name`

The name of the action group.
- Required: Yes
- Type: string

### Parameter: `roleAssignments`

Array of role assignment objects that contain the 'roleDefinitionIdOrName' and 'principalId' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`condition`](#parameter-roleassignmentscondition) | No | string | Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container" |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | No | string | Optional. Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | No | string | Optional. The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | No | string | Optional. The description of the role assignment. |
| [`principalId`](#parameter-roleassignmentsprincipalid) | Yes | string | Required. The principal ID of the principal (user/group/identity) to assign the role to. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | No | string | Optional. The principal type of the assigned principal ID. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | Yes | string | Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead. |

### Parameter: `roleAssignments.condition`

Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container"

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Optional. Version of the condition.

- Required: No
- Type: string
- Allowed: `[2.0]`

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

Optional. The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

Optional. The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalId`

Required. The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.principalType`

Optional. The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed: `[Device, ForeignGroup, Group, ServicePrincipal, User]`

### Parameter: `roleAssignments.roleDefinitionIdOrName`

Required. The name of the role to assign. If it cannot be found you can specify the role definition ID instead.

- Required: Yes
- Type: string

### Parameter: `smsReceivers`

The list of SMS receivers that are part of this action group.
- Required: No
- Type: array

### Parameter: `tags`

Tags of the resource.
- Required: No
- Type: object

### Parameter: `voiceReceivers`

The list of voice receivers that are part of this action group.
- Required: No
- Type: array

### Parameter: `webhookReceivers`

The list of webhook receivers that are part of this action group.
- Required: No
- Type: array


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the action group. |
| `resourceGroupName` | string | The resource group the action group was deployed into. |
| `resourceId` | string | The resource ID of the action group. |

## Cross-referenced modules

_None_
