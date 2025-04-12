# Role Assignments (Subscription scope) `[Microsoft.Authorization/roleAssignments]`

This module deploys a Role Assignment at a Subscription scope.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |

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
| [`principalType`](#parameter-principaltype) | string | The principal type of the assigned principal ID. |
| [`subscriptionId`](#parameter-subscriptionid) | string | Subscription ID of the subscription to assign the RBAC role to. If not provided, will use the current scope for deployment. |

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

### Parameter: `subscriptionId`

Subscription ID of the subscription to assign the RBAC role to. If not provided, will use the current scope for deployment.

- Required: No
- Type: string
- Default: `[subscription().subscriptionId]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The GUID of the Role Assignment. |
| `resourceId` | string | The resource ID of the Role Assignment. |
| `scope` | string | The scope this Role Assignment applies to. |
| `subscriptionName` | string | The name of the resource group the role assignment was applied at. |
