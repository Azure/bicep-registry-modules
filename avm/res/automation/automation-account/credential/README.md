# Automation Account Credential `[Microsoft.Automation/automationAccounts/credentials]`

This module deploys Azure Automation Account Credential.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/credentials` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2023-11-01/automationAccounts/credentials) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Automation Account credential. |
| [`password`](#parameter-password) | securestring | Password of the credential. |
| [`userName`](#parameter-username) | string | The user name associated to the credential. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | Description of the credential. |

### Parameter: `name`

Name of the Automation Account credential.

- Required: Yes
- Type: string

### Parameter: `password`

Password of the credential.

- Required: Yes
- Type: securestring

### Parameter: `userName`

The user name associated to the credential.

- Required: Yes
- Type: string

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

Description of the credential.

- Required: No
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the credential associated to the automation account. |
| `resourceGroupName` | string | The resource group of the deployed credential. |
| `resourceId` | string | The resource Id of the credential associated to the automation account. |
