# SQL Managed Instance Keys `[Microsoft.Sql/managedInstances/keys]`

This module deploys a SQL Managed Instance Key.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/keys` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/managedInstances/keys) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedInstanceName`](#parameter-managedinstancename) | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverKeyType`](#parameter-serverkeytype) | string | The encryption protector type like "ServiceManaged", "AzureKeyVault". |
| [`uri`](#parameter-uri) | string | The URI of the key. If the ServerKeyType is AzureKeyVault, then either the URI or the keyVaultName/keyName combination is required. |

### Parameter: `name`

The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern.

- Required: Yes
- Type: string

### Parameter: `managedInstanceName`

The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `serverKeyType`

The encryption protector type like "ServiceManaged", "AzureKeyVault".

- Required: No
- Type: string
- Default: `'ServiceManaged'`
- Allowed:
  ```Bicep
  [
    'AzureKeyVault'
    'ServiceManaged'
  ]
  ```

### Parameter: `uri`

The URI of the key. If the ServerKeyType is AzureKeyVault, then either the URI or the keyVaultName/keyName combination is required.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed managed instance key. |
| `resourceGroupName` | string | The resource group of the deployed managed instance key. |
| `resourceId` | string | The resource ID of the deployed managed instance key. |
