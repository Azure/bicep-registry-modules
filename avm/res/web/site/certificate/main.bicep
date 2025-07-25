metadata name = 'Web/Function Apps Certificates'
metadata description = 'This module deploys a Web/Function App Certificate.'

@description('Required. Certificate name.')
param name string

@description('Optional. Resource location.')
param location string = resourceGroup().location

@description('Optional. Certificate host names.')
param hostNames array = []

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Kind of resource.')
param kind string?

@description('Optional. Key Vault resource ID.')
param keyVaultId string?

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
    hostNames: !empty(hostNames) ? hostNames : null
    password: !empty(password) ? password : null
    pfxBlob: !empty(pfxBlob) ? pfxBlob : null
    serverFarmId: !empty(serverFarmResourceId) ? serverFarmResourceId : null
    keyVaultId: !empty(keyVaultId) ? keyVaultId : null
    keyVaultSecretName: !empty(keyVaultSecretName) ? keyVaultSecretName : null
    canonicalName: !empty(canonicalName) ? canonicalName : null
    domainValidationMethod: !empty(domainValidationMethod) ? domainValidationMethod : null
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
