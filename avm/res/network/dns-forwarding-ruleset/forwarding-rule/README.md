# Dns Forwarding Rulesets Forwarding Rules `[Microsoft.Network/dnsForwardingRulesets/forwardingRules]`

This template deploys Forwarding Rule in a Dns Forwarding Ruleset.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Network/dnsForwardingRulesets/forwardingRules` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsForwardingRulesets/forwardingRules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`domainName`](#parameter-domainname) | string | The domain name for the forwarding rule. |
| [`name`](#parameter-name) | string | Name of the Forwarding Rule. |
| [`targetDnsServers`](#parameter-targetdnsservers) | array | DNS servers to forward the DNS query to. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dnsForwardingRulesetName`](#parameter-dnsforwardingrulesetname) | string | Name of the parent DNS Forwarding Ruleset. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`forwardingRuleState`](#parameter-forwardingrulestate) | string | The state of forwarding rule. |
| [`metadata`](#parameter-metadata) | object | Metadata attached to the forwarding rule. |

### Parameter: `domainName`

The domain name for the forwarding rule.

- Required: Yes
- Type: string

### Parameter: `name`

Name of the Forwarding Rule.

- Required: Yes
- Type: string

### Parameter: `targetDnsServers`

DNS servers to forward the DNS query to.

- Required: Yes
- Type: array

### Parameter: `dnsForwardingRulesetName`

Name of the parent DNS Forwarding Ruleset. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `forwardingRuleState`

The state of forwarding rule.

- Required: No
- Type: string

### Parameter: `metadata`

Metadata attached to the forwarding rule.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Forwarding Rule. |
| `resourceGroupName` | string | The resource group the Forwarding Rule was deployed into. |
| `resourceId` | string | The resource ID of the Forwarding Rule. |
