# Automation Account Modules `[Microsoft.Automation/automationAccounts/modules]`

This module deploys an Azure Automation Account Module.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Automation/automationAccounts/modules` | [2022-08-08](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Automation/2022-08-08/automationAccounts/modules) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | Name of the Automation Account module. |
| [`uri`](#parameter-uri) | string | Module package URI, e.g. https://www.powershellgallery.com/api/v2/package. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`automationAccountName`](#parameter-automationaccountname) | string | The name of the parent Automation Account. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`location`](#parameter-location) | string | Location for all resources. |
| [`tags`](#parameter-tags) | object | Tags of the Automation Account resource. |
| [`version`](#parameter-version) | string | Module version or specify latest to get the latest version. |

### Parameter: `name`

Name of the Automation Account module.

- Required: Yes
- Type: string

### Parameter: `uri`

Module package URI, e.g. https://www.powershellgallery.com/api/v2/package.

- Required: Yes
- Type: string

### Parameter: `automationAccountName`

The name of the parent Automation Account. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `location`

Location for all resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `tags`

Tags of the Automation Account resource.

- Required: No
- Type: object

### Parameter: `version`

Module version or specify latest to get the latest version.

- Required: No
- Type: string
- Default: `'latest'`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the deployed module. |
| `resourceGroupName` | string | The resource group of the deployed module. |
| `resourceId` | string | The resource ID of the deployed module. |
