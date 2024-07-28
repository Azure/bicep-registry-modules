# Dns Forwarding Rulesets Virtual Network Links `[Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks]`

This template deploys Virtual Network Link in a Dns Forwarding Ruleset.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsForwardingRulesets/virtualNetworkLinks) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualNetworkResourceId`](#parameter-virtualnetworkresourceid) | string | Link to another virtual network resource ID. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dnsForwardingRulesetName`](#parameter-dnsforwardingrulesetname) | string | The name of the parent DNS Fowarding Rule Set. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`metadata`](#parameter-metadata) | object | Metadata attached to the forwarding rule. |
| [`name`](#parameter-name) | string | The name of the virtual network link. |

### Parameter: `virtualNetworkResourceId`

Link to another virtual network resource ID.

- Required: Yes
- Type: string

### Parameter: `dnsForwardingRulesetName`

The name of the parent DNS Fowarding Rule Set. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `metadata`

Metadata attached to the forwarding rule.

- Required: No
- Type: object

### Parameter: `name`

The name of the virtual network link.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed virtual network link. |
| `resourceGroupName` | string | The resource group of the deployed virtual network link. |
| `resourceId` | string | The resource ID of the deployed virtual network link. |
