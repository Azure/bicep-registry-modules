# Azure SQL Server Encryption Protector `[Microsoft.Sql/servers/encryptionProtector]`

This module deploys an Azure SQL Server Encryption Protector.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/encryptionProtector` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/servers/encryptionProtector) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverKeyName`](#parameter-serverkeyname) | string | The name of the server key. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`sqlServerName`](#parameter-sqlservername) | string | The name of the sql server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoRotationEnabled`](#parameter-autorotationenabled) | bool | Key auto rotation opt-in. |
| [`serverKeyType`](#parameter-serverkeytype) | string | The encryption protector type. |

### Parameter: `serverKeyName`

The name of the server key.

- Required: Yes
- Type: string

### Parameter: `sqlServerName`

The name of the sql server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `autoRotationEnabled`

Key auto rotation opt-in.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `serverKeyType`

The encryption protector type.

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
| `name` | string | The name of the deployed encryption protector. |
| `resourceGroupName` | string | The resource group of the deployed encryption protector. |
| `resourceId` | string | The resource ID of the encryption protector. |
