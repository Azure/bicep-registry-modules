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
| [`credentials`](#parameter-credentials) | array | The credential definition. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

### Parameter: `credentials`

The credential definition.

- Required: Yes
- Type: array

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-credentialsname) | string | Name of the Automation Account credential. |
| [`password`](#parameter-credentialspassword) | securestring | Password of the credential. |
| [`userName`](#parameter-credentialsusername) | string | The user name associated to the credential. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-credentialsdescription) | string | Description of the credential. |

### Parameter: `credentials.name`

Name of the Automation Account credential.

- Required: Yes
- Type: string

### Parameter: `credentials.password`

Password of the credential.

- Required: Yes
- Type: securestring

### Parameter: `credentials.userName`

The user name associated to the credential.

- Required: Yes
- Type: string

### Parameter: `credentials.description`

Description of the credential.

- Required: No
- Type: string

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | array | The names of the credentials associated to the automation account. |
| `resourceGroupName` | string | The resource group of the deployed credential. |
| `resourceId` | array | The resource IDs of the credentials associated to the automation account. |
