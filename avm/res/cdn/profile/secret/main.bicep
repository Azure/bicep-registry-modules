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
param subjectAlternativeNames array = []

@description('Optional. Indicates whether to use the latest version of the secret.')
param useLatestVersion bool = false

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
