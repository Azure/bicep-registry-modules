# Relay Namespace WCF Relays `[Microsoft.Relay/namespaces/wcfRelays]`

This module deploys a Relay Namespace WCF Relay.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.Relay/namespaces/wcfRelays` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Relay/2021-11-01/namespaces/wcfRelays) |
| `Microsoft.Relay/namespaces/wcfRelays/authorizationRules` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Relay/2021-11-01/namespaces/wcfRelays/authorizationRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the WCF Relay. |
| [`relayType`](#parameter-relaytype) | string | Type of WCF Relay. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent Relay Namespace for the WCF Relay. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationRules`](#parameter-authorizationrules) | array | Authorization Rules for the WCF Relay. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`requiresClientAuthorization`](#parameter-requiresclientauthorization) | bool | A value indicating if this relay requires client authorization. |
| [`requiresTransportSecurity`](#parameter-requirestransportsecurity) | bool | A value indicating if this relay requires transport security. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`userMetadata`](#parameter-usermetadata) | string | User-defined string data for the WCF Relay. |

### Parameter: `name`

Name of the WCF Relay.

- Required: Yes
- Type: string

### Parameter: `relayType`

Type of WCF Relay.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Http'
    'NetTcp'
  ]
  ```

### Parameter: `namespaceName`

The name of the parent Relay Namespace for the WCF Relay. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `authorizationRules`

Authorization Rules for the WCF Relay.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      name: 'RootManageSharedAccessKey'
      rights: [
        'Listen'
        'Manage'
        'Send'
      ]
    }
    {
      name: 'defaultListener'
      rights: [
        'Listen'
      ]
    }
    {
      name: 'defaultSender'
      rights: [
        'Send'
      ]
    }
  ]
  ```

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

### Parameter: `requiresClientAuthorization`

A value indicating if this relay requires client authorization.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `requiresTransportSecurity`

A value indicating if this relay requires transport security.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Azure Relay Listener'`
  - `'Azure Relay Owner'`
  - `'Azure Relay Sender'`
  - `'Contributor'`
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

### Parameter: `userMetadata`

User-defined string data for the WCF Relay.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed wcf relay. |
| `resourceGroupName` | string | The resource group of the deployed wcf relay. |
| `resourceId` | string | The resource ID of the deployed wcf relay. |
