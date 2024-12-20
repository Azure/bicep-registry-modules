# Event Hub Namespace Network Rule Sets `[Microsoft.EventHub/namespaces/networkRuleSets]`

This module deploys an Event Hub Namespace Network Rule Set.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.EventHub/namespaces/networkRuleSets` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2024-01-01/namespaces/networkRuleSets) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent event hub namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`defaultAction`](#parameter-defaultaction) | string | Default Action for Network Rule Set. Default is "Allow". It will not be set if publicNetworkAccess is "Disabled". Otherwise, it will be set to "Deny" if ipRules or virtualNetworkRules are being used. |
| [`ipRules`](#parameter-iprules) | array | An array of objects for the public IP ranges you want to allow via the Event Hub Namespace firewall. Supports IPv4 address or CIDR. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny". |
| [`networkRuleSetName`](#parameter-networkrulesetname) | string | The name of the network ruleset. |
| [`publicNetworkAccess`](#parameter-publicnetworkaccess) | string | This determines if traffic is allowed over public network. Default is "Enabled". If set to "Disabled", traffic to this namespace will be restricted over Private Endpoints only and network rules will not be applied. |
| [`trustedServiceAccessEnabled`](#parameter-trustedserviceaccessenabled) | bool | Value that indicates whether Trusted Service Access is enabled or not. |
| [`virtualNetworkRules`](#parameter-virtualnetworkrules) | array | An array of subnet resource ID objects that this Event Hub Namespace is exposed to via Service Endpoints. You can enable the `ignoreMissingVnetServiceEndpoint` if you wish to add this virtual network to Event Hub Namespace but do not have an existing service endpoint. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny". |

### Parameter: `namespaceName`

The name of the parent event hub namespace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `defaultAction`

Default Action for Network Rule Set. Default is "Allow". It will not be set if publicNetworkAccess is "Disabled". Otherwise, it will be set to "Deny" if ipRules or virtualNetworkRules are being used.

- Required: No
- Type: string
- Default: `'Allow'`
- Allowed:
  ```Bicep
  [
    'Allow'
    'Deny'
  ]
  ```

### Parameter: `ipRules`

An array of objects for the public IP ranges you want to allow via the Event Hub Namespace firewall. Supports IPv4 address or CIDR. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny".

- Required: No
- Type: array
- Default: `[]`

### Parameter: `networkRuleSetName`

The name of the network ruleset.

- Required: No
- Type: string
- Default: `'default'`

### Parameter: `publicNetworkAccess`

This determines if traffic is allowed over public network. Default is "Enabled". If set to "Disabled", traffic to this namespace will be restricted over Private Endpoints only and network rules will not be applied.

- Required: No
- Type: string
- Default: `'Enabled'`
- Allowed:
  ```Bicep
  [
    'Disabled'
    'Enabled'
  ]
  ```

### Parameter: `trustedServiceAccessEnabled`

Value that indicates whether Trusted Service Access is enabled or not.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `virtualNetworkRules`

An array of subnet resource ID objects that this Event Hub Namespace is exposed to via Service Endpoints. You can enable the `ignoreMissingVnetServiceEndpoint` if you wish to add this virtual network to Event Hub Namespace but do not have an existing service endpoint. It will not be set if publicNetworkAccess is "Disabled". Otherwise, when used, defaultAction will be set to "Deny".

- Required: No
- Type: array
- Default: `[]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the network rule set. |
| `resourceGroupName` | string | The name of the resource group the network rule set was created in. |
| `resourceId` | string | The resource ID of the network rule set. |
