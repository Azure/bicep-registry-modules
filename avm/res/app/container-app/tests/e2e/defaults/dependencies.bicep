@description('Required. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Environment to create.')
param managedEnvironmentName string

resource managedEnvironment 'Microsoft.App/managedEnvironments@2022-10-01' = {
  name: managedEnvironmentName
  location: location
  sku: {
    name: 'Consumption'
  }
  properties: {}
}

@description('The resource ID of the created Managed Environment.')
output managedEnvironmentResourceId string = managedEnvironment.id
