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
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment. |
| [`topicName`](#parameter-topicname) | string | The name of the parent Service Bus Namespace Topic. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoDeleteOnIdle`](#parameter-autodeleteonidle) | string | ISO 8601 timespan idle interval after which the subscription is automatically deleted. The minimum duration is 5 minutes. |
| [`clientAffineProperties`](#parameter-clientaffineproperties) | object | The properties that are associated with a subscription that is client-affine. |
| [`deadLetteringOnFilterEvaluationExceptions`](#parameter-deadletteringonfilterevaluationexceptions) | bool | A value that indicates whether a subscription has dead letter support when a message expires. |
| [`deadLetteringOnMessageExpiration`](#parameter-deadletteringonmessageexpiration) | bool | A value that indicates whether a subscription has dead letter support when a message expires. |
| [`defaultMessageTimeToLive`](#parameter-defaultmessagetimetolive) | string | ISO 8601 timespan idle interval after which the message expires. The minimum duration is 5 minutes. |
| [`duplicateDetectionHistoryTimeWindow`](#parameter-duplicatedetectionhistorytimewindow) | string | ISO 8601 timespan that defines the duration of the duplicate detection history. The default value is 10 minutes. |
| [`enableBatchedOperations`](#parameter-enablebatchedoperations) | bool | A value that indicates whether server-side batched operations are enabled. |
| [`forwardDeadLetteredMessagesTo`](#parameter-forwarddeadletteredmessagesto) | string | The name of the recipient entity to which all the messages sent to the subscription are forwarded to. |
| [`forwardTo`](#parameter-forwardto) | string | The name of the recipient entity to which all the messages sent to the subscription are forwarded to. |
| [`isClientAffine`](#parameter-isclientaffine) | bool | A value that indicates whether the subscription supports the concept of session. |
| [`lockDuration`](#parameter-lockduration) | string | ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute. |
| [`maxDeliveryCount`](#parameter-maxdeliverycount) | int | Number of maximum deliveries. A message is automatically deadlettered after this number of deliveries. Default value is 10. |
| [`requiresSession`](#parameter-requiressession) | bool | A value that indicates whether the subscription supports the concept of session. |
| [`rules`](#parameter-rules) | array | The subscription rules. |
| [`status`](#parameter-status) | string | Enumerates the possible values for the status of a messaging entity. |

### Parameter: `name`

The name of the service bus namespace topic subscription.

- Required: Yes
- Type: string

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
- Default: `'PT1H'`

### Parameter: `clientAffineProperties`

The properties that are associated with a subscription that is client-affine.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `deadLetteringOnFilterEvaluationExceptions`

A value that indicates whether a subscription has dead letter support when a message expires.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `deadLetteringOnMessageExpiration`

A value that indicates whether a subscription has dead letter support when a message expires.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `defaultMessageTimeToLive`

ISO 8601 timespan idle interval after which the message expires. The minimum duration is 5 minutes.

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

The name of the recipient entity to which all the messages sent to the subscription are forwarded to.

- Required: No
- Type: string
- Default: `''`

### Parameter: `forwardTo`

The name of the recipient entity to which all the messages sent to the subscription are forwarded to.

- Required: No
- Type: string
- Default: `''`

### Parameter: `isClientAffine`

A value that indicates whether the subscription supports the concept of session.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `lockDuration`

ISO 8601 timespan duration of a peek-lock; that is, the amount of time that the message is locked for other receivers. The maximum value for LockDuration is 5 minutes; the default value is 1 minute.

- Required: No
- Type: string
- Default: `'PT1M'`

### Parameter: `maxDeliveryCount`

Number of maximum deliveries. A message is automatically deadlettered after this number of deliveries. Default value is 10.

- Required: No
- Type: int
- Default: `10`

### Parameter: `requiresSession`

A value that indicates whether the subscription supports the concept of session.

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
| [`name`](#parameter-rulesname) | string | The name of the service bus namespace topic subscription rule. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-rulesaction) | object | Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression. |
| [`correlationFilter`](#parameter-rulescorrelationfilter) | object | Properties of correlationFilter. |
| [`filterType`](#parameter-rulesfiltertype) | string | Filter type that is evaluated against a BrokeredMessage. |
| [`sqlFilter`](#parameter-rulessqlfilter) | object | Properties of sqlFilter. |

### Parameter: `rules.name`

The name of the service bus namespace topic subscription rule.

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`to`](#parameter-rulescorrelationfilterto) | string | Address to send to. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-rulescorrelationfiltercontenttype) | string | Content type of the message. |
| [`correlationId`](#parameter-rulescorrelationfiltercorrelationid) | string | Identifier of the correlation. |
| [`label`](#parameter-rulescorrelationfilterlabel) | string | Application specific label. |
| [`messageId`](#parameter-rulescorrelationfiltermessageid) | string | Identifier of the message. |
| [`properties`](#parameter-rulescorrelationfilterproperties) | array | dictionary object for custom filters. |
| [`replyTo`](#parameter-rulescorrelationfilterreplyto) | string | Address of the queue to reply to. |
| [`replyToSessionId`](#parameter-rulescorrelationfilterreplytosessionid) | string | Session identifier to reply to. |
| [`requiresPreprocessing`](#parameter-rulescorrelationfilterrequirespreprocessing) | bool | Value that indicates whether the rule action requires preprocessing. |
| [`sessionId`](#parameter-rulescorrelationfiltersessionid) | string | Session identifier. |

### Parameter: `rules.correlationFilter.to`

Address to send to.

- Required: Yes
- Type: string

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

dictionary object for custom filters.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    {}
  ]
  ```

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

### Parameter: `rules.filterType`

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

### Parameter: `rules.sqlFilter`

Properties of sqlFilter.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`compatibilityLevel`](#parameter-rulessqlfiltercompatibilitylevel) | int | This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20. |
| [`requiresPreprocessing`](#parameter-rulessqlfilterrequirespreprocessing) | bool | Value that indicates whether the rule action requires preprocessing. |
| [`sqlExpression`](#parameter-rulessqlfiltersqlexpression) | string | SQL expression. e.g. MyProperty='ABC'. |

### Parameter: `rules.sqlFilter.compatibilityLevel`

This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20.

- Required: No
- Type: int

### Parameter: `rules.sqlFilter.requiresPreprocessing`

Value that indicates whether the rule action requires preprocessing.

- Required: No
- Type: bool

### Parameter: `rules.sqlFilter.sqlExpression`

SQL expression. e.g. MyProperty='ABC'.

- Required: No
- Type: string

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
