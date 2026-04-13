# App ManagedEnvironments Certificates `[Microsoft.App/managedEnvironments/storages]`

This module deploys a App Managed Environment Certificate.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.App/managedEnvironments/storages` | 2025-10-02-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.app_managedenvironments_storages.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.App/2025-10-02-preview/managedEnvironments/storages)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`accessMode`](#parameter-accessmode) | string | The access mode for the storage. |
| [`kind`](#parameter-kind) | string | Type of storage: "SMB" or "NFS". |
| [`name`](#parameter-name) | string | The name of the file share. |
| [`storageAccountName`](#parameter-storageaccountname) | string | Storage account name. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedEnvironmentName`](#parameter-managedenvironmentname) | string | The name of the parent app managed environment. Required if the template is used in a standalone deployment. |

### Parameter: `accessMode`

The access mode for the storage.

- Required: Yes
- Type: string

### Parameter: `kind`

Type of storage: "SMB" or "NFS".

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'NFS'
    'SMB'
  ]
  ```

### Parameter: `name`

The name of the file share.

- Required: Yes
- Type: string

### Parameter: `storageAccountName`

Storage account name.

- Required: Yes
- Type: string

### Parameter: `managedEnvironmentName`

The name of the parent app managed environment. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the file share. |
| `resourceGroupName` | string | The resource group the file share was deployed into. |
| `resourceId` | string | The resource ID of the file share. |
