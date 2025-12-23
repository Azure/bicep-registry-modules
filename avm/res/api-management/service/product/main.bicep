metadata name = 'API Management Service Products'
metadata description = 'This module deploys an API Management Service Product.'

@sys.description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

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
param description string?

@sys.description('Optional. Names of Product APIs.')
param apis string[]?

@sys.description('Optional. Names of Product Groups.')
param groups string[]?

@sys.description('Optional. Array of Policies to apply to the Service Product.')
param policies productPolicyType[]?

@allowed([
  'notPublished'
  'published'
])
@sys.description('Optional. whether product is published or not. Published products are discoverable by users of developer portal. Non published products are visible only to administrators.')
param state string = 'published'

@sys.description('Optional. Whether a product subscription is required for accessing APIs included in this product. If true, the product is referred to as "protected" and a valid subscription key is required for a request to an API included in the product to succeed. If false, the product is referred to as "open" and requests to an API included in the product can be made without a subscription key. If property is omitted when creating a new product it\'s value is assumed to be true.')
param subscriptionRequired bool = false

@sys.description('Optional. Whether the number of subscriptions a user can have to this product at the same time. Set to null or omit to allow unlimited per user subscriptions. Can be present only if subscriptionRequired property is present and has a value of false.')
param subscriptionsLimit int = 1

@sys.description('Optional. Product terms of use. Developers trying to subscribe to the product will be presented and required to accept these terms before they can complete the subscription process.')
param terms string = ''

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var enableReferencedModulesTelemetry bool = false

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.apimgmt-product.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource product 'Microsoft.ApiManagement/service/products@2024-05-01' = {
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
  for (api, index) in (apis ?? []): {
    name: '${deployment().name}-Api-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      name: api
      productName: product.name
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

module product_groups 'group/main.bicep' = [
  for (group, index) in (groups ?? []): {
    name: '${deployment().name}-Grp-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      name: group
      productName: product.name
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

module product_policies 'policy/main.bicep' = [
  for (policy, index) in policies ?? []: {
    name: '${deployment().name}-Pol-${index}'
    params: {
      apiManagementServiceName: apiManagementServiceName
      productName: product.name
      name: policy.name
      format: policy.?format
      value: policy.value
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
output apiResourceIds array = [for index in range(0, length(apis ?? [])): product_apis[index].outputs.resourceId]

@sys.description('The Resources IDs of the API management service product groups.')
output groupResourceIds array = [for index in range(0, length(groups ?? [])): product_groups[index].outputs.resourceId]

@sys.description('The Resources IDs of the API management service product policies.')
output policyResourceIds string[] = [
  for index in range(0, length(policies ?? [])): product_policies[index].outputs.resourceId
]

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
