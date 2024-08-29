# Action Groups `[Microsoft.Insights/actionGroups]`

This module deploys an Action Group.

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
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Insights/actionGroups` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Insights/2023-01-01/actionGroups) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/res/insights/action-group:<version>`.

- [Using only defaults](#example-1-using-only-defaults)
- [Using large parameter set](#example-2-using-large-parameter-set)
- [WAF-aligned](#example-3-waf-aligned)

### Example 1: _Using only defaults_

This instance deploys the module with the minimum set of required parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module actionGroup 'br/public:avm/res/insights/action-group:<version>' = {
  name: 'actionGroupDeployment'
  params: {
    // Required parameters
    groupShortName: 'agiagmin001'
    name: 'iagmin001'
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
    "groupShortName": {
      "value": "agiagmin001"
    },
    "name": {
      "value": "iagmin001"
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
module actionGroup 'br/public:avm/res/insights/action-group:<version>' = {
  name: 'actionGroupDeployment'
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
        name: 'fc3ee4d9-d0c0-42c2-962f-082cf8d78882'
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
          "name": "fc3ee4d9-d0c0-42c2-962f-082cf8d78882",
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

This instance deploys the module in alignment with the best-practices of the Azure Well-Architected Framework.


<details>

<summary>via Bicep module</summary>

```bicep
module actionGroup 'br/public:avm/res/insights/action-group:<version>' = {
  name: 'actionGroupDeployment'
  params: {
    // Required parameters
    groupShortName: 'agiagwaf001'
    name: 'iagwaf001'
    // Non-required parameters
    location: 'global'
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
      "value": "agiagwaf001"
    },
    "name": {
      "value": "iagwaf001"
    },
    // Non-required parameters
    "location": {
      "value": "global"
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
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`smsReceivers`](#parameter-smsreceivers) | array | The list of SMS receivers that are part of this action group. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`voiceReceivers`](#parameter-voicereceivers) | array | The list of voice receivers that are part of this action group. |
| [`webhookReceivers`](#parameter-webhookreceivers) | array | The list of webhook receivers that are part of this action group. |

### Parameter: `groupShortName`

The short name of the action group.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the action group.

- Required: Yes
- Type: string

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
