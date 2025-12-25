metadata name = 'API Management Service Subscriptions'
metadata description = 'This module deploys an API Management Service Subscription.'

@description('Conditional. The name of the parent API Management service. Required if the template is used in a standalone deployment.')
param apiManagementServiceName string

@description('Required. Subscription name.')
param name string

@description('Required. API Management Service Subscriptions name.')
@minLength(1)
@maxLength(100)
param displayName string

@description('Optional. Determines whether tracing can be enabled.')
param allowTracing bool = true

@description('Optional. User (user ID path) for whom subscription is being created in form /users/{userId}.')
param ownerId string?

@minLength(1)
@maxLength(256)
@secure()
@description('Optional. Primary subscription key. If not specified during request key will be generated automatically.')
param primaryKey string?

@description('Optional. Scope like "/products/{productId}" or "/apis" or "/apis/{apiId}".')
param scope string = '/apis'

@minLength(1)
@maxLength(256)
@secure()
@description('Optional. Secondary subscription key. If not specified during request key will be generated automatically.')
param secondaryKey string?

@allowed([
  'active'
  'cancelled'
  'expired'
  'rejected'
  'submitted'
  'suspended'
])
@description('''Optional. Initial subscription state. If no value is specified, subscription is created with Submitted state. Possible states are:
* active - the subscription is active
* suspended - the subscription is blocked, and the subscriber cannot call any APIs of the product
* submitted - the subscription request has been made by the developer, but has not yet been approved or rejected
* rejected - the subscription request has been denied by an administrator
* cancelled - the subscription has been cancelled by the developer or administrator
* expired - the subscription reached its expiration date and was deactivated.''')
param state string?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.apimgmt-subscription.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource service 'Microsoft.ApiManagement/service@2024-05-01' existing = {
  name: apiManagementServiceName
}

resource subscription 'Microsoft.ApiManagement/service/subscriptions@2024-05-01' = {
  name: name
  parent: service
  properties: {
    displayName: displayName
    allowTracing: allowTracing
    ownerId: ownerId
    primaryKey: primaryKey
    scope: scope
    secondaryKey: secondaryKey
    state: state
  }
}

@description('The resource ID of the API management service subscription.')
output resourceId string = subscription.id

@description('The name of the API management service subscription.')
output name string = subscription.name

@description('The resource group the API management service subscription was deployed into.')
output resourceGroupName string = resourceGroup().name
