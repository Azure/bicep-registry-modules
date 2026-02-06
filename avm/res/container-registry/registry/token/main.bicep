metadata name = 'Container Registries Tokens'
metadata description = 'This module deploys an Azure Container Registry (ACR) Token.'

@description('Conditional. The name of the parent registry. Required if the template is used in a standalone deployment.')
param registryName string

@description('Required. The name of the token.')
@minLength(5)
@maxLength(50)
param name string

@description('Required. The resource ID of the scope map to which the token will be associated with.')
param scopeMapId string

@allowed([
  'disabled'
  'enabled'
])
@description('Optional. The status of the token. Default is enabled.')
param status string = 'enabled'

@description('Optional. The credentials associated with the token for authentication.')
param credentials credentialType?

resource registry 'Microsoft.ContainerRegistry/registries@2025-11-01' existing = {
  name: registryName
}

resource token 'Microsoft.ContainerRegistry/registries/tokens@2025-11-01' = {
  name: name
  parent: registry
  properties: {
    scopeMapId: scopeMapId
    status: status
    credentials: !empty(credentials ?? [])
      ? {
          certificates: credentials.?certificates
          passwords: credentials.?passwords
        }
      : null
  }
}

@description('The name of the token.')
output name string = token.name

@description('The name of the resource group the token was created in.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the token.')
output resourceId string = token.id

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for a token certificate.')
type tokenCertificateType = {
  @description('Optional. Base 64 encoded string of the public certificate in PEM format that will be used for authenticating the token.')
  encodedPemCertificate: string?

  @description('Optional. The expiry datetime of the certificate.')
  expiry: string?

  @description('Required. The certificate name.')
  name: 'certificate1' | 'certificate2'

  @description('Optional. The thumbprint of the certificate.')
  thumbprint: string?
}

@export()
@description('The type for a token password.')
type tokenPasswordType = {
  @description('Optional. The creation datetime of the password.')
  creationTime: string?

  @description('Optional. The expiry datetime of the password.')
  expiry: string?

  @description('Required. The password name.')
  name: 'password1' | 'password2'
}

@export()
@description('The type for the token credentials, which can be either certificates or passwords.')
type credentialType = {
  @description('Optional. The certificates associated with the token for authentication.')
  certificates: tokenCertificateType[]?

  @description('Optional. The passwords associated with the token for authentication.')
  passwords: tokenPasswordType[]?
}
