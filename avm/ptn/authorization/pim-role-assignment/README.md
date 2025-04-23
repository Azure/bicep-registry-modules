# PIM Role Assignments (All scopes) `[Authorization/PimRoleAssignment]`

This module deploys a PIM Role Assignment at a Management Group, Subscription or Resource Group scope.

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
- Discriminator: `roleAssignmentType`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`Active`](#variant-pimroleassignmenttyperoleassignmenttype-active) | The type for an active PIM role assignment. |
| [`Eligible`](#variant-pimroleassignmenttyperoleassignmenttype-eligible) | The type for a PIM-eligible role assignment. |

### Variant: `pimRoleAssignmentType.roleAssignmentType-Active`
The type for an active PIM role assignment.

To use this variant, set the property `roleAssignmentType` to `Active`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`roleAssignmentType`](#parameter-pimroleassignmenttyperoleassignmenttype-activeroleassignmenttype) | string | The type of the role assignment. |
| [`scheduleInfo`](#parameter-pimroleassignmenttyperoleassignmenttype-activescheduleinfo) | object | The schedule information for the role assignment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`linkedRoleEligibilityScheduleId`](#parameter-pimroleassignmenttyperoleassignmenttype-activelinkedroleeligibilityscheduleid) | string | The linked role eligibility schedule id - to activate an eligibility. |
| [`targetRoleAssignmentScheduleId`](#parameter-pimroleassignmenttyperoleassignmenttype-activetargetroleassignmentscheduleid) | string | The resultant role assignment schedule id or the role assignment schedule id being updated. |
| [`targetRoleAssignmentScheduleInstanceId`](#parameter-pimroleassignmenttyperoleassignmenttype-activetargetroleassignmentscheduleinstanceid) | string | The role assignment schedule instance id being updated. |

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Active.roleAssignmentType`

The type of the role assignment.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Active'
  ]
  ```

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Active.scheduleInfo`

The schedule information for the role assignment.

- Required: Yes
- Type: object
- Discriminator: `durationType`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`NoExpiration`](#variant-pimroleassignmenttyperoleassignmenttype-activescheduleinfodurationtype-noexpiration) | The type for a permanent role assignment schedule. |
| [`AfterDuration`](#variant-pimroleassignmenttyperoleassignmenttype-activescheduleinfodurationtype-afterduration) | The type for a time-bound role assignment schedule. |
| [`AfterDateTime`](#variant-pimroleassignmenttyperoleassignmenttype-activescheduleinfodurationtype-afterdatetime) | The type for a date-bound role assignment schedule. |

### Variant: `pimRoleAssignmentType.roleAssignmentType-Active.scheduleInfo.durationType-NoExpiration`
The type for a permanent role assignment schedule.

To use this variant, set the property `durationType` to `NoExpiration`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`durationType`](#parameter-pimroleassignmenttyperoleassignmenttype-activescheduleinfodurationtype-noexpirationdurationtype) | string | The type of the duration. |

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Active.scheduleInfo.durationType-NoExpiration.durationType`

The type of the duration.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'NoExpiration'
  ]
  ```

### Variant: `pimRoleAssignmentType.roleAssignmentType-Active.scheduleInfo.durationType-AfterDuration`
The type for a time-bound role assignment schedule.

To use this variant, set the property `durationType` to `AfterDuration`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`duration`](#parameter-pimroleassignmenttyperoleassignmenttype-activescheduleinfodurationtype-afterdurationduration) | string | The duration for the role assignment. |
| [`durationType`](#parameter-pimroleassignmenttyperoleassignmenttype-activescheduleinfodurationtype-afterdurationdurationtype) | string | The type of the duration. |
| [`startTime`](#parameter-pimroleassignmenttyperoleassignmenttype-activescheduleinfodurationtype-afterdurationstarttime) | string | The start time for the role assignment. |

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Active.scheduleInfo.durationType-AfterDuration.duration`

The duration for the role assignment.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Active.scheduleInfo.durationType-AfterDuration.durationType`

The type of the duration.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AfterDuration'
  ]
  ```

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Active.scheduleInfo.durationType-AfterDuration.startTime`

The start time for the role assignment.

- Required: Yes
- Type: string

### Variant: `pimRoleAssignmentType.roleAssignmentType-Active.scheduleInfo.durationType-AfterDateTime`
The type for a date-bound role assignment schedule.

To use this variant, set the property `durationType` to `AfterDateTime`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`durationType`](#parameter-pimroleassignmenttyperoleassignmenttype-activescheduleinfodurationtype-afterdatetimedurationtype) | string | The type of the duration. |
| [`endDateTime`](#parameter-pimroleassignmenttyperoleassignmenttype-activescheduleinfodurationtype-afterdatetimeenddatetime) | string | The end date and time for the role assignment. |
| [`startTime`](#parameter-pimroleassignmenttyperoleassignmenttype-activescheduleinfodurationtype-afterdatetimestarttime) | string | The start date and time for the role assignment. |

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Active.scheduleInfo.durationType-AfterDateTime.durationType`

The type of the duration.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AfterDateTime'
  ]
  ```

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Active.scheduleInfo.durationType-AfterDateTime.endDateTime`

The end date and time for the role assignment.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Active.scheduleInfo.durationType-AfterDateTime.startTime`

The start date and time for the role assignment.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Active.linkedRoleEligibilityScheduleId`

The linked role eligibility schedule id - to activate an eligibility.

- Required: No
- Type: string

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Active.targetRoleAssignmentScheduleId`

The resultant role assignment schedule id or the role assignment schedule id being updated.

- Required: No
- Type: string

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Active.targetRoleAssignmentScheduleInstanceId`

The role assignment schedule instance id being updated.

- Required: No
- Type: string

### Variant: `pimRoleAssignmentType.roleAssignmentType-Eligible`
The type for a PIM-eligible role assignment.

To use this variant, set the property `roleAssignmentType` to `Eligible`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`roleAssignmentType`](#parameter-pimroleassignmenttyperoleassignmenttype-eligibleroleassignmenttype) | string | The type of the role assignment. |
| [`scheduleInfo`](#parameter-pimroleassignmenttyperoleassignmenttype-eligiblescheduleinfo) | object | The schedule information for the role assignment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`targetRoleEligibilityScheduleId`](#parameter-pimroleassignmenttyperoleassignmenttype-eligibletargetroleeligibilityscheduleid) | string | The resultant role eligibility schedule id or the role eligibility schedule id being updated. |
| [`targetRoleEligibilityScheduleInstanceId`](#parameter-pimroleassignmenttyperoleassignmenttype-eligibletargetroleeligibilityscheduleinstanceid) | string | The role eligibility assignment instance id being updated. |

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Eligible.roleAssignmentType`

The type of the role assignment.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Eligible'
  ]
  ```

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Eligible.scheduleInfo`

The schedule information for the role assignment.

- Required: Yes
- Type: object
- Discriminator: `durationType`

<h4>The available variants are:</h4>

| Variant | Description |
| :-- | :-- |
| [`NoExpiration`](#variant-pimroleassignmenttyperoleassignmenttype-eligiblescheduleinfodurationtype-noexpiration) | The type for a permanent role assignment schedule. |
| [`AfterDuration`](#variant-pimroleassignmenttyperoleassignmenttype-eligiblescheduleinfodurationtype-afterduration) | The type for a time-bound role assignment schedule. |
| [`AfterDateTime`](#variant-pimroleassignmenttyperoleassignmenttype-eligiblescheduleinfodurationtype-afterdatetime) | The type for a date-bound role assignment schedule. |

### Variant: `pimRoleAssignmentType.roleAssignmentType-Eligible.scheduleInfo.durationType-NoExpiration`
The type for a permanent role assignment schedule.

To use this variant, set the property `durationType` to `NoExpiration`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`durationType`](#parameter-pimroleassignmenttyperoleassignmenttype-eligiblescheduleinfodurationtype-noexpirationdurationtype) | string | The type of the duration. |

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Eligible.scheduleInfo.durationType-NoExpiration.durationType`

The type of the duration.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'NoExpiration'
  ]
  ```

### Variant: `pimRoleAssignmentType.roleAssignmentType-Eligible.scheduleInfo.durationType-AfterDuration`
The type for a time-bound role assignment schedule.

To use this variant, set the property `durationType` to `AfterDuration`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`duration`](#parameter-pimroleassignmenttyperoleassignmenttype-eligiblescheduleinfodurationtype-afterdurationduration) | string | The duration for the role assignment. |
| [`durationType`](#parameter-pimroleassignmenttyperoleassignmenttype-eligiblescheduleinfodurationtype-afterdurationdurationtype) | string | The type of the duration. |
| [`startTime`](#parameter-pimroleassignmenttyperoleassignmenttype-eligiblescheduleinfodurationtype-afterdurationstarttime) | string | The start time for the role assignment. |

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Eligible.scheduleInfo.durationType-AfterDuration.duration`

The duration for the role assignment.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Eligible.scheduleInfo.durationType-AfterDuration.durationType`

The type of the duration.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AfterDuration'
  ]
  ```

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Eligible.scheduleInfo.durationType-AfterDuration.startTime`

The start time for the role assignment.

- Required: Yes
- Type: string

### Variant: `pimRoleAssignmentType.roleAssignmentType-Eligible.scheduleInfo.durationType-AfterDateTime`
The type for a date-bound role assignment schedule.

To use this variant, set the property `durationType` to `AfterDateTime`.

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`durationType`](#parameter-pimroleassignmenttyperoleassignmenttype-eligiblescheduleinfodurationtype-afterdatetimedurationtype) | string | The type of the duration. |
| [`endDateTime`](#parameter-pimroleassignmenttyperoleassignmenttype-eligiblescheduleinfodurationtype-afterdatetimeenddatetime) | string | The end date and time for the role assignment. |
| [`startTime`](#parameter-pimroleassignmenttyperoleassignmenttype-eligiblescheduleinfodurationtype-afterdatetimestarttime) | string | The start date and time for the role assignment. |

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Eligible.scheduleInfo.durationType-AfterDateTime.durationType`

The type of the duration.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AfterDateTime'
  ]
  ```

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Eligible.scheduleInfo.durationType-AfterDateTime.endDateTime`

The end date and time for the role assignment.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Eligible.scheduleInfo.durationType-AfterDateTime.startTime`

The start date and time for the role assignment.

- Required: Yes
- Type: string

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Eligible.targetRoleEligibilityScheduleId`

The resultant role eligibility schedule id or the role eligibility schedule id being updated.

- Required: No
- Type: string

### Parameter: `pimRoleAssignmentType.roleAssignmentType-Eligible.targetRoleEligibilityScheduleInstanceId`

The role eligibility assignment instance id being updated.

- Required: No
- Type: string

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
