@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

@description('Required. The name of the Route Filter to create.')
param routeFilterName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: managedIdentityName
  location: location
}

resource routeFilter 'Microsoft.Network/routeFilters@2024-10-01' = {
  name: routeFilterName
  location: location
}

@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Route Filter.')
output routeFilterId object = { id: routeFilter.id }
