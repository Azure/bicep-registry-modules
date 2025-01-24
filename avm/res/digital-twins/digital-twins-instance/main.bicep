metadata name = 'Digital Twins Instances'
metadata description = 'This module deploys an Azure Digital Twins Instance.'

@description('Required. The name of the Digital Twin Instance.')
@minLength(3)
@maxLength(63)
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Resource tags.')
param tags object?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentitiesType

@description('Optional. Event Hub Endpoint.')
param eventHubEndpoints array?

@description('Optional. Event Grid Endpoint.')
param eventGridEndpoints array?

@description('Optional. Service Bus Endpoint.')
param serviceBusEndpoints array?

@description('Optional. Configuration details for private endpoints. For security reasons, it is recommended to use private endpoints whenever possible.')
param privateEndpoints privateEndpointType

@description('Optional. Whether or not public network access is allowed for this resource. For security reasons it should be disabled. If not specified, it will be disabled by default if private endpoints are set.')
@allowed([
  ''
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = ''

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalIds\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

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
  'Azure Digital Twins Data Owner': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'bcd981a7-7f74-457b-83e1-cceb9e632ffe'
  )
  'Azure Digital Twins Data Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'd57506d4-4c8d-48b1-8587-93c323f6a5a3'
  )
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.digitaltwins-digitaltwinsinstance.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource digitalTwinsInstance 'Microsoft.DigitalTwins/digitalTwinsInstances@2023-01-31' = {
  name: name
  location: location
  identity: identity
  tags: tags
  properties: {
    publicNetworkAccess: !empty(publicNetworkAccess)
      ? any(publicNetworkAccess)
      : (!empty(privateEndpoints) ? 'Disabled' : 'Enabled')
  }
}

module digitalTwinsInstance_eventHubEndpoints 'endpoint--event-hub/main.bicep' = [
  for (eventHubEndpoint, index) in (eventHubEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-DigitalTwinsInstance-Endpoints-EventHub-${index}'
    params: {
      digitalTwinInstanceName: digitalTwinsInstance.name
      name: contains(eventHubEndpoint, 'name') ? eventHubEndpoint.name : 'EventHubEndpoint'
      authenticationType: contains(eventHubEndpoint, 'authenticationType')
        ? eventHubEndpoint.authenticationType
        : 'KeyBased'
      connectionStringPrimaryKey: contains(eventHubEndpoint, 'connectionStringPrimaryKey')
        ? eventHubEndpoint.connectionStringPrimaryKey
        : ''
      connectionStringSecondaryKey: contains(eventHubEndpoint, 'connectionStringSecondaryKey')
        ? eventHubEndpoint.connectionStringSecondaryKey
        : ''
      deadLetterSecret: contains(eventHubEndpoint, 'deadLetterSecret') ? eventHubEndpoint.deadLetterSecret : ''
      deadLetterUri: contains(eventHubEndpoint, 'deadLetterUri') ? eventHubEndpoint.deadLetterUri : ''
      endpointUri: contains(eventHubEndpoint, 'endpointUri') ? eventHubEndpoint.endpointUri : ''
      entityPath: contains(eventHubEndpoint, 'entityPath') ? eventHubEndpoint.entityPath : ''
      managedIdentities: contains(eventHubEndpoint, 'managedIdentities') ? eventHubEndpoint.managedIdentities : {}
    }
  }
]

module digitalTwinsInstance_eventGridEndpoints 'endpoint--event-grid/main.bicep' = [
  for (eventGridEndpoint, index) in (eventGridEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-DigitalTwinsInstance-Endpoints-EventGrid-${index}'
    params: {
      digitalTwinInstanceName: digitalTwinsInstance.name
      name: contains(eventGridEndpoint, 'name') ? eventGridEndpoint.name : 'EventGridEndpoint'
      topicEndpoint: contains(eventGridEndpoint, 'topicEndpoint') ? eventGridEndpoint.topicEndpoint : ''
      deadLetterSecret: contains(eventGridEndpoint, 'deadLetterSecret') ? eventGridEndpoint.deadLetterSecret : ''
      deadLetterUri: contains(eventGridEndpoint, 'deadLetterUri') ? eventGridEndpoint.deadLetterUri : ''
      eventGridDomainResourceId: contains(eventGridEndpoint, 'eventGridDomainId')
        ? eventGridEndpoint.eventGridDomainId
        : ''
    }
  }
]

module digitalTwinsInstance_serviceBusEndpoints 'endpoint--service-bus/main.bicep' = [
  for (serviceBusEndpoint, index) in (serviceBusEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-DigitalTwinsInstance-Endpoints-ServiceBus-${index}'
    params: {
      digitalTwinInstanceName: digitalTwinsInstance.name
      name: contains(serviceBusEndpoint, 'name') ? serviceBusEndpoint.name : 'ServiceBusEndpoint'
      authenticationType: contains(serviceBusEndpoint, 'authenticationType')
        ? serviceBusEndpoint.authenticationType
        : ''
      deadLetterSecret: contains(serviceBusEndpoint, 'deadLetterSecret') ? serviceBusEndpoint.deadLetterSecret : ''
      deadLetterUri: contains(serviceBusEndpoint, 'deadLetterUri') ? serviceBusEndpoint.deadLetterUri : ''
      endpointUri: contains(serviceBusEndpoint, 'endpointUri') ? serviceBusEndpoint.endpointUri : ''
      entityPath: contains(serviceBusEndpoint, 'entityPath') ? serviceBusEndpoint.entityPath : ''
      primaryConnectionString: contains(serviceBusEndpoint, 'primaryConnectionString')
        ? serviceBusEndpoint.primaryConnectionString
        : ''
      secondaryConnectionString: contains(serviceBusEndpoint, 'secondaryConnectionString')
        ? serviceBusEndpoint.secondaryConnectionString
        : ''
      managedIdentities: contains(serviceBusEndpoint, 'managedIdentities') ? serviceBusEndpoint.managedIdentities : {}
    }
  }
]

module digitalTwinsInstance_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.4.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): {
    name: '${uniqueString(deployment().name, location)}-digitalTwinsInstance-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(digitalTwinsInstance.id, '/'))}-${privateEndpoint.?service ?? 'API'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(digitalTwinsInstance.id, '/'))}-${privateEndpoint.?service ?? 'API'}-${index}'
              properties: {
                privateLinkServiceId: digitalTwinsInstance.id
                groupIds: [
                  privateEndpoint.?service ?? 'API'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(digitalTwinsInstance.id, '/'))}-${privateEndpoint.?service ?? 'API'}-${index}'
              properties: {
                privateLinkServiceId: digitalTwinsInstance.id
                groupIds: [
                  privateEndpoint.?service ?? 'API'
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
      privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
      privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

resource digitalTwinsInstance_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: digitalTwinsInstance
}

resource digitalTwinsInstance_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: digitalTwinsInstance
  }
]

resource digitalTwinsInstance_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(digitalTwinsInstance.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
        ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
        : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
            ? roleAssignment.roleDefinitionIdOrName
            : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: digitalTwinsInstance
  }
]

@description('The resource ID of the Digital Twins Instance.')
output resourceId string = digitalTwinsInstance.id

@description('The name of the resource group the resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the Digital Twins Instance.')
output name string = digitalTwinsInstance.name

@description('The hostname of the Digital Twins Instance.')
output hostname string = digitalTwinsInstance.properties.hostName

@description('The location the resource was deployed into.')
output location string = digitalTwinsInstance.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = digitalTwinsInstance.?identity.?principalId ?? ''

// =============== //
//   Definitions   //
// =============== //

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

  @description('Optional. The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided.')
  privateDnsZoneGroupName: string?

  @description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

  @description('Optional. If Manual Private Link Connection is required.')
  isManualConnection: bool?

  @description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
  @maxLength(140)
  manualConnectionRequestMessage: string?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    @description('Optional. FQDN that resolves to private endpoint IP address.')
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

  @description('Optional. Specify if you want to deploy the Privte Endpoint into a different resource group than the main resource.')
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
