metadata name = 'Application Gateway for Containers Association'
metadata description = 'This module deploys an Application Gateway for Containers Association'

@description('Required. Name of the association to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Conditional. The name of the parent Application Gateway for Containers instance. Required if the template is used in a standalone deployment.')
param trafficControllerName string

@description('Required. The resource ID of the subnet to associate with the traffic controller.')
param subnetResourceId string

// ============== //
// Resources      //
// ============== //

resource trafficController 'Microsoft.ServiceNetworking/trafficControllers@2023-11-01' existing = {
  name: trafficControllerName
}

resource association 'Microsoft.ServiceNetworking/trafficControllers/associations@2023-11-01' = {
  name: name
  parent: trafficController
  location: location
  properties: {
    associationType: 'subnets'
    subnet: {
      id: subnetResourceId
    }
  }
}

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the association.')
output resourceId string = association.id

@description('The name of the association.')
output name string = association.name

@description('The name of the resource group the resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the associated subnet.')
output subnetResourceId string = association.properties.subnet.id
