# CDN Profiles Secret `[Microsoft.Cdn/profiles/secrets]`

This module deploys a CDN Profile Secret.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/secrets` | [2025-04-15](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2025-04-15/profiles/secrets) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the secret. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`profileName`](#parameter-profilename) | string | The name of the parent CDN profile. Required if the template is used in a standalone deployment. |
| [`secretSourceResourceId`](#parameter-secretsourceresourceid) | string | The resource ID of the secret source. Required if the `type` is "CustomerCertificate". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secretVersion`](#parameter-secretversion) | string | The version of the secret. |
| [`subjectAlternativeNames`](#parameter-subjectalternativenames) | array | The subject alternative names of the secret. |
| [`type`](#parameter-type) | string | The type of the secret. |
| [`useLatestVersion`](#parameter-uselatestversion) | bool | Indicates whether to use the latest version of the secret. |

### Parameter: `name`

The name of the secret.

- Required: Yes
- Type: string

### Parameter: `profileName`

The name of the parent CDN profile. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `secretSourceResourceId`

The resource ID of the secret source. Required if the `type` is "CustomerCertificate".

- Required: No
- Type: string
- Default: `''`

### Parameter: `secretVersion`

The version of the secret.

- Required: No
- Type: string
- Default: `''`

### Parameter: `subjectAlternativeNames`

The subject alternative names of the secret.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `type`

The type of the secret.

- Required: No
- Type: string
- Default: `'AzureFirstPartyManagedCertificate'`
- Allowed:
  ```Bicep
  [
    'AzureFirstPartyManagedCertificate'
    'CustomerCertificate'
    'ManagedCertificate'
    'UrlSigningKey'
  ]
  ```

### Parameter: `useLatestVersion`

Indicates whether to use the latest version of the secret.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the secret. |
| `resourceGroupName` | string | The name of the resource group the secret was created in. |
| `resourceId` | string | The resource ID of the secret. |
