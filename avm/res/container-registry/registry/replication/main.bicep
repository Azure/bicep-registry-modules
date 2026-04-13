metadata name = 'Azure Container Registry (ACR) Replications'
metadata description = 'This module deploys an Azure Container Registry (ACR) Replication.'

@description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Required. The name of the replication.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.ContainerRegistry/registries/replications@2025-11-01'>.tags?

@description('Optional. Specifies whether the replication regional endpoint is enabled. Requests will not be routed to a replication whose regional endpoint is disabled, however its data will continue to be synced with other replications.')
param regionEndpointEnabled bool = true

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Whether or not zone redundancy is enabled for this container registry.')
param zoneRedundancy string = 'Disabled'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  #disable-next-line BCP332
  name: '46d3xbcp.res.containerregistry-registry-repl.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource registry 'Microsoft.ContainerRegistry/registries@2025-11-01' existing = {
  name: registryName
}

resource replication 'Microsoft.ContainerRegistry/registries/replications@2025-11-01' = {
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
