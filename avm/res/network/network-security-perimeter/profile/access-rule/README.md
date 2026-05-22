# Network Security Perimeter Access Rule `[Microsoft.Network/networkSecurityPerimeters/profiles/accessRules]`

This module deploys a Network Security Perimeter Access Rule.

You can reference the module as follows:
```bicep
module networkSecurityPerimeter 'br/public:avm/res/network/network-security-perimeter/profile/access-rule:<version>' = {
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
| `Microsoft.Network/networkSecurityPerimeters/profiles/accessRules` | 2024-07-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.network_networksecurityperimeters_profiles_accessrules.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Network/2024-07-01/networkSecurityPerimeters/profiles/accessRules)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`direction`](#parameter-direction) | string | The type for an access rule. |
| [`name`](#parameter-name) | string | The name of the access rule. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`networkPerimeterName`](#parameter-networkperimetername) | string | The name of the parent network perimeter. Required if the template is used in a standalone deployment. |
| [`networkPerimeterProfileName`](#parameter-networkperimeterprofilename) | string | The name of the parent network perimeter Profile. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`addressPrefixes`](#parameter-addressprefixes) | array | Inbound address prefixes (IPv4/IPv6).s. |
| [`emailAddresses`](#parameter-emailaddresses) | array | Outbound rules email address format. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`fullyQualifiedDomainNames`](#parameter-fullyqualifieddomainnames) | array | Outbound rules fully qualified domain name format. |
| [`phoneNumbers`](#parameter-phonenumbers) | array | Outbound rules phone number format. |
| [`serviceTags`](#parameter-servicetags) | array | Inbound rules service tag names. |
| [`subscriptions`](#parameter-subscriptions) | array | List of subscription ids. |

### Parameter: `direction`

The type for an access rule.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Inbound'
    'Outbound'
  ]
  ```

### Parameter: `name`

The name of the access rule.

- Required: Yes
- Type: string

### Parameter: `networkPerimeterName`

The name of the parent network perimeter. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `networkPerimeterProfileName`

The name of the parent network perimeter Profile. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `addressPrefixes`

Inbound address prefixes (IPv4/IPv6).s.

- Required: No
- Type: array

### Parameter: `emailAddresses`

Outbound rules email address format.

- Required: No
- Type: array

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `fullyQualifiedDomainNames`

Outbound rules fully qualified domain name format.

- Required: No
- Type: array

### Parameter: `phoneNumbers`

Outbound rules phone number format.

- Required: No
- Type: array

### Parameter: `serviceTags`

Inbound rules service tag names.

- Required: No
- Type: array

### Parameter: `subscriptions`

List of subscription ids.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-subscriptionsid) | string | The subscription id. |

### Parameter: `subscriptions.id`

The subscription id.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed profile. |
| `resourceGroupName` | string | The resource group the network security perimeter was deployed into. |
| `resourceId` | string | The resource ID of the deployed profile. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
