# Public DNS Zone DNSSEC Config `[Microsoft.Network/dnsZones/dnssecConfigs]`

This module deploys a Public DNS Zone DNSSEC configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Network/dnsZones/dnssecConfigs` | 2023-07-01-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_dnszones_dnssecconfigs.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2023-07-01-preview/dnsZones/dnssecConfigs)</li></ul> |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`dnsZoneName`](#parameter-dnszonename) | string | The name of the parent DNS zone. Required if the template is used in a standalone deployment. |

### Parameter: `dnsZoneName`

The name of the parent DNS zone. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the DNSSEC configuration. |
| `resourceGroupName` | string | The resource group the DNSSEC configuration was deployed into. |
| `resourceId` | string | The resource ID of the DNSSEC configuration. |
| `signingKeys` | array | The signing keys of the DNSSEC configuration. |
