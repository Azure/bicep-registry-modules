metadata name = 'DNS Resolver Inbound Endpoint'
metadata description = 'This module deploys a DNS Resolver Inbound Endpoint.'

@description('Required. Name of the DNS Private Resolver.')
@minLength(1)
param dnsResolverName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Required. The subnet ID of the inbound endpoint.')
param subnetResourceId string

@description('Optional. The private IP address of the inbound endpoint.')
param privateIpAddress string?

@description('Optional. The private IP allocation method of the inbound endpoint.')
param privateIpAllocationMethod string = 'Dynamic'

@description('Required. The name of the inbound endpoint.')
param name string

resource dnsResolver 'Microsoft.Network/dnsResolvers@2022-07-01' existing = {
  name: dnsResolverName
}

resource inboundEndpoint 'Microsoft.Network/dnsResolvers/inboundEndpoints@2022-07-01' = {
  parent: dnsResolver
  name: name
  location: location
  tags: tags
  properties: {
    ipConfigurations: [
      {
        subnet: {
          id: subnetResourceId
        }
        privateIpAddress: privateIpAddress
        privateIpAllocationMethod: privateIpAllocationMethod
      }
    ]
  }
}

@description('The name of the resource.')
output name string = inboundEndpoint.name

@description('The resource ID of the resource.')
output resourceId string = inboundEndpoint.id

@description('The resource group of the resource.')
output resourceGroupName string = resourceGroup().name
