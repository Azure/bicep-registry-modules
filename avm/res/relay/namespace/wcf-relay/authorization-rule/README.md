# WCF Relay Authorization Rules `[Microsoft.Relay/namespaces/wcfRelays/authorizationRules]`

This module deploys a WCF Relay Authorization Rule.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Relay/namespaces/wcfRelays/authorizationRules` | [2021-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Relay/2021-11-01/namespaces/wcfRelays/authorizationRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the authorization rule. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent Relay Namespace. Required if the template is used in a standalone deployment. |
| [`wcfRelayName`](#parameter-wcfrelayname) | string | The name of the parent Relay Namespace WCF Relay. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`rights`](#parameter-rights) | array | The rights associated with the rule. |

### Parameter: `name`

The name of the authorization rule.

- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent Relay Namespace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `wcfRelayName`

The name of the parent Relay Namespace WCF Relay. Required if the template is used in a standalone deployment.

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
