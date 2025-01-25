# Key Vault Access Policies `[Microsoft.KeyVault/vaults/accessPolicies]`

This module deploys a Key Vault Access Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2023-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2023-07-01/vaults/accessPolicies) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultName`](#parameter-keyvaultname) | string | The name of the parent key vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessPolicies`](#parameter-accesspolicies) | array | An array of 0 to 16 identities that have access to the key vault. All identities in the array must use the same tenant ID as the key vault's tenant ID. |

### Parameter: `keyVaultName`

The name of the parent key vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `accessPolicies`

An array of 0 to 16 identities that have access to the key vault. All identities in the array must use the same tenant ID as the key vault's tenant ID.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`objectId`](#parameter-accesspoliciesobjectid) | string | The object ID of a user, service principal or security group in the tenant for the vault. |
| [`permissions`](#parameter-accesspoliciespermissions) | object | Permissions the identity has for keys, secrets and certificates. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`applicationId`](#parameter-accesspoliciesapplicationid) | string | Application ID of the client making request on behalf of a principal. |
| [`tenantId`](#parameter-accesspoliciestenantid) | string | The tenant ID that is used for authenticating requests to the key vault. |

### Parameter: `accessPolicies.objectId`

The object ID of a user, service principal or security group in the tenant for the vault.

- Required: Yes
- Type: string

### Parameter: `accessPolicies.permissions`

Permissions the identity has for keys, secrets and certificates.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`certificates`](#parameter-accesspoliciespermissionscertificates) | array | Permissions to certificates. |
| [`keys`](#parameter-accesspoliciespermissionskeys) | array | Permissions to keys. |
| [`secrets`](#parameter-accesspoliciespermissionssecrets) | array | Permissions to secrets. |
| [`storage`](#parameter-accesspoliciespermissionsstorage) | array | Permissions to storage accounts. |

### Parameter: `accessPolicies.permissions.certificates`

Permissions to certificates.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'all'
    'backup'
    'create'
    'delete'
    'deleteissuers'
    'get'
    'getissuers'
    'import'
    'list'
    'listissuers'
    'managecontacts'
    'manageissuers'
    'purge'
    'recover'
    'restore'
    'setissuers'
    'update'
  ]
  ```

### Parameter: `accessPolicies.permissions.keys`

Permissions to keys.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'all'
    'backup'
    'create'
    'decrypt'
    'delete'
    'encrypt'
    'get'
    'getrotationpolicy'
    'import'
    'list'
    'purge'
    'recover'
    'release'
    'restore'
    'rotate'
    'setrotationpolicy'
    'sign'
    'unwrapKey'
    'update'
    'verify'
    'wrapKey'
  ]
  ```

### Parameter: `accessPolicies.permissions.secrets`

Permissions to secrets.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'all'
    'backup'
    'delete'
    'get'
    'list'
    'purge'
    'recover'
    'restore'
    'set'
  ]
  ```

### Parameter: `accessPolicies.permissions.storage`

Permissions to storage accounts.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'all'
    'backup'
    'delete'
    'deletesas'
    'get'
    'getsas'
    'list'
    'listsas'
    'purge'
    'recover'
    'regeneratekey'
    'restore'
    'set'
    'setsas'
    'update'
  ]
  ```

### Parameter: `accessPolicies.applicationId`

Application ID of the client making request on behalf of a principal.

- Required: No
- Type: string

### Parameter: `accessPolicies.tenantId`

The tenant ID that is used for authenticating requests to the key vault.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the access policies assignment. |
| `resourceGroupName` | string | The name of the resource group the access policies assignment was created in. |
| `resourceId` | string | The resource ID of the access policies assignment. |
