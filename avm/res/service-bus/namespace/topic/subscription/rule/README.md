# Service Bus Namespace Topic Subscription Rule `[Microsoft.ServiceBus/namespaces/topics/subscriptions/rules]`

This module deploys a Service Bus Namespace Topic Subscription Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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
| [`subscriptionName`](#parameter-subscriptionname) | string | The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`filterType`](#parameter-filtertype) | string | Filter type that is evaluated against a BrokeredMessage. |

**Opional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-action) | object | Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression |
| [`correlationFilter`](#parameter-correlationfilter) | object | Properties of correlationFilter |
| [`sqlFilter`](#parameter-sqlfilter) | object | Properties of sqlFilter |

### Parameter: `name`

The name of the service bus namespace topic subscription rule.

- Required: Yes
- Type: string

### Parameter: `subscriptionName`

The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment.

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

Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression

- Required: No
- Type: object
- Default: `{}`

### Parameter: `correlationFilter`

Properties of correlationFilter

- Required: No
- Type: object
- Default: `{}`

### Parameter: `sqlFilter`

Properties of sqlFilter

- Required: No
- Type: object
- Default: `{}`


## Outputs

| Output | Type |
| :-- | :-- |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
