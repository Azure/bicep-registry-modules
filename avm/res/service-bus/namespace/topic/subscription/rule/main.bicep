metadata name = 'Service Bus Namespace Topic Subscription Rule'
metadata description = 'This module deploys a Service Bus Namespace Topic Subscription Rule.'

@description('Required. The name of the service bus namespace topic subscription rule.')
@minLength(1)
@maxLength(50)
param name string

@description('Conditional. The name of the parent Service Bus Namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@description('Conditional. The name of the parent Service Bus Namespace Topic. Required if the template is used in a standalone deployment.')
param topicName string

@description('Conditional. The name of the parent Service Bus Namespace Topic Subscription. Required if the template is used in a standalone deployment.')
param subscriptionName string

@description('Optional. Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression.')
param action actionType?

@description('Conditional. Properties of a correlation filter. Required if \'filterType\' is set to \'CorrelationFilter\'.')
param correlationFilter correlationFilterType?

@description('Required. Filter type that is evaluated against a BrokeredMessage.')
param filterType filterTypeType

@description('Conditional. Properties of a SQL filter. Required if \'filterType\' is set to \'SqlFilter\'.')
param sqlFilter sqlFilterType?

resource namespace 'Microsoft.ServiceBus/namespaces@2022-10-01-preview' existing = {
  name: namespaceName

  resource topic 'topics@2022-10-01-preview' existing = {
    name: topicName

    resource subscription 'subscriptions@2021-11-01' existing = {
      name: subscriptionName
    }
  }
}

resource rule 'Microsoft.ServiceBus/namespaces/topics/subscriptions/rules@2022-10-01-preview' = {
  name: name
  parent: namespace::topic::subscription
  properties: {
    action: action
    correlationFilter: correlationFilter
    filterType: filterType
    sqlFilter: !empty(sqlFilter)
      ? {
          compatibilityLevel: sqlFilter.?compatibilityLevel ?? 20
          requiresPreprocessing: sqlFilter.?requiresPreprocessing
          sqlExpression: sqlFilter.?sqlExpression
        }
      : null
  }
}

@description('The name of the rule.')
output name string = rule.name

@description('The Resource ID of the rule.')
output resourceId string = rule.id

@description('The name of the Resource Group the rule was created in.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //
@export()
@description('A type for a Service Bus Namespace Topic Subscription Rule.')
type ruleType = {
  @description('Required. The name of the Service Bus Namespace Topic Subscription Rule.')
  name: string

  @description('Optional. Represents the filter actions which are allowed for the transformation of a message that have been matched by a filter expression.')
  action: actionType?

  @description('Optional. Properties of correlationFilter.')
  correlationFilter: correlationFilterType?

  @description('Required. Filter type that is evaluated against a BrokeredMessage.')
  filterType: filterTypeType

  @description('Optional. Properties of sqlFilter.')
  sqlFilter: sqlFilterType?
}

@export()
@description('A type for the filter actions of a Service Bus Namespace Topic Subscription Rule.')
type actionType = {
  @description('Optional. This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20.')
  compatibilityLevel: int?

  @description('Optional. Value that indicates whether the rule action requires preprocessing.')
  requiresPreprocessing: bool?

  @description('Optional. SQL expression. e.g. MyProperty=\'ABC\'.')
  sqlExpression: string?
}

@export()
@description('A type for the properties of a correlation filter of a Service Bus Namespace Topic Subscription Rule.')
type correlationFilterType = {
  @description('Optional. Content type of the message.')
  contentType: string?

  @description('Optional. Identifier of the correlation.')
  correlationId: string?

  @description('Optional. Application specific label.')
  label: string?

  @description('Optional. Identifier of the message.')
  messageId: string?

  @description('Optional. Dictionary object for custom filters.')
  properties: object?

  @description('Optional. Address of the queue to reply to.')
  replyTo: string?

  @description('Optional. Session identifier to reply to.')
  replyToSessionId: string?

  @description('Optional. Value that indicates whether the rule action requires preprocessing.')
  requiresPreprocessing: bool?

  @description('Optional. Session identifier.')
  sessionId: string?

  @description('Optional. Address to send to.')
  to: string?
}

@export()
@description('A type for the type of a Service Bus Namespace Topic Subscription Rule.')
type filterTypeType = 'CorrelationFilter' | 'SqlFilter'

@export()
@description('A type for the properties of a SQL filter of a Service Bus Namespace Topic Subscription Rule.')
type sqlFilterType = {
  @description('Optional. This property is reserved for future use. An integer value showing the compatibility level, currently hard-coded to 20.')
  compatibilityLevel: int?

  @description('Optional. Value that indicates whether the rule action requires preprocessing.')
  requiresPreprocessing: bool?

  @description('Required. The SQL expression. e.g. MyProperty=\'ABC\'.')
  sqlExpression: string
}
