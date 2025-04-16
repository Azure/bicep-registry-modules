@description('Required. Name of the existing hub virtual network.')
param hubVirtualNetworkName string = 'vnet-uksouth-hub-blzv'

resource hubNetwork 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: hubVirtualNetworkName
}

output hubNetworkResourceId string = hubNetwork.id
