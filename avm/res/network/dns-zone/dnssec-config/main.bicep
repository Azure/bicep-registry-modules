metadata name = 'Public DNS Zone DNSSEC Config'
metadata description = 'This module deploys a Public DNS Zone DNSSEC configuration.'

@description('Conditional. The name of the parent DNS zone. Required if the template is used in a standalone deployment.')
param dnsZoneName string

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: dnsZoneName
}

resource dnssecConfig 'Microsoft.Network/dnsZones/dnssecConfigs@2023-07-01-preview' = {
  name: 'default'
  parent: dnsZone
}

@description('The name of the DNSSEC configuration.')
output name string = dnssecConfig.name

@description('The resource ID of the DNSSEC configuration.')
output resourceId string = dnssecConfig.id

@description('The resource group the DNSSEC configuration was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The signing keys of the DNSSEC configuration.')
output signingKeys array = dnssecConfig.properties.signingKeys
