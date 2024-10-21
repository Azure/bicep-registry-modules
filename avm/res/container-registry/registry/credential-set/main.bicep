metadata name = 'Container Registries Credential Sets'
metadata description = 'This module deploys an ACR Credential Set.'

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

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false) ? 'SystemAssigned' : null
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

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = credentialSet.?identity.?principalId ?? ''

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?
}

type authCredentialsType = {
  @description('Required. The name of the credential.')
  name: string

  @description('Required. KeyVault Secret URI for accessing the username.')
  usernameSecretIdentifier: string

  @description('Required. KeyVault Secret URI for accessing the password.')
  passwordSecretIdentifier: string
}[]
