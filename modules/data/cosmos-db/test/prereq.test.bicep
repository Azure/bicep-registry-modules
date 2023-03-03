param location string
param name string

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2021-02-01' = {
  name: '${name}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'default'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

output resourceId string = virtualNetwork.id
