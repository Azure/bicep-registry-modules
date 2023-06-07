param location string
param name string

resource virutalNetwork 'Microsoft.Network/virtualNetworks@2022-11-01' = {
  name: 'network-${uniqueString(name)}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/21'
      ]
    }
    subnets: [
      {
        name: 'subnet1'
        properties: {
          addressPrefix: '172.16.0.0/24'
        }
      }
      {
        name: 'subnet2'
        properties: {
          addressPrefix: '172.16.1.0/24'
        }
      }
    ]
  }
}

output vnetId string = virutalNetwork.id
