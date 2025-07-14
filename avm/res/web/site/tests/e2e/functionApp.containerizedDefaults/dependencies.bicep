@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Environment to create.')
param managedEnvironmentName string

// ============== //
// Resources      //
// ============== //

resource managedEnvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: managedEnvironmentName
  location: location
  properties: {
    // Basic managed environment configuration for testing
  }
}

// ============== //
// Outputs        //
// ============== //

@description('The resource ID of the created Managed Environment.')
output managedEnvironmentResourceId string = managedEnvironment.id

@description('The name of the created Managed Environment.')
output managedEnvironmentName string = managedEnvironment.name