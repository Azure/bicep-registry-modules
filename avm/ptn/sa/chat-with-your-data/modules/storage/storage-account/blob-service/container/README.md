# Storage Account Blob Containers `[Sa/ChatWithYourDataModulesStorageStorageAccountBlobServiceContainer]`

This module deploys a Storage Account Blob Container.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Storage/storageAccounts/blobServices/containers` | 2024-01-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.storage_storageaccounts_blobservices_containers.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Storage/2024-01-01/storageAccounts/blobServices/containers)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the Storage Container to deploy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`storageAccountName`](#parameter-storageaccountname) | string | The name of the parent Storage Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`blobServiceName`](#parameter-blobservicename) | string | The name of the parent Blob Service. Required if the template is used in a standalone deployment. |
| [`defaultEncryptionScope`](#parameter-defaultencryptionscope) | string | Default the container to use specified encryption scope for all writes. |
| [`denyEncryptionScopeOverride`](#parameter-denyencryptionscopeoverride) | bool | Block override of encryption scope from the container default. |
| [`enableNfsV3AllSquash`](#parameter-enablenfsv3allsquash) | bool | Enable NFSv3 all squash on blob container. |
| [`enableNfsV3RootSquash`](#parameter-enablenfsv3rootsquash) | bool | Enable NFSv3 root squash on blob container. |
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
| [`immutableStorageWithVersioningEnabled`](#parameter-immutablestoragewithversioningenabled) | bool | This is an immutable property, when set to true it enables object level immutability at the container level. The property is immutable and can only be set to true at the container creation time. Existing containers must undergo a migration process. |
| [`metadata`](#parameter-metadata) | object | A name-value pair to associate with the container as metadata. |
| [`publicAccess`](#parameter-publicaccess) | string | Specifies whether data in the container may be accessed publicly and the level of access. |

### Parameter: `name`

The name of the Storage Container to deploy.

- Required: Yes
- Type: string

### Parameter: `storageAccountName`

The name of the parent Storage Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `blobServiceName`

The name of the parent Blob Service. Required if the template is used in a standalone deployment.

- Required: No
- Type: string
- Default: `'default'`

### Parameter: `defaultEncryptionScope`

Default the container to use specified encryption scope for all writes.

- Required: No
- Type: string

### Parameter: `denyEncryptionScopeOverride`

Block override of encryption scope from the container default.

- Required: No
- Type: bool

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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed container. |
| `resourceGroupName` | string | The resource group of the deployed container. |
| `resourceId` | string | The resource ID of the deployed container. |

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
