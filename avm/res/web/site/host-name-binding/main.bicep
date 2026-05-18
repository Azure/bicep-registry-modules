metadata name = 'Web/Function Apps Slot Host Name Bindings'
metadata description = 'This module deploys a Site Slot Host Name Binding.'

@description('Conditional. The name of the parent site resource. Required if the template is used in a standalone deployment.')
param appName string

@description('Required. Hostname in the hostname binding.')
param name string

@description('Optional. Kind of resource.')
param kind string?

@description('Optional. Azure resource name.')
param azureResourceName string?

@description('Optional. Azure resource type. Possible values are Website and TrafficManager.')
@allowed([
  'Website'
  'TrafficManager'
])
param azureResourceType string?

@description('Optional. Custom DNS record type. Possible values are CName and A.')
@allowed([
  'CName'
  'A'
])
param customHostNameDnsRecordType string?

@description('Optional. Fully qualified ARM domain resource URI.')
param domainResourceId string?

@description('Optional. Hostname type. Possible values are Verified and Managed.')
@allowed([
  'Verified'
  'Managed'
])
param hostNameType string?

@description('Optional. App Service app name.')
param siteName string?

@description('Optional. SSL type. Possible values are Disabled, SniEnabled, and IpBasedEnabled.')
@allowed([
  'Disabled'
  'SniEnabled'
  'IpBasedEnabled'
])
param sslState string?

@description('Optional. SSL certificate thumbprint.')
param thumbprint string?

import { certificateType } from '../modules/certificate.bicep'
@description('Optional. Certificate object with properties for certificate creation. The expected structure matches the certificateType defined in host-name-binding-type.bicep.')
param certificate certificateType?

@description('Optional. Resource location.')
param location string = resourceGroup().location

resource app 'Microsoft.Web/sites@2024-11-01' existing = {
  name: appName
}

// Create certificate using the certificate module
module sslCertificate '../modules/certificate.bicep' = if (!empty(certificate)) {
  name: '${uniqueString(deployment().name, location)}-Cert'
  params: {
    name: certificate.?name ?? 'cert-${replace(name, '.', '-')}'
    location: location
    kind: kind
    hostNames: certificate.?hostNames ?? [name]
    password: certificate.?password
    pfxBlob: certificate.?pfxBlob
    serverFarmResourceId: certificate.?serverFarmResourceId
    keyVaultResourceId: certificate.?keyVaultResourceId
    keyVaultSecretName: certificate.?keyVaultSecretName
    canonicalName: certificate.?canonicalName
    domainValidationMethod: certificate.?domainValidationMethod
  }
}

resource hostNameBinding 'Microsoft.Web/sites/hostNameBindings@2024-11-01' = {
  parent: app
  name: name
  kind: kind
  properties: {
    azureResourceName: azureResourceName
    azureResourceType: azureResourceType
    customHostNameDnsRecordType: customHostNameDnsRecordType
    domainId: domainResourceId
    hostNameType: hostNameType
    siteName: siteName
    sslState: sslState ?? ((!empty(thumbprint) || !empty(certificate)) ? 'SniEnabled' : null)
    thumbprint: thumbprint ?? sslCertificate.?outputs.?thumbprint
  }
}

@description('The name of the host name binding.')
output name string = name

@description('The resource ID of the host name binding.')
output resourceId string = hostNameBinding.id

@description('The name of the resource group the resource was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The thumbprint of the certificate.')
output certificateThumbprint string? = sslCertificate.?outputs.?thumbprint

@description('The resource ID of the certificate.')
output certificateResourceId string? = sslCertificate.?outputs.?resourceId
