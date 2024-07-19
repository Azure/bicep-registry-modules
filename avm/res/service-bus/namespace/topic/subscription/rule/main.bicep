metadata name = 'Service Bus Namespace Topic Subscription Rule'
metadata description = 'This module deploys a Service Bus Namespace Topic Subscription Rule.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the service bus namespace topic subscription rule.')
param name string

@description('Conditional. The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment.')
param subscriptionName string

@description('Opional. Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression')
param action object = {}

@description('Opional. Properties of correlationFilter')
param correlationFilter object = {}

@description('Optional. Filter type that is evaluated against a BrokeredMessage.')
@allowed([
  'CorrelationFilter'
  'SqlFilter'
])
param filterType string?

@description('Opional. Properties of sqlFilter')
param sqlFilter object = {}

resource subscription 'Microsoft.ServiceBus/namespaces/topics/subscriptions@2022-10-01-preview' existing = {
  name: subscriptionName
}

resource symbolicname 'Microsoft.ServiceBus/namespaces/topics/subscriptions/rules@2022-10-01-preview' = {
  name: name
  parent: subscription
  properties: {
    action: action
    correlationFilter: correlationFilter
    filterType: filterType
    sqlFilter: sqlFilter
  }
}
