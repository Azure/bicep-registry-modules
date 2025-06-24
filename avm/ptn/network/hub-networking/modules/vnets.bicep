metadata name = 'Virtual Networks'
metadata description = 'This module deploys a Virtual Network.'

@description('Required. The name of the parent virtual network. Required if the template is used in a standalone deployment.')
param name string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: name
}

@description('The resource group the virtual network peering was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the virtual network peering.')
output name string = virtualNetwork.name

@description('The resource ID of the virtual network peering.')
output resourceId string = virtualNetwork.id

@description('The address space of the virtual network.')
output addressPrefix string = virtualNetwork.properties.addressSpace.addressPrefixes[0]
