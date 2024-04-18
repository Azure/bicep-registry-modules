metadata name = 'App Configuration Replica Configurations'
metadata description = 'This module deploys an App Configuration Replica.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the replica.')
param name string

@description('Conditional. The name of the parent app configuration store.')
param appConfigurationName string

@description('Conditional. Location of the replica')
param replicaLocation string

resource appConfiguration 'Microsoft.AppConfiguration/configurationStores@2023-03-01' existing = {
  name: appConfigurationName
}

resource replicas 'Microsoft.AppConfiguration/configurationStores/replicas@2023-03-01' = {
  name: name
  parent: appConfiguration
  location: replicaLocation
}

@description('The resource group the app configuration was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the replica that was deployed')
output replicaName string = replicas.name
