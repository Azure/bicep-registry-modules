param location                 string
param vnetAddressPrefix        string
param subnetAddressPrefix      string
param vnetName                 string
param subnetName               string
param networkSecurityGroupName string

//By Default the nsg will allow the vnet access and deny all other access
resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2021-08-01' = {
  name: networkSecurityGroupName
  location: location
}

module minvnet 'br/public:network/virtual-network:1.0.3' = {
  name: '${uniqueString(deployment().name, 'WestEurope')}-minvnet'
  params: {
    location: location
    name: vnetName
    subnets: [
      {
        name: subnetName
        addressPrefix: subnetAddressPrefix
        networkSecurityGroup: {
          id: networkSecurityGroup.id
        }
      }
    ]
    addressPrefixes: [vnetAddressPrefix]    
  }
}

output vnetId     string = minvnet.outputs.resourceId
output vnet       string = minvnet.outputs.name
output nsgID      string = networkSecurityGroup.id
output subnetName string = subnetName
