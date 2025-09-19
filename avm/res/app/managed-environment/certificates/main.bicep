metadata name = 'App ManagedEnvironments Certificates'
metadata description = 'This module deploys a App Managed Environment Certificate.'

@description('Required. Name of the Container Apps Managed Environment Certificate.')
param name string

@description('Conditional. The name of the parent app managed environment. Required if the template is used in a standalone deployment.')
param managedEnvironmentName string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. A key vault reference to the certificate to use for the custom domain.')
param certificateKeyVaultProperties certificateKeyVaultPropertiesType?

@allowed(['ServerSSLCertificate', 'ImagePullTrustedCA'])
@description('Optional. The type of the certificate.')
param certificateType string?

@description('Optional. The value of the certificate. PFX or PEM blob.')
param certificateValue string?

@secure()
@description('Optional. The password of the certificate.')
param certificatePassword string?

@description('Optional. Tags of the resource.')
param tags object?

resource managedEnvironment 'Microsoft.App/managedEnvironments@2024-10-02-preview' existing = {
  name: managedEnvironmentName
}

resource managedEnvironmentCertificate 'Microsoft.App/managedEnvironments/certificates@2024-10-02-preview' = {
  parent: managedEnvironment
  location: location
  name: name
  properties: {
    certificateKeyVaultProperties: !empty(certificateKeyVaultProperties)
      ? {
          identity: certificateKeyVaultProperties!.identityResourceId
          keyVaultUrl: certificateKeyVaultProperties!.keyVaultUrl
        }
      : null
    certificateType: certificateType
    password: certificatePassword
    value: certificateValue
  }
  tags: tags
}

@description('The name of the key values.')
output name string = managedEnvironmentCertificate.name

@description('The resource ID of the key values.')
output resourceId string = managedEnvironmentCertificate.id

@description('The resource group the batch account was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for the certificate\'s key vault properties.')
type certificateKeyVaultPropertiesType = {
  @description('Required. The resource ID of the identity. This is the identity that will be used to access the key vault.')
  identityResourceId: string

  @description('Required. A key vault URL referencing the wildcard certificate that will be used for the custom domain.')
  keyVaultUrl: string
}
