targetScope = 'resourceGroup'

// ------------------
//    PARAMETERS
// ------------------

param keyVaultName string

param appGatewayUserAssignedIdentityPrincipalId string

param appGatewayCertificateKeyName string

param appGatewayCertificateData string

// ------------------
// VARIABLES
// ------------------

var keyVaultSecretUserRoleGuid = '4633458b-17de-408a-b874-0445c86b69e6'

// ------------------
// RESOURCES
// ------------------

resource keyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = {
  name: keyVaultName
}

//TODO: this needs to be updated to use the AVM module when it is available
resource sslCertSecret 'Microsoft.KeyVault/vaults/secrets@2023-07-01' = {
  parent: keyVault
  name: appGatewayCertificateKeyName
  properties: {
    value: appGatewayCertificateData
    contentType: 'application/x-pkcs12'
    attributes: {
      enabled: true
    }
  }
}

resource keyvaultSecretUserRoleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(subscription().id, keyVault.id, appGatewayUserAssignedIdentityPrincipalId, 'KeyVaultSecretUser')
  scope: sslCertSecret
  properties: {
    principalId: appGatewayUserAssignedIdentityPrincipalId
    roleDefinitionId: resourceId('Microsoft.Authorization/roleDefinitions', keyVaultSecretUserRoleGuid)
    principalType: 'ServicePrincipal'
  }
}

// Using SecretUri instead of SecretUriWithVersion to avoid having to update the App Gateway configuration when the secret version changes
output SecretUri string = sslCertSecret.properties.secretUri
