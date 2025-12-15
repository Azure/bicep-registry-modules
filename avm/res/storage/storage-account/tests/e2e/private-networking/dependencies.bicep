@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Virtual Network to create.')
param virtualNetworkName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

var addressPrefix = '10.0.0.0/8'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2025-01-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
  }
}

resource subnetDefault 'Microsoft.Network/virtualNetworks/subnets@2025-01-01' = {
  name: 'defaultSubnet'
  parent: virtualNetwork
  properties: {
    addressPrefixes: ['10.0.0.0/23']
    serviceEndpoints: [
      {
        service: 'Microsoft.Storage'
      }
    ]
  }
}

resource subnetPeps 'Microsoft.Network/virtualNetworks/subnets@2025-01-01' = {
  name: 'peps'
  parent: virtualNetwork
  dependsOn: [subnetDefault]
  properties: {
    addressPrefixes: ['10.0.2.0/23']
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Disabled'
  }
}

resource subnetDeployScripts 'Microsoft.Network/virtualNetworks/subnets@2025-01-01' = {
  name: 'deploymentScripts'
  parent: virtualNetwork
  dependsOn: [subnetPeps]
  properties: {
    addressPrefixes: ['10.0.4.0/24']
    serviceEndpoints: [
      {
        service: 'Microsoft.Storage'
      }
    ]
    delegations: [
      {
        name: 'delegationToContainerInstances'
        properties: {
          serviceName: 'Microsoft.ContainerInstance/containerGroups'
        }
      }
    ]
  }
}

resource privateDNSZone 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: 'privatelink.blob.${environment().suffixes.storage}'
  location: 'global'
  dependsOn: [subnetDefault, subnetPeps, subnetDeployScripts]

  resource virtualNetworkLinks 'virtualNetworkLinks@2024-06-01' = {
    name: '${virtualNetwork.name}-vnetlink'
    location: 'global'
    properties: {
      virtualNetwork: {
        id: virtualNetwork.id
      }
      registrationEnabled: false
    }
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

@description('The resource ID of the created Virtual Network Default Subnet.')
output defaultSubnetResourceId string = subnetDefault.id

@description('The resource ID of the created Virtual Network Subnet for Private Endpoints.')
output privateEndpointSubnetResourceId string = subnetPeps.id

@description('The resource ID of the created Virtual Network Subnet for Deployment Scripts.')
output deploymentScriptsSubnetResourceId string = subnetDeployScripts.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Private DNS Zone.')
output privateDNSZoneResourceId string = privateDNSZone.id
