# Service Bus Namespace Queue `[Microsoft.ServiceBus/namespaces/queues]`

This module deploys a Service Bus Namespace Queue.

You can reference the module as follows:
```bicep
module namespace 'br/public:avm/res/service-bus/namespace/queue:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Authorization/roleAssignments` | 2022-04-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_roleassignments.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments)</li></ul> |
| `Microsoft.ServiceBus/namespaces/queues` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.servicebus_namespaces_queues.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2024-01-01/namespaces/queues)</li></ul> |
| `Microsoft.ServiceBus/namespaces/queues/authorizationRules` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.servicebus_namespaces_queues_authorizationrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2024-01-01/namespaces/queues/authorizationRules)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Service Bus Queue. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationRules`](#parameter-authorizationrules) | array | Authorization Rules for the Service Bus Queue. |
| [`autoDeleteOnIdle`](#parameter-autodeleteonidle) | string | ISO 8061 timeSpan idle interval after which the queue is automatically deleted. The minimum duration is 5 minutes (PT5M). |
| [`deadLetteringOnMessageExpiration`](#parameter-deadletteringonmessageexpiration) | bool | A value that indicates whether this queue has dead letter support when a message expires. |
| [`defaultMessageTimeToLive`](#parameter-defaultmessagetimetolive) | string | ISO 8601 default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. |
| [`duplicateDetectionHistoryTimeWindow`](#parameter-duplicatedetectionhistorytimewindow) | string | ISO 8601 timeSpan structure that defines the duration of the duplicate detection history. The default value is 10 minutes. |
| [`enableBatchedOperations`](#parameter-enablebatchedoperations) | bool | Value that indicates whether server-side batched operations are enabled. |
| [`enableExpress`](#parameter-enableexpress) | bool | A value that indicates whether Express Entities are enabled. An express queue holds a message in memory temporarily before writing it to persistent storage. This property is only used if the `service-bus/namespace` sku is Premium. |
| [`enablePartitioning`](#parameter-enablepartitioning) | bool | A value that indicates whether the queue is to be partitioned across multiple message brokers. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`forwardDeadLetteredMessagesTo`](#parameter-forwarddeadletteredmessagesto) | string | Queue/Topic name to forward the Dead Letter message. |
| [`forwardTo`](#parameter-forwardto) | string | Queue/Topic name to forward the messages. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`lockDuration`](#parameter-lockduration) | string | ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute. |
| [`maxDeliveryCount`](#parameter-maxdeliverycount) | int | The maximum delivery count. A message is automatically deadlettered after this number of deliveries. default value is 10. |
| [`maxMessageSizeInKilobytes`](#parameter-maxmessagesizeinkilobytes) | int | Maximum size (in KB) of the message payload that can be accepted by the queue. This property is only used in Premium today and default is 1024. |
| [`maxSizeInMegabytes`](#parameter-maxsizeinmegabytes) | int | The maximum size of the queue in megabytes, which is the size of memory allocated for the queue. Default is 1024. |
| [`requiresDuplicateDetection`](#parameter-requiresduplicatedetection) | bool | A value indicating if this queue requires duplicate detection. |
| [`requiresSession`](#parameter-requiressession) | bool | A value that indicates whether the queue supports the concept of sessions. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`status`](#parameter-status) | string | Enumerates the possible values for the status of a messaging entity. - Active, Disabled, Restoring, SendDisabled, ReceiveDisabled, Creating, Deleting, Renaming, Unknown. |

### Parameter: `name`

Name of the Service Bus Queue.

- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent Service Bus Namespace for the Service Bus Queue. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `authorizationRules`

Authorization Rules for the Service Bus Queue.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `autoDeleteOnIdle`

ISO 8061 timeSpan idle interval after which the queue is automatically deleted. The minimum duration is 5 minutes (PT5M).

- Required: No
- Type: string

### Parameter: `deadLetteringOnMessageExpiration`

A value that indicates whether this queue has dead letter support when a message expires.

- Required: No
- Type: bool
- Default: `True`

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

A value that indicates whether Express Entities are enabled. An express queue holds a message in memory temporarily before writing it to persistent storage. This property is only used if the `service-bus/namespace` sku is Premium.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enablePartitioning`

A value that indicates whether the queue is to be partitioned across multiple message brokers.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `forwardDeadLetteredMessagesTo`

Queue/Topic name to forward the Dead Letter message.

- Required: No
- Type: string

### Parameter: `forwardTo`

Queue/Topic name to forward the messages.

- Required: No
- Type: string

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

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

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `lockDuration`

ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute.

- Required: No
- Type: string
- Default: `'PT1M'`

### Parameter: `maxDeliveryCount`

The maximum delivery count. A message is automatically deadlettered after this number of deliveries. default value is 10.

- Required: No
- Type: int
- Default: `10`

### Parameter: `maxMessageSizeInKilobytes`

Maximum size (in KB) of the message payload that can be accepted by the queue. This property is only used in Premium today and default is 1024.

- Required: No
- Type: int
- Default: `1024`

### Parameter: `maxSizeInMegabytes`

The maximum size of the queue in megabytes, which is the size of memory allocated for the queue. Default is 1024.

- Required: No
- Type: int
- Default: `1024`

### Parameter: `requiresDuplicateDetection`

A value indicating if this queue requires duplicate detection.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `requiresSession`

A value that indicates whether the queue supports the concept of sessions.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Azure Service Bus Data Owner'`
  - `'Azure Service Bus Data Receiver'`
  - `'Azure Service Bus Data Sender'`
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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed queue. |
| `resourceGroupName` | string | The resource group of the deployed queue. |
| `resourceId` | string | The resource ID of the deployed queue. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
| `br/public:avm/utl/types/avm-common-types:0.6.0` | Remote reference |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
