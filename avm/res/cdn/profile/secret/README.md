# CDN Profiles Secret `[Microsoft.Cdn/profiles/secrets]`

This module deploys a CDN Profile Secret.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Cdn/profiles/secrets` | [2023-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Cdn/2023-05-01/profiles/secrets) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the secrect. |
| [`type`](#parameter-type) | string | The type of the secrect. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`profileName`](#parameter-profilename) | string | The name of the parent CDN profile. Required if the template is used in a standalone deployment. |
| [`secretSourceResourceId`](#parameter-secretsourceresourceid) | string | The resource ID of the secret source. Required if the `type` is "CustomerCertificate". |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secretVersion`](#parameter-secretversion) | string | The version of the secret. |
| [`subjectAlternativeNames`](#parameter-subjectalternativenames) | array | The subject alternative names of the secrect. |
| [`useLatestVersion`](#parameter-uselatestversion) | bool | Indicates whether to use the latest version of the secrect. |

### Parameter: `name`

The name of the secrect.

- Required: Yes
- Type: string

### Parameter: `type`

The type of the secrect.

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

The subject alternative names of the secrect.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `useLatestVersion`

Indicates whether to use the latest version of the secrect.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the secrect. |
| `resourceGroupName` | string | The name of the resource group the secret was created in. |
| `resourceId` | string | The resource ID of the secrect. |
