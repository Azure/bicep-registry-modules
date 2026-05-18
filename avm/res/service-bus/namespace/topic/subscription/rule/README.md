# Service Bus Namespace Topic Subscription Rule `[Microsoft.ServiceBus/namespaces/topics/subscriptions/rules]`

This module deploys a Service Bus Namespace Topic Subscription Rule.

You can reference the module as follows:
```bicep
module namespace 'br/public:avm/res/service-bus/namespace/topic/subscription/rule:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ServiceBus/namespaces/topics/subscriptions/rules` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.servicebus_namespaces_topics_subscriptions_rules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2024-01-01/namespaces/topics/subscriptions/rules)</li></ul> |

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the rule. |
| `resourceGroupName` | string | The name of the Resource Group the rule was created in. |
| `resourceId` | string | The Resource ID of the rule. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
