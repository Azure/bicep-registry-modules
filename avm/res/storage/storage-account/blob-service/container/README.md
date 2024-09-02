# Storage Account Blob Containers `[Microsoft.Storage/storageAccounts/blobServices/containers]`

This module deploys a Storage Account Blob Container.

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
| `Microsoft.Storage/storageAccounts/blobServices/containers` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers) |
| `Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2022-09-01/storageAccounts/blobServices/containers/immutabilityPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the storage container to deploy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAccountName`](#parameter-storageaccountname) | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`defaultEncryptionScope`](#parameter-defaultencryptionscope) | string | Default the container to use specified encryption scope for all writes. |
| [`denyEncryptionScopeOverride`](#parameter-denyencryptionscopeoverride) | bool | Block override of encryption scope from the container default. |
| [`enableNfsV3AllSquash`](#parameter-enablenfsv3allsquash) | bool | Enable NFSv3 all squash on blob container. |
| [`enableNfsV3RootSquash`](#parameter-enablenfsv3rootsquash) | bool | Enable NFSv3 root squash on blob container. |
| [`immutabilityPolicyName`](#parameter-immutabilitypolicyname) | string | Name of the immutable policy. |
| [`immutabilityPolicyProperties`](#parameter-immutabilitypolicyproperties) | object | Configure immutability policy. |
| [`immutableStorageWithVersioningEnabled`](#parameter-immutablestoragewithversioningenabled) | bool | This is an immutable property, when set to true it enables object level immutability at the container level. The property is immutable and can only be set to true at the container creation time. Existing containers must undergo a migration process. |
| [`metadata`](#parameter-metadata) | object | A name-value pair to associate with the container as metadata. |
| [`publicAccess`](#parameter-publicaccess) | string | Specifies whether data in the container may be accessed publicly and the level of access. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |

### Parameter: `name`

The name of the storage container to deploy.

- Required: Yes
- Type: string

### Parameter: `storageAccountName`

The name of the parent Storage Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `defaultEncryptionScope`

Default the container to use specified encryption scope for all writes.

- Required: No
- Type: string
- Default: `''`

### Parameter: `denyEncryptionScopeOverride`

Block override of encryption scope from the container default.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableNfsV3AllSquash`

Enable NFSv3 all squash on blob container.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enableNfsV3RootSquash`

Enable NFSv3 root squash on blob container.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `immutabilityPolicyName`

Name of the immutable policy.

- Required: No
- Type: string
- Default: `'default'`

### Parameter: `immutabilityPolicyProperties`

Configure immutability policy.

- Required: No
- Type: object

### Parameter: `immutableStorageWithVersioningEnabled`

This is an immutable property, when set to true it enables object level immutability at the container level. The property is immutable and can only be set to true at the container creation time. Existing containers must undergo a migration process.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `metadata`

A name-value pair to associate with the container as metadata.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `publicAccess`

Specifies whether data in the container may be accessed publicly and the level of access.

- Required: No
- Type: string
- Default: `'None'`
- Allowed:
  ```Bicep
  [
    'Blob'
    'Container'
    'None'
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


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed container. |
| `resourceGroupName` | string | The resource group of the deployed container. |
| `resourceId` | string | The resource ID of the deployed container. |

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
