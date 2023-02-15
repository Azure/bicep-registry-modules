param nameseed string = 'dbox'
param location string = resourceGroup().location
param devcenterName string

param subnetName string = 'sn-devpools'

@description('The name of a new resource group that will be created to store some Networking resources (like NICs) in')
param networkingResourceGroupName string = '${resourceGroup().name}-networking'

resource dc 'Microsoft.DevCenter/devcenters@2022-11-11-preview' existing = {
  name: devcenterName
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-07-01' = {
  name: 'vnet-${nameseed}'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource networkconnection 'Microsoft.DevCenter/networkConnections@2022-11-11-preview' = {
  name: 'con-${nameseed}'
  location: location
  properties: {
    domainJoinType: 'AzureADJoin'
    subnetId: '${virtualNetwork.id}/subnets/${subnetName}'
    networkingResourceGroupName: networkingResourceGroupName
  }
}

resource attachedNetwork 'Microsoft.DevCenter/devcenters/attachednetworks@2022-11-11-preview' = {
  name: 'dcon-${nameseed}-${location}'
  parent: dc
  properties: {
    networkConnectionId: networkconnection.id
  }
}

output networkConnectionName string = networkconnection.name
output networkConnectionId string = networkconnection.id
output attachedNetworkName string = attachedNetwork.name
