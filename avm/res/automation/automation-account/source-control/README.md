# Automation Account Source Controls `[Microsoft.Automation/automationAccounts/sourceControls]`

This module deploys an Azure Automation Account Source Control.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Automation/automationAccounts/sourceControls` | 2024-10-23 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.automation_automationaccounts_sourcecontrols.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2024-10-23/automationAccounts/sourceControls)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`branch`](#parameter-branch) | string | The repo branch of the source control. Include branch as empty string for VsoTfvc. |
| [`description`](#parameter-description) | string | The user description of the source control. |
| [`folderPath`](#parameter-folderpath) | string | The folder path of the source control. Path must be relative. |
| [`name`](#parameter-name) | string | A friendly name for the source control. This name must contain only letters and numbers. |
| [`repoUrl`](#parameter-repourl) | string | The repo url of the source control. |
| [`sourceType`](#parameter-sourcetype) | string | Type of source control mechanism. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoSync`](#parameter-autosync) | bool | Setting that turns on or off automatic synchronization when a commit is made in the source control repository or GitHub repo. Defaults to `false`. |
| [`publishRunbook`](#parameter-publishrunbook) | bool | The auto publish of the source control. Defaults to `true`. |
| [`securityToken`](#parameter-securitytoken) | object | The authorization token for the repo of the source control. |

### Parameter: `branch`

The repo branch of the source control. Include branch as empty string for VsoTfvc.

- Required: Yes
- Type: string

### Parameter: `description`

The user description of the source control.

- Required: Yes
- Type: string

### Parameter: `folderPath`

The folder path of the source control. Path must be relative.

- Required: Yes
- Type: string

### Parameter: `name`

A friendly name for the source control. This name must contain only letters and numbers.

- Required: Yes
- Type: string

### Parameter: `repoUrl`

The repo url of the source control.

- Required: Yes
- Type: string

### Parameter: `sourceType`

Type of source control mechanism.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'GitHub'
    'VsoGit'
    'VsoTfvc'
  ]
  ```

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `autoSync`

Setting that turns on or off automatic synchronization when a commit is made in the source control repository or GitHub repo. Defaults to `false`.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `publishRunbook`

The auto publish of the source control. Defaults to `true`.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `securityToken`

The authorization token for the repo of the source control.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the deployed source control. |
| `resourceGroupName` | string | The resource group of the deployed source control. |
| `resourceId` | string | The resource ID of the deployed source control. |
