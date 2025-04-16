extension graphV1
extension graphBeta

@description('Optional. The location to deploy resources to.')
param location string = resourceGroup().location

@description('Required. The name of the Managed Identity to be created.')
param managedIdentityName string

@description('Required. Email address used by resource. This value is tenant-specific and must be stored in the CI Key Vault in a secret named \'CI-adminMembersSecret\'.')
@secure()
param adminMembersSecret string = ''

resource entraAdmin 'Microsoft.Graph/users@v1.0' existing = {
  userPrincipalName: adminMembersSecret
}

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
@description('The SID of the EntraAdmin user.')
output entraAdminSid string = entraAdmin.id
