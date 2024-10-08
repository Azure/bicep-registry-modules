# Site Deployment Extension  `[Microsoft.Web/sites/extensions]`

This module deploys a Site extension for MSDeploy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/extensions` | [2023-12-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites/extensions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent site resource. |
| [`msDeployConfiguration`](#parameter-msdeployconfiguration) | object | Sets the MSDeployment Properties. |

### Parameter: `appName`

The name of the parent site resource.

- Required: Yes
- Type: string

### Parameter: `msDeployConfiguration`

Sets the MSDeployment Properties.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the MSDeploy Package. |
| `resourceGroupName` | string | The resource group the site config was deployed into. |
| `resourceId` | string | The resource ID of the Site Extension. |
