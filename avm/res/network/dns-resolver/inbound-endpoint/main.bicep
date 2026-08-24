metadata name = 'DNS Resolver Inbound Endpoint'
metadata description = 'This module deploys a DNS Resolver Inbound Endpoint.'

@description('Required. Name of the DNS Private Resolver.')
@minLength(1)
param dnsResolverName string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Network/dnsResolvers/inboundEndpoints@2025-05-01'>.tags?

@description('Required. The subnet ID of the inbound endpoint.')
param subnetResourceId string

@description('Optional. The private IP address of the inbound endpoint.')
param privateIpAddress string?

@description('Optional. The private IP allocation method of the inbound endpoint.')
param privateIpAllocationMethod string = 'Dynamic'

@description('Required. The name of the inbound endpoint.')
param name string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-dnsresolver-inboundendpoint.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource dnsResolver 'Microsoft.Network/dnsResolvers@2025-05-01' existing = {
  name: dnsResolverName
}

resource inboundEndpoint 'Microsoft.Network/dnsResolvers/inboundEndpoints@2025-05-01' = {
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
