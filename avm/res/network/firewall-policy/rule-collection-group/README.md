# Firewall Policy Rule Collection Groups `[Microsoft.Network/firewallPolicies/ruleCollectionGroups]`

This module deploys a Firewall Policy Rule Collection Group.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/firewallPolicies/ruleCollectionGroups` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-04-01/firewallPolicies/ruleCollectionGroups) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the rule collection group to deploy. |
| [`priority`](#parameter-priority) | int | Priority of the Firewall Policy Rule Collection Group resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`firewallPolicyName`](#parameter-firewallpolicyname) | string | The name of the parent Firewall Policy. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`ruleCollections`](#parameter-rulecollections) | array | Group of Firewall Policy rule collections. |

### Parameter: `name`

The name of the rule collection group to deploy.

- Required: Yes
- Type: string

### Parameter: `priority`

Priority of the Firewall Policy Rule Collection Group resource.

- Required: Yes
- Type: int

### Parameter: `firewallPolicyName`

The name of the parent Firewall Policy. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `ruleCollections`

Group of Firewall Policy rule collections.

- Required: No
- Type: array

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed rule collection group. |
| `resourceGroupName` | string | The resource group of the deployed rule collection group. |
| `resourceId` | string | The resource ID of the deployed rule collection group. |
