# Service Bus Namespace Topic `[Microsoft.ServiceBus/namespaces/topics]`

This module deploys a Service Bus Namespace Topic.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ServiceBus/namespaces/topics` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/topics) |
| `Microsoft.ServiceBus/namespaces/topics/authorizationRules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/topics/authorizationRules) |
| `Microsoft.ServiceBus/namespaces/topics/subscriptions` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-11-01/namespaces/topics/subscriptions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Service Bus Topic. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent Service Bus Namespace for the Service Bus Topic. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationRules`](#parameter-authorizationrules) | array | Authorization Rules for the Service Bus Topic. |
| [`autoDeleteOnIdle`](#parameter-autodeleteonidle) | string | ISO 8601 timespan idle interval after which the topic is automatically deleted. The minimum duration is 5 minutes. |
| [`defaultMessageTimeToLive`](#parameter-defaultmessagetimetolive) | string | ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. |
| [`duplicateDetectionHistoryTimeWindow`](#parameter-duplicatedetectionhistorytimewindow) | string | ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes. |
| [`enableBatchedOperations`](#parameter-enablebatchedoperations) | bool | Value that indicates whether server-side batched operations are enabled. |
| [`enableExpress`](#parameter-enableexpress) | bool | A value that indicates whether Express Entities are enabled. An express topic holds a message in memory temporarily before writing it to persistent storage. This property is only used if the `service-bus/namespace` sku is Premium. |
| [`enablePartitioning`](#parameter-enablepartitioning) | bool | A value that indicates whether the topic is to be partitioned across multiple message brokers. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`maxMessageSizeInKilobytes`](#parameter-maxmessagesizeinkilobytes) | int | Maximum size (in KB) of the message payload that can be accepted by the topic. This property is only used in Premium today and default is 1024. This property is only used if the `service-bus/namespace` sku is Premium. |
| [`maxSizeInMegabytes`](#parameter-maxsizeinmegabytes) | int | The maximum size of the topic in megabytes, which is the size of memory allocated for the topic. Default is 1024. |
| [`requiresDuplicateDetection`](#parameter-requiresduplicatedetection) | bool | A value indicating if this topic requires duplicate detection. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`status`](#parameter-status) | string | Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown. |
| [`subscriptions`](#parameter-subscriptions) | array | The subscriptions of the topic. |
| [`supportOrdering`](#parameter-supportordering) | bool | Value that indicates whether the topic supports ordering. |

### Parameter: `name`

Name of the Service Bus Topic.

- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent Service Bus Namespace for the Service Bus Topic. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `authorizationRules`

Authorization Rules for the Service Bus Topic.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      name: 'RootManageSharedAccessKey'
      properties: {
        rights: [
          'Listen'
          'Manage'
          'Send'
        ]
      }
    }
  ]
  ```

### Parameter: `autoDeleteOnIdle`

ISO 8601 timespan idle interval after which the topic is automatically deleted. The minimum duration is 5 minutes.

- Required: No
- Type: string

### Parameter: `defaultMessageTimeToLive`

ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself.

- Required: No
- Type: string
- Default: `'P14D'`

### Parameter: `duplicateDetectionHistoryTimeWindow`

ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes.

- Required: No
- Type: string
- Default: `'PT10M'`

### Parameter: `enableBatchedOperations`

Value that indicates whether server-side batched operations are enabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `enableExpress`

A value that indicates whether Express Entities are enabled. An express topic holds a message in memory temporarily before writing it to persistent storage. This property is only used if the `service-bus/namespace` sku is Premium.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePartitioning`

A value that indicates whether the topic is to be partitioned across multiple message brokers.

- Required: No
- Type: bool
- Default: `False`

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

### Parameter: `maxMessageSizeInKilobytes`

Maximum size (in KB) of the message payload that can be accepted by the topic. This property is only used in Premium today and default is 1024. This property is only used if the `service-bus/namespace` sku is Premium.

- Required: No
- Type: int
- Default: `1024`

### Parameter: `maxSizeInMegabytes`

The maximum size of the topic in megabytes, which is the size of memory allocated for the topic. Default is 1024.

- Required: No
- Type: int
- Default: `1024`

### Parameter: `requiresDuplicateDetection`

A value indicating if this topic requires duplicate detection.

- Required: No
- Type: bool
- Default: `True`

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

### Parameter: `status`

Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown.

- Required: No
- Type: string
- Default: `'Active'`
- Allowed:
  ```Bicep
  [
    'Active'
    'Creating'
    'Deleting'
    'Disabled'
    'ReceiveDisabled'
    'Renaming'
    'Restoring'
    'SendDisabled'
    'Unknown'
  ]
  ```

### Parameter: `subscriptions`

The subscriptions of the topic.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `supportOrdering`

Value that indicates whether the topic supports ordering.

- Required: No
- Type: bool
- Default: `False`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed topic. |
| `resourceGroupName` | string | The resource group of the deployed topic. |
| `resourceId` | string | The resource ID of the deployed topic. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
