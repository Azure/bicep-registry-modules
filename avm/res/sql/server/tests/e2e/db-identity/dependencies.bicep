@description('Required. The name of the admin managed identity to create for the server.')
param serverAdminIdentityName string

@description('Required. The name of the managed identity to create for the database.')
param databaseIdentityName string

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

resource serverAdminIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: serverAdminIdentityName
  location: location
}

resource databaseIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: databaseIdentityName
  location: location
}

@description('The principal ID of the created server admin managed identity.')
output serverAdminIdentityPrincipalId string = serverAdminIdentity.properties.principalId

@description('The resource ID of the created database managed identity.')
output databaseIdentityResourceId string = databaseIdentity.id
