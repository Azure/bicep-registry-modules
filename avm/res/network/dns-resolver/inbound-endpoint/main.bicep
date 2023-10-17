@description('Required. Name of the Private DNS Resolver.')
@minLength(1)
param dnsResolverName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. The subnet ID of the inbound endpoint.')
param subnetId string

@description('Optional. The private IP address of the inbound endpoint.')
param privateIpAddress string?

@description('Optional. The private IP allocation method of the inbound endpoint.')
param privateIpAllocationMethod string?

@description('Required. The name of the inbound endpoint.')
param name string

resource dnsResolver 'Microsoft.Network/dnsResolvers@2022-07-01' existing = {
  name: dnsResolverName
}

resource dnsResolver_inboundEndpoint 'Microsoft.Network/dnsResolvers/inboundEndpoints@2022-07-01' = {
  parent: dnsResolver
  name: name
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        subnet: {
          id: subnetId
        }
        privateIpAddress: privateIpAddress
        privateIpAllocationMethod: !empty(privateIpAllocationMethod) ? privateIpAllocationMethod : !empty(privateIpAddress) ? 'Static' : 'Dyanamic'
      }
    ]
  }
}

@description('The name of the resource.')
output name string = dnsResolver_inboundEndpoint.name

@description('The ID of the resource.')
output resourceId string = dnsResolver_inboundEndpoint.id

@description('The resource group of the resource.')
output resourceGroupName string = resourceGroup().name
