@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Host Pool to create.')
param hostPoolName string

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

#disable-next-line use-recent-api-versions
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-01-31-preview' = {
  name: managedIdentityName
  location: location
}

#disable-next-line use-recent-api-versions
resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2025-03-01-preview' = {
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
