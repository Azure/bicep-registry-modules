metadata name = 'AI Gateway API Key'
metadata description = 'Configures a gateway-level API key without returning its secret values.'

@description('Required. Parent gateway name.')
param aiGatewayName string
@description('Required. API key resource name.')
param name string
@description('Optional. API key properties.')
param properties apiKeyPropertiesType = {}
@secure()
@description('Optional. Secure values for explicit primary and secondary key references.')
param secrets { *: string } = {}

#disable-next-line BCP081
resource gateway 'Microsoft.ApiManagement/aigateways@2025-09-01-preview' existing = {
  name: aiGatewayName
}
#disable-next-line BCP081
resource apiKey 'Microsoft.ApiManagement/aigateways/apiKeys@2025-09-01-preview' = {
  name: name
  parent: gateway
  properties: union(
    {
      displayName: properties.?displayName
      state: properties.?state
      expirationDate: properties.?expirationDate
    },
    properties.?primaryKeySecretName == null
      ? {}
      : {
          primaryKey: secrets[properties.primaryKeySecretName!]
        },
    properties.?secondaryKeySecretName == null
      ? {}
      : {
          secondaryKey: secrets[properties.secondaryKeySecretName!]
        }
  )
}

@description('The API key resource ID, not the key value.')
output resourceId string = apiKey.id
@description('The API key resource name.')
output name string = apiKey.name
@description('The resource group name.')
output resourceGroupName string = resourceGroup().name

@export()
@sealed()
@description('API key resource configuration.')
type apiKeyType = {
  name: string
  properties: apiKeyPropertiesType?
}
@export()
@sealed()
@description('API key metadata and optional secure input references.')
type apiKeyPropertiesType = {
  displayName: string?
  state: string?
  expirationDate: string?
  primaryKeySecretName: string?
  secondaryKeySecretName: string?
}
