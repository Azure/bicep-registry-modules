metadata name = 'Application Gateway for Containers Frontend'
metadata description = 'This module deploys an Application Gateway for Containers Frontend'

@description('Required. Name of the frontend to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Conditional. The name of the parent Application Gateway for Containers instance. Required if the template is used in a standalone deployment.')
param trafficControllerName string

// ============== //
// Resources      //
// ============== //

resource trafficController 'Microsoft.ServiceNetworking/trafficControllers@2023-11-01' existing = {
  name: trafficControllerName
}

resource frontend 'Microsoft.ServiceNetworking/trafficControllers/frontends@2023-11-01' = {
  name: name
  parent: trafficController
  location: location
  properties: {}
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the frontend.')
output resourceId string = frontend.id

@description('The name of the frontend.')
output name string = frontend.name

@description('The name of the resource group the resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The FQDN of the frontend.')
output fqdn string = frontend.properties.fqdn
