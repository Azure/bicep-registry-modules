# CDN Profiles Custom Domains `[Microsoft.Cdn/profiles/customDomains]`

This module deploys a CDN Profile Custom Domains.

You can reference the module as follows:
```bicep
module profile 'br/public:avm/res/cdn/profile/custom-domain:<version>' = {
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
| `Microsoft.Cdn/profiles/customDomains` | 2025-06-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.cdn_profiles_customdomains.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-06-01/profiles/customDomains)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateType`](#parameter-certificatetype) | string | The type of the certificate used for secure delivery. |
| [`hostName`](#parameter-hostname) | string | The host name of the domain. Must be a domain name. |
| [`name`](#parameter-name) | string | The name of the custom domain. |
| [`profileName`](#parameter-profilename) | string | The name of the CDN profile. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`cipherSuiteSetType`](#parameter-ciphersuitesettype) | string | The cipher suite set type that will be used for Https. |
| [`customizedCipherSuiteSet`](#parameter-customizedciphersuiteset) | object | The customized cipher suite set that will be used for Https. Required if cipherSuiteSetType is Customized. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`extendedProperties`](#parameter-extendedproperties) | object | Key-Value pair representing migration properties for domains. |
| [`minimumTlsVersion`](#parameter-minimumtlsversion) | string | The minimum TLS version required for the custom domain. Default value: TLS12. |
| [`preValidatedCustomDomainResourceId`](#parameter-prevalidatedcustomdomainresourceid) | string | Resource reference to the Azure resource where custom domain ownership was prevalidated. |
| [`secretName`](#parameter-secretname) | string | The name of the secret. ie. subs/rg/profile/secret. |

**Optonal parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureDnsZoneResourceId`](#parameter-azurednszoneresourceid) | string | Resource reference to the Azure DNS zone. |

### Parameter: `certificateType`

The type of the certificate used for secure delivery.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'AzureFirstPartyManagedCertificate'
    'CustomerCertificate'
    'ManagedCertificate'
  ]
  ```

### Parameter: `hostName`

The host name of the domain. Must be a domain name.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the custom domain.

- Required: Yes
- Type: string

### Parameter: `profileName`

The name of the CDN profile.

- Required: Yes
- Type: string

### Parameter: `cipherSuiteSetType`

The cipher suite set type that will be used for Https.

- Required: No
- Type: string

### Parameter: `customizedCipherSuiteSet`

The customized cipher suite set that will be used for Https. Required if cipherSuiteSetType is Customized.

- Required: No
- Type: object

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `extendedProperties`

Key-Value pair representing migration properties for domains.

- Required: No
- Type: object

### Parameter: `minimumTlsVersion`

The minimum TLS version required for the custom domain. Default value: TLS12.

- Required: No
- Type: string
- Default: `'TLS12'`
- Allowed:
  ```Bicep
  [
    'TLS10'
    'TLS12'
    'TLS13'
  ]
  ```

### Parameter: `preValidatedCustomDomainResourceId`

Resource reference to the Azure resource where custom domain ownership was prevalidated.

- Required: No
- Type: string
- Default: `''`

### Parameter: `secretName`

The name of the secret. ie. subs/rg/profile/secret.

- Required: No
- Type: string
- Default: `''`

### Parameter: `azureDnsZoneResourceId`

Resource reference to the Azure DNS zone.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `dnsValidation` |  | The DNS validation records. |
| `name` | string | The name of the custom domain. |
| `resourceGroupName` | string | The name of the resource group the custom domain was created in. |
| `resourceId` | string | The resource id of the custom domain. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
