metadata name = 'Container Registries Credential Sets'
metadata description = 'This module deploys an ACR Credential Set.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Required. The name of the credential set.')
param name string

@description('Required. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Required. List of authentication credentials stored for an upstream. Usually consists of a primary and an optional secondary credential.')
param authCredentials authCredentialsType

@description('Required. The credentials are stored for this upstream or login server.')
param loginServer string

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }
var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned, UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

resource registry 'Microsoft.ContainerRegistry/registries@2023-06-01-preview' existing = {
  name: registryName
}

resource credentialSet 'Microsoft.ContainerRegistry/registries/credentialSets@2023-11-01-preview' = {
  name: name
  parent: registry
  identity: identity
  properties: {
    authCredentials: authCredentials
    loginServer: loginServer
  }
}

@description('The Name of the Credential Set.')
output name string = credentialSet.name

@description('The name of the Credential Set.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the Credential Set.')
output resourceId string = credentialSet.id

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.')
  userAssignedResourceIds: string[]?
}

type authCredentialsType = {
  @description('Required. The name of the credential.')
  name: string

  @description('Required. KeyVault Secret URI for accessing the username.')
  usernameSecretIdentifier: string

  @description('Required. KeyVault Secret URI for accessing the password.')
  passwordSecretIdentifier: string
}[]
