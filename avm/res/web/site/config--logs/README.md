# Site logs Config `[Microsoft.Web/sites/config]`

This module deploys a Site logs Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/config` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent site resource. |
| [`logsConfiguration`](#parameter-logsconfiguration) | object | The logs settings configuration. |

### Parameter: `appName`

The name of the parent site resource.

- Required: Yes
- Type: string

### Parameter: `logsConfiguration`

The logs settings configuration.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the site config. |
| `resourceGroupName` | string | The resource group the site config was deployed into. |
| `resourceId` | string | The resource ID of the site config. |
