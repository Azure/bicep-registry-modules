# Site Deployment Extension  `[Microsoft.Web/sites/extensions]`

This module deploys a Site extension for MSDeploy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version | References |
| :-- | :-- | :-- |
| `Microsoft.Web/sites/extensions` | 2025-03-01 | <ul style="padding-left: 0px;"><li>[AzAdvertizer](https://www.azadvertizer.net/azresourcetypes/microsoft.web_sites_extensions.html)</li><li>[Template reference](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/2025-03-01/sites/extensions)</li></ul> |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent site resource. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-kind) | string | The kind of extension. |
| [`name`](#parameter-name) | string | The name of the extension. |
| [`properties`](#parameter-properties) | object | Sets the properties. |

### Parameter: `appName`

The name of the parent site resource.

- Required: Yes
- Type: string

### Parameter: `kind`

The kind of extension.

- Required: No
- Type: string
- Default: `'MSDeploy'`
- Allowed:
  ```Bicep
  [
    'MSDeploy'
  ]
  ```

### Parameter: `name`

The name of the extension.

- Required: No
- Type: string
- Default: `'MSDeploy'`
- Allowed:
  ```Bicep
  [
    'MSDeploy'
  ]
  ```

### Parameter: `properties`

Sets the properties.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the extension. |
| `resourceGroupName` | string | The resource group the extension was deployed into. |
| `resourceId` | string | The resource ID of the extension. |
