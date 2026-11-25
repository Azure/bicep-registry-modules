# Automation Account Source Controls `[Microsoft.Automation/automationAccounts/sourceControls]`

This module deploys an Azure Automation Account Source Control.

You can reference the module as follows:
```bicep
module automationAccount 'br/public:avm/res/automation/automation-account/source-control:<version>' = {
  params: { (...) }
}
```
For examples, please refer to the [Usage Examples](#usage-examples) section.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Data Collection](#Data-Collection)

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
| [`enableTelemetry`](#parameter-enabletelemetry) | bool | Enable/Disable usage telemetry for module. |
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

### Parameter: `enableTelemetry`

Enable/Disable usage telemetry for module.

- Required: No
- Type: bool
- Default: `True`

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

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft's privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
