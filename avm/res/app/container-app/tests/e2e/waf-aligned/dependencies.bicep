@description('Required. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Environment for Container Apps to create.')
param managedEnvironmentName string

@description('Required. The name of the managed identity to create.')
param managedIdentityName string

resource managedEnvironment 'Microsoft.App/managedEnvironments@2022-10-01' = {
  name: managedEnvironmentName
  location: location
  sku: {
    name: 'Consumption'
  }
  properties: {}
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2022-01-31-preview' = {
  name: managedIdentityName
  location: location
}

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created Managed Environment.')
output managedEnvironmentResourceId string = managedEnvironment.id
