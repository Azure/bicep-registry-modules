metadata name = 'App Configuration Replicas'
metadata description = 'This module deploys an App Configuration Replica.'

@description('Optional. Name of the replica.')
param name string = '${replicaLocation}replica'

@description('Conditional. The name of the parent app configuration store. Required if the template is used in a standalone deployment.')
param appConfigurationName string

@description('Required. Location of the replica.')
param replicaLocation string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.appconfig-configstore-replica.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2025-02-01-preview' existing = {
  name: appConfigurationName
}

resource replica 'Microsoft.AppConfiguration/configurationStores/replicas@2025-02-01-preview' = {
  name: name
  parent: appConfiguration
  location: replicaLocation
}

@description('The resource group the app configuration was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the replica that was deployed.')
output name string = replica.name

@description('The resource ID of the replica that was deployed.')
output resourceId string = replica.id
