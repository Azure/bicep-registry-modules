# Recovery Services Vault Backup Policies `[Microsoft.RecoveryServices/vaults/backupPolicies]`

This module deploys a Recovery Services Vault Backup Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/backupPolicies` | [2023-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2023-01-01/vaults/backupPolicies) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Azure Recovery Service Vault Backup Policy. |
| [`properties`](#parameter-properties) | object | Configuration of the Azure Recovery Service Vault Backup Policy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`recoveryVaultName`](#parameter-recoveryvaultname) | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

### Parameter: `name`

Name of the Azure Recovery Service Vault Backup Policy.

- Required: Yes
- Type: string

### Parameter: `properties`

Configuration of the Azure Recovery Service Vault Backup Policy.

- Required: Yes
- Type: object

### Parameter: `recoveryVaultName`

The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the backup policy. |
| `resourceGroupName` | string | The name of the resource group the backup policy was created in. |
| `resourceId` | string | The resource ID of the backup policy. |
