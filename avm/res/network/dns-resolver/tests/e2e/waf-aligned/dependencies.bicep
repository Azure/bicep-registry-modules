@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

var addressPrefix = '10.0.0.0/16'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: map(
      range(0, 2),
      i => {
        name: 'subnet-${i}'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 25, i)
          delegations: [
            {
              name: 'dnsdel'
              properties: {
                serviceName: 'Microsoft.Network/dnsResolvers'
              }
            }
          ]
        }
      }
    )
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Virtual Network.')
output virtualNetworkResourceId string = virtualNetwork.id

@description('The resource ID of the created inbound endpoint Virtual Network Subnet.')
output subnetResourceId_dnsIn string = virtualNetwork.properties.subnets[0].id

@description('The resource ID of the created outbound endpoint Virtual Network Subnet.')
output subnetResourceId_dnsOut string = virtualNetwork.properties.subnets[1].id
