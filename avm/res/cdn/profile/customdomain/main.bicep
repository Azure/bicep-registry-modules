metadata name = 'CDN Profiles Custom Domains'
metadata description = 'This module deploys a CDN Profile Custom Domains.'
metadata owner = 'Azure/module-maintainers'

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

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource profile 'Microsoft.Cdn/profiles@2023-05-01' existing = {
  name: profileName

  resource profile_secrect 'secrets@2023-05-01' existing = if (!empty(secretName)) {
    name: secretName
  }
}

resource profile_custom_domain 'Microsoft.Cdn/profiles/customDomains@2023-05-01' = {
  name: name
  parent: profile
  properties: {
    azureDnsZone: !empty(azureDnsZoneResourceId) ? {
      id: azureDnsZoneResourceId
    } : null
    extendedProperties: !empty(extendedProperties) ? extendedProperties : null
    hostName: hostName
    preValidatedCustomDomainResourceId: !empty(preValidatedCustomDomainResourceId) ? {
      id: preValidatedCustomDomainResourceId
    } : null
    tlsSettings: {
      certificateType: certificateType
      minimumTlsVersion: minimumTlsVersion
      secret: !(empty(secretName)) ? {
        id: profile::profile_secrect.id
      } : null
    }
  }
}

@description('The name of the custom domain.')
output name string = profile_custom_domain.name

@description('The resource id of the custom domain.')
output resourceId string = profile_custom_domain.id

@description('The name of the resource group the custom domain was created in.')
output resourceGroupName string = resourceGroup().name
