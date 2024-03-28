@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Traffic Manager Profile to create.')
param trafficManagerProfileName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource trafficManagerProfile 'Microsoft.Network/trafficmanagerprofiles@2022-04-01-preview' = {
  name: trafficManagerProfileName
  location: 'global'
  properties: {
    trafficRoutingMethod: 'Performance'
    maxReturn: 0
    dnsConfig: {
      relativeName: trafficManagerProfileName
      ttl: 60
    }
    monitorConfig: {
      protocol: 'HTTP'
      port: 80
      path: '/'
    }
  }
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

@description('The resource ID of the created Traffic Manager Profile.')
output trafficManagerProfileResourceId string = trafficManagerProfile.id

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
