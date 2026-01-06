@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the user-assigned managed identity to create.')
param managedIdentityName string

resource userAssignedManagedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2025-01-31-preview' = {
  name: managedIdentityName
  location: location
}

@description('The principal (object) Id of the created managed identity.')
output managedIdentityPrincipalId string = userAssignedManagedIdentity.properties.principalId
