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

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultName`](#parameter-keyvaultname) | string | The name of the parent key vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyProperties`](#parameter-keyproperties) | object | Sets the attributes of the secret. |

### Parameter: `keyVaultName`

The name of the parent key vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `keyProperties`

Sets the attributes of the secret.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-keypropertiesname) | string | The name of the key. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`attributes`](#parameter-keypropertiesattributes) | object | Contains attributes of the key. |
| [`curveName`](#parameter-keypropertiescurvename) | string | The elliptic curve name. Only works if "keySize" equals "EC" or "EC-HSM". Default is "P-256". |
| [`keyOps`](#parameter-keypropertieskeyops) | array | The allowed operations on this key. |
| [`keySize`](#parameter-keypropertieskeysize) | int | The key size in bits. Only works if "keySize" equals "RSA" or "RSA-HSM". Default is "4096". |
| [`kty`](#parameter-keypropertieskty) | string | The type of the key. Default is "EC". |
| [`releasePolicy`](#parameter-keypropertiesreleasepolicy) | object | Key release policy. |
| [`roleAssignments`](#parameter-keypropertiesroleassignments) | array | Array of role assignments to create. |
| [`rotationPolicy`](#parameter-keypropertiesrotationpolicy) | object | Key rotation policy. |
| [`tags`](#parameter-keypropertiestags) | object | Resource tags. |

### Parameter: `keyProperties.name`

The name of the key.

- Required: Yes
- Type: string

### Parameter: `keyProperties.attributes`

Contains attributes of the key.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-keypropertiesattributesenabled) | bool | Defines whether the key is enabled or disabled. |
| [`exp`](#parameter-keypropertiesattributesexp) | int | Defines when the key will become invalid. Defined in seconds since 1970-01-01T00:00:00Z. |
| [`nbf`](#parameter-keypropertiesattributesnbf) | int | If set, defines the date from which onwards the key becomes valid. Defined in seconds since 1970-01-01T00:00:00Z. |

### Parameter: `keyProperties.attributes.enabled`

Defines whether the key is enabled or disabled.

- Required: No
- Type: bool

### Parameter: `keyProperties.attributes.exp`

Defines when the key will become invalid. Defined in seconds since 1970-01-01T00:00:00Z.

- Required: No
- Type: int

### Parameter: `keyProperties.attributes.nbf`

If set, defines the date from which onwards the key becomes valid. Defined in seconds since 1970-01-01T00:00:00Z.

- Required: No
- Type: int

### Parameter: `keyProperties.curveName`

The elliptic curve name. Only works if "keySize" equals "EC" or "EC-HSM". Default is "P-256".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'P-256'
    'P-256K'
    'P-384'
    'P-521'
  ]
  ```

### Parameter: `keyProperties.keyOps`

The allowed operations on this key.

- Required: No
- Type: array
- Allowed:
  ```Bicep
  [
    'decrypt'
    'encrypt'
    'import'
    'release'
    'sign'
    'unwrapKey'
    'verify'
    'wrapKey'
  ]
  ```

### Parameter: `keyProperties.keySize`

The key size in bits. Only works if "keySize" equals "RSA" or "RSA-HSM". Default is "4096".

- Required: No
- Type: int
- Allowed:
  ```Bicep
  [
    2048
    3072
    4096
  ]
  ```

### Parameter: `keyProperties.kty`

The type of the key. Default is "EC".

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'EC'
    'EC-HSM'
    'RSA'
    'RSA-HSM'
  ]
  ```

### Parameter: `keyProperties.releasePolicy`

Key release policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`contentType`](#parameter-keypropertiesreleasepolicycontenttype) | string | Content type and version of key release policy. |
| [`data`](#parameter-keypropertiesreleasepolicydata) | string | Blob encoding the policy rules under which the key can be released. |

### Parameter: `keyProperties.releasePolicy.contentType`

Content type and version of key release policy.

- Required: No
- Type: string

### Parameter: `keyProperties.releasePolicy.data`

Blob encoding the policy rules under which the key can be released.

- Required: No
- Type: string

### Parameter: `keyProperties.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-keypropertiesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-keypropertiesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-keypropertiesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-keypropertiesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-keypropertiesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-keypropertiesroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-keypropertiesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `keyProperties.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `keyProperties.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `keyProperties.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `keyProperties.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `keyProperties.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `keyProperties.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `keyProperties.roleAssignments.principalType`

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

### Parameter: `keyProperties.rotationPolicy`

Key rotation policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`attributes`](#parameter-keypropertiesrotationpolicyattributes) | object | The attributes of key rotation policy. |
| [`lifetimeActions`](#parameter-keypropertiesrotationpolicylifetimeactions) | array | The lifetimeActions for key rotation action. |

### Parameter: `keyProperties.rotationPolicy.attributes`

The attributes of key rotation policy.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`expiryTime`](#parameter-keypropertiesrotationpolicyattributesexpirytime) | string | The expiration time for the new key version. It should be in ISO8601 format. Eg: "P90D", "P1Y". |

### Parameter: `keyProperties.rotationPolicy.attributes.expiryTime`

The expiration time for the new key version. It should be in ISO8601 format. Eg: "P90D", "P1Y".

- Required: No
- Type: string

### Parameter: `keyProperties.rotationPolicy.lifetimeActions`

The lifetimeActions for key rotation action.

- Required: No
- Type: array

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`action`](#parameter-keypropertiesrotationpolicylifetimeactionsaction) | object | The action of key rotation policy lifetimeAction. |
| [`trigger`](#parameter-keypropertiesrotationpolicylifetimeactionstrigger) | object | The trigger of key rotation policy lifetimeAction. |

### Parameter: `keyProperties.rotationPolicy.lifetimeActions.action`

The action of key rotation policy lifetimeAction.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`type`](#parameter-keypropertiesrotationpolicylifetimeactionsactiontype) | string | The type of action. |

### Parameter: `keyProperties.rotationPolicy.lifetimeActions.action.type`

The type of action.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Notify'
    'Rotate'
  ]
  ```

### Parameter: `keyProperties.rotationPolicy.lifetimeActions.trigger`

The trigger of key rotation policy lifetimeAction.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`timeAfterCreate`](#parameter-keypropertiesrotationpolicylifetimeactionstriggertimeaftercreate) | string | The time duration after key creation to rotate the key. It only applies to rotate. It will be in ISO 8601 duration format. Eg: "P90D", "P1Y". |
| [`timeBeforeExpiry`](#parameter-keypropertiesrotationpolicylifetimeactionstriggertimebeforeexpiry) | string | The time duration before key expiring to rotate or notify. It will be in ISO 8601 duration format. Eg: "P90D", "P1Y". |

### Parameter: `keyProperties.rotationPolicy.lifetimeActions.trigger.timeAfterCreate`

The time duration after key creation to rotate the key. It only applies to rotate. It will be in ISO 8601 duration format. Eg: "P90D", "P1Y".

- Required: No
- Type: string

### Parameter: `keyProperties.rotationPolicy.lifetimeActions.trigger.timeBeforeExpiry`

The time duration before key expiring to rotate or notify. It will be in ISO 8601 duration format. Eg: "P90D", "P1Y".

- Required: No
- Type: string

### Parameter: `keyProperties.tags`

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
