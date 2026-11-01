metadata name = 'AI Gateway Alias'
metadata description = 'Creates a client-facing alias with priority and weighted routing.'

import { policyType } from '../model-provider/model/main.bicep'

@description('Required. Parent gateway name.')
param aiGatewayName string
@description('Required. Parent workspace name.')
param workspaceName string
@description('Required. Alias resource name.')
param name string
@description('Required. Alias routes and policies.')
param properties aliasPropertiesType

#disable-next-line BCP081
resource workspace 'Microsoft.ApiManagement/aigateways/workspaces@2025-09-01-preview' existing = {
  name: '${aiGatewayName}/${workspaceName}'
}
#disable-next-line BCP081
resource alias 'Microsoft.ApiManagement/aigateways/workspaces/aliases@2025-09-01-preview' = {
  name: name
  parent: workspace
  properties: {
    displayName: properties.displayName
    description: properties.?description
    routes: [
      for route in properties.routes: {
        providerName: route.providerName
        modelName: route.modelName
        priority: route.?priority ?? 0
        weight: route.?weight ?? 1
      }
    ]
    policies: properties.?policies
  }
}

@description('The alias resource ID.')
output resourceId string = alias.id
@description('The alias name.')
output name string = alias.name
@description('The resource group name.')
output resourceGroupName string = resourceGroup().name

@export()
@sealed()
@description('Alias resource configuration.')
type aliasType = {
  name: string
  properties: aliasPropertiesType
}
@export()
@sealed()
@description('Alias wire properties for the preview routes contract.')
type aliasPropertiesType = {
  displayName: string
  description: string?
  @minLength(1)
  @maxLength(30)
  routes: routeType[]
  policies: policyType[]?
}
@export()
@sealed()
@description('Route to a catalog model. Lower priority wins; weight is relative within a priority group.')
type routeType = {
  providerName: string
  modelName: string
  @minValue(0)
  @maxValue(100)
  priority: int?
  @minValue(1)
  @maxValue(100)
  weight: int?
}
