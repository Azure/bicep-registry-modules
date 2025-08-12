# Web/Function Apps Certificates `[Microsoft.Web/sites/certificates]`

This module deploys a Web/Function App Certificate.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/certificates` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2024-11-01/certificates) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Certificate name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`canonicalName`](#parameter-canonicalname) | string | CNAME of the certificate to be issued via free certificate. |
| [`domainValidationMethod`](#parameter-domainvalidationmethod) | string | Method of domain validation for free certificate. |
| [`hostNames`](#parameter-hostnames) | array | Certificate host names. |
| [`keyVaultId`](#parameter-keyvaultid) | string | Key Vault resource ID. |
| [`keyVaultSecretName`](#parameter-keyvaultsecretname) | string | Key Vault secret name. |
| [`kind`](#parameter-kind) | string | Kind of resource. |
| [`location`](#parameter-location) | string | Resource location. |
| [`password`](#parameter-password) | securestring | Certificate password. |
| [`pfxBlob`](#parameter-pfxblob) | securestring | Certificate data in PFX format. |
| [`serverFarmResourceId`](#parameter-serverfarmresourceid) | string | Server farm resource ID. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Certificate name.

- Required: Yes
- Type: string

### Parameter: `canonicalName`

CNAME of the certificate to be issued via free certificate.

- Required: No
- Type: string

### Parameter: `domainValidationMethod`

Method of domain validation for free certificate.

- Required: No
- Type: string

### Parameter: `hostNames`

Certificate host names.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `keyVaultId`

Key Vault resource ID.

- Required: No
- Type: string

### Parameter: `keyVaultSecretName`

Key Vault secret name.

- Required: No
- Type: string

### Parameter: `kind`

Kind of resource.

- Required: No
- Type: string

### Parameter: `location`

Resource location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `password`

Certificate password.

- Required: No
- Type: securestring

### Parameter: `pfxBlob`

Certificate data in PFX format.

- Required: No
- Type: securestring

### Parameter: `serverFarmResourceId`

Server farm resource ID.

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
| `name` | string | The name of the certificate. |
| `resourceGroupName` | string | The resource group the certificate was deployed into. |
| `resourceId` | string | The resource ID of the certificate. |
| `thumbprint` | string | The thumbprint of the certificate. |
