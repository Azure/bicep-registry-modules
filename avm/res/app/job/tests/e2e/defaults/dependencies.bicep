@description('Required. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Environment to create.')
param managedEnvironmentName string

resource managedEnvironment 'Microsoft.App/managedEnvironments@2024-03-01' = {
  name: managedEnvironmentName
  location: location
  properties: {
    workloadProfiles: [
      {
        workloadProfileType: 'D4'
        name: 'WorkloadProfile'
        minimumCount: 1
        maximumCount: 3
      }
    ]
  }
}

@description('The resource ID of the created Managed Environment.')
output managedEnvironmentResourceId string = managedEnvironment.id
