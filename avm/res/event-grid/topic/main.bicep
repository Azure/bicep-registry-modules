metadata name = 'Event Grid Topics'
metadata description = 'This module deploys an Event Grid Topic.'

@description('Required. The name of the Event Grid Topic.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set and inboundIpRules are not set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Optional. This can be used to restrict traffic from specific IPs instead of all IPs. Note: These are considered only if PublicNetworkAccess is enabled.')
param inboundIpRules array = []

@description('Optional. Event subscriptions to deploy.')
param eventSubscriptions eventSubscriptionType[]?

@description('Optional. This determines the format that Event Grid should expect for incoming events published to the topic.')
@allowed([
  'CloudEventSchemaV1_0'
  'CustomEventSchema'
  'EventGridSchema'
])
param inputSchema string = 'EventGridSchema'

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Data residency boundary for the topic. Controls where event data can be stored and processed.')
@allowed([
  'WithinGeopair'
  'WithinRegion'
])
param dataResidencyBoundary string?

@description('Optional. Event type information for the topic. Used to define custom event types.')
param eventTypeInfo resourceInput<'Microsoft.EventGrid/topics@2025-04-01-preview'>.properties.eventTypeInfo?

@description('Optional. Input schema mapping for custom event schema. This is the full mapping object including fields and default values.')
param inputSchemaMapping resourceInput<'Microsoft.EventGrid/topics@2025-04-01-preview'>.properties.inputSchemaMapping?

@description('Optional. Extended location for the topic (e.g., Edge Zones).')
param extendedLocation resourceInput<'Microsoft.EventGrid/topics@2025-04-01-preview'>.extendedLocation?

@description('Optional. The kind of topic resource.')
@allowed([
  'Azure'
  'AzureArc'
])
param kind string = 'Azure'

@description('Optional. Allow only Azure AD authentication. Should be enabled for security reasons.')
param disableLocalAuth bool = true

@description('Optional. Minimum TLS version of the publisher allowed to publish to this topic. For security reasons, it is recommended to use TLS 1.2.')
@allowed([
  '1.0'
  '1.1'
  '1.2'
])
param minimumTlsVersionAllowed string = '1.2'

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.EventGrid/topics@2025-04-01-preview'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var enableReferencedModulesTelemetry = false

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'EventGrid Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1e241071-0855-49ea-94dc-649edcd759de'
  )
  'EventGrid Data Sender': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'd5a91429-5739-47e2-a06b-3470a27159e7'
  )
  'EventGrid EventSubscription Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '428e0ff0-5e57-4d9c-a221-2c70d0e0a443'
  )
  'EventGrid EventSubscription Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '2414bbcf-6497-4faf-8c65-045460748405'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: take(
    '46d3xbcp.res.eventgrid-topic.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}',
    64
  )
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

resource topic 'Microsoft.EventGrid/topics@2025-04-01-preview' = {
  name: name
  location: location
  identity: identity
  tags: tags
  kind: kind
  extendedLocation: extendedLocation
  properties: {
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? any(publicNetworkAccess)
      : (!empty(privateEndpoints) && empty(inboundIpRules) ? 'Disabled' : null)
    inboundIpRules: (empty(inboundIpRules) ? null : inboundIpRules)
    disableLocalAuth: disableLocalAuth
    minimumTlsVersionAllowed: minimumTlsVersionAllowed
    inputSchema: inputSchema
    dataResidencyBoundary: dataResidencyBoundary
    eventTypeInfo: eventTypeInfo
    inputSchemaMapping: inputSchemaMapping
  }
}

// Event subscriptions
module topics_eventSubscriptions 'event-subscription/main.bicep' = [
  for (eventSubscription, index) in (eventSubscriptions ?? []): {
    name: '${uniqueString(deployment().name, location)}-EventGrid-Topics-EventSubs-${index}'
    params: {
      destination: empty(eventSubscription.?deliveryWithResourceIdentity) ? eventSubscription.?destination : null
      topicName: topic.name
      name: eventSubscription.name
      deadLetterDestination: eventSubscription.?deadLetterDestination
      deadLetterWithResourceIdentity: eventSubscription.?deadLetterWithResourceIdentity
      deliveryWithResourceIdentity: eventSubscription.?deliveryWithResourceIdentity
      eventDeliverySchema: eventSubscription.?eventDeliverySchema ?? 'EventGridSchema'
      expirationTimeUtc: eventSubscription.?expirationTimeUtc
      filter: eventSubscription.?filter
      labels: eventSubscription.?labels
      retryPolicy: eventSubscription.?retryPolicy
    }
  }
]

resource topic_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: topic
}

resource topic_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: topic
  }
]

module topic_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.11.0' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-topic-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(topic.id, '/'))}-${privateEndpoint.?service ?? 'topic'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(topic.id, '/'))}-${privateEndpoint.?service ?? 'topic'}-${index}'
              properties: {
                privateLinkServiceId: topic.id
                groupIds: [
                  privateEndpoint.?service ?? 'topic'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(topic.id, '/'))}-${privateEndpoint.?service ?? 'topic'}-${index}'
              properties: {
                privateLinkServiceId: topic.id
                groupIds: [
                  privateEndpoint.?service ?? 'topic'
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: enableReferencedModulesTelemetry
      location: privateEndpoint.?location ?? reference(
        split(privateEndpoint.subnetResourceId, '/subnets/')[0],
        '2020-06-01',
        'Full'
      ).location
      lock: privateEndpoint.?lock ?? lock
      privateDnsZoneGroup: privateEndpoint.?privateDnsZoneGroup
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

resource topic_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(topic.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: topic
  }
]

@description('The name of the event grid topic.')
output name string = topic.name

@description('The resource ID of the event grid topic.')
output resourceId string = topic.id

@description('The name of the resource group the event grid topic was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = topic.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = topic.?identity.?principalId

@description('The private endpoints of the resource.')
output privateEndpoints privateEndpointOutputType[] = [
  for (pe, index) in (privateEndpoints ?? []): {
    name: topic_privateEndpoints[index].outputs.name
    resourceId: topic_privateEndpoints[index].outputs.resourceId
    groupId: topic_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: topic_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: topic_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

@export()
type privateEndpointOutputType = {
  @description('The name of the private endpoint.')
  name: string

  @description('The resource ID of the private endpoint.')
  resourceId: string

  @description('The group Id for the private endpoint Group.')
  groupId: string?

  @description('The custom DNS configurations of the private endpoint.')
  customDnsConfigs: {
    @description('FQDN that resolves to private endpoint IP address.')
    fqdn: string?

    @description('A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]

  @description('The IDs of the network interfaces associated with the private endpoint.')
  networkInterfaceResourceIds: string[]
}

@export()
@description('Event subscription configuration.')
type eventSubscriptionType = {
  @description('Required. The name of the event subscription.')
  name: string
  
  @description('Optional. Dead Letter Destination.')
  deadLetterDestination: resourceInput<'Microsoft.EventGrid/topics/eventSubscriptions@2025-04-01-preview'>.properties.deadLetterDestination?
  
  @description('Optional. Dead Letter with Resource Identity Configuration.')
  deadLetterWithResourceIdentity: resourceInput<'Microsoft.EventGrid/topics/eventSubscriptions@2025-04-01-preview'>.properties.deadLetterWithResourceIdentity?
  
  @description('Optional. Delivery with Resource Identity Configuration.')
  deliveryWithResourceIdentity: resourceInput<'Microsoft.EventGrid/topics/eventSubscriptions@2025-04-01-preview'>.properties.deliveryWithResourceIdentity?
  
  @description('Conditional. Required if deliveryWithResourceIdentity is not provided. The destination for the event subscription.')
  destination: resourceInput<'Microsoft.EventGrid/topics/eventSubscriptions@2025-04-01-preview'>.properties.destination?
  
  @description('Optional. The event delivery schema for the event subscription.')
  eventDeliverySchema: ('CloudEventSchemaV1_0' | 'CustomInputSchema' | 'EventGridSchema' | 'EventGridEvent')?
  
  @description('Optional. The expiration time for the event subscription. Format is ISO-8601 (yyyy-MM-ddTHH:mm:ssZ).')
  expirationTimeUtc: string?
  
  @description('Optional. The filter for the event subscription.')
  filter: resourceInput<'Microsoft.EventGrid/topics/eventSubscriptions@2025-04-01-preview'>.properties.filter?
  
  @description('Optional. The list of user defined labels.')
  labels: string[]?
  
  @description('Optional. The retry policy for events.')
  retryPolicy: resourceInput<'Microsoft.EventGrid/topics/eventSubscriptions@2025-04-01-preview'>.properties.retryPolicy?
}
