param nameSuffix string = 'blzv'

param location string = 'uksouth'

param vnetAddressSpace string = '192.168.255.0/24'

param vwanHubAddressSpace string = '192.168.252.0/23'

param tags object = {
  UsedFor: 'Bicep LZ Vending Automated Testing (PRs)'
  ResponsibleContactAlias: 'jatracey'
}

resource hubVnet 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: 'vnet-${location}-hub-${nameSuffix}'
  location: location
  tags: tags
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressSpace
      ]
    }
  }
}

resource vwan 'Microsoft.Network/virtualWans@2022-07-01' = {
  name: 'vwan-${nameSuffix}'
  location: location
  tags: tags
  properties: {
    allowBranchToBranchTraffic: true
    allowVnetToVnetTraffic: true
    type: 'Standard'
  }
}

resource vwanHub 'Microsoft.Network/virtualHubs@2022-07-01' = {
  name: 'vhub-${location}-${nameSuffix}'
  location: location
  tags: tags
  properties: {
    virtualWan: {
      id: vwan.id
    }
    addressPrefix: vwanHubAddressSpace
  }
}

output hubVnetResId string = hubVnet.id
output vwanHubResId string = vwanHub.id
