# Key Vault Secrets `[Microsoft.KeyVault/vaults/secrets]`

This module deploys a Key Vault Secret.

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
| `Microsoft.KeyVault/vaults/secrets` | [2022-07-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.KeyVault/2022-07-01/vaults/secrets) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`keyVaultName`](#parameter-keyvaultname) | string | The name of the parent key vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`secretProperties`](#parameter-secretproperties) | object | Sets the attributes of the secret. |

### Parameter: `keyVaultName`

The name of the parent key vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `secretProperties`

Sets the attributes of the secret.

- Required: Yes
- Type: object

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-secretpropertiesname) | string | The name of the secret. |
| [`value`](#parameter-secretpropertiesvalue) | securestring | The value of the secret. NOTE: "value" will never be returned from the service, as APIs using this model are is intended for internal use in ARM deployments. Users should use the data-plane REST service for interaction with vault secrets. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`attributes`](#parameter-secretpropertiesattributes) | object | Contains attributes of the secret. |
| [`contentType`](#parameter-secretpropertiescontenttype) | securestring | The content type of the secret. |
| [`roleAssignments`](#parameter-secretpropertiesroleassignments) | array | Array of role assignments to create. |
| [`tags`](#parameter-secretpropertiestags) | object | Resource tags. |

### Parameter: `secretProperties.name`

The name of the secret.

- Required: Yes
- Type: string

### Parameter: `secretProperties.value`

The value of the secret. NOTE: "value" will never be returned from the service, as APIs using this model are is intended for internal use in ARM deployments. Users should use the data-plane REST service for interaction with vault secrets.

- Required: Yes
- Type: securestring

### Parameter: `secretProperties.attributes`

Contains attributes of the secret.

- Required: Yes
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabled`](#parameter-secretpropertiesattributesenabled) | bool | Defines whether the secret is enabled or disabled. |
| [`exp`](#parameter-secretpropertiesattributesexp) | int | Defines when the secret will become invalid. Defined in seconds since 1970-01-01T00:00:00Z. |
| [`nbf`](#parameter-secretpropertiesattributesnbf) | int | If set, defines the date from which onwards the secret becomes valid. Defined in seconds since 1970-01-01T00:00:00Z. |

### Parameter: `secretProperties.attributes.enabled`

Defines whether the secret is enabled or disabled.

- Required: No
- Type: bool

### Parameter: `secretProperties.attributes.exp`

Defines when the secret will become invalid. Defined in seconds since 1970-01-01T00:00:00Z.

- Required: No
- Type: int

### Parameter: `secretProperties.attributes.nbf`

If set, defines the date from which onwards the secret becomes valid. Defined in seconds since 1970-01-01T00:00:00Z.

- Required: No
- Type: int

### Parameter: `secretProperties.contentType`

The content type of the secret.

- Required: No
- Type: securestring

### Parameter: `secretProperties.roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-secretpropertiesroleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-secretpropertiesroleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-secretpropertiesroleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-secretpropertiesroleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-secretpropertiesroleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-secretpropertiesroleassignmentsdescription) | string | The description of the role assignment. |
| [`principalType`](#parameter-secretpropertiesroleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `secretProperties.roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `secretProperties.roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `secretProperties.roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `secretProperties.roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `secretProperties.roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `secretProperties.roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `secretProperties.roleAssignments.principalType`

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

### Parameter: `secretProperties.tags`

Resource tags.

- Required: No
- Type: object


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the secret. |
| `resourceGroupName` | string | The name of the resource group the secret was created in. |
| `resourceId` | string | The resource ID of the secret. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
