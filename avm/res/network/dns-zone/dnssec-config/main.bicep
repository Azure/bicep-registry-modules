metadata name = 'Public DNS Zone DNSSEC Config'
metadata description = 'This module deploys a Public DNS Zone DNSSEC configuration.'

@description('Conditional. The name of the parent DNS zone. Required if the template is used in a standalone deployment.')
param dnsZoneName string

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

resource dnsZone 'Microsoft.Network/dnsZones@2018-05-01' existing = {
  name: dnsZoneName
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-dnszone-dnssecconfig.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
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
