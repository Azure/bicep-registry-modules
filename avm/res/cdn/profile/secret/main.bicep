metadata name = 'CDN Profiles Secret'
metadata description = 'This module deploys a CDN Profile Secret.'

@description('Required. The name of the secret.')
param name string

@description('Conditional. The name of the parent CDN profile. Required if the template is used in a standalone deployment.')
param profileName string

@allowed([
  'AzureFirstPartyManagedCertificate'
  'CustomerCertificate'
  'ManagedCertificate'
  'UrlSigningKey'
])
@description('Optional. The type of the secret.')
param type string = 'AzureFirstPartyManagedCertificate'

@description('Conditional. The resource ID of the secret source. Required if the `type` is "CustomerCertificate".')
#disable-next-line secure-secrets-in-params
param secretSourceResourceId string = ''

@description('Optional. The version of the secret.')
param secretVersion string = ''

@description('Optional. The subject alternative names of the secret.')
param subjectAlternativeNames string[] = []

@description('Optional. Indicates whether to use the latest version of the secret.')
param useLatestVersion bool = false

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.cdn-profile-secret.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource profile 'Microsoft.Cdn/profiles@2025-04-15' existing = {
  name: profileName
}

resource secret 'Microsoft.Cdn/profiles/secrets@2025-04-15' = {
  name: name
  parent: profile
  properties: {
    // False positive
    #disable-next-line BCP225
    parameters: (type == 'CustomerCertificate')
      ? {
          type: type
          secretSource: {
            id: secretSourceResourceId
          }
          secretVersion: secretVersion
          subjectAlternativeNames: subjectAlternativeNames
          useLatestVersion: useLatestVersion
        }
      : null
  }
}

@description('The name of the secret.')
output name string = secret.name

@description('The resource ID of the secret.')
output resourceId string = secret.id

@description('The name of the resource group the secret was created in.')
output resourceGroupName string = resourceGroup().name
