# Automation Account Runbooks `[Microsoft.Automation/automationAccounts/runbooks]`

This module deploys an Azure Automation Account Runbook.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/runbooks` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2023-11-01/automationAccounts/runbooks) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Automation Account runbook. |
| [`type`](#parameter-type) | string | The type of the runbook. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`description`](#parameter-description) | string | The description of the runbook. |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`sasTokenValidityLength`](#parameter-sastokenvaliditylength) | string | SAS token validity length. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours. |
| [`scriptStorageAccountResourceId`](#parameter-scriptstorageaccountresourceid) | string | Resource Id of the runbook storage account. |
| [`tags`](#parameter-tags) | object | Tags of the Automation Account resource. |
| [`uri`](#parameter-uri) | string | The uri of the runbook content. |
| [`version`](#parameter-version) | string | The version of the runbook content. |

**Generated parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`baseTime`](#parameter-basetime) | string | Time used as a basis for e.g. the schedule start date. |

### Parameter: `name`

Name of the Automation Account runbook.

- Required: Yes
- Type: string

### Parameter: `type`

The type of the runbook.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'Graph'
    'GraphPowerShell'
    'GraphPowerShellWorkflow'
    'PowerShell'
    'PowerShell72'
    'PowerShellWorkflow'
    'Python2'
    'Python3'
    'Script'
  ]
  ```

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `description`

The description of the runbook.

- Required: No
- Type: string
- Default: `''`

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `sasTokenValidityLength`

SAS token validity length. Usage: 'PT8H' - valid for 8 hours; 'P5D' - valid for 5 days; 'P1Y' - valid for 1 year. When not provided, the SAS token will be valid for 8 hours.

- Required: No
- Type: string
- Default: `'PT8H'`

### Parameter: `scriptStorageAccountResourceId`

Resource Id of the runbook storage account.

- Required: No
- Type: string

### Parameter: `tags`

Tags of the Automation Account resource.

- Required: No
- Type: object

### Parameter: `uri`

The uri of the runbook content.

- Required: No
- Type: string
- Default: `''`

### Parameter: `version`

The version of the runbook content.

- Required: No
- Type: string
- Default: `''`

### Parameter: `baseTime`

Time used as a basis for e.g. the schedule start date.

- Required: No
- Type: string
- Default: `[utcNow('u')]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed runbook. |
| `resourceGroupName` | string | The resource group of the deployed runbook. |
| `resourceId` | string | The resource ID of the deployed runbook. |
