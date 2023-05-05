param location string
param name string
param tags object

resource publicIp 'Microsoft.Network/publicIPAddresses@2022-09-01' = {
  name: 'nat-public-ip-${uniqueString(name)}'
  location: location
  tags: tags
  sku: {
    tier: 'Regional'
    name: 'Standard' //natGateway needed Standard sku

  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource publicIpPrefix 'Microsoft.Network/publicIPPrefixes@2022-09-01' = {
  name: 'nat-public-ip-prefix-${uniqueString(name)}'
  location: location
  tags: tags
  sku: {
    name: 'Standard'
  }
  properties: {
    prefixLength: 30
    publicIPAddressVersion: 'IPv4'
  }
}

output publicIpId string = publicIp.id
output publicIpPrefixId string = publicIpPrefix.id
