# Virtual Machine Extensions `[Microsoft.Compute/virtualMachines/extensions]`

This module deploys a Virtual Machine Extension.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)
- [Cross-referenced modules](#Cross-referenced-modules)
- [Data Collection](#Data-Collection)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Compute/virtualMachines/extensions` | [2022-11-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2022-11-01/virtualMachines/extensions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoUpgradeMinorVersion`](#parameter-autoupgrademinorversion) | bool | Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true. |
| [`enableAutomaticUpgrade`](#parameter-enableautomaticupgrade) | bool | Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available. |
| [`name`](#parameter-name) | string | The name of the virtual machine extension. |
| [`publisher`](#parameter-publisher) | string | The name of the extension handler publisher. |
| [`type`](#parameter-type) | string | Specifies the type of the extension; an example is "CustomScriptExtension". |
| [`typeHandlerVersion`](#parameter-typehandlerversion) | string | Specifies the version of the script handler. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualMachineName`](#parameter-virtualmachinename) | string | The name of the parent virtual machine that extension is provisioned for. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`forceUpdateTag`](#parameter-forceupdatetag) | string | How the extension handler should be forced to update even if the extension configuration has not changed. |
| [`location`](#parameter-location) | string | The location the extension is deployed to. |
| [`protectedSettings`](#parameter-protectedsettings) | secureObject | Any object that contains the extension specific protected settings. |
| [`settings`](#parameter-settings) | object | Any object that contains the extension specific settings. |
| [`supressFailures`](#parameter-supressfailures) | bool | Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). The default is false. |
| [`tags`](#parameter-tags) | object | Tags of the resource. |

### Parameter: `autoUpgradeMinorVersion`

Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true.

- Required: Yes
- Type: bool

### Parameter: `enableAutomaticUpgrade`

Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available.

- Required: Yes
- Type: bool

### Parameter: `name`

The name of the virtual machine extension.

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

### Parameter: `virtualMachineName`

The name of the parent virtual machine that extension is provisioned for. Required if the template is used in a standalone deployment.

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

### Parameter: `supressFailures`

Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). The default is false.

- Required: No
- Type: bool
- Default: `False`

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

## Cross-referenced modules

_None_

## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the [repository](https://aka.ms/avm/telemetry). There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
