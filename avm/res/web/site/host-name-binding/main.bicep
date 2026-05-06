metadata name = 'Web/Function Apps Host Name Bindings'
metadata description = 'This module deploys a Site Host Name Binding.'

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
param domainId string?

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
param thumbprint string = ''

@description('Optional. Certificate object with properties for certificate creation. The expected structure matches the certificateType defined in host-name-binding-type.bicep.')
param certificate object = {}

@description('Optional. Resource location.')
param location string = resourceGroup().location

var certificateName = 'cert-${replace(name, '.', '-')}'
var shouldCreateCertificate = !empty(certificate)

// Create certificate if certificate object is provided and add hostname binding
module withCertificateScenario 'with-certificate.bicep' = if (shouldCreateCertificate) {
  name: 'HostNameBindingWithCert-${name}'
  params: {
    appName: appName
    name: name
    kind: kind
    location: location
    certificateName: certificateName
    certificate: certificate
    azureResourceName: azureResourceName
    azureResourceType: azureResourceType
    customHostNameDnsRecordType: customHostNameDnsRecordType
    domainId: domainId
    hostNameType: hostNameType
    siteName: siteName
    sslState: sslState ?? 'SniEnabled'
  }
}

// Just add hostname binding with existing thumbprint if provided
module withoutCertificateScenario 'without-certificate.bicep' = if (!shouldCreateCertificate) {
  name: 'HostNameBindingWithoutCert-${name}'
  params: {
    appName: appName
    name: name
    kind: kind
    azureResourceName: azureResourceName
    azureResourceType: azureResourceType
    customHostNameDnsRecordType: customHostNameDnsRecordType
    domainId: domainId
    hostNameType: hostNameType
    siteName: siteName
    sslState: !empty(thumbprint) ? (sslState ?? 'SniEnabled') : sslState
    thumbprint: thumbprint
  }
}

// Define output variables
var bindingResourceId = shouldCreateCertificate
  ? withCertificateScenario.?outputs.?resourceId ?? ''
  : withoutCertificateScenario.?outputs.?resourceId ?? ''

var bindingCertificateThumbprint = shouldCreateCertificate
  ? withCertificateScenario.?outputs.?certificateThumbprint ?? ''
  : ''

var bindingCertificateResourceId = shouldCreateCertificate
  ? withCertificateScenario.?outputs.?certificateResourceId ?? ''
  : ''

@description('The name of the host name binding.')
output name string = name

@description('The resource ID of the host name binding.')
output resourceId string = bindingResourceId

@description('The name of the resource group the resource was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The thumbprint of the certificate if one was created.')
output certificateThumbprint string = bindingCertificateThumbprint

@description('The resource ID of the certificate if one was created.')
output certificateResourceId string = bindingCertificateResourceId
