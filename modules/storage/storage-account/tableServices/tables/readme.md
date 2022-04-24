# Storage Account Table `[Microsoft.Storage/storageAccounts/tableServices/tables]`

This module deploys a storage account table

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Template references](#Template-references)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Storage/storageAccounts/tableServices/tables` | 2021-06-01 |

## Parameters

**Required parameters**
| Parameter Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | Name of the table. |
| `storageAccountName` | string | Name of the Storage Account. |

**Optional parameters**
| Parameter Name | Type | Default Value | Description |
| :-- | :-- | :-- | :-- |
| `enableDefaultTelemetry` | bool | `True` | Enable telemetry via the Customer Usage Attribution ID (GUID). |
| `tableServicesName` | string | `'default'` | The name of the table service |


## Outputs

| Output Name | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed file share service |
| `resourceGroupName` | string | The resource group of the deployed file share service |
| `resourceId` | string | The resource ID of the deployed file share service |

## Template references

- [Storageaccounts/Tableservices/Tables](https://docs.microsoft.com/en-us/azure/templates/Microsoft.Storage/2021-06-01/storageAccounts/tableServices/tables)
