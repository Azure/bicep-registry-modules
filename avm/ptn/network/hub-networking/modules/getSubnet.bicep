metadata name = 'Existing Virtual Network Subnets'
metadata description = 'This module retrieves an existing Virtual Network Subnet.'

@description('Optional. The name of the subnet.')
param subnetName string = ''

@description('Optional. The name of the virtual network.')
param virtualNetworkName string = ''

resource vnet 'Microsoft.Network/virtualNetworks@2024-01-01' existing = {
  name: virtualNetworkName

  resource subnet 'subnets@2024-01-01' existing = {
    name: subnetName
  }
}

@description('Subnet ID')
output subnetId string = vnet::subnet.id

@description('Subnet address prefix')
output addressPrefix string = vnet::subnet.properties.addressPrefix
