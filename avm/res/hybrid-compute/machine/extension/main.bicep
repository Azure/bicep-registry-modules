metadata name = 'Arc Machine Extensions'
metadata description = 'This module deploys a Arc Machine Extension. This module should be used as a standalone deployment after the Arc agent has connected to the Arc Machine resource.'

@description('Required. The name of the parent Arc Machine that extension is provisioned for.')
param arcMachineName string

@description('Required. The name of the Arc Machine extension.')
param name string

@description('Optional. The location the extension is deployed to.')
param location string = resourceGroup().location

@description('Required. The name of the extension handler publisher.')
param publisher string

@description('Required. Specifies the type of the extension; an example is "CustomScriptExtension".')
param type string

@description('Required. Specifies the version of the script handler.')
param typeHandlerVersion string

@description('Required. Indicates whether the extension should use a newer minor version if one is available at deployment time. Once deployed, however, the extension will not upgrade minor versions unless redeployed, even with this property set to true.')
param autoUpgradeMinorVersion bool

@description('Optional. How the extension handler should be forced to update even if the extension configuration has not changed.')
param forceUpdateTag string = ''

@description('Optional. Any object that contains the extension specific settings.')
param settings object = {}

@description('Optional. Any object that contains the extension specific protected settings.')
@secure()
param protectedSettings object = {}

@description('Required. Indicates whether the extension should be automatically upgraded by the platform if there is a newer version of the extension available.')
param enableAutomaticUpgrade bool

@description('Optional. Tags of the resource.')
param tags object?

resource machine 'Microsoft.HybridCompute/machines@2024-07-10' existing = {
  name: arcMachineName
}

resource extension 'Microsoft.HybridCompute/machines/extensions@2024-07-10' = {
  name: name
  parent: machine
  location: location
  tags: tags
  properties: {
    publisher: publisher
    type: type
    typeHandlerVersion: typeHandlerVersion
    autoUpgradeMinorVersion: autoUpgradeMinorVersion
    enableAutomaticUpgrade: enableAutomaticUpgrade
    forceUpdateTag: !empty(forceUpdateTag) ? forceUpdateTag : null
    settings: !empty(settings) ? settings : null
    protectedSettings: !empty(protectedSettings) ? protectedSettings : null
  }
}

@description('The name of the extension.')
output name string = extension.name

@description('The resource ID of the extension.')
output resourceId string = extension.id

@description('The name of the Resource Group the extension was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = extension.location
