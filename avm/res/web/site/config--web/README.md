# Site Api Management Config `[Microsoft.Web/sites/config]`

This module deploys a Site Api Management Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/config` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementConfiguration`](#parameter-apimanagementconfiguration) | object | The web settings api management configuration. |
| [`appName`](#parameter-appname) | string | The name of the parent site resource. |

### Parameter: `apiManagementConfiguration`

The web settings api management configuration.

- Required: No
- Type: object

### Parameter: `appName`

The name of the parent site resource.

- Required: Yes
- Type: string

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the site config. |
| `resourceGroupName` | string | The resource group the site config was deployed into. |
| `resourceId` | string | The resource ID of the site config. |

## Cross-referenced modules

This section gives you an overview of all local-referenced module files (i.e., other modules that are referenced in this module) and all remote-referenced files (i.e., Bicep modules that are referenced from a Bicep Registry or Template Specs).

| Reference | Type |
| :-- | :-- |
