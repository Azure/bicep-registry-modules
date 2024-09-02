# Azure SQL Server Encryption Protector `[Microsoft.Sql/servers/encryptionProtector]`

This module deploys an Azure SQL Server Encryption Protector.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
