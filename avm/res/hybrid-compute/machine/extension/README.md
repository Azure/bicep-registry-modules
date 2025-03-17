# Arc Machine Extensions `[Microsoft.HybridCompute/machines/extensions]`

This module deploys a Arc Machine Extension. This module should be used as a standalone deployment after the Arc agent has connected to the Arc Machine resource.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.HybridCompute/machines/extensions` | [2024-07-10](https://learn.microsoft.com/en-us/azure/templates/Microsoft.HybridCompute/2024-07-10/machines/extensions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`arcMachineName`](#parameter-arcmachinename) | string | The name of the parent Arc Machine that extension is provisioned for. |
| [`autoUpgradeMinorVersion`](#parameter-autoupgrademinorversion) | bool | Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true. |
| [`enableAutomaticUpgrade`](#parameter-enableautomaticupgrade) | bool | Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available. |
| [`name`](#parameter-name) | string | The name of the Arc Machine extension. |
| [`publisher`](#parameter-publisher) | string | The name of the extension handler publisher. |
| [`type`](#parameter-type) | string | Specifies the type of the extension; an example is "CustomScriptExtension". |
| [`typeHandlerVersion`](#parameter-typehandlerversion) | string | Specifies the version of the script handler. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`forceUpdateTag`](#parameter-forceupdatetag) | string | How the extension handler should be forced to update even if the extension configuration has not changed. |
| [`location`](#parameter-location) | string | The location the extension is deployed to. |
| [`protectedSettings`](#parameter-protectedsettings) | secureObject | Any object that contains the extension specific protected settings. |
| [`settings`](#parameter-settings) | object | Any object that contains the extension specific settings. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `arcMachineName`

The name of the parent Arc Machine that extension is provisioned for.

- Required: Yes
- Type: string

### Parameter: `autoUpgradeMinorVersion`

Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true.

- Required: Yes
- Type: bool

### Parameter: `enableAutomaticUpgrade`

Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available.

- Required: Yes
- Type: bool

### Parameter: `name`

The name of the Arc Machine extension.

- Required: Yes
- Type: string

### Parameter: `publisher`

The name of the extension handler publisher.

- Required: Yes
- Type: string

### Parameter: `type`

Specifies the type of the extension; an example is "CustomScriptExtension".

- Required: Yes
- Type: string

### Parameter: `typeHandlerVersion`

Specifies the version of the script handler.

- Required: Yes
- Type: string

### Parameter: `forceUpdateTag`

How the extension handler should be forced to update even if the extension configuration has not changed.

- Required: No
- Type: string
- Default: `''`

### Parameter: `location`

The location the extension is deployed to.

- Required: No
- Type: string
- Default: `[resourceGroup().location]`

### Parameter: `protectedSettings`

Any object that contains the extension specific protected settings.

- Required: No
- Type: secureObject
- Default: `{}`

### Parameter: `settings`

Any object that contains the extension specific settings.

- Required: No
- Type: object
- Default: `{}`

### Parameter: `tags`

Tags of the resource.

- Required: No
- Type: object

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `location` | string | The location the resource was deployed into. |
| `name` | string | The name of the extension. |
| `resourceGroupName` | string | The name of the Resource Group the extension was created in. |
| `resourceId` | string | The resource ID of the extension. |
