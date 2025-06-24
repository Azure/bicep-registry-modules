@description('Optional. The location to deploy to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to create.')
param managedIdentityName string

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' = {
  name: managedIdentityName
  location: location
}

@description('The client ID of the created Managed Identity.')
output managedIdentityClientId string = managedIdentity.properties.clientId

@description('The name of the created Managed Identity.')
output managedIdentityName string = managedIdentity.name
