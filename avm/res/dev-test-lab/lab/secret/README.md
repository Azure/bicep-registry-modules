# DevTest Lab Secrets `[Microsoft.DevTestLab/labs]`

This module deploys a DevTest Lab Secret.

Lab secrets will be accessible to all lab users. Depending on their scope, secrets can be used to securely provide credentials when creating formulas, virtual machines, artifacts, or ARM templates.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.DevTestLab/labs/secrets` | 2018-10-15-preview | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.devtestlab_labs_secrets.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.DevTestLab/labs)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the secret. Secret names can only contain alphanumeric characters and dashes. |
| [`value`](#parameter-value) | securestring | The value of the secret. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`labName`](#parameter-labname) | string | The name of the parent lab. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enabledForArtifacts`](#parameter-enabledforartifacts) | bool | Set a secret for your artifacts (e.g., a personal access token to clone your Git repository via an artifact). At least one of the following must be true: enabledForArtifacts, enabledForVmCreation. |
| [`enabledForVmCreation`](#parameter-enabledforvmcreation) | bool | Set a user password or provide an SSH public key to access your Windows or Linux virtual machines. At least one of the following must be true: enabledForArtifacts, enabledForVmCreation. |

### Parameter: `name`

The name of the secret. Secret names can only contain alphanumeric characters and dashes.

- Required: Yes
- Type: string

### Parameter: `value`

The value of the secret.

- Required: Yes
- Type: securestring

### Parameter: `labName`

The name of the parent lab. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enabledForArtifacts`

Set a secret for your artifacts (e.g., a personal access token to clone your Git repository via an artifact). At least one of the following must be true: enabledForArtifacts, enabledForVmCreation.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `enabledForVmCreation`

Set a user password or provide an SSH public key to access your Windows or Linux virtual machines. At least one of the following must be true: enabledForArtifacts, enabledForVmCreation.

- Required: No
- Type: bool
- Default: `False`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the secret. |
| `resourceGroupName` | string | The name of the resource group the secret was created in. |
| `resourceId` | string | The resource ID of the secret. |
