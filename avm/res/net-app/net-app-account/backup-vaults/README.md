#  `[Microsoft.NetApp/netAppAccounts/backupVaults]`


## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.NetApp/netAppAccounts/backupVaults` | [2024-03-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.NetApp/2024-03-01/netAppAccounts/backupVaults) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`netAppAccountName`](#parameter-netappaccountname) | string | The name of the parent NetApp account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`backupVaultLocation`](#parameter-backupvaultlocation) | string | The location of the backup vault. |
| [`backupVaultName`](#parameter-backupvaultname) | string | The name of the backup vault. |

### Parameter: `netAppAccountName`

The name of the parent NetApp account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `backupVaultLocation`

The location of the backup vault.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `backupVaultName`

The name of the backup vault.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the Backup Policy. |
| `resourceGroupName` | string | The name of the Resource Group the Backup Policy was created in. |
| `resourceId` | string | The resource IDs of the backup Policy created within volume. |
