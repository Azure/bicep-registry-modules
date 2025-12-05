# Integration Account Certificates `[Microsoft.Logic/integrationAccounts/certificates]`

This module deploys an Integration Account Certificate.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Logic/integrationAccounts/certificates` | 2019-05-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.logic_integrationaccounts_certificates.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Logic/2019-05-01/integrationAccounts/certificates)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The Name of the certificate resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`integrationAccountName`](#parameter-integrationaccountname) | string | The name of the parent integration account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`key`](#parameter-key) | object | The key details in the key vault. |
| [`location`](#parameter-location) | string | Resource location. |
| [`metadata`](#parameter-metadata) | object | The certificate metadata. |
| [`publicCertificate`](#parameter-publiccertificate) | string | The public certificate. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `name`

The Name of the certificate resource.

- Required: Yes
- Type: string

### Parameter: `integrationAccountName`

The name of the parent integration account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `key`

The key details in the key vault.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyName`](#parameter-keykeyname) | string | The private key name in key vault. |
| [`keyVault`](#parameter-keykeyvault) | object | The key vault reference. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVersion`](#parameter-keykeyversion) | string | The private key version in key vault. |

### Parameter: `key.keyName`

The private key name in key vault.

- Required: Yes
- Type: string

### Parameter: `key.keyVault`

The key vault reference.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`id`](#parameter-keykeyvaultid) | string | The resource id of the key vault. |

### Parameter: `key.keyVault.id`

The resource id of the key vault.

- Required: Yes
- Type: string

### Parameter: `key.keyVersion`

The private key version in key vault.

- Required: No
- Type: string

### Parameter: `location`

Resource location.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `metadata`

The certificate metadata.

- Required: No
- Type: object

### Parameter: `publicCertificate`

The public certificate.

- Required: No
- Type: string

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the integration account certificate. |
| `resourceGroupName` | string | The resource group the integration account certificate was deployed into. |
| `resourceId` | string | The resource ID of the integration account certificate. |
