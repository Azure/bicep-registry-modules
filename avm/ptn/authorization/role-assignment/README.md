# Role Assignments (All scopes) `[Authorization/RoleAssignment]`

This module deploys a Role Assignment at a Management Group, Subscription or Resource Group scope.

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

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/authorization/role-assignment:<version>`.

- [Role Assignments (Management Group scope)](#example-1-role-assignments-management-group-scope)
- [Role Assignments (Management Group scope)](#example-2-role-assignments-management-group-scope)
- [Role Assignments (Resource Group scope)](#example-3-role-assignments-resource-group-scope)
- [Role Assignments (Resource Group)](#example-4-role-assignments-resource-group)
- [Role Assignments (Subscription scope)](#example-5-role-assignments-subscription-scope)
- [Role Assignments (Subscription scope)](#example-6-role-assignments-subscription-scope)

### Example 1: _Role Assignments (Management Group scope)_

This module deploys a Role Assignment at a Management Group scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignment 'br/public:avm/ptn/authorization/role-assignment:<version>' = {
  name: 'roleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: 'Resource Policy Contributor'
    // Non-required parameters
    location: '<location>'
    principalType: 'ServicePrincipal'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "Resource Policy Contributor"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "principalType": {
      "value": "ServicePrincipal"
    }
  }
}
```

</details>
<p>

### Example 2: _Role Assignments (Management Group scope)_

This module deploys a Role Assignment at a Management Group scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignment 'br/public:avm/ptn/authorization/role-assignment:<version>' = {
  name: 'roleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: 'Management Group Reader'
    // Non-required parameters
    description: 'Role Assignment (management group scope)'
    location: '<location>'
    managementGroupId: '<managementGroupId>'
    principalType: 'ServicePrincipal'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "Management Group Reader"
    },
    // Non-required parameters
    "description": {
      "value": "Role Assignment (management group scope)"
    },
    "location": {
      "value": "<location>"
    },
    "managementGroupId": {
      "value": "<managementGroupId>"
    },
    "principalType": {
      "value": "ServicePrincipal"
    }
  }
}
```

</details>
<p>

### Example 3: _Role Assignments (Resource Group scope)_

This module deploys a Role Assignment at a Resource Group scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignment 'br/public:avm/ptn/authorization/role-assignment:<version>' = {
  name: 'roleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'
    // Non-required parameters
    location: '<location>'
    principalType: 'ServicePrincipal'
    resourceGroupName: '<resourceGroupName>'
    subscriptionId: '<subscriptionId>'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "principalType": {
      "value": "ServicePrincipal"
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

### Example 4: _Role Assignments (Resource Group)_

This module deploys a Role Assignment at a Resource Group scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignment 'br/public:avm/ptn/authorization/role-assignment:<version>' = {
  name: 'roleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: 'Reader'
    // Non-required parameters
    description: 'Role Assignment (resource group scope)'
    location: '<location>'
    principalType: 'ServicePrincipal'
    resourceGroupName: '<resourceGroupName>'
    subscriptionId: '<subscriptionId>'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "Reader"
    },
    // Non-required parameters
    "description": {
      "value": "Role Assignment (resource group scope)"
    },
    "location": {
      "value": "<location>"
    },
    "principalType": {
      "value": "ServicePrincipal"
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

### Example 5: _Role Assignments (Subscription scope)_

This module deploys a Role Assignment at a Subscription scope using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignment 'br/public:avm/ptn/authorization/role-assignment:<version>' = {
  name: 'roleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: '<roleDefinitionIdOrName>'
    // Non-required parameters
    location: '<location>'
    principalType: 'ServicePrincipal'
    subscriptionId: '<subscriptionId>'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "<roleDefinitionIdOrName>"
    },
    // Non-required parameters
    "location": {
      "value": "<location>"
    },
    "principalType": {
      "value": "ServicePrincipal"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
    }
  }
}
```

</details>
<p>

### Example 6: _Role Assignments (Subscription scope)_

This module deploys a Role Assignment at a Subscription scope using common parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module roleAssignment 'br/public:avm/ptn/authorization/role-assignment:<version>' = {
  name: 'roleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    roleDefinitionIdOrName: 'Reader'
    // Non-required parameters
    description: 'Role Assignment (subscription scope)'
    location: '<location>'
    principalType: 'ServicePrincipal'
    subscriptionId: '<subscriptionId>'
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
    "principalId": {
      "value": "<principalId>"
    },
    "roleDefinitionIdOrName": {
      "value": "Reader"
    },
    // Non-required parameters
    "description": {
      "value": "Role Assignment (subscription scope)"
    },
    "location": {
      "value": "<location>"
    },
    "principalType": {
      "value": "ServicePrincipal"
    },
    "subscriptionId": {
      "value": "<subscriptionId>"
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
| [`principalId`](#parameter-principalid) | string | The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity). |
| [`roleDefinitionIdOrName`](#parameter-roledefinitionidorname) | string | You can provide either the display name of the role definition (must be configured in the variable `builtInRoleNames`), or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-condition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. |
| [`conditionVersion`](#parameter-conditionversion) | string | Version of the condition. Currently accepted value is "2.0". |
| [`delegatedManagedIdentityResourceId`](#parameter-delegatedmanagedidentityresourceid) | string | ID of the delegated managed identity resource. |
| [`description`](#parameter-description) | string | The description of the role assignment. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | Location deployment metadata. |
| [`managementGroupId`](#parameter-managementgroupid) | string | Group ID of the Management Group to assign the RBAC role to. If not provided, will use the current scope for deployment. |
| [`principalType`](#parameter-principaltype) | string | The principal type of the assigned principal ID. |
| [`resourceGroupName`](#parameter-resourcegroupname) | string | Name of the Resource Group to assign the RBAC role to. If Resource Group name is provided, and Subscription ID is provided, the module deploys at resource group level, therefore assigns the provided RBAC role to the resource group. |
| [`subscriptionId`](#parameter-subscriptionid) | string | Subscription ID of the subscription to assign the RBAC role to. If no Resource Group name is provided, the module deploys at subscription level, therefore assigns the provided RBAC role to the subscription. |

### Parameter: `principalId`

The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).

- Required: Yes
- Type: string

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

### Parameter: `delegatedManagedIdentityResourceId`

ID of the delegated managed identity resource.

- Required: No
- Type: string
- Default: `''`

### Parameter: `description`

The description of the role assignment.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Default: `''`
- Allowed:
  ```Bicep
  [
    ''
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

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


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Assignment. |
| `resourceId` | string | The resource ID of the Role Assignment. |
| `scope` | string | The scope this Role Assignment applies to. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
