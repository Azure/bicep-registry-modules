# Service Bus Namespace Topic Subscription Rule `[Microsoft.ServiceBus/namespaces/topics/subscriptions/rules]`

This module deploys a Service Bus Namespace Topic Subscription Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/topics/subscriptions/rules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/topics/subscriptions/rules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`filterType`](#parameter-filtertype) | string | Filter type that is evaluated against a BrokeredMessage. |
| [`name`](#parameter-name) | string | The name of the service bus namespace topic subscription rule. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`correlationFilter`](#parameter-correlationfilter) | object | Properties of a correlation filter. Required if 'filterType' is set to 'CorrelationFilter'. |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment. |
| [`sqlFilter`](#parameter-sqlfilter) | object | Properties of a SQL filter. Required if 'filterType' is set to 'SqlFilter'. |
| [`subscriptionName`](#parameter-subscriptionname) | string | The name of the parent Service Bus Namespace Topic Subscription. Required if the template is used in a standalone deployment. |
| [`topicName`](#parameter-topicname) | string | The name of the parent Service Bus Namespace Topic. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-action) | object | Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression. |

### Parameter: `filterType`

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

### Parameter: `name`

The name of the service bus namespace topic subscription rule.

- Required: Yes
- Type: string

### Parameter: `correlationFilter`

Properties of a correlation filter. Required if 'filterType' is set to 'CorrelationFilter'.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-correlationfiltercontenttype) | string | Content type of the message. |
| [`correlationId`](#parameter-correlationfiltercorrelationid) | string | Identifier of the correlation. |
| [`label`](#parameter-correlationfilterlabel) | string | Application specific label. |
| [`messageId`](#parameter-correlationfiltermessageid) | string | Identifier of the message. |
| [`properties`](#parameter-correlationfilterproperties) | object | Dictionary object for custom filters. |
| [`replyTo`](#parameter-correlationfilterreplyto) | string | Address of the queue to reply to. |
| [`replyToSessionId`](#parameter-correlationfilterreplytosessionid) | string | Session identifier to reply to. |
| [`requiresPreprocessing`](#parameter-correlationfilterrequirespreprocessing) | bool | Value that indicates whether the rule action requires preprocessing. |
| [`sessionId`](#parameter-correlationfiltersessionid) | string | Session identifier. |
| [`to`](#parameter-correlationfilterto) | string | Address to send to. |

### Parameter: `correlationFilter.contentType`

Content type of the message.

- Required: No
- Type: string

### Parameter: `correlationFilter.correlationId`

Identifier of the correlation.

- Required: No
- Type: string

### Parameter: `correlationFilter.label`

Application specific label.

- Required: No
- Type: string

### Parameter: `correlationFilter.messageId`

Identifier of the message.

- Required: No
- Type: string

### Parameter: `correlationFilter.properties`

Dictionary object for custom filters.

- Required: No
- Type: object

### Parameter: `correlationFilter.replyTo`

Address of the queue to reply to.

- Required: No
- Type: string

### Parameter: `correlationFilter.replyToSessionId`

Session identifier to reply to.

- Required: No
- Type: string

### Parameter: `correlationFilter.requiresPreprocessing`

Value that indicates whether the rule action requires preprocessing.

- Required: No
- Type: bool

### Parameter: `correlationFilter.sessionId`

Session identifier.

- Required: No
- Type: string

### Parameter: `correlationFilter.to`

Address to send to.

- Required: No
- Type: string

### Parameter: `namespaceName`

The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `sqlFilter`

Properties of a SQL filter. Required if 'filterType' is set to 'SqlFilter'.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sqlExpression`](#parameter-sqlfiltersqlexpression) | string | The SQL expression. e.g. MyProperty='ABC'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`compatibilityLevel`](#parameter-sqlfiltercompatibilitylevel) | int | This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20. |
| [`requiresPreprocessing`](#parameter-sqlfilterrequirespreprocessing) | bool | Value that indicates whether the rule action requires preprocessing. |

### Parameter: `sqlFilter.sqlExpression`

The SQL expression. e.g. MyProperty='ABC'.

- Required: Yes
- Type: string

### Parameter: `sqlFilter.compatibilityLevel`

This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20.

- Required: No
- Type: int

### Parameter: `sqlFilter.requiresPreprocessing`

Value that indicates whether the rule action requires preprocessing.

- Required: No
- Type: bool

### Parameter: `subscriptionName`

The name of the parent Service Bus Namespace Topic Subscription. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `topicName`

The name of the parent Service Bus Namespace Topic. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `action`

Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`compatibilityLevel`](#parameter-actioncompatibilitylevel) | int | This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20. |
| [`requiresPreprocessing`](#parameter-actionrequirespreprocessing) | bool | Value that indicates whether the rule action requires preprocessing. |
| [`sqlExpression`](#parameter-actionsqlexpression) | string | SQL expression. e.g. MyProperty='ABC'. |

### Parameter: `action.compatibilityLevel`

This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20.

- Required: No
- Type: int

### Parameter: `action.requiresPreprocessing`

Value that indicates whether the rule action requires preprocessing.

- Required: No
- Type: bool

### Parameter: `action.sqlExpression`

SQL expression. e.g. MyProperty='ABC'.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the rule. |
| `resourceGroupName` | string | The name of the Resource Group the rule was created in. |
| `resourceId` | string | The Resource ID of the rule. |
