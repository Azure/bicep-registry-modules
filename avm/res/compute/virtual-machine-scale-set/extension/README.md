# Virtual Machine Scale Set Extensions `[Microsoft.Compute/virtualMachineScaleSets/extensions]`

This module deploys a Virtual Machine Scale Set Extension.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Compute/virtualMachineScaleSets/extensions` | [2023-09-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Compute/2023-09-01/virtualMachineScaleSets/extensions) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`autoUpgradeMinorVersion`](#parameter-autoupgrademinorversion) | bool | Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true. |
| [`enableAutomaticUpgrade`](#parameter-enableautomaticupgrade) | bool | Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available. |
| [`name`](#parameter-name) | string | The name of the virtual machine scale set extension. |
| [`publisher`](#parameter-publisher) | string | The name of the extension handler publisher. |
| [`type`](#parameter-type) | string | Specifies the type of the extension; an example is "CustomScriptExtension". |
| [`typeHandlerVersion`](#parameter-typehandlerversion) | string | Specifies the version of the script handler. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`virtualMachineScaleSetName`](#parameter-virtualmachinescalesetname) | string | The name of the parent virtual machine scale set that extension is provisioned for. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`forceUpdateTag`](#parameter-forceupdatetag) | string | How the extension handler should be forced to update even if the extension configuration has not changed. |
| [`protectedSettings`](#parameter-protectedsettings) | secureObject | Any object that contains the extension specific protected settings. |
| [`settings`](#parameter-settings) | object | Any object that contains the extension specific settings. |
| [`supressFailures`](#parameter-supressfailures) | bool | Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). The default is false. |

### Parameter: `autoUpgradeMinorVersion`

Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true.

- Required: Yes
- Type: bool

### Parameter: `enableAutomaticUpgrade`

Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available.

- Required: Yes
- Type: bool

### Parameter: `name`

The name of the virtual machine scale set extension.

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

### Parameter: `virtualMachineScaleSetName`

The name of the parent virtual machine scale set that extension is provisioned for. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `forceUpdateTag`

How the extension handler should be forced to update even if the extension configuration has not changed.

- Required: No
- Type: string
- Default: `''`

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

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the extension. |
| `resourceGroupName` | string | The name of the Resource Group the extension was created in. |
| `resourceId` | string | The ResourceId of the extension. |
