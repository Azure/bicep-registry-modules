# Site Auth Settings V2 Config `[Microsoft.Web/sites/config]`

This module deploys a Site Auth Settings V2 Configuration.

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
| [`authSettingV2Configuration`](#parameter-authsettingv2configuration) | object | The auth settings V2 configuration. |
| [`kind`](#parameter-kind) | string | Type of site to deploy. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent site resource. Required if the template is used in a standalone deployment. |

### Parameter: `authSettingV2Configuration`

The auth settings V2 configuration.

- Required: Yes
- Type: object

### Parameter: `kind`

Type of site to deploy.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'api'
    'app'
    'app,container,windows'
    'app,linux'
    'app,linux,container'
    'functionapp'
    'functionapp,linux'
    'functionapp,linux,container'
    'functionapp,workflowapp'
    'functionapp,workflowapp,linux'
    'linux,api'
  ]
  ```

### Parameter: `appName`

The name of the parent site resource. Required if the template is used in a standalone deployment.

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
