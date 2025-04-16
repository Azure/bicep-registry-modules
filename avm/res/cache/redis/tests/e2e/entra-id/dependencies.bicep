@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to be created.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-07-31-preview' = {
  name: managedIdentityName
  location: location
}

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
@description('The client ID of the created Managed Identity.')
output managedIdentityClientId string = managedIdentity.properties.clientId
@description('The principal ID of the created Managed Identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId
@description('The name of the created Managed Identity.')
output managedIdentityName string = managedIdentity.name
