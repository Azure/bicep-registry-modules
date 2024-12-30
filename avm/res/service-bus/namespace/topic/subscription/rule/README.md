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
| [`name`](#parameter-name) | string | The name of the service bus namespace topic subscription rule. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment. |
| [`subscriptionName`](#parameter-subscriptionname) | string | The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment. |
| [`topicName`](#parameter-topicname) | string | The name of the parent Service Bus Namespace Topic. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`filterType`](#parameter-filtertype) | string | Filter type that is evaluated against a BrokeredMessage. |

**Opional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-action) | object | Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression. |
| [`correlationFilter`](#parameter-correlationfilter) | object | Properties of a correlation filter. |
| [`sqlFilter`](#parameter-sqlfilter) | object | The properties of an SQL filter. |

### Parameter: `name`

The name of the service bus namespace topic subscription rule.

- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `subscriptionName`

The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `topicName`

The name of the parent Service Bus Namespace Topic. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `filterType`

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

### Parameter: `action`

Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `correlationFilter`

Properties of a correlation filter.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `sqlFilter`

The properties of an SQL filter.

- Required: No
- Type: object
- Default: `{}`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the rule. |
| `resourceGroupName` | string | The name of the Resource Group the rule was created in. |
| `resourceId` | string | The Resource ID of the rule. |
