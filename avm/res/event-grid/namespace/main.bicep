metadata name = 'Event Grid Namespaces'
metadata description = 'This module deploys an Event Grid Namespace.'
metadata owner = 'Azure/module-maintainers'

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

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

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

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

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

module namespace_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.7.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-namespace-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
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
output systemAssignedMIPrincipalId string = namespace.?identity.?principalId ?? ''

@sys.description('The Resources IDs of the EventGrid Namespace Topics.')
output topicResourceIds array = [
  for index in range(0, length(topics ?? [])): namespace_topics[index].outputs.resourceId
]

@description('The private endpoints of the EventGrid Namespace.')
output privateEndpoints array = [
  for (pe, i) in (!empty(privateEndpoints) ? array(privateEndpoints) : []): {
    name: namespace_privateEndpoints[i].outputs.name
    resourceId: namespace_privateEndpoints[i].outputs.resourceId
    groupId: namespace_privateEndpoints[i].outputs.groupId
    customDnsConfig: namespace_privateEndpoints[i].outputs.customDnsConfig
    networkInterfaceIds: namespace_privateEndpoints[i].outputs.networkInterfaceIds
  }
]

// ================ //
// Definitions      //
// ================ //
//
type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]?
}?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type privateEndpointType = {
  @description('Optional. The name of the private endpoint.')
  name: string?

  @description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @description('Optional. The name of the private link connection to create.')
  privateLinkServiceConnectionName: string?

  @description('Optional. The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".')
  service: string?

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The private DNS zone group to configure for the private endpoint.')
  privateDnsZoneGroup: {
    @description('Optional. The name of the Private DNS Zone Group.')
    name: string?

    @description('Required. The private DNS zone groups to associate the private endpoint. A DNS zone group can support up to 5 DNS zones.')
    privateDnsZoneGroupConfigs: {
      @description('Optional. The name of the private DNS zone group config.')
      name: string?

      @description('Required. The resource id of the private DNS zone.')
      privateDnsZoneResourceId: string
    }[]
  }?

  @description('Optional. If Manual Private Link Connection is required.')
  isManualConnection: bool?

  @description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
  @maxLength(140)
  manualConnectionRequestMessage: string?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    @description('Required. Fqdn that resolves to private endpoint IP address.')
    fqdn: string?

    @description('Required. A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]?

  @description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    @description('Required. The name of the resource that is unique within a resource group.')
    name: string

    @description('Required. Properties of private endpoint IP configurations.')
    properties: {
      @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
      groupId: string

      @description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.')
      memberName: string

      @description('Required. A private IP address obtained from the private endpoint\'s subnet.')
      privateIPAddress: string
    }
  }[]?

  @description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @description('Optional. Specify the type of lock.')
  lock: lockType

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?

  @description('Optional. Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.')
  resourceGroupName: string?
}[]?

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?
