@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the integration service environment to create.')
param integrationServiceEnvironmentName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource integrationServiceEnvironment 'Microsoft.Logic/integrationServiceEnvironments@2019-05-01' = {
  name: integrationServiceEnvironmentName
  location: location
  sku: {
    capacity: 2
    name: 'Devloper'
  }
  properties: {
    state: 'Enabled'
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created integration service environment.')
output integrationServiceEnvironmentResourceId string = integrationServiceEnvironment.id
