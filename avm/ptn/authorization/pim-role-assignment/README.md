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
| `Microsoft.Authorization/roleEligibilityScheduleRequests` | [2022-04-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01-preview/roleEligibilityScheduleRequests) |

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/authorization/pim-role-assignment:<version>`.

- [ PIM Role Assignments (Management Group scope)](#example-1-pim-role-assignments-management-group-scope)
- [PIM Role Assignments (Management Group scope)](#example-2-pim-role-assignments-management-group-scope)
- [PIM Role Assignments (Resource Group scope)](#example-3-pim-role-assignments-resource-group-scope)
- [PIM Role Assignments (Resource Group)](#example-4-pim-role-assignments-resource-group)
- [PIM Role Assignments (Subscription scope)](#example-5-pim-role-assignments-subscription-scope)
- [PIM Role Assignments (Subscription scope)](#example-6-pim-role-assignments-subscription-scope)

### Example 1: _ PIM Role Assignments (Management Group scope)_

This module deploys a PIM Role Assignment at a Management Group scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module pimRoleAssignment 'br/public:avm/ptn/authorization/pim-role-assignment:<version>' = {
  name: 'pimRoleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    requestType: 'AdminAssign'
    roleDefinitionIdOrName: 'Resource Policy Contributor'
    scheduleInfo: {
      expiration: {
        duration: 'P1H'
        type: 'AfterDuration'
      }
    }
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
    "principalId": {
      "value": "<principalId>"
    },
    "requestType": {
      "value": "AdminAssign"
    },
    "roleDefinitionIdOrName": {
      "value": "Resource Policy Contributor"
    },
    "scheduleInfo": {
      "value": {
        "expiration": {
          "duration": "P1H",
          "type": "AfterDuration"
        }
      }
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
using 'br/public:avm/ptn/authorization/pim-role-assignment:<version>'

// Required parameters
param principalId = '<principalId>'
param requestType = 'AdminAssign'
param roleDefinitionIdOrName = 'Resource Policy Contributor'
param scheduleInfo = {
  expiration: {
    duration: 'P1H'
    type: 'AfterDuration'
  }
}
// Non-required parameters
param location = '<location>'
```

</details>
<p>

### Example 2: _PIM Role Assignments (Management Group scope)_

This module deploys a PIM Role Assignment at a Management Group scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module pimRoleAssignment 'br/public:avm/ptn/authorization/pim-role-assignment:<version>' = {
  name: 'pimRoleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    requestType: 'AdminAssign'
    roleDefinitionIdOrName: 'Resource Policy Contributor'
    scheduleInfo: {
      expiration: {
        type: 'AfterDateTime'
      }
      startDateTime: '2025-01-23T12:39:44Z'
    }
    // Non-required parameters
    justification: 'Justification for the role eligibility'
    location: '<location>'
    ticketInfo: {
      ticketNumber: '123456'
      ticketSystem: 'system1'
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
    "principalId": {
      "value": "<principalId>"
    },
    "requestType": {
      "value": "AdminAssign"
    },
    "roleDefinitionIdOrName": {
      "value": "Resource Policy Contributor"
    },
    "scheduleInfo": {
      "value": {
        "expiration": {
          "type": "AfterDateTime"
        },
        "startDateTime": "2025-01-23T12:39:44Z"
      }
    },
    // Non-required parameters
    "justification": {
      "value": "Justification for the role eligibility"
    },
    "location": {
      "value": "<location>"
    },
    "ticketInfo": {
      "value": {
        "ticketNumber": "123456",
        "ticketSystem": "system1"
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
param principalId = '<principalId>'
param requestType = 'AdminAssign'
param roleDefinitionIdOrName = 'Resource Policy Contributor'
param scheduleInfo = {
  expiration: {
    type: 'AfterDateTime'
  }
  startDateTime: '2025-01-23T12:39:44Z'
}
// Non-required parameters
param justification = 'Justification for the role eligibility'
param location = '<location>'
param ticketInfo = {
  ticketNumber: '123456'
  ticketSystem: 'system1'
}
```

</details>
<p>

### Example 3: _PIM Role Assignments (Resource Group scope)_

This module deploys a PIM Role Assignment at a Resource Group scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module pimRoleAssignment 'br/public:avm/ptn/authorization/pim-role-assignment:<version>' = {
  name: 'pimRoleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    requestType: 'AdminAssign'
    roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
    scheduleInfo: {
      expiration: {
        duration: 'P1H'
        type: 'AfterDuration'
      }
    }
    // Non-required parameters
    location: '<location>'
    resourceGroupName: '<resourceGroupName>'
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
    "principalId": {
      "value": "<principalId>"
    },
    "requestType": {
      "value": "AdminAssign"
    },
    "roleDefinitionIdOrName": {
      "value": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11"
    },
    "scheduleInfo": {
      "value": {
        "expiration": {
          "duration": "P1H",
          "type": "AfterDuration"
        }
      }
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "resourceGroupName": {
      "value": "<resourceGroupName>"
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
param principalId = '<principalId>'
param requestType = 'AdminAssign'
param roleDefinitionIdOrName = '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
param scheduleInfo = {
  expiration: {
    duration: 'P1H'
    type: 'AfterDuration'
  }
}
// Non-required parameters
param location = '<location>'
param resourceGroupName = '<resourceGroupName>'
param subscriptionId = '<subscriptionId>'
```

</details>
<p>

### Example 4: _PIM Role Assignments (Resource Group)_

This module deploys a PIM Role Assignment at a Resource Group scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module pimRoleAssignment 'br/public:avm/ptn/authorization/pim-role-assignment:<version>' = {
  name: 'pimRoleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    requestType: 'AdminAssign'
    roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
    scheduleInfo: {
      expiration: {
        type: 'AfterDateTime'
      }
      startDateTime: '<startDateTime>'
    }
    // Non-required parameters
    justification: 'Justification for role eligibility'
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
    "principalId": {
      "value": "<principalId>"
    },
    "requestType": {
      "value": "AdminAssign"
    },
    "roleDefinitionIdOrName": {
      "value": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11"
    },
    "scheduleInfo": {
      "value": {
        "expiration": {
          "type": "AfterDateTime"
        },
        "startDateTime": "<startDateTime>"
      }
    },
    // Non-required parameters
    "justification": {
      "value": "Justification for role eligibility"
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
param principalId = '<principalId>'
param requestType = 'AdminAssign'
param roleDefinitionIdOrName = '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
param scheduleInfo = {
  expiration: {
    type: 'AfterDateTime'
  }
  startDateTime: '<startDateTime>'
}
// Non-required parameters
param justification = 'Justification for role eligibility'
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

### Example 5: _PIM Role Assignments (Subscription scope)_

This module deploys a PIM Role Assignment at a Subscription scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module pimRoleAssignment 'br/public:avm/ptn/authorization/pim-role-assignment:<version>' = {
  name: 'pimRoleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    requestType: 'AdminAssign'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
    scheduleInfo: {
      expiration: {
        duration: 'P1H'
        type: 'AfterDuration'
      }
    }
    // Non-required parameters
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
    "principalId": {
      "value": "<principalId>"
    },
    "requestType": {
      "value": "AdminAssign"
    },
    "roleDefinitionIdOrName": {
      "value": "<roleDefinitionIdOrName>"
    },
    "scheduleInfo": {
      "value": {
        "expiration": {
          "duration": "P1H",
          "type": "AfterDuration"
        }
      }
    },
    // Non-required parameters
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
param principalId = '<principalId>'
param requestType = 'AdminAssign'
param roleDefinitionIdOrName = '<roleDefinitionIdOrName>'
param scheduleInfo = {
  expiration: {
    duration: 'P1H'
    type: 'AfterDuration'
  }
}
// Non-required parameters
param subscriptionId = '<subscriptionId>'
```

</details>
<p>

### Example 6: _PIM Role Assignments (Subscription scope)_

This module deploys a PIM Role Assignment at a Subscription scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module pimRoleAssignment 'br/public:avm/ptn/authorization/pim-role-assignment:<version>' = {
  name: 'pimRoleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    requestType: 'AdminAssign'
    roleDefinitionIdOrName: 'Reader'
    scheduleInfo: {
      expiration: {
        duration: 'P1H'
        type: 'AfterDuration'
      }
    }
    // Non-required parameters
    justification: 'Justification for role assignment'
    location: '<location>'
    subscriptionId: '<subscriptionId>'
    ticketInfo: {
      ticketNumber: '21312'
      ticketSystem: ' System2'
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
    "principalId": {
      "value": "<principalId>"
    },
    "requestType": {
      "value": "AdminAssign"
    },
    "roleDefinitionIdOrName": {
      "value": "Reader"
    },
    "scheduleInfo": {
      "value": {
        "expiration": {
          "duration": "P1H",
          "type": "AfterDuration"
        }
      }
    },
    // Non-required parameters
    "justification": {
      "value": "Justification for role assignment"
    },
    "location": {
      "value": "<location>"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    },
    "ticketInfo": {
      "value": {
        "ticketNumber": "21312",
        "ticketSystem": " System2"
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
param principalId = '<principalId>'
param requestType = 'AdminAssign'
param roleDefinitionIdOrName = 'Reader'
param scheduleInfo = {
  expiration: {
    duration: 'P1H'
    type: 'AfterDuration'
  }
}
// Non-required parameters
param justification = 'Justification for role assignment'
param location = '<location>'
param subscriptionId = '<subscriptionId>'
param ticketInfo = {
  ticketNumber: '21312'
  ticketSystem: ' System2'
}
```

</details>
<p>

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-principalid) | string | The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity). |
| [`requestType`](#parameter-requesttype) | string | The type of the role assignment eligibility request. |
| [`roleDefinitionIdOrName`](#parameter-roledefinitionidorname) | string | You can provide either the display name of the role definition (must be configured in the variable `builtInRoleNames`), or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |
| [`scheduleInfo`](#parameter-scheduleinfo) | object | Schedule info of the role eligibility assignment. |

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
| [`targetRoleEligibilityScheduleId`](#parameter-targetroleeligibilityscheduleid) | string | The resultant role eligibility assignment id or the role eligibility assignment id being updated. |
| [`targetRoleEligibilityScheduleInstanceId`](#parameter-targetroleeligibilityscheduleinstanceid) | string | The role eligibility assignment instance id being updated. |
| [`ticketInfo`](#parameter-ticketinfo) | object | Ticket Info of the role eligibility. |

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

### Parameter: `scheduleInfo`

Schedule info of the role eligibility assignment.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`expiration`](#parameter-scheduleinfoexpiration) | object | The expiry information for the role eligibility. |
| [`startDateTime`](#parameter-scheduleinfostartdatetime) | string | Start DateTime of the role eligibility assignment. |

### Parameter: `scheduleInfo.expiration`

The expiry information for the role eligibility.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`duration`](#parameter-scheduleinfoexpirationduration) | string | Duration of the role eligibility assignment in TimeSpan format. Example: P365D, P2H. |
| [`endDateTime`](#parameter-scheduleinfoexpirationenddatetime) | string | End DateTime of the role eligibility assignment. |
| [`type`](#parameter-scheduleinfoexpirationtype) | string | Type of the role eligibility assignment expiration. |

### Parameter: `scheduleInfo.expiration.duration`

Duration of the role eligibility assignment in TimeSpan format. Example: P365D, P2H.

- Required: No
- Type: string

### Parameter: `scheduleInfo.expiration.endDateTime`

End DateTime of the role eligibility assignment.

- Required: No
- Type: string

### Parameter: `scheduleInfo.expiration.type`

Type of the role eligibility assignment expiration.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'AfterDateTime'
    'AfterDuration'
    'NoExpiration'
  ]
  ```

### Parameter: `scheduleInfo.startDateTime`

Start DateTime of the role eligibility assignment.

- Required: No
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
