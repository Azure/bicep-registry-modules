metadata name = 'API Management Service Products'
metadata description = 'This module deploys an API Management Service Product.'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Required. API Management Service Products name. Must be 1 to 300 characters long.')
@maxLength(300)
param displayName string

@sys.description('Optional. Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the products APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the products APIs. Can be present only if subscriptionRequired property is present and has a value of false.')
param approvalRequired bool = false

@sys.description('Optional. Product description. May include HTML formatting tags.')
param description string = ''

@sys.description('Optional. Array of Product APIs.')
param apis array = []

@sys.description('Optional. Array of Product Groups.')
param groups array = []

@sys.description('Required. Product Name.')
param name string

@sys.description('Optional. whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators. Default state of Product is notPublished. - notPublished or published.')
param state string = 'published'

@sys.description('Optional. Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it\'s value is assumed to be true.')
param subscriptionRequired bool = false

@sys.description('Optional. Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false.')
param subscriptionsLimit int = 1

@sys.description('Optional. Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process.')
param terms string = ''

resource service 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: apiManagementServiceName
}

resource product 'Microsoft.ApiManagement/service/products@2022-08-01' = {
  name: name
  parent: service
  properties: {
    description: description
    displayName: displayName
    terms: terms
    subscriptionRequired: subscriptionRequired
    approvalRequired: subscriptionRequired ? approvalRequired : null
    subscriptionsLimit: subscriptionRequired ? subscriptionsLimit : null
    state: state
  }
}

module product_apis 'api/main.bicep' = [
  for (api, index) in apis: {
    name: '${deployment().name}-Api-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      name: api.name
      productName: name
    }
  }
]

module product_groups 'group/main.bicep' = [
  for (group, index) in groups: {
    name: '${deployment().name}-Group-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      name: group.name
      productName: name
    }
  }
]

@sys.description('The resource ID of the API management service product.')
output resourceId string = product.id

@sys.description('The name of the API management service product.')
output name string = product.name

@sys.description('The resource group the API management service product was deployed into.')
output resourceGroupName string = resourceGroup().name

@sys.description('The Resources IDs of the API management service product APIs.')
output apiResourceIds array = [for index in range(0, length(apis)): product_apis[index].outputs.resourceId]

@sys.description('The Resources IDs of the API management service product groups.')
output groupResourceIds array = [for index in range(0, length(groups)): product_groups[index].outputs.resourceId]
