// Test API Management Product module
targetScope = 'resourceGroup'

@description('Get test location.')
param location string = resourceGroup().location

// ----------
// REFERENCES
// ----------

@description('An APIM service for testing.')
resource service 'Microsoft.ApiManagement/service@2022-08-01' = {
  name: 'apim-${uniqueString(resourceGroup().id)}'
  location: location
  sku: {
    name: 'Basic'
    capacity: 1
  }
  properties: {
    publisherEmail: 'noreply@contoso.com'
    publisherName: 'Contoso'
  }
}

// ---------
// RESOURCES
// ---------

@description('A basic product for testing.')
module reporting '../main.bicep' = {
  name: 'reporting-apis'
  params: {
    displayName: 'Reporting'
    description: 'A group of APIs for managing reports.'
    serviceId: service.id
    terms: 'By using this product you agree to the terms of service.'
  }
}

@description('Test publish of product.')
module reporting_published '../main.bicep' = {
  name: 'reporting-published-apis'
  params: {
    displayName: 'Reporting'
    description: 'A group of APIs for managing reports which is published.'
    serviceId: service.id
    terms: loadTextContent('terms.txt')
    published: true
    approvalRequired: true
    subscriptionRequired: true
  }
}

@description('Test publish of product with a group.')
module reporting_with_group '../main.bicep' = {
  name: 'reporting-with-group'
  params: {
    displayName: 'Reporting'
    description: 'A group of APIs for managing reports which is published.'
    serviceId: service.id
    terms: loadTextContent('terms.txt')
    published: true
    approvalRequired: true
    subscriptionRequired: true
    groups: [
      'internal-developers'
    ]
  }
}
