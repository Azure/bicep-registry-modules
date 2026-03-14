metadata name = 'DNS Resolver Outbound Endpoint'
metadata description = 'This module deploys a DNS Resolver Outbound Endpoint.'

@description('Required. Name of the DNS Private Resolver.')
@minLength(1)
param dnsResolverName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Network/dnsResolvers/outboundEndpoints@2025-05-01'>.tags?

@description('Required. The subnet ID of the inbound endpoint.')
param subnetResourceId string

@description('Required. The name of the inbound endpoint.')
param name string

resource dnsResolver 'Microsoft.Network/dnsResolvers@2025-05-01' existing = {
  name: dnsResolverName
}

resource outboundEndpoint 'Microsoft.Network/dnsResolvers/outboundEndpoints@2025-05-01' = {
  name: name
  parent: dnsResolver
  location: location
  tags: tags
  properties: {
    subnet: {
      id: subnetResourceId
    }
  }
}

@description('The name of the resource.')
output name string = outboundEndpoint.name

@description('The resource ID of the resource.')
output resourceId string = outboundEndpoint.id

@description('The resource group of the resource.')
output resourceGroupName string = resourceGroup().name
