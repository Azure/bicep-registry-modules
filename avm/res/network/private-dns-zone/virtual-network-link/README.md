# Private DNS Zone Virtual Network Link `[Microsoft.Network/privateDnsZones/virtualNetworkLinks]`

This module deploys a Private DNS Zone Virtual Network Link.

You can reference the module as follows:
```bicep
module privateDnsZone 'br/public:avm/res/network/private-dns-zone/virtual-network-link:<version>' = {
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
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | 2024-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_virtualnetworklinks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones/virtualNetworkLinks)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualNetworkResourceId`](#parameter-virtualnetworkresourceid) | string | Link to another virtual network resource ID. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`privateDnsZoneName`](#parameter-privatednszonename) | string | The name of the parent Private DNS zone. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The location of the PrivateDNSZone. Should be global. |
| [`name`](#parameter-name) | string | The name of the virtual network link. |
| [`registrationEnabled`](#parameter-registrationenabled) | bool | Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?. |
| [`resolutionPolicy`](#parameter-resolutionpolicy) | string | The resolution policy on the virtual network link. Only applicable for virtual network links to privatelink zones, and for A,AAAA,CNAME queries. When set to `NxDomainRedirect`, Azure DNS resolver falls back to public resolution if private dns query resolution results in non-existent domain response. `Default` is configured as the default option. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `virtualNetworkResourceId`

Link to another virtual network resource ID.

- Required: Yes
- Type: string

### Parameter: `privateDnsZoneName`

The name of the parent Private DNS zone. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

The location of the PrivateDNSZone. Should be global.

- Required: No
- Type: string
- Default: `'global'`

### Parameter: `name`

The name of the virtual network link.

- Required: No
- Type: string
- Default: `[format('{0}-vnetlink', last(split(parameters('virtualNetworkResourceId'), '/')))]`

### Parameter: `registrationEnabled`

Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `resolutionPolicy`

The resolution policy on the virtual network link. Only applicable for virtual network links to privatelink zones, and for A,AAAA,CNAME queries. When set to `NxDomainRedirect`, Azure DNS resolver falls back to public resolution if private dns query resolution results in non-existent domain response. `Default` is configured as the default option.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed virtual network link. |
| `resourceGroupName` | string | The resource group of the deployed virtual network link. |
| `resourceId` | string | The resource ID of the deployed virtual network link. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
