@sys.description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@sys.description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@sys.description('Required. The name of the Managed Identity to create.')
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
    subnets: [
      {
        name: 'defaultSubnet'
        properties: {
          addressPrefix: cidrSubnet(addressPrefix, 20, 0)
        }
      }
    ]
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

@sys.description('The resource ID of the created Virtual Network Default Subnet.')
output subnetResourceId string = virtualNetwork.properties.subnets[0].id

@sys.description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@sys.description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
