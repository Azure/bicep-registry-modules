# Event Hub Namespace Event Hub Authorization Rules `[Microsoft.EventHub/namespaces/eventhubs/authorizationRules]`

This module deploys an Event Hub Namespace Event Hub Authorization Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventHub/namespaces/eventhubs/authorizationRules` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2024-01-01/namespaces/eventhubs/authorizationRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the authorization rule. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`eventHubName`](#parameter-eventhubname) | string | The name of the parent event hub namespace event hub. Required if the template is used in a standalone deployment. |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent event hub namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rights`](#parameter-rights) | array | The rights associated with the rule. |

### Parameter: `name`

The name of the authorization rule.

- Required: Yes
- Type: string

### Parameter: `eventHubName`

The name of the parent event hub namespace event hub. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent event hub namespace. Required if the template is used in a standalone deployment.

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
| `resourceGroupName` | string | The name of the resource group the authorization rule was created in. |
| `resourceId` | string | The resource ID of the authorization rule. |
