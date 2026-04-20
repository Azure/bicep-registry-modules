metadata name = 'Container Registries Credential Sets'
metadata description = 'This module deploys an ACR Credential Set.'

@description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Required. The name of the credential set.')
param name string

import { managedIdentityOnlySysAssignedType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityOnlySysAssignedType?

@description('Required. List of authentication credentials stored for an upstream. Usually consists of a primary and an optional secondary credential.')
param authCredentials authCredentialsType[]

@description('Required. The credentials are stored for this upstream or login server.')
param loginServer string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  #disable-next-line BCP332
  name: '46d3xbcp.res.containerregistry-registry-credset.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

resource registry 'Microsoft.ContainerRegistry/registries@2025-11-01' existing = {
  name: registryName
}

resource credentialSet 'Microsoft.ContainerRegistry/registries/credentialSets@2025-11-01' = {
  name: name
  parent: registry
  identity: !empty(managedIdentities)
    ? {
        type: (managedIdentities.?systemAssigned ?? false) ? 'SystemAssigned' : null
      }
    : null
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
output systemAssignedMIPrincipalId string? = credentialSet.?identity.?principalId

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for auth credentials.')
type authCredentialsType = {
  @description('Required. The name of the credential.')
  name: string

  @description('Required. KeyVault Secret URI for accessing the username.')
  usernameSecretIdentifier: string

  @description('Required. KeyVault Secret URI for accessing the password.')
  passwordSecretIdentifier: string
}
