metadata name = 'API Management Service Subscriptions'
metadata description = 'This module deploys an API Management Service Subscription.'

@description('Optional. Determines whether tracing can be enabled.')
param allowTracing bool = true

@description('Required. API Management Service Subscriptions name. Must be 1 to 100 characters long.')
@maxLength(100)
param displayName string

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Optional. User (user ID path) for whom subscription is being created in form /users/{userId}.')
param ownerId string?

@description('Optional. Primary subscription key. If not specified during request key will be generated automatically.')
param primaryKey string?

@description('Optional. Scope type to choose between a product, "allAPIs" or a specific API. Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}".')
param scope string = '/apis'

@description('Optional. Secondary subscription key. If not specified during request key will be generated automatically.')
param secondaryKey string?

@description('Optional. Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are "*" active "?" the subscription is active, "*" suspended "?" the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted ? the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected ? the subscription request has been denied by an administrator, * cancelled ? the subscription has been cancelled by the developer or administrator, * expired ? the subscription reached its expiration date and was deactivated. - suspended, active, expired, submitted, rejected, cancelled.')
param state string?

@description('Required. Subscription name.')
param name string

resource service 'Microsoft.ApiManagement/service@2023-05-01-preview' existing = {
  name: apiManagementServiceName
}

resource subscription 'Microsoft.ApiManagement/service/subscriptions@2022-08-01' = {
  name: name
  parent: service
  properties: {
    scope: scope
    displayName: displayName
    ownerId: ownerId
    primaryKey: primaryKey
    secondaryKey: secondaryKey
    state: state
    allowTracing: allowTracing
  }
}

@description('The resource ID of the API management service subscription.')
output resourceId string = subscription.id

@description('The name of the API management service subscription.')
output name string = subscription.name

@description('The resource group the API management service subscription was deployed into.')
output resourceGroupName string = resourceGroup().name
