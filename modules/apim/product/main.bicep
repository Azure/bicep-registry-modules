// Create or update an API Management Product
targetScope = 'resourceGroup'
// metadata name = 'API Management Product'
// metadata description = 'An API Management product for grouping and controlling access to APIs.'

// ----------
// PARAMETERS
// ----------

@minLength(1)
@maxLength(80)
@sys.description('A unique name of the product.')
param name string = deployment().name

@sys.description('A display name of the product.')
param displayName string = name

@sys.description('A description for the product.')
param description string = ''

@metadata({
  strongType: 'Microsoft.ApiManagement/service'
})
@sys.description('The resource Id to the API Management service.')
param serviceId string

@sys.description('Determines if the product is published.')
param published bool = false

@sys.description('Determines if the product requires approval to subscribe.')
param approvalRequired bool = true

@sys.description('Determines of the product requires a subscription to use.')
param subscriptionRequired bool = true

@sys.description('Configures the legal terms to accept prior to subscribing to the product.')
param terms string

@sys.description('Configures a list of groups that are added to the product.')
param groups array = []

// ---------
// VARIABLES
// ---------

// ----------
// REFERENCES
// ----------

resource service 'Microsoft.ApiManagement/service@2022-08-01' existing = {
  name: split(serviceId, '/')[8]
}

// ---------
// RESOURCES
// ---------

@sys.description('Create or update an API Management Product.')
resource product 'Microsoft.ApiManagement/service/products@2022-08-01' = {
  parent: service
  name: name
  properties: {
    state: published ? 'published' : 'notPublished'
    displayName: displayName
    approvalRequired: approvalRequired
    subscriptionRequired: subscriptionRequired
    description: description
    terms: terms
  }
}

@sys.description('Configures a list of groups that are added to the product.')
resource group 'Microsoft.ApiManagement/service/products/groups@2022-08-01' = [for item in groups: {
  parent: product
  name: item
}]

// -------
// OUTPUTS
// -------

@sys.description('The name of the API Management Product')
output name string = product.name

@sys.description('A unique identifier for the API Management Product.')
output id string = product.id

@sys.description('The name of the Resource Group where the API Management Product is deployed.')
output resourceGroupName string = resourceGroup().name

@sys.description('The guid for the subscription where the API Management Product is deployed.')
output subscriptionId string = subscription().subscriptionId
