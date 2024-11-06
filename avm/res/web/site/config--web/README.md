# Site Api Management Config `[Microsoft.Web/sites/config]`

This module deploys a Site Api Management Configuration.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/config` | [2023-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2023-12-01/sites/config) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent site resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`apiManagementConfiguration`](#parameter-apimanagementconfiguration) | object | The web settings api management configuration. |

### Parameter: `appName`

The name of the parent site resource.

- Required: Yes
- Type: string

### Parameter: `apiManagementConfiguration`

The web settings api management configuration.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the site config. |
| `resourceGroupName` | string | The resource group the site config was deployed into. |
| `resourceId` | string | The resource ID of the site config. |
