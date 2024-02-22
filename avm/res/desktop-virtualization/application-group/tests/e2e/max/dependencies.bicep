@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Host Pool to create.')
param hostPoolName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2022-09-09' = {
  name: hostPoolName
  location: location
  properties: {
    hostPoolType: 'Pooled'
    loadBalancerType: 'BreadthFirst'
    preferredAppGroupType: 'RailApplications'
  }
}

@description('The name of the created Host Pool.')
output hostPoolName string = hostPool.name

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
