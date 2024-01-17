# Key Vault Keys `[Microsoft.KeyVault/vaults/keys]`

This module deploys a Key Vault Key.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.KeyVault/vaults/keys` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/keys) |

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

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

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

### Parameter: `tags`

Resource tags.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the key. |
| `resourceGroupName` | string | The name of the resource group the key was created in. |
| `resourceId` | string | The resource ID of the key. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
