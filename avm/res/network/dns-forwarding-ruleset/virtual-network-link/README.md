# Dns Forwarding Rulesets Virtual Network Links `[Microsoft.Network/dnsForwardingRulesets/virtualNetworkLinks]`

This template deploys Virtual Network Link in a Dns Forwarding Ruleset.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
