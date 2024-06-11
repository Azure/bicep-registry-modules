@description('Optional. The name of the subnet.')
param subnetName string = ''

@description('Optional. The name of the virtual network.')
param virtualNetworkName string = ''

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = {
  name: '${virtualNetworkName}/${subnetName}'
}

@description('Subnet ID')
output subnetId string = subnet.id

@description('Subnet address prefix')
output addressPrefix string = subnet.properties.addressPrefix
