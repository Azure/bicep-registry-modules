# Eventgrid Namespace Topics `[Microsoft.EventGrid/namespaces/topics]`

This module deploys an Eventgrid Namespace Topic.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.EventGrid/namespaces/topics` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/namespaces/topics) |
| `Microsoft.EventGrid/namespaces/topics/eventSubscriptions` | [2023-12-15-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventGrid/2023-12-15-preview/namespaces/topics/eventSubscriptions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the topic. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventRetentionInDays`](#parameter-eventretentionindays) | int | Event retention for the namespace topic expressed in days. |
| [`eventSubscriptions`](#parameter-eventsubscriptions) | array | All event subscriptions to create. |
| [`inputSchema`](#parameter-inputschema) | string | This determines the format that is expected for incoming events published to the topic. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`publisherType`](#parameter-publishertype) | string | Publisher type of the namespace topic. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |

### Parameter: `name`

Name of the topic.

- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent EventGrid namespace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `eventRetentionInDays`

Event retention for the namespace topic expressed in days.

- Required: No
- Type: int
- Default: `1`

### Parameter: `eventSubscriptions`

All event subscriptions to create.

- Required: No
- Type: array

### Parameter: `inputSchema`

This determines the format that is expected for incoming events published to the topic.

- Required: No
- Type: string
- Default: `'CloudEventSchemaV1_0'`

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

### Parameter: `publisherType`

Publisher type of the namespace topic.

- Required: No
- Type: string
- Default: `'Custom'`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Azure Resource Notifications System Topics Subscriber'`
  - `'Contributor'`
  - `'EventGrid Contributor'`
  - `'EventGrid Data Contributor'`
  - `'EventGrid Data Receiver'`
  - `'EventGrid Data Sender'`
  - `'EventGrid EventSubscription Contributor'`
  - `'EventGrid EventSubscription Reader'`
  - `'EventGrid TopicSpaces Publisher'`
  - `'EventGrid TopicSpaces Subscriber'`
  - `'Owner'`
  - `'Reader'`
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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Namespace Topic. |
| `resourceGroupName` | string | The name of the resource group the Namespace Topic was created in. |
| `resourceId` | string | The resource ID of the Namespace Topic. |
