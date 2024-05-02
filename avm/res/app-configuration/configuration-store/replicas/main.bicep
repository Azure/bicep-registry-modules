metadata name = 'App Configuration Replicas'
metadata description = 'This module deploys an App Configuration Replica.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the replica.')
param name string

@description('Optional. The name of the parent app configuration store.')
param appConfigurationName string

@description('Optional. Location of the replica.')
param replicaLocation string

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2023-03-01' existing = {
  name: appConfigurationName
}

resource replica 'Microsoft.AppConfiguration/configurationStores/replicas@2023-03-01' = {
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
