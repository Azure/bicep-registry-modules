metadata name = 'Digital Twins Instance Endpoint'
metadata description = 'This module deploys a Digital Twins Instance Endpoint.'

@description('Required. The name of the Digital Twin Endpoint.')
param name string

@description('Conditional. The name of the parent Digital Twin Instance resource. Required if the template is used in a standalone deployment.')
param digitalTwinInstanceName string

@description('Required. The properties of the endpoint.')
param properties propertiesType

var identity = !empty(properties.?managedIdentities)
  ? {
      type: (properties.?managedIdentities.?systemAssigned ?? false)
        ? 'SystemAssigned'
        : (!empty(properties.?managedIdentities.?userAssignedResourceId ?? '') ? 'UserAssigned' : null)
      userAssignedIdentity: properties.?managedIdentities.?userAssignedResourceId
    }
  : null

resource eventGridTopic 'Microsoft.EventGrid/topics@2022-06-15' existing = if (properties.endpointType == 'EventGrid') {
  name: last(split(properties.?eventGridTopicResourceId, '/'))
  scope: resourceGroup(
    split((properties.?eventGridTopicResourceId ?? '//'), '/')[2],
    split((properties.?eventGridTopicResourceId ?? '////'), '/')[4]
  )
}

resource eventHubNamespace 'Microsoft.EventHub/namespaces@2024-01-01' existing = if (properties.endpointType == 'EventHub') {
  name: split((properties.authentication.eventHubResourceId ?? '////'), '/')[8]
  scope: resourceGroup(
    split((properties.authentication.eventHubResourceId ?? '//'), '/')[2],
    split((properties.authentication.eventHubResourceId ?? '////'), '/')[4]
  )

  resource eventHub 'eventhubs@2024-01-01' existing = if (properties.endpointType == 'EventHub') {
    name: last(split((properties.authentication.eventHubResourceId ?? '////'), '/'))

    resource authorizationRule 'authorizationRules@2024-01-01' existing = if (!empty(properties.authentication.?eventHubAuthorizationRuleName)) {
      name: properties.authentication.?eventHubAuthorizationRuleName
    }
  }
}

resource serviceBusNamespace 'Microsoft.ServiceBus/namespaces@2024-01-01' existing = if (properties.endpointType == 'ServiceBus') {
  name: properties.authentication.type == 'IdentityBased'
    ? split(properties.authentication.?serviceBusNamespaceTopicResourceId, '/')[8]
    : split(properties.authentication.?serviceBusNamespaceAuthorizationRuleResourceId, '/')[8]
  scope: properties.authentication.type == 'IdentityBased'
    ? resourceGroup(
        split((properties.authentication.?serviceBusNamespaceTopicResourceId ?? '//'), '/')[2],
        split((properties.authentication.?serviceBusNamespaceTopicResourceId ?? '////'), '/')[4]
      )
    : resourceGroup(
        split((properties.authentication.?serviceBusNamespaceAuthorizationRuleResourceId ?? '//'), '/')[2],
        split((properties.authentication.?serviceBusNamespaceAuthorizationRuleResourceId ?? '////'), '/')[4]
      )

  resource topic 'topics@2024-01-01' existing = if (!empty(properties.authentication.?serviceBusNamespaceTopicResourceId)) {
    name: last(split(properties.authentication.?serviceBusNamespaceTopicResourceId, '/'))
  }

  resource authorizationRule 'AuthorizationRules@2024-01-01' existing = if (!empty(properties.authentication.?serviceBusNamespaceAuthorizationRuleResourceId)) {
    name: last(split(properties.authentication.?serviceBusNamespaceAuthorizationRuleResourceId, '/'))
  }
}

resource digitalTwinsInstance 'Microsoft.DigitalTwins/digitalTwinsInstances@2023-01-31' existing = {
  name: digitalTwinInstanceName
}

resource endpoint 'Microsoft.DigitalTwins/digitalTwinsInstances/endpoints@2023-01-31' = {
  name: name
  parent: digitalTwinsInstance
  properties: {
    endpointType: properties.endpointType
    identity: identity
    deadLetterSecret: properties.?deadLetterSecret
    deadLetterUri: properties.?deadLetterUri
    // Event Grid Event Hub
    ...(properties.endpointType == 'EventGrid'
      ? {
          authenticationType: 'KeyBased'
          TopicEndpoint: 'dummy' // eventGridTopic.properties.endpoint
          accessKey1: eventGridTopic.listkeys().key1
          accessKey2: eventGridTopic.listkeys().key2
        }
      : {})

    // EventHub Event Hub
    ...(properties.endpointType == 'EventHub'
      ? {
          authenticationType: properties.authentication.type
          ...(properties.authentication.type == 'IdentityBased'
            ? {
                endpointUri: 'sb://${eventHubNamespace.name}.servicebus.windows.net/'
                entityPath: eventHubNamespace::eventHub.name
              }
            : {
                connectionStringPrimaryKey: eventHubNamespace::eventHub::authorizationRule.listKeys().primaryConnectionString
                connectionStringSecondaryKey: eventHubNamespace::eventHub::authorizationRule.listKeys().secondaryConnectionString
              })
        }
      : {})

    // Service Bus Event Hub
    ...(properties.endpointType == 'ServiceBus'
      ? {
          authenticationType: properties.authentication.type
          ...(properties.authentication.type == 'IdentityBased'
            ? {
                endpointUri: 'sb://${serviceBusNamespace.name}.servicebus.windows.net/'
                entityPath: serviceBusNamespace::topic.name
              }
            : {
                primaryConnectionString: serviceBusNamespace::authorizationRule.listKeys().primaryConnectionString
                secondaryConnectionString: serviceBusNamespace::authorizationRule.listKeys().secondaryConnectionString
              })
        }
      : {})
  }
}

@description('The resource ID of the Endpoint.')
output resourceId string = endpoint.id

@description('The name of the resource group the resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Endpoint.')
output name string = endpoint.name

// =============== //
//   Definitions   //
// =============== //

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'

@description('The type for the Digital Twin Endpoint.')
@discriminator('endpointType')
@export()
type propertiesType = eventGridPropertiesType | eventHubPropertiesType | serviceBusPropertiesType

@export()
@description('The type for an event grid endpoint.')
type eventGridPropertiesType = {
  @description('Required. The type of endpoint to create.')
  endpointType: 'EventGrid'

  @description('Optional. Dead letter storage secret for key-based authentication. Will be obfuscated during read.')
  @secure()
  deadLetterSecret: string?

  @description('Optional. Dead letter storage URL for identity-based authentication.')
  deadLetterUri: string?

  @description('Optional. The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.')
  managedIdentities: managedIdentityAllType?

  @description('Required. The resource ID of the Event Grid Topic to get access keys from.')
  eventGridTopicResourceId: string
}

@export()
@description('The type for an event hub endpoint.')
type eventHubPropertiesType = {
  @description('Required. The type of endpoint to create.')
  endpointType: 'EventHub'

  @description('Optional. Dead letter storage secret for key-based authentication. Will be obfuscated during read.')
  @secure()
  deadLetterSecret: string?

  @description('Optional. Dead letter storage URL for identity-based authentication.')
  deadLetterUri: string?

  @description('Optional. The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.')
  managedIdentities: managedIdentityAllType?

  @description('Required. Specifies the authentication type being used for connecting to the endpoint.')
  authentication: eventHubAuthorizationPropertiesType
}

@discriminator('type')
@export()
type eventHubAuthorizationPropertiesType =
  | eventHubIdentityBasedAuthenticationPropertiesType
  | eventHubKeyBasedAuthenticationPropertiesType

type eventHubIdentityBasedAuthenticationPropertiesType = {
  @description('Required. Specifies the authentication type being used for connecting to the endpoint. If \'KeyBased\' is selected, a connection string must be specified (at least the primary connection string). If \'IdentityBased\' is select, the endpointUri and entityPath properties must be specified.')
  type: 'IdentityBased'

  @description('Required. The resource ID of the Event Hub Namespace Event Hub.')
  eventHubResourceId: string
}

type eventHubKeyBasedAuthenticationPropertiesType = {
  @description('Required. Specifies the authentication type being used for connecting to the endpoint. If \'KeyBased\' is selected, a connection string must be specified (at least the primary connection string). If \'IdentityBased\' is select, the endpointUri and entityPath properties must be specified.')
  type: 'KeyBased'

  @description('Required. The resource ID of the Event Hub Namespace Event Hub.')
  eventHubResourceId: string

  @description('Required. The name of the Event Hub Namespace Event Hub Authorization Rule.')
  eventHubAuthorizationRuleName: string
}

@export()
@description('The type for a service bus endpoint.')
type serviceBusPropertiesType = {
  @description('Required. The type of endpoint to create.')
  endpointType: 'ServiceBus'

  @description('Required. Specifies the authentication type being used for connecting to the endpoint.')
  authentication: serviceBusNamespaceAuthorizationPropertiesType

  @description('Optional. Dead letter storage secret for key-based authentication. Will be obfuscated during read.')
  @secure()
  deadLetterSecret: string?

  @description('Optional. Dead letter storage URL for identity-based authentication.')
  deadLetterUri: string?

  @description('Optional. The managed identity definition for this resource. Only one type of identity is supported: system-assigned or user-assigned, but not both.')
  managedIdentities: managedIdentityAllType?
}

@discriminator('type')
@export()
type serviceBusNamespaceAuthorizationPropertiesType =
  | serviceBusNamespaceIdentityBasedAuthenticationPropertiesType
  | serviceBusNamespaceKeyBasedAuthenticationPropertiesType

type serviceBusNamespaceIdentityBasedAuthenticationPropertiesType = {
  @description('Required. Specifies the authentication type being used for connecting to the endpoint. If \'KeyBased\' is selected, a connection string must be specified (at least the primary connection string). If \'IdentityBased\' is select, the endpointUri and entityPath properties must be specified.')
  type: 'IdentityBased'

  @description('Required. The ServiceBus Namespace Topic resource ID.')
  serviceBusNamespaceTopicResourceId: string
}

type serviceBusNamespaceKeyBasedAuthenticationPropertiesType = {
  @description('Required. Specifies the authentication type being used for connecting to the endpoint. If \'KeyBased\' is selected, a connection string must be specified (at least the primary connection string). If \'IdentityBased\' is select, the endpointUri and entityPath properties must be specified.')
  type: 'KeyBased'

  @description('Required. The ServiceBus Namespace Authorization Rule resource ID.')
  serviceBusNamespaceAuthorizationRuleResourceId: string
}
