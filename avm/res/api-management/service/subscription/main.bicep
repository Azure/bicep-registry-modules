metadata name = 'API Management Service Subscriptions'
metadata description = 'This module deploys an API Management Service Subscription.'
metadata owner = 'Azure/module-maintainers'

@description('Optional. Determines whether tracing can be enabled.')
param allowTracing bool = true

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Optional. User (user ID path) for whom subscription is being created in form /users/{userId}.')
param ownerId string = ''

@description('Optional. Primary subscription key. If not specified during request key will be generated automatically.')
param primaryKey string = ''

@description('Optional. Scope type to choose between a product, "allAPIs" or a specific API. Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}".')
param scope string = '/apis'

@description('Optional. Secondary subscription key. If not specified during request key will be generated automatically.')
param secondaryKey string = ''

@description('Optional. Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are "*" active "?" the subscription is active, "*" suspended "?" the subscription is blocked, and the subscriber cannot call any APIs of the product, * submitted ? the subscription request has been made by the developer, but has not yet been approved or rejected, * rejected ? the subscription request has been denied by an administrator, * cancelled ? the subscription has been cancelled by the developer or administrator, * expired ? the subscription reached its expiration date and was deactivated. - suspended, active, expired, submitted, rejected, cancelled.')
param state string = ''

@description('Required. Subscription name.')
param name string

resource defaultTelemetry 'Microsoft.Resources/deployments@2021-04-01' = if (enableDefaultTelemetry) {
  name: 'pid-47ed15a6-730a-4827-bcb4-0fd963ffbd82-${uniqueString(deployment().name)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource service 'Microsoft.ApiManagement/service@2021-08-01' existing = {
  name: apiManagementServiceName
}

resource subscription 'Microsoft.ApiManagement/service/subscriptions@2021-08-01' = {
  name: name
  parent: service
  properties: {
    scope: scope
    displayName: name
    ownerId: !empty(ownerId) ? ownerId : null
    primaryKey: !empty(primaryKey) ? primaryKey : null
    secondaryKey: !empty(secondaryKey) ? secondaryKey : null
    state: !empty(state) ? state : null
    allowTracing: allowTracing
  }
}

@description('The resource ID of the API management service subscription.')
output resourceId string = subscription.id

@description('The name of the API management service subscription.')
output name string = subscription.name

@description('The resource group the API management service subscription was deployed into.')
output resourceGroupName string = resourceGroup().name
