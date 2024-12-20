# SQL Managed Instance Encryption Protector `[Microsoft.Sql/managedInstances/encryptionProtector]`

This module deploys a SQL Managed Instance Encryption Protector.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/managedInstances/encryptionProtector` | [2022-05-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2022-05-01-preview/managedInstances/encryptionProtector) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverKeyName`](#parameter-serverkeyname) | string | The name of the SQL managed instance key. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`managedInstanceName`](#parameter-managedinstancename) | string | The name of the parent SQL managed instance. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoRotationEnabled`](#parameter-autorotationenabled) | bool | Key auto rotation opt-in flag. |
| [`serverKeyType`](#parameter-serverkeytype) | string | The encryption protector type like "ServiceManaged", "AzureKeyVault". |

### Parameter: `serverKeyName`

The name of the SQL managed instance key.

- Required: Yes
- Type: string

### Parameter: `managedInstanceName`

The name of the parent SQL managed instance. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `autoRotationEnabled`

Key auto rotation opt-in flag.

- Required: No
- Type: bool
- Default: `False`

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed managed instance encryption protector. |
| `resourceGroupName` | string | The resource group of the deployed managed instance encryption protector. |
| `resourceId` | string | The resource ID of the deployed managed instance encryption protector. |
