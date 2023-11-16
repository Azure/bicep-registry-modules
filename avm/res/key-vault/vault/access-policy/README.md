# Key Vault Access Policies `[Microsoft.KeyVault/vaults/accessPolicies]`

This module deploys a Key Vault Access Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.KeyVault/vaults/accessPolicies` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/accessPolicies) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultName`](#parameter-keyvaultname) | string | The name of the parent key vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessPolicies`](#parameter-accesspolicies) | array | An array of 0 to 16 identities that have access to the key vault. All identities in the array must use the same tenant ID as the key vault's tenant ID. |

### Parameter: `accessPolicies`

An array of 0 to 16 identities that have access to the key vault. All identities in the array must use the same tenant ID as the key vault's tenant ID.
- Required: No
- Type: array


| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`applicationId`](#parameter-accesspoliciesapplicationid) | No | string | Optional. Application ID of the client making request on behalf of a principal. |
| [`objectId`](#parameter-accesspoliciesobjectid) | Yes | string | Required. The object ID of a user, service principal or security group in the tenant for the vault. |
| [`permissions`](#parameter-accesspoliciespermissions) | Yes | object |  |
| [`tenantId`](#parameter-accesspoliciestenantid) | No | string | Optional. The tenant ID that is used for authenticating requests to the key vault. |

### Parameter: `accessPolicies.applicationId`

Optional. Application ID of the client making request on behalf of a principal.

- Required: No
- Type: string

### Parameter: `accessPolicies.objectId`

Required. The object ID of a user, service principal or security group in the tenant for the vault.

- Required: Yes
- Type: string

### Parameter: `accessPolicies.permissions`
- Required: Yes
- Type: object

| Name | Required | Type | Description |
| :-- | :-- | :--| :-- |
| [`certificates`](#parameter-accesspoliciespermissionscertificates) | No | array | Optional. Permissions to certificates. |
| [`keys`](#parameter-accesspoliciespermissionskeys) | No | array | Optional. Permissions to keys. |
| [`secrets`](#parameter-accesspoliciespermissionssecrets) | No | array | Optional. Permissions to secrets. |
| [`storage`](#parameter-accesspoliciespermissionsstorage) | No | array | Optional. Permissions to storage accounts. |

### Parameter: `accessPolicies.permissions.certificates`

Optional. Permissions to certificates.

- Required: No
- Type: array
- Allowed: `[all, backup, create, delete, deleteissuers, get, getissuers, import, list, listissuers, managecontacts, manageissuers, purge, recover, restore, setissuers, update]`

### Parameter: `accessPolicies.permissions.keys`

Optional. Permissions to keys.

- Required: No
- Type: array
- Allowed: `[all, backup, create, decrypt, delete, encrypt, get, getrotationpolicy, import, list, purge, recover, release, restore, rotate, setrotationpolicy, sign, unwrapKey, update, verify, wrapKey]`

### Parameter: `accessPolicies.permissions.secrets`

Optional. Permissions to secrets.

- Required: No
- Type: array
- Allowed: `[all, backup, delete, get, list, purge, recover, restore, set]`

### Parameter: `accessPolicies.permissions.storage`

Optional. Permissions to storage accounts.

- Required: No
- Type: array
- Allowed: `[all, backup, delete, deletesas, get, getsas, list, listsas, purge, recover, regeneratekey, restore, set, setsas, update]`


### Parameter: `accessPolicies.tenantId`

Optional. The tenant ID that is used for authenticating requests to the key vault.

- Required: No
- Type: string

### Parameter: `keyVaultName`

The name of the parent key vault. Required if the template is used in a standalone deployment.
- Required: Yes
- Type: string


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the access policies assignment. |
| `resourceGroupName` | string | The name of the resource group the access policies assignment was created in. |
| `resourceId` | string | The resource ID of the access policies assignment. |

## Cross-referenced modules

_None_
