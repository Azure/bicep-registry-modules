metadata name = 'Event Grid Namespaces'
metadata description = 'This module deploys an Event Grid Namespace.'

@minLength(3)
@maxLength(50)
@description('Required. Name of the Event Grid Namespace to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Allows the user to specify if the namespace resource supports zone-redundancy capability or not. If this property is not specified explicitly by the user, its default value depends on the following conditions: a. For Availability Zones enabled regions - The default property value would be true. b. For non-Availability Zones enabled regions - The default property value would be false. Once specified, this property cannot be updated.')
param isZoneRedundant bool?

@allowed([
  'Disabled'
  'Enabled'
  'SecuredByPerimeter'
])
@description('Optional. This determines if traffic is allowed over public network. By default it is enabled. You can further restrict to specific IPs by configuring.')
param publicNetworkAccess string?

@description('Optional. This can be used to restrict traffic from specific IPs instead of all IPs. Note: These are considered only if PublicNetworkAccess is enabled.')
param inboundIpRules array?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointSingleServiceType[]?

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Indicates if Topic Spaces Configuration is enabled for the namespace. This enables the MQTT Broker functionality for the namespace. Once enabled, this property cannot be disabled.')
param topicSpacesState string = 'Disabled'

@allowed([
  'ClientCertificateDns'
  'ClientCertificateEmail'
  'ClientCertificateIp'
  'ClientCertificateSubject'
  'ClientCertificateUri'
])
@description('Optional. Alternative authentication name sources related to client authentication settings for namespace resource. Used only when MQTT broker is enabled (\'topicSpacesState\' is set to \'Enabled\').')
param alternativeAuthenticationNameSources array?

@minValue(1)
@maxValue(8)
@description('Optional. The maximum session expiry in hours. Used only when MQTT broker is enabled (\'topicSpacesState\' is set to \'Enabled\').')
param maximumSessionExpiryInHours int = 1

@minValue(1)
@maxValue(100)
@description('Optional. The maximum number of sessions per authentication name. Used only when MQTT broker is enabled (\'topicSpacesState\' is set to \'Enabled\').')
param maximumClientSessionsPerAuthenticationName int = 1

@description('Optional. Resource Id for the Event Grid Topic to which events will be routed to from TopicSpaces under a namespace. This enables routing of the MQTT messages to an Event Grid Topic. Used only when MQTT broker is enabled (\'topicSpacesState\' is set to \'Enabled\'). Note that the topic must exist prior to deployment, meaning: if referencing a topic in the same namespace, the deployment must be launched twice: 1. To create the topic 2. To enable the routing this topic.')
param routeTopicResourceId string?

@description('Optional. Routing enrichments for topic spaces configuration.  Used only when MQTT broker is enabled (\'topicSpacesState\' is set to \'Enabled\') and routing is enabled (\'routeTopicResourceId\' is set).')
param routingEnrichments object?

@description('Conditional. Routing identity info for topic spaces configuration. Required if the \'routeTopicResourceId\' points to a topic outside of the current Event Grid Namespace.  Used only when MQTT broker is enabled (\'topicSpacesState\' is set to \'Enabled\') and routing is enabled (\'routeTopicResourceId\' is set).')
param routingIdentityInfo object?

@description('Optional. All namespace Topics to create.')
param topics array?

@description('Optional. CA certificates (Root or intermediate) used to sign the client certificates for clients authenticated using CA-signed certificates.  Used only when MQTT broker is enabled (\'topicSpacesState\' is set to \'Enabled\').')
param caCertificates array?

@description('Optional. All namespace Clients to create. Used only when MQTT broker is enabled (\'topicSpacesState\' is set to \'Enabled\').')
param clients array?

@description('Optional. All namespace Client Groups to create. Used only when MQTT broker is enabled (\'topicSpacesState\' is set to \'Enabled\').')
param clientGroups array?

@description('Optional. All namespace Topic Spaces to create. Used only when MQTT broker is enabled (\'topicSpacesState\' is set to \'Enabled\').')
param topicSpaces array?

@description('Optional. All namespace Permission Bindings to create. Used only when MQTT broker is enabled (\'topicSpacesState\' is set to \'Enabled\').')
param permissionBindings array?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  'Azure Resource Notifications System Topics Subscriber': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0b962ed2-6d56-471c-bd5f-3477d83a7ba4'
  )
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'EventGrid Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1e241071-0855-49ea-94dc-649edcd759de'
  )
  'EventGrid Data Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '1d8c3fe3-8864-474b-8749-01e3783e8157'
  )
  'EventGrid Data Receiver': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '78cbd9e7-9798-4e2e-9b5a-547d9ebb31fb'
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
  'EventGrid TopicSpaces Publisher': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a12b0b94-b317-4dcd-84a8-502ce99884c6'
  )
  'EventGrid TopicSpaces Subscriber': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4b0f2fd7-60b4-4eca-896f-4435034f8bf5'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
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

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.eventgrid-namespace.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource namespace 'Microsoft.EventGrid/namespaces@2023-12-15-preview' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    isZoneRedundant: isZoneRedundant
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? publicNetworkAccess
      : (!empty(privateEndpoints) ? 'Disabled' : 'Enabled')
    inboundIpRules: inboundIpRules
    topicSpacesConfiguration: topicSpacesState == 'Enabled'
      ? {
          state: topicSpacesState
          clientAuthentication: !empty(alternativeAuthenticationNameSources)
            ? {
                alternativeAuthenticationNameSources: alternativeAuthenticationNameSources
              }
            : null
          maximumSessionExpiryInHours: maximumSessionExpiryInHours
          maximumClientSessionsPerAuthenticationName: maximumClientSessionsPerAuthenticationName
          routeTopicResourceId: routeTopicResourceId
          routingEnrichments: !empty(routeTopicResourceId) ? routingEnrichments : null
          routingIdentityInfo: !empty(routeTopicResourceId) && !startsWith(
              routeTopicResourceId ?? '',
              '/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.EventGrid/namespaces/${name}/topics/'
            )
            ? routingIdentityInfo
            : null // Use routingIdentityInfo only if the topic is not in the same namespace
        }
      : null
  }
}

resource namespace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: namespace
}

resource namespace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: namespace
  }
]

module namespace_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.10.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-namespace-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(namespace.id, '/'))}-${privateEndpoint.?service ?? 'topic'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(namespace.id, '/'))}-${privateEndpoint.?service ?? 'topic'}-${index}'
              properties: {
                privateLinkServiceId: namespace.id
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
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(namespace.id, '/'))}-${privateEndpoint.?service ?? 'topic'}-${index}'
              properties: {
                privateLinkServiceId: namespace.id
                groupIds: [
                  privateEndpoint.?service ?? 'topic'
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: privateEndpoint.?enableTelemetry ?? enableTelemetry
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

resource namespace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(namespace.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: namespace
  }
]

module namespace_topics 'topic/main.bicep' = [
  for (topic, index) in (topics ?? []): {
    name: '${uniqueString(deployment().name, location)}-Namespace-Topic-${index}'
    params: {
      name: topic.name
      namespaceName: namespace.name
      eventRetentionInDays: topic.?eventRetentionInDays
      inputSchema: topic.?inputSchema
      publisherType: topic.?publisherType
      roleAssignments: topic.?roleAssignments
      eventSubscriptions: topic.?eventSubscriptions
    }
  }
]

module namespace_caCertificates 'ca-certificate/main.bicep' = [
  for (caCertificate, index) in (caCertificates ?? []): if (topicSpacesState == 'Enabled') {
    name: '${uniqueString(deployment().name, location)}-Namespace-caCertificate-${index}'
    params: {
      name: caCertificate.name
      namespaceName: namespace.name
      description: caCertificate.?description
      encodedCertificate: caCertificate.encodedCertificate
    }
  }
]

module namespace_clients 'client/main.bicep' = [
  for (client, index) in (clients ?? []): if (topicSpacesState == 'Enabled') {
    name: '${uniqueString(deployment().name, location)}-Namespace-Client-${index}'
    params: {
      name: client.name
      namespaceName: namespace.name
      authenticationName: client.?authenticationName
      description: client.?description
      clientCertificateAuthenticationValidationSchema: client.?clientCertificateAuthenticationValidationSchema
      clientCertificateAuthenticationAllowedThumbprints: client.?clientCertificateAuthenticationAllowedThumbprints
      attributes: client.?attributes
      state: client.?state
    }
  }
]

module namespace_clientGroups 'client-group/main.bicep' = [
  for (clientGroup, index) in (clientGroups ?? []): if (topicSpacesState == 'Enabled') {
    name: '${uniqueString(deployment().name, location)}-Namespace-clientGroup-${index}'
    params: {
      name: clientGroup.name
      namespaceName: namespace.name
      query: clientGroup.query
      description: clientGroup.?description
    }
  }
]

module namespace_topicSpaces 'topic-space/main.bicep' = [
  for (topicSpaces, index) in (topicSpaces ?? []): if (topicSpacesState == 'Enabled') {
    name: '${uniqueString(deployment().name, location)}-Namespace-topicSpace-${index}'
    params: {
      name: topicSpaces.name
      namespaceName: namespace.name
      description: topicSpaces.?description
      topicTemplates: topicSpaces.topicTemplates
      roleAssignments: topicSpaces.?roleAssignments
    }
  }
]

module namespace_permissionBindings 'permission-binding/main.bicep' = [
  for (permissionBinding, index) in (permissionBindings ?? []): if (topicSpacesState == 'Enabled') {
    name: '${uniqueString(deployment().name, location)}-Namespace-permissionBinding-${index}'
    params: {
      name: permissionBinding.name
      namespaceName: namespace.name
      description: permissionBinding.?description
      clientGroupName: permissionBinding.clientGroupName
      topicSpaceName: permissionBinding.topicSpaceName
      permission: permissionBinding.permission
    }
    dependsOn: [
      namespace_clientGroups
      namespace_topicSpaces
    ]
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the EventGrid Namespace.')
output resourceId string = namespace.id

@description('The name of the EventGrid Namespace.')
output name string = namespace.name

@description('The location the EventGrid Namespace was deployed into.')
output location string = namespace.location

@description('The name of the resource group the EventGrid Namespace was created in.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = namespace.?identity.?principalId

@sys.description('The Resources IDs of the EventGrid Namespace Topics.')
output topicResourceIds array = [
  for index in range(0, length(topics ?? [])): namespace_topics[index].outputs.resourceId
]
@description('The private endpoints of the EventGrid Namespace.')
output privateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (privateEndpoints ?? []): {
    name: namespace_privateEndpoints[index].outputs.name
    resourceId: namespace_privateEndpoints[index].outputs.resourceId
    groupId: namespace_privateEndpoints[index].outputs.?groupId!
    customDnsConfigs: namespace_privateEndpoints[index].outputs.customDnsConfigs
    networkInterfaceResourceIds: namespace_privateEndpoints[index].outputs.networkInterfaceResourceIds
  }
]

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for a private endpoint output.')
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
