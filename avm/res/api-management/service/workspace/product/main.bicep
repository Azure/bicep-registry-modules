metadata name = 'API Management Workspace Products'
metadata description = 'This module deploys a Product in an API Management Workspace.'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@sys.description('Conditional. The name of the parent Workspace. Required if the template is used in a standalone deployment.')
param workspaceName string

@minLength(1)
@maxLength(256)
@sys.description('Required. Product Name.')
param name string

@sys.description('Required. Product display name.')
@minLength(1)
@maxLength(300)
param displayName string

@sys.description('Optional. Whether subscription approval is required. If false, new subscriptions will be approved automatically enabling developers to call the product\'s APIs immediately after subscribing. If true, administrators must manually approve the subscription before the developer can any of the product\'s APIs. Can be present only if subscriptionRequired property is present and has a value of false.')
param approvalRequired bool = false

@maxLength(1000)
@sys.description('Optional. Product description. May include HTML formatting tags.')
param description string = ''

@sys.description('Optional. Names of Product API Links.')
param apiLinks apiLinkType[]?

@sys.description('Optional. Names of Product Group Links.')
param groupLinks groupLinkType[]?

@sys.description('Optional. Array of Policies to apply to the Product.')
param policies productPolicyType[]?

@allowed([
  'notPublished'
  'published'
])
@sys.description('Optional. Whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators.')
param state string = 'published'

@sys.description('Optional. Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it\'s value is assumed to be true.')
param subscriptionRequired bool = false

@sys.description('Optional. Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false.')
param subscriptionsLimit int = 1

@sys.description('Optional. Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process.')
param terms string?

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName

  resource workspace 'workspaces@2024-05-01' existing = {
    name: workspaceName
  }
}

resource product 'Microsoft.ApiManagement/service/workspaces/products@2024-05-01' = {
  name: name
  parent: service::workspace
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

module product_apiLinks 'api-link/main.bicep' = [
  for (apiLink, index) in apiLinks ?? []: {
    name: '${deployment().name}-ApiLnk-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspaceName
      productName: product.name
      name: apiLink.name
      apiResourceId: apiLink.apiResourceId
    }
  }
]

module product_groupLinks 'group-link/main.bicep' = [
  for (groupLink, index) in groupLinks ?? []: {
    name: '${deployment().name}-GrpLnk-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspaceName
      productName: product.name
      name: groupLink.name
      groupResourceId: groupLink.groupResourceId
    }
  }
]

module product_policies 'policy/main.bicep' = [
  for (policy, index) in policies ?? []: {
    name: '${deployment().name}-Pol-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      workspaceName: workspaceName
      productName: product.name
      name: policy.?name
      format: policy.?format
      value: policy.value
    }
  }
]

@sys.description('The resource ID of the workspace product.')
output resourceId string = product.id

@sys.description('The name of the workspace product.')
output name string = product.name

@sys.description('The resource group the workspace product was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

@export()
@sys.description('The type of a product policy.')
type productPolicyType = {
  @sys.description('Optional. The name of the policy.')
  name: string?

  @sys.description('Optional. Format of the policyContent.')
  format: ('rawxml' | 'rawxml-link' | 'xml' | 'xml-link')?

  @sys.description('Required. Contents of the Policy as defined by the format.')
  value: string
}

@export()
@sys.description('The type of a product API link.')
type apiLinkType = {
  @sys.description('Required. The name of the API link.')
  name: string

  @sys.description('Required. Full resource Id of an API.')
  apiResourceId: string
}

@export()
@sys.description('The type of a product group link.')
type groupLinkType = {
  @sys.description('Required. The name of the Product Group link.')
  name: string

  @sys.description('Required. Full resource Id of a Group.')
  groupResourceId: string
}
