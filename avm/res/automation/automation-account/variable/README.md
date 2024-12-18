# Automation Account Variables `[Microsoft.Automation/automationAccounts/variables]`

This module deploys an Azure Automation Account Variable.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/variables` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/variables) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the variable. |
| [`value`](#parameter-value) | securestring | The value of the variable. For security best practices, this value is always passed as a secure string as it could contain an encrypted value when the "isEncrypted" property is set to true. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | The description of the variable. |
| [`isEncrypted`](#parameter-isencrypted) | bool | If the variable should be encrypted. For security reasons encryption of variables should be enabled. |

### Parameter: `name`

The name of the variable.

- Required: Yes
- Type: string
- Nullable: No

### Parameter: `value`

The value of the variable. For security best practices, this value is always passed as a secure string as it could contain an encrypted value when the "isEncrypted" property is set to true.

- Required: Yes
- Type: securestring
- Nullable: No

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string
- Nullable: No

### Parameter: `description`

The description of the variable.

- Required: No
- Type: string
- Nullable: No
- Default: `''`

### Parameter: `isEncrypted`

If the variable should be encrypted. For security reasons encryption of variables should be enabled.

- Required: No
- Type: bool
- Nullable: No
- Default: `True`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed variable. |
| `resourceGroupName` | string | The resource group of the deployed variable. |
| `resourceId` | string | The resource ID of the deployed variable. |
