# Storage Account Local Users `[Microsoft.Storage/storageAccounts/localUsers]`

This module deploys a Storage Account Local User, which is used for SFTP authentication.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/localUsers` | [2023-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/storageAccounts/localUsers) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hasSshKey`](#parameter-hassshkey) | bool | Indicates whether SSH key exists. Set it to false to remove existing SSH key. |
| [`hasSshPassword`](#parameter-hassshpassword) | bool | Indicates whether SSH password exists. Set it to false to remove existing SSH password. |
| [`name`](#parameter-name) | string | The name of the local user used for SFTP Authentication. |
| [`permissionScopes`](#parameter-permissionscopes) | array | The permission scopes of the local user. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAccountName`](#parameter-storageaccountname) | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`hasSharedKey`](#parameter-hassharedkey) | bool | Indicates whether shared key exists. Set it to false to remove existing shared key. |
| [`homeDirectory`](#parameter-homedirectory) | string | The local user home directory. |
| [`sshAuthorizedKeys`](#parameter-sshauthorizedkeys) | secureObject | The local user SSH authorized keys for SFTP. |

### Parameter: `hasSshKey`

Indicates whether SSH key exists. Set it to false to remove existing SSH key.

- Required: Yes
- Type: bool

### Parameter: `hasSshPassword`

Indicates whether SSH password exists. Set it to false to remove existing SSH password.

- Required: Yes
- Type: bool

### Parameter: `name`

The name of the local user used for SFTP Authentication.

- Required: Yes
- Type: string

### Parameter: `permissionScopes`

The permission scopes of the local user.

- Required: Yes
- Type: array

### Parameter: `storageAccountName`

The name of the parent Storage Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `hasSharedKey`

Indicates whether shared key exists. Set it to false to remove existing shared key.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `homeDirectory`

The local user home directory.

- Required: No
- Type: string
- Default: `''`

### Parameter: `sshAuthorizedKeys`

The local user SSH authorized keys for SFTP.

- Required: No
- Type: secureObject


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed local user. |
| `resourceGroupName` | string | The resource group of the deployed local user. |
| `resourceId` | string | The resource ID of the deployed local user. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
