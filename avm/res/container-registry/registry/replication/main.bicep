metadata name = 'Azure Container Registry (ACR) Replications'
metadata description = 'This module deploys an Azure Container Registry (ACR) Replication.'

@description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Required. The name of the replication.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Specifies whether the replication regional endpoint is enabled. Requests will not be routed to a replication whose regional endpoint is disabled, however its data will continue to be synced with other replications.')
param regionEndpointEnabled bool = true

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Whether or not zone redundancy is enabled for this container registry.')
param zoneRedundancy string = 'Disabled'

resource registry 'Microsoft.ContainerRegistry/registries@2023-06-01-preview' existing = {
  name: registryName
}

resource replication 'Microsoft.ContainerRegistry/registries/replications@2023-06-01-preview' = {
  name: name
  parent: registry
  location: location
  tags: tags
  properties: {
    regionEndpointEnabled: regionEndpointEnabled
    zoneRedundancy: zoneRedundancy
  }
}

@description('The name of the replication.')
output name string = replication.name

@description('The resource ID of the replication.')
output resourceId string = replication.id

@description('The name of the resource group the replication was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = replication.location
