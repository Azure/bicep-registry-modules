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
  team: 'core-dev'
}

module test1 '../main.bicep' = {
  name: 'test1-${name}-${uniqueString(resourceGroup().id)}'
  params: {
    location: location
    tags: tags
  }
}

module test2 '../main.bicep' = {
  name: 'test2-${name}-${uniqueString(resourceGroup().id)}'
  params: {
    name: 'test2-${uniqueString(resourceGroup().id)}'
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
    federatedCredentials: [
      {
        name: 'federatedCredential-github-test2--${uniqueString(resourceGroup().id)}'
        issuer: 'https://token.actions.githubusercontent.com'
        subject: 'repo:Azure/https://github.com/Azure/bicep-registry-modules:ref:refs/heads/main'
        audiences: [
          'api://AzureADTokenExchange'
        ]
      }
      {
        name: 'federatedCredential-aks-test2--${uniqueString(resourceGroup().id)}'
        issuer: 'https://cluster.issuer.url/xxxxx/xxxxx/'
        subject: 'system:serviceaccount:mynamespace-name:myserviceaccount-name'
        audiences: [
          'api://AzureADTokenExchange'
        ]
      }
    ]
  }
}
