# <Add module name> `[Authorization/PimRoleAssignment]`

<Add description>

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignmentScheduleRequests` | [2022-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01-preview/roleAssignmentScheduleRequests) |
| `Microsoft.Authorization/roleEligibilityScheduleRequests` | [2022-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01-preview/roleEligibilityScheduleRequests) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/authorization/pim-role-assignment:<version>`.

- [ PIM Eligible Role Assignments (Management Group scope)](#example-1-pim-eligible-role-assignments-management-group-scope)
- [PIM Active Role Assignments (Resource Group)](#example-2-pim-active-role-assignments-resource-group)
- [PIM Active permanent Role Assignments (Subscription scope)](#example-3-pim-active-permanent-role-assignments-subscription-scope)

### Example 1: _ PIM Eligible Role Assignments (Management Group scope)_

This module deploys a PIM Eligible Role Assignment at a Management Group scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module pimRoleAssignment 'br/public:avm/ptn/authorization/pim-role-assignment:<version>' = {
  name: 'pimRoleAssignmentDeployment'
  params: {
    // Required parameters
    pimRoleAssignmentType: {
      roleAssignmentType: 'Eligible'
      scheduleInfo: {
        duration: 'PT4H'
        durationType: 'AfterDuration'
        startTime: '<startTime>'
      }
    }
    principalId: '<principalId>'
    requestType: 'AdminAssign'
    roleDefinitionIdOrName: 'Role Based Access Control Administrator'
    // Non-required parameters
    justification: 'AVM test'
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
    "pimRoleAssignmentType": {
      "value": {
        "roleAssignmentType": "Eligible",
        "scheduleInfo": {
          "duration": "PT4H",
          "durationType": "AfterDuration",
          "startTime": "<startTime>"
        }
      }
    },
    "principalId": {
      "value": "<principalId>"
    },
    "requestType": {
      "value": "AdminAssign"
    },
    "roleDefinitionIdOrName": {
      "value": "Role Based Access Control Administrator"
    },
    // Non-required parameters
    "justification": {
      "value": "AVM test"
    },
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
using 'br/public:avm/ptn/authorization/pim-role-assignment:<version>'

// Required parameters
param pimRoleAssignmentType = {
  roleAssignmentType: 'Eligible'
  scheduleInfo: {
    duration: 'PT4H'
    durationType: 'AfterDuration'
    startTime: '<startTime>'
  }
}
param principalId = '<principalId>'
param requestType = 'AdminAssign'
param roleDefinitionIdOrName = 'Role Based Access Control Administrator'
// Non-required parameters
param justification = 'AVM test'
param location = '<location>'
```

</details>
<p>

### Example 2: _PIM Active Role Assignments (Resource Group)_

This module deploys a PIM Active Role Assignment at a Resource Group scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module pimRoleAssignment 'br/public:avm/ptn/authorization/pim-role-assignment:<version>' = {
  name: 'pimRoleAssignmentDeployment'
  params: {
    // Required parameters
    pimRoleAssignmentType: {
      roleAssignmentType: 'Active'
      scheduleInfo: {
        durationType: 'AfterDateTime'
        endDateTime: '<endDateTime>'
        startTime: '<startTime>'
      }
    }
    principalId: '<principalId>'
    requestType: 'AdminAssign'
    roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
    // Non-required parameters
    justification: 'AVM test'
    location: '<location>'
    resourceGroupName: '<resourceGroupName>'
    subscriptionId: '<subscriptionId>'
    ticketInfo: {
      ticketNumber: '32423'
      ticketSystem: 'system12'
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
    "pimRoleAssignmentType": {
      "value": {
        "roleAssignmentType": "Active",
        "scheduleInfo": {
          "durationType": "AfterDateTime",
          "endDateTime": "<endDateTime>",
          "startTime": "<startTime>"
        }
      }
    },
    "principalId": {
      "value": "<principalId>"
    },
    "requestType": {
      "value": "AdminAssign"
    },
    "roleDefinitionIdOrName": {
      "value": "/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168"
    },
    // Non-required parameters
    "justification": {
      "value": "AVM test"
    },
    "location": {
      "value": "<location>"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    },
    "ticketInfo": {
      "value": {
        "ticketNumber": "32423",
        "ticketSystem": "system12"
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
using 'br/public:avm/ptn/authorization/pim-role-assignment:<version>'

// Required parameters
param pimRoleAssignmentType = {
  roleAssignmentType: 'Active'
  scheduleInfo: {
    durationType: 'AfterDateTime'
    endDateTime: '<endDateTime>'
    startTime: '<startTime>'
  }
}
param principalId = '<principalId>'
param requestType = 'AdminAssign'
param roleDefinitionIdOrName = '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
// Non-required parameters
param justification = 'AVM test'
param location = '<location>'
param resourceGroupName = '<resourceGroupName>'
param subscriptionId = '<subscriptionId>'
param ticketInfo = {
  ticketNumber: '32423'
  ticketSystem: 'system12'
}
```

</details>
<p>

### Example 3: _PIM Active permanent Role Assignments (Subscription scope)_

This module deploys a PIM permanent Role Assignment at a Subscription scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module pimRoleAssignment 'br/public:avm/ptn/authorization/pim-role-assignment:<version>' = {
  name: 'pimRoleAssignmentDeployment'
  params: {
    // Required parameters
    pimRoleAssignmentType: {
      roleAssignmentType: 'Active'
      scheduleInfo: {
        durationType: 'NoExpiration'
      }
    }
    principalId: '<principalId>'
    requestType: 'AdminAssign'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
    // Non-required parameters
    justification: 'AVM test'
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
    "pimRoleAssignmentType": {
      "value": {
        "roleAssignmentType": "Active",
        "scheduleInfo": {
          "durationType": "NoExpiration"
        }
      }
    },
    "principalId": {
      "value": "<principalId>"
    },
    "requestType": {
      "value": "AdminAssign"
    },
    "roleDefinitionIdOrName": {
      "value": "<roleDefinitionIdOrName>"
    },
    // Non-required parameters
    "justification": {
      "value": "AVM test"
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
using 'br/public:avm/ptn/authorization/pim-role-assignment:<version>'

// Required parameters
param pimRoleAssignmentType = {
  roleAssignmentType: 'Active'
  scheduleInfo: {
    durationType: 'NoExpiration'
  }
}
param principalId = '<principalId>'
param requestType = 'AdminAssign'
param roleDefinitionIdOrName = '<roleDefinitionIdOrName>'
// Non-required parameters
param justification = 'AVM test'
param subscriptionId = '<subscriptionId>'
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`pimRoleAssignmentType`](#parameter-pimroleassignmenttype) | object | The type of the PIM role assignment whether its active or eligible. |
| [`principalId`](#parameter-principalid) | string | The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity). |
| [`requestType`](#parameter-requesttype) | string | The type of the role assignment eligibility request. |
| [`roleDefinitionIdOrName`](#parameter-roledefinitionidorname) | string | You can provide either the display name of the role definition (must be configured in the variable `builtInRoleNames`), or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-condition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. |
| [`conditionVersion`](#parameter-conditionversion) | string | Version of the condition. Currently accepted value is "2.0". |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`justification`](#parameter-justification) | string | The justification for the role eligibility. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`managementGroupId`](#parameter-managementgroupid) | string | Group ID of the Management Group to assign the RBAC role to. If not provided, will use the current scope for deployment. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | Name of the Resource Group to assign the RBAC role to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided RBAC role to the resource group. |
| [`subscriptionId`](#parameter-subscriptionid) | string | Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription. |
| [`targetRoleAssignmentScheduleId`](#parameter-targetroleassignmentscheduleid) | string | The resultant role assignment schedule id or the role assignment schedule id being updated. |
| [`targetRoleAssignmentScheduleInstanceId`](#parameter-targetroleassignmentscheduleinstanceid) | string | The role assignment schedule instance id being updated. |
| [`targetRoleEligibilityScheduleId`](#parameter-targetroleeligibilityscheduleid) | string | The resultant role eligibility assignment id or the role eligibility assignment id being updated. |
| [`targetRoleEligibilityScheduleInstanceId`](#parameter-targetroleeligibilityscheduleinstanceid) | string | The role eligibility assignment instance id being updated. |
| [`ticketInfo`](#parameter-ticketinfo) | object | Ticket Info of the role eligibility. |

### Parameter: `pimRoleAssignmentType`

The type of the PIM role assignment whether its active or eligible.

- Required: Yes
- Type: object

### Parameter: `principalId`

The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).

- Required: Yes
- Type: string

### Parameter: `requestType`

The type of the role assignment eligibility request.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AdminAssign'
    'AdminExtend'
    'AdminRemove'
    'AdminRenew'
    'AdminUpdate'
    'SelfActivate'
    'SelfDeactivate'
    'SelfExtend'
    'SelfRenew'
  ]
  ```

### Parameter: `roleDefinitionIdOrName`

You can provide either the display name of the role definition (must be configured in the variable `builtInRoleNames`), or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `condition`

The conditions on the role assignment. This limits the resources it can be assigned to.

- Required: No
- Type: string
- Default: `''`

### Parameter: `conditionVersion`

Version of the condition. Currently accepted value is "2.0".

- Required: No
- Type: string
- Default: `'2.0'`
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `justification`

The justification for the role eligibility.

- Required: No
- Type: string
- Default: `''`

### Parameter: `location`

Location deployment metadata.

- Required: No
- Type: string
- Default: `[deployment().location]`

### Parameter: `managementGroupId`

Group ID of the Management Group to assign the RBAC role to. If not provided, will use the current scope for deployment.

- Required: No
- Type: string
- Default: `[managementGroup().name]`

### Parameter: `resourceGroupName`

Name of the Resource Group to assign the RBAC role to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided RBAC role to the resource group.

- Required: No
- Type: string
- Default: `''`

### Parameter: `subscriptionId`

Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription.

- Required: No
- Type: string
- Default: `''`

### Parameter: `targetRoleAssignmentScheduleId`

The resultant role assignment schedule id or the role assignment schedule id being updated.

- Required: No
- Type: string
- Default: `''`

### Parameter: `targetRoleAssignmentScheduleInstanceId`

The role assignment schedule instance id being updated.

- Required: No
- Type: string
- Default: `''`

### Parameter: `targetRoleEligibilityScheduleId`

The resultant role eligibility assignment id or the role eligibility assignment id being updated.

- Required: No
- Type: string
- Default: `''`

### Parameter: `targetRoleEligibilityScheduleInstanceId`

The role eligibility assignment instance id being updated.

- Required: No
- Type: string
- Default: `''`

### Parameter: `ticketInfo`

Ticket Info of the role eligibility.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ticketNumber`](#parameter-ticketinfoticketnumber) | string | The ticket number for the role eligibility assignment. |
| [`ticketSystem`](#parameter-ticketinfoticketsystem) | string | The ticket system name for the role eligibility assignment. |

### Parameter: `ticketInfo.ticketNumber`

The ticket number for the role eligibility assignment.

- Required: No
- Type: string

### Parameter: `ticketInfo.ticketSystem`

The ticket system name for the role eligibility assignment.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the PIM Role Assignment. |
| `resourceId` | string | The resource ID of the PIM Role Assignment. |
| `scope` | string | The scope this PIM Role Assignment applies to. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
