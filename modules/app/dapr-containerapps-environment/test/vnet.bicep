param vnetName string = 'vnet-${uniqueString(resourceGroup().id)}'
param vnetAddressPrefix string = '10.0.0.0/16'
param subnetName string = 'default'
param subnetAddressPrefix string = '10.0.0.0/23'

@description('Specifies the location for all resources.')
param location string 

resource vnet 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: vnetName
  location: location
  properties: {
   addressSpace: {
    addressPrefixes: [
      vnetAddressPrefix
    ]
   } 
   subnets: [
    {
      name: subnetName
      properties: {
        addressPrefix: subnetAddressPrefix
      }
    }
   ]
  }
}

output subnetId string = '${vnet.id}/subnets/${subnetName}'
