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
    capacity: 0
    name: 'Developer'
  }
  properties: {
    state: 'Enabled'
    networkConfiguration: {
      accessEndpoint: { type: 'Internal' }
      subnets: [
        {
          id: resourceId('Microsoft.Network/virtualNetworks/subnets', integrationServiceEnvironmentName, 'default')
        }
      ]
      virtualNetworkAddressSpace: '10.0.0.0/16'
    }
  }
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id

@description('The resource ID of the created integration service environment.')
output integrationServiceEnvironmentResourceId string = integrationServiceEnvironment.id
