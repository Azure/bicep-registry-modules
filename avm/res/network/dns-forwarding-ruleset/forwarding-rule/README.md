# Dns Forwarding Rulesets Forwarding Rules `[Microsoft.Network/dnsForwardingRulesets/forwardingRules]`

This template deploys Forwarding Rule in a Dns Forwarding Ruleset.

You can reference the module as follows:
```bicep
module dnsForwardingRuleset 'br/public:avm/res/network/dns-forwarding-ruleset/forwarding-rule:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Network/dnsForwardingRulesets/forwardingRules` | 2022-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_dnsforwardingrulesets_forwardingrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2022-07-01/dnsForwardingRulesets/forwardingRules)</li></ul> |

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
