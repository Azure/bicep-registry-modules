@description('Required. The name of the managed identity to create.')
param managedIdentityName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: managedIdentityName
  location: location
}

@description('The principal ID of the created managed identity.')
output managedIdentityPrincipalId string = managedIdentity.properties.principalId

@description('The resource ID of the created Managed Identity.')
output managedIdentityResourceId string = managedIdentity.id
