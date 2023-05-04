/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
targetScope = 'resourceGroup'

param name string = deployment().name
param location string = resourceGroup().location
param tags object = {
  LOB: 'ENT'
  costcenter: '000'
  environment: 'dev'
  location: resourceGroup().location
  team: 'coredev'
}

module basicTest '../main.bicep' = {
  name: 'test-${name}'
  params: {
    name: take(replace('test-${name}', '.', '-'), 5)
    location: location
    tags: tags
    roles: [
      {
        name: 'Contributor'
        roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
        principalType: 'ServicePrincipal'
      }
      {
        name: 'Azure Kubernetes Service RBAC Admin'
        roleDefinitionId: '3498e952-d568-435e-9b2c-8d77e338d7f7'
        principalType: 'ServicePrincipal'
      }
    ]
  }
}
