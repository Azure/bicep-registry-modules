# Web/Function Apps Slot Host Name Bindings `[Microsoft.Web/sites/slots/hostNameBindings]`

This module deploys a Site Slot Host Name Binding.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/certificates` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-11-01/certificates) |
| `Microsoft.Web/sites/slots/hostNameBindings` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-11-01/sites/slots/hostNameBindings) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Hostname in the hostname binding. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent site resource. Required if the template is used in a standalone deployment. |
| [`slotName`](#parameter-slotname) | string | The name of the site slot. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`azureResourceName`](#parameter-azureresourcename) | string | Azure resource name. |
| [`azureResourceType`](#parameter-azureresourcetype) | string | Azure resource type. Possible values are Website and TrafficManager. |
| [`certificate`](#parameter-certificate) | object | Certificate object with properties for certificate creation. The expected structure matches the certificateType defined in host-name-binding-type.bicep. |
| [`customHostNameDnsRecordType`](#parameter-customhostnamednsrecordtype) | string | Custom DNS record type. Possible values are CName and A. |
| [`domainId`](#parameter-domainid) | string | Fully qualified ARM domain resource URI. |
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

### Parameter: `slotName`

The name of the site slot. Required if the template is used in a standalone deployment.

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
- Default: `{}`

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

### Parameter: `domainId`

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
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `certificateResourceId` | string | The resource ID of the certificate if one was created. |
| `certificateThumbprint` | string | The thumbprint of the certificate if one was created. |
| `name` | string | The name of the host name binding. |
| `resourceGroupName` | string | The name of the resource group the resource was deployed into. |
| `resourceId` | string | The resource ID of the host name binding. |
