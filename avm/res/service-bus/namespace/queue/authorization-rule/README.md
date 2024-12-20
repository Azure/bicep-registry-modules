# Service Bus Namespace Queue Authorization Rules `[Microsoft.ServiceBus/namespaces/queues/authorizationRules]`

This module deploys a Service Bus Namespace Queue Authorization Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.ServiceBus/namespaces/queues/authorizationRules` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ServiceBus/2022-10-01-preview/namespaces/queues/authorizationRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the service bus namepace queue. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment. |
| [`queueName`](#parameter-queuename) | string | The name of the parent Service Bus Namespace Queue. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rights`](#parameter-rights) | array | The rights associated with the rule. |

### Parameter: `name`

The name of the service bus namepace queue.

- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `queueName`

The name of the parent Service Bus Namespace Queue. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `rights`

The rights associated with the rule.

- Required: No
- Type: array
- Default: `[]`
- Allowed:
  ```Bicep
  [
    'Listen'
    'Manage'
    'Send'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the authorization rule. |
| `resourceGroupName` | string | The name of the Resource Group the authorization rule was created in. |
| `resourceId` | string | The Resource ID of the authorization rule. |
