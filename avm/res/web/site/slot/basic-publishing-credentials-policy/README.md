# Web Site Slot Basic Publishing Credentials Policies `[Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies]`

This module deploys a Web Site Slot Basic Publishing Credentials Policy.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Web/sites/slots/basicPublishingCredentialsPolicies` | [2022-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Web/sites) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the resource. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`appName`](#parameter-appname) | string | The name of the parent web site. Required if the template is used in a standalone deployment. |
| [`slotName`](#parameter-slotname) | string | The name of the parent web site slot. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`allow`](#parameter-allow) | bool | Set to true to enable or false to disable a publishing method. |
| [`location`](#parameter-location) | string | Location for all Resources. |

### Parameter: `name`

The name of the resource.

- Required: Yes
- Type: string
- Allowed:
  ```Bicep
  [
    'ftp'
    'scm'
  ]
  ```

### Parameter: `appName`

The name of the parent web site. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `slotName`

The name of the parent web site slot. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `allow`

Set to true to enable or false to disable a publishing method.

- Required: No
- Type: bool
- Default: `True`

### Parameter: `location`

Location for all Resources.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the basic publishing credential policy. |
| `resourceGroupName` | string | The name of the resource group the basic publishing credential policy was deployed into. |
| `resourceId` | string | The resource ID of the basic publishing credential policy. |
