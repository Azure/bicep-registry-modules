@description('Required. Name of the existing hub virtual network.')
param hubVirtualNetworkName string = 'vnet-uksouth-hub-blzv'

@description('Required. Name of the existing virtual hub.')
param virtualHubName string = 'vhub-uksouth-blzv'

resource hubNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: hubVirtualNetworkName
}

resource virtualHub 'Microsoft.Network/virtualHubs@2023-09-01' existing = {
  name: virtualHubName
}

output hubNetworkResourceId string = hubNetwork.id
output virtualHubResourceId string = virtualHub.id
