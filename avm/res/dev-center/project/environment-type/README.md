# Dev Center Project Environment Type `[Microsoft.DevCenter/projects/environmentTypes]`

This module deploys a Dev Center Project Environment Type.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.DevCenter/projects/environmentTypes` | [2025-02-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevCenter/2025-02-01/projects/environmentTypes) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`creatorRoleAssignmentRoles`](#parameter-creatorroleassignmentroles) | array | An array specifying the role definitions (permissions) GUIDs that will be granted to the user that creates a given environment of this type. These can be both built-in or custom role definitions. At least one role must be specified. |
| [`deploymentTargetSubscriptionResourceId`](#parameter-deploymenttargetsubscriptionresourceid) | string | The subscription Resource ID where the environment type will be mapped to. The environment's resources will be deployed into this subscription. Should be in the format "/subscriptions/{subscriptionId}". |
| [`name`](#parameter-name) | string | The name of the environment type. The environment type must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`projectName`](#parameter-projectname) | string | The name of the parent dev center project. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`displayName`](#parameter-displayname) | string | The display name of the environment type. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`managedIdentities`](#parameter-managedidentities) | object | The managed identity definition for this resource. If using user assigned identities, they must be first associated to the project that this environment type is created in and only one user identity can be used per project. At least one identity (system assigned or user assigned) must be enabled for deployment. The default is set to system assigned identity. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`status`](#parameter-status) | string | Defines whether this Environment Type can be used in this Project. The default is "Enabled". |
| [`tags`](#parameter-tags) | object | Resource tags to apply to the environment type. |
| [`userRoleAssignmentsRoles`](#parameter-userroleassignmentsroles) | array | A collection of additional object IDs of users, groups, service principals or managed identities be granted permissions on each environment of this type. Each identity can have multiple role definitions (permissions) GUIDs assigned to it. These can be either built-in or custom role definitions. |

### Parameter: `creatorRoleAssignmentRoles`

An array specifying the role definitions (permissions) GUIDs that will be granted to the user that creates a given environment of this type. These can be both built-in or custom role definitions. At least one role must be specified.

- Required: Yes
- Type: array

### Parameter: `deploymentTargetSubscriptionResourceId`

The subscription Resource ID where the environment type will be mapped to. The environment's resources will be deployed into this subscription. Should be in the format "/subscriptions/{subscriptionId}".

- Required: Yes
- Type: string

### Parameter: `name`

The name of the environment type. The environment type must be first created in the Dev Center and then made available to a project using project level environment types. The name should be equivalent to the name of the environment type in the Dev Center.

- Required: Yes
- Type: string

### Parameter: `projectName`

The name of the parent dev center project. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `displayName`

The display name of the environment type.

- Required: No
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `managedIdentities`

The managed identity definition for this resource. If using user assigned identities, they must be first associated to the project that this environment type is created in and only one user identity can be used per project. At least one identity (system assigned or user assigned) must be enabled for deployment. The default is set to system assigned identity.

- Required: No
- Type: object
- Default:
  ```Bicep
  {
      systemAssigned: true
  }
  ```

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

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'DevCenter Project Admin'`
  - `'DevCenter Dev Box User'`
  - `'DevTest Labs User'`
  - `'Deployment Environments User'`
  - `'Deployment Environments Reader'`
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

### Parameter: `status`

Defines whether this Environment Type can be used in this Project. The default is "Enabled".

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `tags`

Resource tags to apply to the environment type.

- Required: No
- Type: object

### Parameter: `userRoleAssignmentsRoles`

A collection of additional object IDs of users, groups, service principals or managed identities be granted permissions on each environment of this type. Each identity can have multiple role definitions (permissions) GUIDs assigned to it. These can be either built-in or custom role definitions.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`objectId`](#parameter-userroleassignmentsrolesobjectid) | string | The object ID of the user, group, service principal, or managed identity. |
| [`roleDefinitions`](#parameter-userroleassignmentsrolesroledefinitions) | array | An array of role definition GUIDs to assign to the object. |

### Parameter: `userRoleAssignmentsRoles.objectId`

The object ID of the user, group, service principal, or managed identity.

- Required: Yes
- Type: string

### Parameter: `userRoleAssignmentsRoles.roleDefinitions`

An array of role definition GUIDs to assign to the object.

- Required: Yes
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the environment type. |
| `resourceGroupName` | string | The name of the resource group the environment type was created in. |
| `resourceId` | string | The resource ID of the environment type. |
| `systemAssignedMIPrincipalId` | string | The principal ID of the system assigned identity. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
