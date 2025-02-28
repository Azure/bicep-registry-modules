# Automation Account Python 2 Packages `[Microsoft.Automation/automationAccounts/python2Packages]`

This module deploys a Python2 Package in the Automation Account.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/python2Packages` | [2023-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2023-11-01/automationAccounts/python2Packages) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Python2 Automation Account package. |
| [`uri`](#parameter-uri) | string | Package URI, e.g. https://www.powershellgallery.com/api/v2/package. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`tags`](#parameter-tags) | object | Tags of the Automation Account resource. |
| [`version`](#parameter-version) | string | Package version or specify latest to get the latest version. |

### Parameter: `name`

Name of the Python2 Automation Account package.

- Required: Yes
- Type: string

### Parameter: `uri`

Package URI, e.g. https://www.powershellgallery.com/api/v2/package.

- Required: Yes
- Type: string

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `tags`

Tags of the Automation Account resource.

- Required: No
- Type: object

### Parameter: `version`

Package version or specify latest to get the latest version.

- Required: No
- Type: string
- Default: `'latest'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed package. |
| `resourceGroupName` | string | The resource group of the deployed package. |
| `resourceId` | string | The resource ID of the deployed package. |
