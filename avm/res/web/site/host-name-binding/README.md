# Web/Function Apps Slot Host Name Bindings `[Microsoft.Web/sites/hostNameBindings]`

This module deploys a Site Slot Host Name Binding.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Web/certificates` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_certificates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-11-01/certificates)</li></ul> |
| `Microsoft.Web/sites/hostNameBindings` | 2024-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_hostnamebindings.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-11-01/sites/hostNameBindings)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Hostname in the hostname binding. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent site resource. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureResourceName`](#parameter-azureresourcename) | string | Azure resource name. |
| [`azureResourceType`](#parameter-azureresourcetype) | string | Azure resource type. Possible values are Website and TrafficManager. |
| [`certificate`](#parameter-certificate) | object | Certificate object with properties for certificate creation. The expected structure matches the certificateType defined in host-name-binding-type.bicep. |
| [`customHostNameDnsRecordType`](#parameter-customhostnamednsrecordtype) | string | Custom DNS record type. Possible values are CName and A. |
| [`domainResourceId`](#parameter-domainresourceid) | string | Fully qualified ARM domain resource URI. |
| [`hostNameType`](#parameter-hostnametype) | string | Hostname type. Possible values are Verified and Managed. |
| [`kind`](#parameter-kind) | string | Kind of resource. |
| [`location`](#parameter-location) | string | Resource location. |
| [`siteName`](#parameter-sitename) | string | App Service app name. |
| [`sslState`](#parameter-sslstate) | string | SSL type. Possible values are Disabled, SniEnabled, and IpBasedEnabled. |
| [`thumbprint`](#parameter-thumbprint) | string | SSL certificate thumbprint. |

### Parameter: `name`

Hostname in the hostname binding.

- Required: Yes
- Type: string

### Parameter: `appName`

The name of the parent site resource. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `azureResourceName`

Azure resource name.

- Required: No
- Type: string

### Parameter: `azureResourceType`

Azure resource type. Possible values are Website and TrafficManager.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'TrafficManager'
    'Website'
  ]
  ```

### Parameter: `certificate`

Certificate object with properties for certificate creation. The expected structure matches the certificateType defined in host-name-binding-type.bicep.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-certificatename) | string | Certificate name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`canonicalName`](#parameter-certificatecanonicalname) | string | CNAME of the certificate to be issued via free certificate. |
| [`domainValidationMethod`](#parameter-certificatedomainvalidationmethod) | string | Method of domain validation for free certificate. |
| [`hostNames`](#parameter-certificatehostnames) | array | Certificate host names. |
| [`keyVaultResourceId`](#parameter-certificatekeyvaultresourceid) | string | Key Vault resource ID. |
| [`keyVaultSecretName`](#parameter-certificatekeyvaultsecretname) | string | Key Vault secret name. |
| [`kind`](#parameter-certificatekind) | string | Kind of resource. |
| [`location`](#parameter-certificatelocation) | string | Resource location. |
| [`password`](#parameter-certificatepassword) | securestring | Certificate password. |
| [`pfxBlob`](#parameter-certificatepfxblob) | securestring | Certificate data in PFX format. |
| [`serverFarmResourceId`](#parameter-certificateserverfarmresourceid) | string | Server farm resource ID. |
| [`tags`](#parameter-certificatetags) | object | Tags of the resource. |

### Parameter: `certificate.name`

Certificate name.

- Required: Yes
- Type: string

### Parameter: `certificate.canonicalName`

CNAME of the certificate to be issued via free certificate.

- Required: No
- Type: string

### Parameter: `certificate.domainValidationMethod`

Method of domain validation for free certificate.

- Required: No
- Type: string

### Parameter: `certificate.hostNames`

Certificate host names.

- Required: No
- Type: array

### Parameter: `certificate.keyVaultResourceId`

Key Vault resource ID.

- Required: No
- Type: string

### Parameter: `certificate.keyVaultSecretName`

Key Vault secret name.

- Required: No
- Type: string

### Parameter: `certificate.kind`

Kind of resource.

- Required: No
- Type: string

### Parameter: `certificate.location`

Resource location.

- Required: No
- Type: string

### Parameter: `certificate.password`

Certificate password.

- Required: No
- Type: securestring

### Parameter: `certificate.pfxBlob`

Certificate data in PFX format.

- Required: No
- Type: securestring

### Parameter: `certificate.serverFarmResourceId`

Server farm resource ID.

- Required: No
- Type: string

### Parameter: `certificate.tags`

Tags of the resource.

- Required: No
- Type: object

### Parameter: `customHostNameDnsRecordType`

Custom DNS record type. Possible values are CName and A.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'A'
    'CName'
  ]
  ```

### Parameter: `domainResourceId`

Fully qualified ARM domain resource URI.

- Required: No
- Type: string

### Parameter: `hostNameType`

Hostname type. Possible values are Verified and Managed.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Managed'
    'Verified'
  ]
  ```

### Parameter: `kind`

Kind of resource.

- Required: No
- Type: string

### Parameter: `location`

Resource location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `siteName`

App Service app name.

- Required: No
- Type: string

### Parameter: `sslState`

SSL type. Possible values are Disabled, SniEnabled, and IpBasedEnabled.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Disabled'
    'IpBasedEnabled'
    'SniEnabled'
  ]
  ```

### Parameter: `thumbprint`

SSL certificate thumbprint.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `certificateResourceId` | string | The resource ID of the certificate. |
| `certificateThumbprint` | string | The thumbprint of the certificate. |
| `name` | string | The name of the host name binding. |
| `resourceGroupName` | string | The name of the resource group the resource was deployed into. |
| `resourceId` | string | The resource ID of the host name binding. |
