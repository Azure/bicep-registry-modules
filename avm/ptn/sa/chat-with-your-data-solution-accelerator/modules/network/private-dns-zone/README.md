# Private DNS Zones `[Sa/ChatWithYourDataSolutionAcceleratorModulesNetworkPrivateDnsZone]`

This module deploys a Private DNS zone.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Authorization/locks` | 2020-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.authorization_locks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks)</li></ul> |
| `Microsoft.Network/privateDnsZones` | 2020-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2020-06-01/privateDnsZones)</li></ul> |
| `Microsoft.Network/privateDnsZones/virtualNetworkLinks` | 2024-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_privatednszones_virtualnetworklinks.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-06-01/privateDnsZones/virtualNetworkLinks)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Private DNS zone name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`location`](#parameter-location) | string | The location of the PrivateDNSZone. Should be global. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |
| [`virtualNetworkLinks`](#parameter-virtualnetworklinks) | array | Array of custom objects describing vNet links of the DNS zone. Each object should contain properties 'virtualNetworkResourceId' and 'registrationEnabled'. The 'vnetResourceId' is a resource ID of a vNet to link, 'registrationEnabled' (bool) enables automatic DNS registration in the zone for the linked vNet. |

### Parameter: `name`

Private DNS zone name.

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

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |
| [`notes`](#parameter-locknotes) | string | Specify the notes of the lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `lock.notes`

Specify the notes of the lock.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `virtualNetworkLinks`

Array of custom objects describing vNet links of the DNS zone. Each object should contain properties 'virtualNetworkResourceId' and 'registrationEnabled'. The 'vnetResourceId' is a resource ID of a vNet to link, 'registrationEnabled' (bool) enables automatic DNS registration in the zone for the linked vNet.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualNetworkResourceId`](#parameter-virtualnetworklinksvirtualnetworkresourceid) | string | The resource ID of the virtual network to link. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-virtualnetworklinkslocation) | string | The Azure Region where the resource lives. |
| [`name`](#parameter-virtualnetworklinksname) | string | The resource name. |
| [`registrationEnabled`](#parameter-virtualnetworklinksregistrationenabled) | bool | Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?. |
| [`resolutionPolicy`](#parameter-virtualnetworklinksresolutionpolicy) | string | The resolution type of the private-dns-zone fallback machanism. |
| [`tags`](#parameter-virtualnetworklinkstags) | object | Resource tags. |

### Parameter: `virtualNetworkLinks.virtualNetworkResourceId`

The resource ID of the virtual network to link.

- Required: Yes
- Type: string

### Parameter: `virtualNetworkLinks.location`

The Azure Region where the resource lives.

- Required: No
- Type: string

### Parameter: `virtualNetworkLinks.name`

The resource name.

- Required: No
- Type: string

### Parameter: `virtualNetworkLinks.registrationEnabled`

Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?.

- Required: No
- Type: bool

### Parameter: `virtualNetworkLinks.resolutionPolicy`

The resolution type of the private-dns-zone fallback machanism.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Default'
    'NxDomainRedirect'
  ]
  ```

### Parameter: `virtualNetworkLinks.tags`

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `resourceId` | string | The resource ID of the private DNS zone. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
