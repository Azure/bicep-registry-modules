# Resource-scoped role assignment `[Authorization/ResourceRoleAssignment]`

This module deploys a Role Assignment for a specific resource.

## Navigation

- [Resource Types](#Resource-Types)
- [Usage examples](#Usage-examples)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

_None_

## Usage examples

The following section provides usage examples for the module, which were used to validate and deploy the module successfully. For a full reference, please review the module's test folder in its repository.

>**Note**: Each example lists all the required parameters first, followed by the rest - each in alphabetical order.

>**Note**: To reference the module, please use the following syntax `br/public:avm/ptn/authorization/resource-role-assignment:<version>`.

- [Resource Role Assignments](#example-1-resource-role-assignments)
- [Resource Role Assignments](#example-2-resource-role-assignments)

### Example 1: _Resource Role Assignments_

This module deploys a Resource Role Assignment using all parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module resourceRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:<version>' = {
  name: 'resourceRoleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    resourceId: '<resourceId>'
    roleDefinitionId: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
    // Non-required parameters
    description: 'Assign Storage Blob Data Reader role to the managed identity on the storage account.'
    principalType: 'ServicePrincipal'
    roleName: 'Storage Blob Data Reader'
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
    "resourceId": {
      "value": "<resourceId>"
    },
    "roleDefinitionId": {
      "value": "2a2b9908-6ea1-4ae2-8e65-a410df84e7d1"
    },
    // Non-required parameters
    "description": {
      "value": "Assign Storage Blob Data Reader role to the managed identity on the storage account."
    },
    "principalType": {
      "value": "ServicePrincipal"
    },
    "roleName": {
      "value": "Storage Blob Data Reader"
    }
  }
}
```

</details>
<p>

### Example 2: _Resource Role Assignments_

This module deploys a Resource Role Assignment using minimal parameters.


<details>

<summary>via Bicep module</summary>

```bicep
module resourceRoleAssignment 'br/public:avm/ptn/authorization/resource-role-assignment:<version>' = {
  name: 'resourceRoleAssignmentDeployment'
  params: {
    // Required parameters
    principalId: '<principalId>'
    resourceId: '<resourceId>'
    roleDefinitionId: '2a2b9908-6ea1-4ae2-8e65-a410df84e7d1'
    // Non-required parameters
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
    "resourceId": {
      "value": "<resourceId>"
    },
    "roleDefinitionId": {
      "value": "2a2b9908-6ea1-4ae2-8e65-a410df84e7d1"
    },
    // Non-required parameters
    "principalType": {
      "value": "ServicePrincipal"
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
| [`resourceId`](#parameter-resourceid) | string | The scope for the role assignment, fully qualified resourceId. |
| [`roleDefinitionId`](#parameter-roledefinitionid) | string | The role definition ID for the role assignment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | The description of role assignment. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`name`](#parameter-name) | string | The unique guid name for the role assignment. |
| [`principalType`](#parameter-principaltype) | string | The principal type of the assigned principal ID. |
| [`roleName`](#parameter-rolename) | string | The name for the role, used for logging. |

### Parameter: `principalId`

The Principal or Object ID of the Security Principal (User, Group, Service Principal, Managed Identity).

- Required: Yes
- Type: string

### Parameter: `resourceId`

The scope for the role assignment, fully qualified resourceId.

- Required: Yes
- Type: string

### Parameter: `roleDefinitionId`

The role definition ID for the role assignment.

- Required: Yes
- Type: string

### Parameter: `description`

The description of role assignment.

- Required: No
- Type: string
- Default: `''`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `name`

The unique guid name for the role assignment.

- Required: No
- Type: string
- Default: `[guid(parameters('resourceId'), parameters('principalId'), if(contains(parameters('roleDefinitionId'), '/providers/Microsoft.Authorization/roleDefinitions/'), parameters('roleDefinitionId'), subscriptionResourceId('Microsoft.Authorization/roleDefinitions', parameters('roleDefinitionId'))))]`

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

### Parameter: `roleName`

The name for the role, used for logging.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Assignment. |
| `resourceGroupName` | string | The name of the resource group the role assignment was applied at. |
| `resourceId` | string | The resource ID of the Role Assignment. |
| `roleName` | string | The name for the role, used for logging. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
