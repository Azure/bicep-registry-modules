# Recovery Services Vault Replication Alert Settings `[Microsoft.RecoveryServices/vaults/replicationAlertSettings]`

This module deploys a Recovery Services Vault Replication Alert Settings.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.RecoveryServices/vaults/replicationAlertSettings` | [2022-10-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.RecoveryServices/2022-10-01/vaults/replicationAlertSettings) |

## Parameters

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`recoveryVaultName`](#parameter-recoveryvaultname) | string | The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`customEmailAddresses`](#parameter-customemailaddresses) | array | Comma separated list of custom email address for sending alert emails. |
| [`locale`](#parameter-locale) | string | The locale for the email notification. |
| [`name`](#parameter-name) | string | The name of the replication Alert Setting. |
| [`sendToOwners`](#parameter-sendtoowners) | string | The value indicating whether to send email to subscription administrator. |

### Parameter: `recoveryVaultName`

The name of the parent Azure Recovery Service Vault. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `customEmailAddresses`

Comma separated list of custom email address for sending alert emails.

- Required: No
- Type: array
- Default: `[]`

### Parameter: `locale`

The locale for the email notification.

- Required: No
- Type: string
- Default: `''`

### Parameter: `name`

The name of the replication Alert Setting.

- Required: No
- Type: string
- Default: `'defaultAlertSetting'`

### Parameter: `sendToOwners`

The value indicating whether to send email to subscription administrator.

- Required: No
- Type: string
- Default: `'Send'`
- Allowed:
  ```Bicep
  [
    'DoNotSend'
    'Send'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the replication Alert Setting. |
| `resourceGroupName` | string | The name of the resource group the replication alert setting was created. |
| `resourceId` | string | The resource ID of the replication alert setting. |
