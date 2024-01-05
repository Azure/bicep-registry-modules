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

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`enableDefaultTelemetry`](#parameter-enabledefaulttelemetry) | bool | Enable telemetry via a Globally Unique Identifier (GUID). |

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
    'app'
    'functionapp'
    'functionapp,linux'
    'functionapp,workflowapp'
    'functionapp,workflowapp,linux'
  ]
  ```

### Parameter: `appName`

The name of the parent site resource. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `enableDefaultTelemetry`

Enable telemetry via a Globally Unique Identifier (GUID).

- Required: No
- Type: bool
- Default: `True`


## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the site config. |
| `resourceGroupName` | string | The resource group the site config was deployed into. |
| `resourceId` | string | The resource ID of the site config. |

## Cross-referenced modules

_None_
