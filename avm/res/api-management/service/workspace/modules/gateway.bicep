@description('Required. The name of the API Management Workspace Gateway.')
param name string

@description('Optional. The location for the API Management Gateway. Defaults to the resource group location.')
param location string = resourceGroup().location

@description('Optional. The capacity of the API Management Workspace Gateway. Default is 1.')
param capacity int = 1

@description('Optional. The virtual network type for the API Management Workspace Gateway.')
@allowed([
  'None'
  'External'
  'Internal'
])
param virtualNetworkType string = 'None'

@description('Required. The resource ID of the API Management workspace to connect to.')
param workspaceResourceId string

resource gateway 'Microsoft.ApiManagement/gateways@2024-05-01' = {
  name: name
  location: location
  sku: {
    name: 'WorkspaceGatewayPremium'
    capacity: capacity
  }
  properties: {
    backend: {}
    virtualNetworkType: virtualNetworkType
  }
}

resource configConnection 'Microsoft.ApiManagement/gateways/configConnections@2024-06-01-preview' = {
  parent: gateway
  name: '${name}-${split(workspaceResourceId, '/')[8]}-${last(split(workspaceResourceId, '/'))}'
  properties: {
    sourceId: workspaceResourceId
  }
}
