# Azure SQL Server Keys `[Microsoft.Sql/servers/keys]`

This module deploys an Azure SQL Server Key.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Sql/servers/keys` | [2023-08-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Sql/2023-08-01-preview/servers/keys) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`serverName`](#parameter-servername) | string | The name of the parent SQL server. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern. |
| [`serverKeyType`](#parameter-serverkeytype) | string | The server key type. |
| [`uri`](#parameter-uri) | string | The URI of the server key. If the ServerKeyType is AzureKeyVault, then the URI is required. The AKV URI is required to be in this format: 'https://YourVaultName.azure.net/keys/YourKeyName/YourKeyVersion'. |

### Parameter: `serverName`

The name of the parent SQL server. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `name`

The name of the key. Must follow the [<keyVaultName>_<keyName>_<keyVersion>] pattern.

- Required: No
- Type: string

### Parameter: `serverKeyType`

The server key type.

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

The URI of the server key. If the ServerKeyType is AzureKeyVault, then the URI is required. The AKV URI is required to be in this format: 'https://YourVaultName.azure.net/keys/YourKeyName/YourKeyVersion'.

- Required: No
- Type: string
- Default: `''`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed server key. |
| `resourceGroupName` | string | The resource group of the deployed server key. |
| `resourceId` | string | The resource ID of the deployed server key. |
