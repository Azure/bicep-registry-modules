metadata name = 'Web/Function Apps Certificates'
metadata description = 'This module deploys a Web/Function App Certificate.'

@description('Required. Certificate name.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Optional. Certificate host names.')
param hostNames string[]?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.Web/certificates@2024-11-01'>.tags?

@description('Optional. Kind of resource.')
param kind string?

@description('Optional. Key Vault resource ID.')
param keyVaultResourceId string?

@description('Optional. Key Vault secret name.')
param keyVaultSecretName string?

@description('Optional. Server farm resource ID.')
param serverFarmResourceId string?

@description('Optional. CNAME of the certificate to be issued via free certificate.')
param canonicalName string?

@description('Optional. Certificate password.')
@secure()
param password string?

@description('Optional. Certificate data in PFX format.')
@secure()
param pfxBlob string?

@description('Optional. Method of domain validation for free certificate.')
param domainValidationMethod string?

resource certificate 'Microsoft.Web/certificates@2024-11-01' = {
  name: name
  location: location
  kind: kind
  tags: tags
  properties: {
    hostNames: hostNames
    password: password
    pfxBlob: pfxBlob
    serverFarmId: serverFarmResourceId
    keyVaultId: keyVaultResourceId
    keyVaultSecretName: keyVaultSecretName
    canonicalName: canonicalName
    domainValidationMethod: domainValidationMethod
  }
}

@description('The resource ID of the certificate.')
output resourceId string = certificate.id

@description('The resource group the certificate was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the certificate.')
output name string = certificate.name

@description('The thumbprint of the certificate.')
output thumbprint string = certificate.properties.thumbprint

@description('The location the resource was deployed into.')
output location string = certificate.location

// ================ //
// Definitions      //
// ================ //

@export()
@description('The type of a certificate.')
type certificateType = {
  @description('Required. Certificate name.')
  name: string

  @description('Optional. Resource location.')
  location: string?

  @description('Optional. Certificate host names.')
  hostNames: string[]?

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.Web/certificates@2024-11-01'>.tags?

  @description('Optional. Kind of resource.')
  kind: string?

  @description('Optional. Key Vault resource ID.')
  keyVaultResourceId: string?

  @description('Optional. Key Vault secret name.')
  keyVaultSecretName: string?

  @description('Optional. Server farm resource ID.')
  serverFarmResourceId: string?

  @description('Optional. CNAME of the certificate to be issued via free certificate.')
  canonicalName: string?

  @description('Optional. Certificate password.')
  @secure()
  password: string?

  @description('Optional. Certificate data in PFX format.')
  @secure()
  pfxBlob: string?

  @description('Optional. Method of domain validation for free certificate.')
  domainValidationMethod: string?
}
