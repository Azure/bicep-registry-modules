# Service Bus Namespace Topic Subscription `[Microsoft.ServiceBus/namespaces/topics/subscriptions]`

This module deploys a Service Bus Namespace Topic Subscription.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/topics/subscriptions` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2021-11-01/namespaces/topics/subscriptions) |
| `Microsoft.ServiceBus/namespaces/topics/subscriptions/rules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/topics/subscriptions/rules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the service bus namespace topic subscription. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientAffineProperties`](#parameter-clientaffineproperties) | object | The properties that are associated with a subscription that is client-affine. Required if 'isClientAffine' is set to true. |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment. |
| [`topicName`](#parameter-topicname) | string | The name of the parent Service Bus Namespace Topic. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoDeleteOnIdle`](#parameter-autodeleteonidle) | string | ISO 8601 timespan idle interval after which the subscription is automatically deleted. The minimum duration is 5 minutes. |
| [`deadLetteringOnFilterEvaluationExceptions`](#parameter-deadletteringonfilterevaluationexceptions) | bool | A value that indicates whether a subscription has dead letter support on filter evaluation exceptions. |
| [`deadLetteringOnMessageExpiration`](#parameter-deadletteringonmessageexpiration) | bool | A value that indicates whether a subscription has dead letter support when a message expires. |
| [`defaultMessageTimeToLive`](#parameter-defaultmessagetimetolive) | string | ISO 8061 Default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself. |
| [`duplicateDetectionHistoryTimeWindow`](#parameter-duplicatedetectionhistorytimewindow) | string | ISO 8601 timespan that defines the duration of the duplicate detection history. The default value is 10 minutes. |
| [`enableBatchedOperations`](#parameter-enablebatchedoperations) | bool | A value that indicates whether server-side batched operations are enabled. |
| [`forwardDeadLetteredMessagesTo`](#parameter-forwarddeadletteredmessagesto) | string | Queue/Topic name to forward the Dead Letter messages to. |
| [`forwardTo`](#parameter-forwardto) | string | Queue/Topic name to forward the messages to. |
| [`isClientAffine`](#parameter-isclientaffine) | bool | A value that indicates whether the subscription has an affinity to the client id. |
| [`lockDuration`](#parameter-lockduration) | string | ISO 8061 lock duration timespan for the subscription. The default value is 1 minute. |
| [`maxDeliveryCount`](#parameter-maxdeliverycount) | int | Number of maximum deliveries. A message is automatically deadlettered after this number of deliveries. Default value is 10. |
| [`requiresSession`](#parameter-requiressession) | bool | A value that indicates whether the subscription supports the concept of sessions. |
| [`rules`](#parameter-rules) | array | The subscription rules. |
| [`status`](#parameter-status) | string | Enumerates the possible values for the status of a messaging entity. |

### Parameter: `name`

The name of the service bus namespace topic subscription.

- Required: Yes
- Type: string

### Parameter: `clientAffineProperties`

The properties that are associated with a subscription that is client-affine. Required if 'isClientAffine' is set to true.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`clientId`](#parameter-clientaffinepropertiesclientid) | string | Indicates the Client ID of the application that created the client-affine subscription. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`isDurable`](#parameter-clientaffinepropertiesisdurable) | bool | For client-affine subscriptions, this value indicates whether the subscription is durable or not. Defaults to true. |
| [`isShared`](#parameter-clientaffinepropertiesisshared) | bool | For client-affine subscriptions, this value indicates whether the subscription is shared or not. Defaults to false. |

### Parameter: `clientAffineProperties.clientId`

Indicates the Client ID of the application that created the client-affine subscription.

- Required: Yes
- Type: string

### Parameter: `clientAffineProperties.isDurable`

For client-affine subscriptions, this value indicates whether the subscription is durable or not. Defaults to true.

- Required: No
- Type: bool

### Parameter: `clientAffineProperties.isShared`

For client-affine subscriptions, this value indicates whether the subscription is shared or not. Defaults to false.

- Required: No
- Type: bool

### Parameter: `namespaceName`

The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `topicName`

The name of the parent Service Bus Namespace Topic. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `autoDeleteOnIdle`

ISO 8601 timespan idle interval after which the subscription is automatically deleted. The minimum duration is 5 minutes.

- Required: No
- Type: string
- Default: `'P10675198DT2H48M5.477S'`

### Parameter: `deadLetteringOnFilterEvaluationExceptions`

A value that indicates whether a subscription has dead letter support on filter evaluation exceptions.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `deadLetteringOnMessageExpiration`

A value that indicates whether a subscription has dead letter support when a message expires.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `defaultMessageTimeToLive`

ISO 8061 Default message timespan to live value. This is the duration after which the message expires, starting from when the message is sent to Service Bus. This is the default value used when TimeToLive is not set on a message itself.

- Required: No
- Type: string
- Default: `'P10675199DT2H48M5.4775807S'`

### Parameter: `duplicateDetectionHistoryTimeWindow`

ISO 8601 timespan that defines the duration of the duplicate detection history. The default value is 10 minutes.

- Required: No
- Type: string
- Default: `'PT10M'`

### Parameter: `enableBatchedOperations`

A value that indicates whether server-side batched operations are enabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `forwardDeadLetteredMessagesTo`

Queue/Topic name to forward the Dead Letter messages to.

- Required: No
- Type: string
- Default: `''`

### Parameter: `forwardTo`

Queue/Topic name to forward the messages to.

- Required: No
- Type: string
- Default: `''`

### Parameter: `isClientAffine`

A value that indicates whether the subscription has an affinity to the client id.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `lockDuration`

ISO 8061 lock duration timespan for the subscription. The default value is 1 minute.

- Required: No
- Type: string
- Default: `'PT1M'`

### Parameter: `maxDeliveryCount`

Number of maximum deliveries. A message is automatically deadlettered after this number of deliveries. Default value is 10.

- Required: No
- Type: int
- Default: `10`

### Parameter: `requiresSession`

A value that indicates whether the subscription supports the concept of sessions.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `rules`

The subscription rules.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`filterType`](#parameter-rulesfiltertype) | string | Filter type that is evaluated against a BrokeredMessage. |
| [`name`](#parameter-rulesname) | string | The name of the Service Bus Namespace Topic Subscription Rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-rulesaction) | object | Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression. |
| [`correlationFilter`](#parameter-rulescorrelationfilter) | object | Properties of correlationFilter. |
| [`sqlFilter`](#parameter-rulessqlfilter) | object | Properties of sqlFilter. |

### Parameter: `rules.filterType`

Filter type that is evaluated against a BrokeredMessage.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'CorrelationFilter'
    'SqlFilter'
  ]
  ```

### Parameter: `rules.name`

The name of the Service Bus Namespace Topic Subscription Rule.

- Required: Yes
- Type: string

### Parameter: `rules.action`

Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`compatibilityLevel`](#parameter-rulesactioncompatibilitylevel) | int | This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20. |
| [`requiresPreprocessing`](#parameter-rulesactionrequirespreprocessing) | bool | Value that indicates whether the rule action requires preprocessing. |
| [`sqlExpression`](#parameter-rulesactionsqlexpression) | string | SQL expression. e.g. MyProperty='ABC'. |

### Parameter: `rules.action.compatibilityLevel`

This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20.

- Required: No
- Type: int

### Parameter: `rules.action.requiresPreprocessing`

Value that indicates whether the rule action requires preprocessing.

- Required: No
- Type: bool

### Parameter: `rules.action.sqlExpression`

SQL expression. e.g. MyProperty='ABC'.

- Required: No
- Type: string

### Parameter: `rules.correlationFilter`

Properties of correlationFilter.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-rulescorrelationfiltercontenttype) | string | Content type of the message. |
| [`correlationId`](#parameter-rulescorrelationfiltercorrelationid) | string | Identifier of the correlation. |
| [`label`](#parameter-rulescorrelationfilterlabel) | string | Application specific label. |
| [`messageId`](#parameter-rulescorrelationfiltermessageid) | string | Identifier of the message. |
| [`properties`](#parameter-rulescorrelationfilterproperties) | object | Dictionary object for custom filters. |
| [`replyTo`](#parameter-rulescorrelationfilterreplyto) | string | Address of the queue to reply to. |
| [`replyToSessionId`](#parameter-rulescorrelationfilterreplytosessionid) | string | Session identifier to reply to. |
| [`requiresPreprocessing`](#parameter-rulescorrelationfilterrequirespreprocessing) | bool | Value that indicates whether the rule action requires preprocessing. |
| [`sessionId`](#parameter-rulescorrelationfiltersessionid) | string | Session identifier. |
| [`to`](#parameter-rulescorrelationfilterto) | string | Address to send to. |

### Parameter: `rules.correlationFilter.contentType`

Content type of the message.

- Required: No
- Type: string

### Parameter: `rules.correlationFilter.correlationId`

Identifier of the correlation.

- Required: No
- Type: string

### Parameter: `rules.correlationFilter.label`

Application specific label.

- Required: No
- Type: string

### Parameter: `rules.correlationFilter.messageId`

Identifier of the message.

- Required: No
- Type: string

### Parameter: `rules.correlationFilter.properties`

Dictionary object for custom filters.

- Required: No
- Type: object

### Parameter: `rules.correlationFilter.replyTo`

Address of the queue to reply to.

- Required: No
- Type: string

### Parameter: `rules.correlationFilter.replyToSessionId`

Session identifier to reply to.

- Required: No
- Type: string

### Parameter: `rules.correlationFilter.requiresPreprocessing`

Value that indicates whether the rule action requires preprocessing.

- Required: No
- Type: bool

### Parameter: `rules.correlationFilter.sessionId`

Session identifier.

- Required: No
- Type: string

### Parameter: `rules.correlationFilter.to`

Address to send to.

- Required: No
- Type: string

### Parameter: `rules.sqlFilter`

Properties of sqlFilter.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sqlExpression`](#parameter-rulessqlfiltersqlexpression) | string | The SQL expression. e.g. MyProperty='ABC'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`compatibilityLevel`](#parameter-rulessqlfiltercompatibilitylevel) | int | This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20. |
| [`requiresPreprocessing`](#parameter-rulessqlfilterrequirespreprocessing) | bool | Value that indicates whether the rule action requires preprocessing. |

### Parameter: `rules.sqlFilter.sqlExpression`

The SQL expression. e.g. MyProperty='ABC'.

- Required: Yes
- Type: string

### Parameter: `rules.sqlFilter.compatibilityLevel`

This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20.

- Required: No
- Type: int

### Parameter: `rules.sqlFilter.requiresPreprocessing`

Value that indicates whether the rule action requires preprocessing.

- Required: No
- Type: bool

### Parameter: `status`

Enumerates the possible values for the status of a messaging entity.

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
| `name` | string | The name of the topic subscription. |
| `resourceGroupName` | string | The name of the Resource Group the topic subscription was created in. |
| `resourceId` | string | The Resource ID of the topic subscription. |
