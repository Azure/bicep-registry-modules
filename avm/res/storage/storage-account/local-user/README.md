# Storage Account Local Users `[Microsoft.Storage/storageAccounts/localUsers]`

This module deploys a Storage Account Local User, which is used for SFTP authentication.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/localUsers` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/localUsers) |

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
| [`sshAuthorizedKeys`](#parameter-sshauthorizedkeys) | array | The local user SSH authorized keys for SFTP. |

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

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`permissions`](#parameter-permissionscopespermissions) | string | The permissions for the local user. Possible values include: Read (r), Write (w), Delete (d), List (l), and Create (c). |
| [`resourceName`](#parameter-permissionscopesresourcename) | string | The name of resource, normally the container name or the file share name, used by the local user. |
| [`service`](#parameter-permissionscopesservice) | string | The service used by the local user, e.g. blob, file. |

### Parameter: `permissionScopes.permissions`

The permissions for the local user. Possible values include: Read (r), Write (w), Delete (d), List (l), and Create (c).

- Required: Yes
- Type: string

### Parameter: `permissionScopes.resourceName`

The name of resource, normally the container name or the file share name, used by the local user.

- Required: Yes
- Type: string

### Parameter: `permissionScopes.service`

The service used by the local user, e.g. blob, file.

- Required: Yes
- Type: string

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
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`key`](#parameter-sshauthorizedkeyskey) | securestring | SSH public key base64 encoded. The format should be: '{keyType} {keyData}', e.g. ssh-rsa AAAABBBB. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-sshauthorizedkeysdescription) | string | Description used to store the function/usage of the key. |

### Parameter: `sshAuthorizedKeys.key`

SSH public key base64 encoded. The format should be: '{keyType} {keyData}', e.g. ssh-rsa AAAABBBB.

- Required: Yes
- Type: securestring

### Parameter: `sshAuthorizedKeys.description`

Description used to store the function/usage of the key.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed local user. |
| `resourceGroupName` | string | The resource group of the deployed local user. |
| `resourceId` | string | The resource ID of the deployed local user. |
