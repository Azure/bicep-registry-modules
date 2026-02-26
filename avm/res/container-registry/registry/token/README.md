# Container Registries Tokens `[Microsoft.ContainerRegistry/registries/tokens]`

This module deploys an Azure Container Registry (ACR) Token.

You can reference the module as follows:
```bicep
module registry 'br/public:avm/res/container-registry/registry/token:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.ContainerRegistry/registries/tokens` | 2025-11-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.containerregistry_registries_tokens.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.ContainerRegistry/2025-11-01/registries/tokens)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the token. |
| [`scopeMapId`](#parameter-scopemapid) | string | The resource ID of the scope map to which the token will be associated with. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`registryName`](#parameter-registryname) | string | The name of the parent registry. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`credentials`](#parameter-credentials) | object | The credentials associated with the token for authentication. |
| [`status`](#parameter-status) | string | The status of the token. Default is enabled. |

### Parameter: `name`

The name of the token.

- Required: Yes
- Type: string

### Parameter: `scopeMapId`

The resource ID of the scope map to which the token will be associated with.

- Required: Yes
- Type: string

### Parameter: `registryName`

The name of the parent registry. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `credentials`

The credentials associated with the token for authentication.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificates`](#parameter-credentialscertificates) | array | The certificates associated with the token for authentication. |
| [`passwords`](#parameter-credentialspasswords) | array | The passwords associated with the token for authentication. |

### Parameter: `credentials.certificates`

The certificates associated with the token for authentication.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-credentialscertificatesname) | string | The certificate name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`encodedPemCertificate`](#parameter-credentialscertificatesencodedpemcertificate) | string | Base 64 encoded string of the public certificate in PEM format that will be used for authenticating the token. |
| [`expiry`](#parameter-credentialscertificatesexpiry) | string | The expiry datetime of the certificate. |
| [`thumbprint`](#parameter-credentialscertificatesthumbprint) | string | The thumbprint of the certificate. |

### Parameter: `credentials.certificates.name`

The certificate name.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'certificate1'
    'certificate2'
  ]
  ```

### Parameter: `credentials.certificates.encodedPemCertificate`

Base 64 encoded string of the public certificate in PEM format that will be used for authenticating the token.

- Required: No
- Type: string

### Parameter: `credentials.certificates.expiry`

The expiry datetime of the certificate.

- Required: No
- Type: string

### Parameter: `credentials.certificates.thumbprint`

The thumbprint of the certificate.

- Required: No
- Type: string

### Parameter: `credentials.passwords`

The passwords associated with the token for authentication.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-credentialspasswordsname) | string | The password name. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`creationTime`](#parameter-credentialspasswordscreationtime) | string | The creation datetime of the password. |
| [`expiry`](#parameter-credentialspasswordsexpiry) | string | The expiry datetime of the password. |

### Parameter: `credentials.passwords.name`

The password name.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'password1'
    'password2'
  ]
  ```

### Parameter: `credentials.passwords.creationTime`

The creation datetime of the password.

- Required: No
- Type: string

### Parameter: `credentials.passwords.expiry`

The expiry datetime of the password.

- Required: No
- Type: string

### Parameter: `status`

The status of the token. Default is enabled.

- Required: No
- Type: string
- Default: `'enabled'`
- Allowed:
  ```Bicep
  [
    'disabled'
    'enabled'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the token. |
| `resourceGroupName` | string | The name of the resource group the token was created in. |
| `resourceId` | string | The resource ID of the token. |
