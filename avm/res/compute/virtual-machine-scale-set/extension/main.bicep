metadata name = 'Virtual Machine Scale Set Extensions'
metadata description = 'This module deploys a Virtual Machine Scale Set Extension.'

@description('Conditional. The name of the parent virtual machine scale set that extension is provisioned for. Required if the template is used in a standalone deployment.')
param virtualMachineScaleSetName string

@description('Required. The name of the virtual machine scale set extension.')
param name string

@description('Required. The name of the extension handler publisher.')
param publisher string

@description('Required. Specifies the type of the extension; an example is "CustomScriptExtension".')
param type string

@description('Required. Specifies the version of the script handler.')
param typeHandlerVersion string

@description('Required. Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true.')
param autoUpgradeMinorVersion bool

@description('Optional. How the extension handler should be forced to update even if the extension configuration has not changed.')
param forceUpdateTag string?

@description('Optional. Any object that contains the extension specific settings.')
param settings object? // Type any(...). Cannot use RDTs

@description('Optional. Any object that contains the extension specific protected settings.')
@secure()
param protectedSettings object? // Type any(...). Cannot use RDTs

@description('Optional. Indicates whether failures stemming from the extension will be suppressed (Operational failures such as not connecting to the VM will not be suppressed regardless of this value). The default is false.')
param supressFailures bool = false

@description('Required. Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available.')
param enableAutomaticUpgrade bool

@description('Optional. The extensions protected settings that are passed by reference, and consumed from key vault.')
param protectedSettingsFromKeyVault resourceInput<'Microsoft.Compute/virtualMachineScaleSets/extensions@2024-11-01'>.properties.protectedSettingsFromKeyVault?

@description('Optional. Collection of extension names after which this extension needs to be provisioned.')
param provisionAfterExtensions string[]?

resource virtualMachineScaleSet 'Microsoft.Compute/virtualMachineScaleSets@2024-11-01' existing = {
  name: virtualMachineScaleSetName
}

resource extension 'Microsoft.Compute/virtualMachineScaleSets/extensions@2024-11-01' = {
  name: name
  parent: virtualMachineScaleSet
  properties: {
    publisher: publisher
    type: type
    typeHandlerVersion: typeHandlerVersion
    autoUpgradeMinorVersion: autoUpgradeMinorVersion
    enableAutomaticUpgrade: enableAutomaticUpgrade
    forceUpdateTag: forceUpdateTag
    settings: settings
    protectedSettings: protectedSettings
    suppressFailures: supressFailures
    protectedSettingsFromKeyVault: protectedSettingsFromKeyVault
    provisionAfterExtensions: provisionAfterExtensions
  }
}

@description('The name of the extension.')
output name string = extension.name

@description('The ResourceId of the extension.')
output resourceId string = extension.id

@description('The name of the Resource Group the extension was created in.')
output resourceGroupName string = resourceGroup().name
