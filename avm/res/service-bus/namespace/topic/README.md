# Service Bus Namespace Topic `[Microsoft.ServiceBus/namespaces/topics]`

This module deploys a Service Bus Namespace Topic.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.ServiceBus/namespaces/topics` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/topics) |
| `Microsoft.ServiceBus/namespaces/topics/authorizationRules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/topics/authorizationRules) |
| `Microsoft.ServiceBus/namespaces/topics/subscriptions` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-11-01/namespaces/topics/subscriptions) |
| `Microsoft.ServiceBus/namespaces/topics/subscriptions/rules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/topics/subscriptions/rules) |

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
- Default: `[]`

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

### Parameter: `subscriptions`

The subscriptions of the topic.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-subscriptionsname) | string | The name of the service bus namespace topic subscription. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoDeleteOnIdle`](#parameter-subscriptionsautodeleteonidle) | string | ISO 8601 timespan idle interval after which the syubscription is automatically deleted. The minimum duration is 5 minutes. |
| [`clientAffineProperties`](#parameter-subscriptionsclientaffineproperties) | object | The properties that are associated with a subscription that is client-affine. |
| [`deadLetteringOnFilterEvaluationExceptions`](#parameter-subscriptionsdeadletteringonfilterevaluationexceptions) | bool | A value that indicates whether a subscription has dead letter support when a message expires. |
| [`deadLetteringOnMessageExpiration`](#parameter-subscriptionsdeadletteringonmessageexpiration) | bool | A value that indicates whether a subscription has dead letter support when a message expires. |
| [`defaultMessageTimeToLive`](#parameter-subscriptionsdefaultmessagetimetolive) | string | ISO 8601 timespan idle interval after which the message expires. The minimum duration is 5 minutes. |
| [`duplicateDetectionHistoryTimeWindow`](#parameter-subscriptionsduplicatedetectionhistorytimewindow) | string | ISO 8601 timespan that defines the duration of the duplicate detection history. The default value is 10 minutes. |
| [`enableBatchedOperations`](#parameter-subscriptionsenablebatchedoperations) | bool | A value that indicates whether server-side batched operations are enabled. |
| [`forwardDeadLetteredMessagesTo`](#parameter-subscriptionsforwarddeadletteredmessagesto) | string | The name of the recipient entity to which all the messages sent to the subscription are forwarded to. |
| [`forwardTo`](#parameter-subscriptionsforwardto) | string | The name of the recipient entity to which all the messages sent to the subscription are forwarded to. |
| [`isClientAffine`](#parameter-subscriptionsisclientaffine) | bool | A value that indicates whether the subscription supports the concept of session. |
| [`lockDuration`](#parameter-subscriptionslockduration) | string | ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute. |
| [`maxDeliveryCount`](#parameter-subscriptionsmaxdeliverycount) | int | Number of maximum deliveries. A message is automatically deadlettered after this number of deliveries. Default value is 10. |
| [`requiresSession`](#parameter-subscriptionsrequiressession) | bool | A value that indicates whether the subscription supports the concept of session. |
| [`rules`](#parameter-subscriptionsrules) | array | The subscription rules. |
| [`status`](#parameter-subscriptionsstatus) | string | Enumerates the possible values for the status of a messaging entity. |

### Parameter: `subscriptions.name`

The name of the service bus namespace topic subscription.

- Required: Yes
- Type: string

### Parameter: `subscriptions.autoDeleteOnIdle`

ISO 8601 timespan idle interval after which the syubscription is automatically deleted. The minimum duration is 5 minutes.

- Required: No
- Type: string

### Parameter: `subscriptions.clientAffineProperties`

The properties that are associated with a subscription that is client-affine.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-subscriptionsclientaffinepropertiesclientid) | string | Indicates the Client ID of the application that created the client-affine subscription. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isDurable`](#parameter-subscriptionsclientaffinepropertiesisdurable) | bool | For client-affine subscriptions, this value indicates whether the subscription is durable or not. |
| [`isShared`](#parameter-subscriptionsclientaffinepropertiesisshared) | bool | For client-affine subscriptions, this value indicates whether the subscription is shared or not. |

### Parameter: `subscriptions.clientAffineProperties.clientId`

Indicates the Client ID of the application that created the client-affine subscription.

- Required: Yes
- Type: string

### Parameter: `subscriptions.clientAffineProperties.isDurable`

For client-affine subscriptions, this value indicates whether the subscription is durable or not.

- Required: No
- Type: bool

### Parameter: `subscriptions.clientAffineProperties.isShared`

For client-affine subscriptions, this value indicates whether the subscription is shared or not.

- Required: No
- Type: bool

### Parameter: `subscriptions.deadLetteringOnFilterEvaluationExceptions`

A value that indicates whether a subscription has dead letter support when a message expires.

- Required: No
- Type: bool

### Parameter: `subscriptions.deadLetteringOnMessageExpiration`

A value that indicates whether a subscription has dead letter support when a message expires.

- Required: No
- Type: bool

### Parameter: `subscriptions.defaultMessageTimeToLive`

ISO 8601 timespan idle interval after which the message expires. The minimum duration is 5 minutes.

- Required: No
- Type: string

### Parameter: `subscriptions.duplicateDetectionHistoryTimeWindow`

ISO 8601 timespan that defines the duration of the duplicate detection history. The default value is 10 minutes.

- Required: No
- Type: string

### Parameter: `subscriptions.enableBatchedOperations`

A value that indicates whether server-side batched operations are enabled.

- Required: No
- Type: bool

### Parameter: `subscriptions.forwardDeadLetteredMessagesTo`

The name of the recipient entity to which all the messages sent to the subscription are forwarded to.

- Required: No
- Type: string

### Parameter: `subscriptions.forwardTo`

The name of the recipient entity to which all the messages sent to the subscription are forwarded to.

- Required: No
- Type: string

### Parameter: `subscriptions.isClientAffine`

A value that indicates whether the subscription supports the concept of session.

- Required: No
- Type: bool

### Parameter: `subscriptions.lockDuration`

ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute.

- Required: No
- Type: string

### Parameter: `subscriptions.maxDeliveryCount`

Number of maximum deliveries. A message is automatically deadlettered after this number of deliveries. Default value is 10.

- Required: No
- Type: int

### Parameter: `subscriptions.requiresSession`

A value that indicates whether the subscription supports the concept of session.

- Required: No
- Type: bool

### Parameter: `subscriptions.rules`

The subscription rules.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-subscriptionsrulesname) | string | The name of the service bus namespace topic subscription rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-subscriptionsrulesaction) | object | Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression. |
| [`correlationFilter`](#parameter-subscriptionsrulescorrelationfilter) | object | Properties of correlationFilter. |
| [`filterType`](#parameter-subscriptionsrulesfiltertype) | string | Filter type that is evaluated against a BrokeredMessage. |
| [`sqlFilter`](#parameter-subscriptionsrulessqlfilter) | object | Properties of sqlFilter. |

### Parameter: `subscriptions.rules.name`

The name of the service bus namespace topic subscription rule.

- Required: Yes
- Type: string

### Parameter: `subscriptions.rules.action`

Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`compatibilityLevel`](#parameter-subscriptionsrulesactioncompatibilitylevel) | int | This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20. |
| [`requiresPreprocessing`](#parameter-subscriptionsrulesactionrequirespreprocessing) | bool | Value that indicates whether the rule action requires preprocessing. |
| [`sqlExpression`](#parameter-subscriptionsrulesactionsqlexpression) | string | SQL expression. e.g. MyProperty='ABC'. |

### Parameter: `subscriptions.rules.action.compatibilityLevel`

This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20.

- Required: No
- Type: int

### Parameter: `subscriptions.rules.action.requiresPreprocessing`

Value that indicates whether the rule action requires preprocessing.

- Required: No
- Type: bool

### Parameter: `subscriptions.rules.action.sqlExpression`

SQL expression. e.g. MyProperty='ABC'.

- Required: No
- Type: string

### Parameter: `subscriptions.rules.correlationFilter`

Properties of correlationFilter.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`to`](#parameter-subscriptionsrulescorrelationfilterto) | string | Address to send to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-subscriptionsrulescorrelationfiltercontenttype) | string | Content type of the message. |
| [`correlationId`](#parameter-subscriptionsrulescorrelationfiltercorrelationid) | string | Identifier of the correlation. |
| [`label`](#parameter-subscriptionsrulescorrelationfilterlabel) | string | Application specific label. |
| [`messageId`](#parameter-subscriptionsrulescorrelationfiltermessageid) | string | Identifier of the message. |
| [`properties`](#parameter-subscriptionsrulescorrelationfilterproperties) | array | dictionary object for custom filters. |
| [`replyTo`](#parameter-subscriptionsrulescorrelationfilterreplyto) | string | Address of the queue to reply to. |
| [`replyToSessionId`](#parameter-subscriptionsrulescorrelationfilterreplytosessionid) | string | Session identifier to reply to. |
| [`requiresPreprocessing`](#parameter-subscriptionsrulescorrelationfilterrequirespreprocessing) | bool | Value that indicates whether the rule action requires preprocessing. |
| [`sessionId`](#parameter-subscriptionsrulescorrelationfiltersessionid) | string | Session identifier. |

### Parameter: `subscriptions.rules.correlationFilter.to`

Address to send to.

- Required: Yes
- Type: string

### Parameter: `subscriptions.rules.correlationFilter.contentType`

Content type of the message.

- Required: No
- Type: string

### Parameter: `subscriptions.rules.correlationFilter.correlationId`

Identifier of the correlation.

- Required: No
- Type: string

### Parameter: `subscriptions.rules.correlationFilter.label`

Application specific label.

- Required: No
- Type: string

### Parameter: `subscriptions.rules.correlationFilter.messageId`

Identifier of the message.

- Required: No
- Type: string

### Parameter: `subscriptions.rules.correlationFilter.properties`

dictionary object for custom filters.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    {}
  ]
  ```

### Parameter: `subscriptions.rules.correlationFilter.replyTo`

Address of the queue to reply to.

- Required: No
- Type: string

### Parameter: `subscriptions.rules.correlationFilter.replyToSessionId`

Session identifier to reply to.

- Required: No
- Type: string

### Parameter: `subscriptions.rules.correlationFilter.requiresPreprocessing`

Value that indicates whether the rule action requires preprocessing.

- Required: No
- Type: bool

### Parameter: `subscriptions.rules.correlationFilter.sessionId`

Session identifier.

- Required: No
- Type: string

### Parameter: `subscriptions.rules.filterType`

Filter type that is evaluated against a BrokeredMessage.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CorrelationFilter'
    'SqlFilter'
  ]
  ```

### Parameter: `subscriptions.rules.sqlFilter`

Properties of sqlFilter.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`compatibilityLevel`](#parameter-subscriptionsrulessqlfiltercompatibilitylevel) | int | This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20. |
| [`requiresPreprocessing`](#parameter-subscriptionsrulessqlfilterrequirespreprocessing) | bool | Value that indicates whether the rule action requires preprocessing. |
| [`sqlExpression`](#parameter-subscriptionsrulessqlfiltersqlexpression) | string | SQL expression. e.g. MyProperty='ABC'. |

### Parameter: `subscriptions.rules.sqlFilter.compatibilityLevel`

This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20.

- Required: No
- Type: int

### Parameter: `subscriptions.rules.sqlFilter.requiresPreprocessing`

Value that indicates whether the rule action requires preprocessing.

- Required: No
- Type: bool

### Parameter: `subscriptions.rules.sqlFilter.sqlExpression`

SQL expression. e.g. MyProperty='ABC'.

- Required: No
- Type: string

### Parameter: `subscriptions.status`

Enumerates the possible values for the status of a messaging entity.

- Required: No
- Type: string
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

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.4.0` | Remote reference |
