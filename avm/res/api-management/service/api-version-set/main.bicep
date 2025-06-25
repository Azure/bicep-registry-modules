metadata name = 'API Management Service API Version Sets'
metadata description = 'This module deploys an API Management Service API Version Set.'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Optional. API Version set name.')
param name string = 'default'

@sys.description('Required. The display name of the Name of API Version Set.')
@minLength(1)
@maxLength(100)
param displayName string

@sys.description('Required. An value that determines where the API Version identifier will be located in a HTTP request.')
@allowed([
  'Header'
  'Query'
  'Segment'
])
param versioningScheme string

@sys.description('Optional. Description of API Version Set.')
param description string?

@sys.description('Optional. Name of HTTP header parameter that indicates the API Version if versioningScheme is set to header.')
@minLength(1)
@maxLength(100)
param versionHeaderName string?

@sys.description('Optional. Name of query parameter that indicates the API Version if versioningScheme is set to query.')
@minLength(1)
@maxLength(100)
param versionQueryName string?

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName
}

resource apiVersionSet 'Microsoft.ApiManagement/service/apiVersionSets@2024-05-01' = {
  name: name
  parent: service
  properties: {
    displayName: displayName
    versioningScheme: versioningScheme
    description: description
    versionHeaderName: versionHeaderName
    versionQueryName: versionQueryName
  }
}

@sys.description('The resource ID of the API Version set.')
output resourceId string = apiVersionSet.id

@sys.description('The name of the API Version set.')
output name string = apiVersionSet.name

@sys.description('The resource group the API Version set was deployed into.')
output resourceGroupName string = resourceGroup().name
