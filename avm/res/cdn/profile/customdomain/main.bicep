metadata name = 'CDN Profiles Custom Domains'
metadata description = 'This module deploys a CDN Profile Custom Domains.'

@description('Required. The name of the custom domain.')
param name string

@description('Required. The name of the CDN profile.')
param profileName string

@description('Required. The host name of the domain. Must be a domain name.')
param hostName string

@description('Optonal. Resource reference to the Azure DNS zone.')
param azureDnsZoneResourceId string = ''

@description('Optional. Key-Value pair representing migration properties for domains.')
param extendedProperties object = {}

@description('Optional. Resource reference to the Azure resource where custom domain ownership was prevalidated.')
param preValidatedCustomDomainResourceId string = ''

@allowed([
  'AzureFirstPartyManagedCertificate'
  'CustomerCertificate'
  'ManagedCertificate'
])
@description('Required. The type of the certificate used for secure delivery.')
param certificateType string

@allowed([
  'TLS10'
  'TLS12'
])
@description('Optional. The minimum TLS version required for the custom domain. Default value: TLS12.')
param minimumTlsVersion string = 'TLS12'

@description('Optional. The name of the secret. ie. subs/rg/profile/secret.')
param secretName string = ''

@description('Optional. The cipher suite set type that will be used for Https.')
param cipherSuiteSetType string = ''

@description('Optional. The customized cipher suite set that will be used for Https. Required if cipherSuiteSetType is Customized.')
param customizedCipherSuiteSet object = {}

resource profile 'Microsoft.Cdn/profiles@2025-04-15' existing = {
  name: profileName

  resource secret 'secrets@2025-04-15' existing = if (!empty(secretName)) {
    name: secretName
  }
}

resource customDomain 'Microsoft.Cdn/profiles/customDomains@2025-04-15' = {
  name: name
  parent: profile
  properties: {
    azureDnsZone: !empty(azureDnsZoneResourceId)
      ? {
          id: azureDnsZoneResourceId
        }
      : null
    extendedProperties: !empty(extendedProperties) ? extendedProperties : null
    hostName: hostName
    preValidatedCustomDomainResourceId: !empty(preValidatedCustomDomainResourceId)
      ? {
          id: preValidatedCustomDomainResourceId
        }
      : null
    tlsSettings: {
      certificateType: certificateType
      cipherSuiteSetType: !empty(cipherSuiteSetType) ? cipherSuiteSetType : null
      customizedCipherSuiteSet: !empty(customizedCipherSuiteSet) ? customizedCipherSuiteSet : null
      minimumTlsVersion: minimumTlsVersion
      secret: !(empty(secretName))
        ? {
            id: profile::secret.id
          }
        : null
    }
  }
}

@description('The name of the custom domain.')
output name string = customDomain.name

@description('The resource id of the custom domain.')
output resourceId string = customDomain.id

@description('The name of the resource group the custom domain was created in.')
output resourceGroupName string = resourceGroup().name

@description('The DNS validation records.')
output dnsValidation dnsValidationOutputType = {
  dnsTxtRecordName: !empty(customDomain.properties.validationProperties)
    ? '_dnsauth.${customDomain.properties.hostName}'
    : null
  dnsTxtRecordValue: customDomain.properties.?validationProperties.?validationToken
  dnsTxtRecordExpiry: customDomain.properties.?validationProperties.?expirationDate
}

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of the custom domain.')
type customDomainType = {
  @description('Required. The name of the custom domain.')
  name: string

  @description('Required. The host name of the custom domain.')
  hostName: string

  @description('Required. The type of the certificate.')
  certificateType: 'AzureFirstPartyManagedCertificate' | 'CustomerCertificate' | 'ManagedCertificate'

  @description('Optional. The resource ID of the Azure DNS zone.')
  azureDnsZoneResourceId: string?

  @description('Optional. The resource ID of the pre-validated custom domain.')
  preValidatedCustomDomainResourceId: string?

  @description('Optional. The name of the secret.')
  secretName: string?

  @description('Optional. The minimum TLS version.')
  minimumTlsVersion: 'TLS10' | 'TLS12' | null

  @description('Optional. Extended properties.')
  extendedProperties: object?

  @description('Optional. The cipher suite set type that will be used for Https.')
  cipherSuiteSetType: string?

  @description('Optional. The customized cipher suite set that will be used for Https.')
  customizedCipherSuiteSet: object?
}

@export()
@description('The type of the DNS validation.')
type dnsValidationOutputType = {
  @description('The DNS record name.')
  dnsTxtRecordName: string?

  @description('The DNS record value.')
  dnsTxtRecordValue: string?

  @description('The expiry date of the DNS record.')
  dnsTxtRecordExpiry: string?
}
