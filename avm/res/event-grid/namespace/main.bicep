metadata name = 'Event Grid Namespaces'
metadata description = 'This module deploys an Event Grid Namespace.'
metadata owner = 'Azure/module-maintainers'

@minLength(3)
@maxLength(50)
@description('Required. Name of the Event Grid Namespace to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@sys.description('Optional. Resource tags.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Allows the user to specify if the namespace resource supports zone-redundancy capability or not. If this property is not specified explicitly by the user, its default value depends on the following conditions: a. For Availability Zones enabled regions - The default property value would be true. b. For non-Availability Zones enabled regions - The default property value would be false. Once specified, this property cannot be updated.')
param isZoneRedundant bool = false

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. All namespace topics to create.')
param topics array?

var formattedUserAssignedIdentities = reduce(map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next)) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities) ? {
  type: (managedIdentities.?systemAssigned ?? false) ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned') : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
  userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
} : null

var builtInRoleNames = {
  'Azure Resource Notifications System Topics Subscriber': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '0b962ed2-6d56-471c-bd5f-3477d83a7ba4')
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'EventGrid Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1e241071-0855-49ea-94dc-649edcd759de')
  'EventGrid Data Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '1d8c3fe3-8864-474b-8749-01e3783e8157')
  'EventGrid Data Receiver': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '78cbd9e7-9798-4e2e-9b5a-547d9ebb31fb')
  'EventGrid Data Sender': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'd5a91429-5739-47e2-a06b-3470a27159e7')
  'EventGrid EventSubscription Contributor': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '428e0ff0-5e57-4d9c-a221-2c70d0e0a443')
  'EventGrid EventSubscription Reader': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '2414bbcf-6497-4faf-8c65-045460748405')
  'EventGrid TopicSpaces Publisher': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'a12b0b94-b317-4dcd-84a8-502ce99884c6')
  'EventGrid TopicSpaces Subscriber': subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '4b0f2fd7-60b4-4eca-896f-4435034f8bf5')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
}

// ============== //
// Resources      //
// ============== //

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' = if (enableTelemetry) {
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
  properties: {}
}

resource namespace_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot delete or modify the resource or child resources.'
  }
  scope: namespace
}

resource namespace_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
  name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
  properties: {
    storageAccountId: diagnosticSetting.?storageAccountResourceId
    workspaceId: diagnosticSetting.?workspaceResourceId
    eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
    eventHubName: diagnosticSetting.?eventHubName
    metrics: [for group in (diagnosticSetting.?metricCategories ?? [ { category: 'AllMetrics' } ]): {
      category: group.category
      enabled: group.?enabled ?? true
      timeGrain: null
    }]
    logs: [for group in (diagnosticSetting.?logCategoriesAndGroups ?? [ { categoryGroup: 'allLogs' } ]): {
      categoryGroup: group.?categoryGroup
      category: group.?category
      enabled: group.?enabled ?? true
    }]
    marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
    logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
  }
  scope: namespace
}]

module namespace_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.4.1' = [for (privateEndpoint, index) in (privateEndpoints ?? []): {
  name: '${uniqueString(deployment().name, location)}-namespace-PrivateEndpoint-${index}'
  params: {
    name: privateEndpoint.?name ?? 'pep-${last(split(namespace.id, '/'))}-${privateEndpoint.?service ?? 'topic'}-${index}'
    privateLinkServiceConnections: privateEndpoint.?manualPrivateLinkServiceConnections != true ? [
      {
        name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(namespace.id, '/'))}-${privateEndpoint.?service ?? 'topic'}-${index}'
        properties: {
          privateLinkServiceId: namespace.id
          groupIds: [
            privateEndpoint.?service ?? 'topic'
          ]
        }
      }
    ] : null
    manualPrivateLinkServiceConnections: privateEndpoint.?manualPrivateLinkServiceConnections == true ? [
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
    ] : null
    subnetResourceId: privateEndpoint.subnetResourceId
    enableTelemetry: privateEndpoint.?enableTelemetry ?? enableTelemetry
    location: privateEndpoint.?location ?? reference(split(privateEndpoint.subnetResourceId, '/subnets/')[0], '2020-06-01', 'Full').location
    lock: privateEndpoint.?lock ?? lock
    privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
    privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
    roleAssignments: privateEndpoint.?roleAssignments
    tags: privateEndpoint.?tags ?? tags
    customDnsConfigs: privateEndpoint.?customDnsConfigs
    ipConfigurations: privateEndpoint.?ipConfigurations
    applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
    customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
  }
}]

resource namespace_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for (roleAssignment, index) in (roleAssignments ?? []): {
  name: guid(namespace.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
  properties: {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName) ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName] : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/') ? roleAssignment.roleDefinitionIdOrName : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
    principalId: roleAssignment.principalId
    description: roleAssignment.?description
    principalType: roleAssignment.?principalType
    condition: roleAssignment.?condition
    conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
    delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
  }
  scope: namespace
}]

module namespace_topics 'topic/main.bicep' = [for (topic, index) in (topics ?? []): {
  name: '${uniqueString(deployment().name, location)}-Namespace-Topic-${index}'
  params: {
    name: topic.name
    namespaceName: namespace.name
    eventRetentionInDays: topic.?eventRetentionInDays
    inputSchema: topic.?inputSchema
    publisherType: topic.?publisherType
    roleAssignments: topic.?roleAssignments
  }
}]

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the resource.')
output resourceId string = namespace.id

@description('The name of the resource.')
output name string = namespace.name

@description('The location the resource was deployed into.')
output location string = namespace.location

@sys.description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = namespace.?identity.?principalId ?? ''

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
  @sys.description('Optional. Specify the name of lock.')
  name: string?

  @sys.description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @sys.description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @sys.description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @sys.description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @sys.description('Optional. The description of the role assignment.')
  description: string?

  @sys.description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @sys.description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @sys.description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type privateEndpointType = {
  @sys.description('Optional. The name of the private endpoint.')
  name: string?

  @sys.description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @sys.description('Optional. The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".')
  service: string?

  @sys.description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @sys.description('Optional. The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided.')
  privateDnsZoneGroupName: string?

  @sys.description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

  @sys.description('Optional. If Manual Private Link Connection is required.')
  isManualConnection: bool?

  @sys.description('Optional. A message passed to the owner of the remote resource with the manual connection request. Restricted to 140 chars.')
  manualConnectionRequestMessage: string?

  @sys.description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    @sys.description('Required. Fqdn that resolves to private endpoint IP address.')
    fqdn: string?

    @sys.description('Required. A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]?

  @sys.description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    @sys.description('Required. The name of the resource that is unique within a resource group.')
    name: string

    @sys.description('Required. Properties of private endpoint IP configurations.')
    properties: {
      @sys.description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
      groupId: string

      @sys.description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.')
      memberName: string

      @sys.description('Required. A private IP address obtained from the private endpoint\'s subnet.')
      privateIPAddress: string
    }
  }[]?

  @sys.description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @sys.description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @sys.description('Optional. Specify the type of lock.')
  lock: lockType

  @sys.description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @sys.description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @sys.description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?
}[]?

type diagnosticSettingType = {
  @sys.description('Optional. The name of diagnostic setting.')
  name: string?

  @sys.description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @sys.description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @sys.description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @sys.description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @sys.description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
  metricCategories: {
    @sys.description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @sys.description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @sys.description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @sys.description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @sys.description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @sys.description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @sys.description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @sys.description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?
