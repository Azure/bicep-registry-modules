# App ManagedEnvironments Certificates `[Microsoft.App/managedEnvironments/certificates]`

This module deploys a App Managed Environment Certificate.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.App/managedEnvironments/certificates` | [2024-10-02-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2024-10-02-preview/managedEnvironments/certificates) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Container Apps Managed Environment Certificate. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedEnvironmentName`](#parameter-managedenvironmentname) | string | The name of the parent app managed environment. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificateKeyVaultProperties`](#parameter-certificatekeyvaultproperties) | object | A key vault reference to the certificate to use for the custom domain. |
| [`certificatePassword`](#parameter-certificatepassword) | securestring | The password of the certificate. |
| [`certificateType`](#parameter-certificatetype) | string | The type of the certificate. |
| [`certificateValue`](#parameter-certificatevalue) | string | The value of the certificate. PFX or PEM blob. |
| [`location`](#parameter-location) | string | Location for all Resources. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `name`

Name of the Container Apps Managed Environment Certificate.

- Required: Yes
- Type: string

### Parameter: `managedEnvironmentName`

The name of the parent app managed environment. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `certificateKeyVaultProperties`

A key vault reference to the certificate to use for the custom domain.

- Required: No
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`identityResourceId`](#parameter-certificatekeyvaultpropertiesidentityresourceid) | string | The resource ID of the identity. This is the identity that will be used to access the key vault. |
| [`keyVaultUrl`](#parameter-certificatekeyvaultpropertieskeyvaulturl) | string | A key vault URL referencing the wildcard certificate that will be used for the custom domain. |

### Parameter: `certificateKeyVaultProperties.identityResourceId`

The resource ID of the identity. This is the identity that will be used to access the key vault.

- Required: Yes
- Type: string

### Parameter: `certificateKeyVaultProperties.keyVaultUrl`

A key vault URL referencing the wildcard certificate that will be used for the custom domain.

- Required: Yes
- Type: string

### Parameter: `certificatePassword`

The password of the certificate.

- Required: No
- Type: securestring

### Parameter: `certificateType`

The type of the certificate.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'ImagePullTrustedCA'
    'ServerSSLCertificate'
  ]
  ```

### Parameter: `certificateValue`

The value of the certificate. PFX or PEM blob.

- Required: No
- Type: string

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the key values. |
| `resourceGroupName` | string | The resource group the batch account was deployed into. |
| `resourceId` | string | The resource ID of the key values. |
