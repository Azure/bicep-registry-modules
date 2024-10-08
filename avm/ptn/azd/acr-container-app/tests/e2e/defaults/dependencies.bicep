@description('Required. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Environment to create.')
param managedEnvironmentName string

resource managedEnvironment 'Microsoft.App/managedEnvironments@2023-05-01' = {
  name: managedEnvironmentName
  location: location
  properties: {}
}

@description('The name of the Container Apps environment.')
output containerAppsEnvironmentName string = managedEnvironment.name
