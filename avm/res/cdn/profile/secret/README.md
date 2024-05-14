# CDN Profiles Secret `[Microsoft.Cdn/profiles/secrets]`

This module deploys a CDN Profile Secret.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
