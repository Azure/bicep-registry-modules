@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Optional. The naming prefix.')
param namePrefix string = 'dev'

var addressPrefix = '10.0.0.0/16'

var virtualNetworkName = 'dep-vnet-${namePrefix}'

var publicIPName = 'dep-pip-${namePrefix}'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: 'acr-subnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 2)
        }
      }
      {
        name: 'aci-subnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 3)
          delegations: [
            {
              name: 'Microsoft.ContainerInstance/containerGroups'
              properties: {
                serviceName: 'Microsoft.ContainerInstance/containerGroups'
              }
            }
          ]
        }
      }
    ]
  }
}

resource natGateway 'Microsoft.Network/natGateways@2024-01-01' = {
  name: 'natgw-${namePrefix}'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIpAddresses: [
      {
        id: publicIP.id
      }
    ]
  }
}

resource acrPrivateDNSZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.azurecr.io'
  location: 'global'
}

resource vnetLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  name: '${acrPrivateDNSZone.name}-link-${namePrefix}'
  location: 'global'
  parent: acrPrivateDNSZone
  properties: {
    virtualNetwork: {
      id: virtualNetwork.id
    }
    registrationEnabled: false
  }
}

resource publicIP 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: publicIPName
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

@description('The resource ID of the created virtual network.')
output virtualNetworkResourceId string = virtualNetwork.id

@description('The resource ID of the created public IP.')
output publicIPResourceId string = publicIP.id

@description('The resource ID of the created NAT gateway.')
output natGatewayResourceId string = natGateway.id
