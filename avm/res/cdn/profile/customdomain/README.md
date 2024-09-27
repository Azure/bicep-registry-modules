# CDN Profiles Custom Domains `[Microsoft.Cdn/profiles/customDomains]`

This module deploys a CDN Profile Custom Domains.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/customDomains` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/customDomains) |

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

### Parameter: `extendedProperties`

Key-Value pair representing migration properties for domains.

- Required: No
- Type: object
- Default: `{}`

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
| `name` | string | The name of the custom domain. |
| `resourceGroupName` | string | The name of the resource group the custom domain was created in. |
| `resourceId` | string | The resource id of the custom domain. |
