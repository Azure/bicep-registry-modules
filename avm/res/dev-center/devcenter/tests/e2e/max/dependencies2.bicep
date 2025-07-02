@description('Required. The name of the Compute Gallery to create.')
param galleryName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

var addressPrefix = '10.0.0.0/16'

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource gallery 'Microsoft.Compute/galleries@2024-03-03' = {
  name: galleryName
  location: location
  properties: {}
}

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2024-05-01' = {
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
        name: 'image'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 1)
          privateLinkServiceNetworkPolicies: 'Disabled'
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
        }
      }
      {
        name: 'deploymentScript'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 24, 2)
          privateLinkServiceNetworkPolicies: 'Disabled'
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
            }
          ]
          delegations: [
            {
              name: 'aciDelegation'
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

@description('The name of the created Managed Identity.')
output managedIdentityName string = managedIdentity.name

@description('The name of the created Virtual Network.')
output virtualNetworkName string = virtualNetwork.name

@description('The address space of the created Virtual Network.')
output virtualNetworkAddressSpace string = virtualNetwork.properties.addressSpace.addressPrefixes[0]

@description('The subnets of the created Virtual Network.')
output virtualNetworkSubnets array = virtualNetwork.properties.subnets

@description('The resource ID of the created Azure Compute Gallery.')
output galleryResourceId string = gallery.id
