# Key Vault Keys `[Microsoft.KeyVault/vaults/keys]`

This module deploys a Key Vault Key.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.KeyVault/vaults/keys` | [2024-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2024-11-01/vaults/keys) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the key. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultName`](#parameter-keyvaultname) | string | The name of the parent key vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`attributesEnabled`](#parameter-attributesenabled) | bool | Determines whether the object is enabled. |
| [`attributesExp`](#parameter-attributesexp) | int | Expiry date in seconds since 1970-01-01T00:00:00Z. For security reasons, it is recommended to set an expiration date whenever possible. |
| [`attributesNbf`](#parameter-attributesnbf) | int | Not before date in seconds since 1970-01-01T00:00:00Z. |
| [`curveName`](#parameter-curvename) | string | The elliptic curve name. |
| [`keyOps`](#parameter-keyops) | array | Array of JsonWebKeyOperation. |
| [`keySize`](#parameter-keysize) | int | The key size in bits. For example: 2048, 3072, or 4096 for RSA. |
| [`kty`](#parameter-kty) | string | The type of the key. |
| [`releasePolicy`](#parameter-releasepolicy) | object | Key release policy. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`rotationPolicy`](#parameter-rotationpolicy) | object | Key rotation policy properties object. |
| [`tags`](#parameter-tags) | object | Resource tags. |

### Parameter: `name`

The name of the key.

- Required: Yes
- Type: string

### Parameter: `keyVaultName`

The name of the parent key vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `attributesEnabled`

Determines whether the object is enabled.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `attributesExp`

Expiry date in seconds since 1970-01-01T00:00:00Z. For security reasons, it is recommended to set an expiration date whenever possible.

- Required: No
- Type: int

### Parameter: `attributesNbf`

Not before date in seconds since 1970-01-01T00:00:00Z.

- Required: No
- Type: int

### Parameter: `curveName`

The elliptic curve name.

- Required: No
- Type: string
- Default: `'P-256'`
- Allowed:
  ```Bicep
  [
    'P-256'
    'P-256K'
    'P-384'
    'P-521'
  ]
  ```

### Parameter: `keyOps`

Array of JsonWebKeyOperation.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'decrypt'
    'encrypt'
    'import'
    'sign'
    'unwrapKey'
    'verify'
    'wrapKey'
  ]
  ```

### Parameter: `keySize`

The key size in bits. For example: 2048, 3072, or 4096 for RSA.

- Required: No
- Type: int

### Parameter: `kty`

The type of the key.

- Required: No
- Type: string
- Default: `'EC'`
- Allowed:
  ```Bicep
  [
    'EC'
    'EC-HSM'
    'RSA'
    'RSA-HSM'
  ]
  ```

### Parameter: `releasePolicy`

Key release policy.

- Required: No
- Type: object

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Contributor'`
  - `'Key Vault Administrator'`
  - `'Key Vault Contributor'`
  - `'Key Vault Crypto Officer'`
  - `'Key Vault Crypto Service Encryption User'`
  - `'Key Vault Crypto User'`
  - `'Key Vault Reader'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `rotationPolicy`

Key rotation policy properties object.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`attributes`](#parameter-rotationpolicyattributes) | object | The attributes of key rotation policy. |
| [`lifetimeActions`](#parameter-rotationpolicylifetimeactions) | array | The key rotation policy lifetime actions. |

### Parameter: `rotationPolicy.attributes`

The attributes of key rotation policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`expiryTime`](#parameter-rotationpolicyattributesexpirytime) | string | The expiration time for the new key version. It should be in ISO8601 format. Eg: "P90D", "P1Y". |

### Parameter: `rotationPolicy.attributes.expiryTime`

The expiration time for the new key version. It should be in ISO8601 format. Eg: "P90D", "P1Y".

- Required: No
- Type: string

### Parameter: `rotationPolicy.lifetimeActions`

The key rotation policy lifetime actions.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-rotationpolicylifetimeactionsaction) | object | The type of the action. |
| [`trigger`](#parameter-rotationpolicylifetimeactionstrigger) | object | The time duration for rotating the key. |

### Parameter: `rotationPolicy.lifetimeActions.action`

The type of the action.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-rotationpolicylifetimeactionsactiontype) | string | The type of the action. |

### Parameter: `rotationPolicy.lifetimeActions.action.type`

The type of the action.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'notify'
    'rotate'
  ]
  ```

### Parameter: `rotationPolicy.lifetimeActions.trigger`

The time duration for rotating the key.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`timeAfterCreate`](#parameter-rotationpolicylifetimeactionstriggertimeaftercreate) | string | The time duration after key creation to rotate the key. It only applies to rotate. It will be in ISO 8601 duration format. Eg: "P90D", "P1Y". |
| [`timeBeforeExpiry`](#parameter-rotationpolicylifetimeactionstriggertimebeforeexpiry) | string | The time duration before key expiring to rotate or notify. It will be in ISO 8601 duration format. Eg: "P90D", "P1Y". |

### Parameter: `rotationPolicy.lifetimeActions.trigger.timeAfterCreate`

The time duration after key creation to rotate the key. It only applies to rotate. It will be in ISO 8601 duration format. Eg: "P90D", "P1Y".

- Required: No
- Type: string

### Parameter: `rotationPolicy.lifetimeActions.trigger.timeBeforeExpiry`

The time duration before key expiring to rotate or notify. It will be in ISO 8601 duration format. Eg: "P90D", "P1Y".

- Required: No
- Type: string

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `keyUri` | string | The uri of the key. |
| `keyUriWithVersion` | string | The uri with version of the key. |
| `name` | string | The name of the key. |
| `resourceGroupName` | string | The name of the resource group the key was created in. |
| `resourceId` | string | The resource ID of the key. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
| `br/public:avm/utl/types/avm-common-types:0.5.1` | Remote reference |
