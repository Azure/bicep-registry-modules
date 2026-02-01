metadata name = 'Data Collection Rules'
metadata description = 'This module deploys a Data Collection Rule.'

// ============== //
//   Parameters   //
// ============== //

@description('Required. The name of the data collection rule. The name is case insensitive.')
param name string

@description('Required. The kind of data collection rule.')
param dataCollectionRuleProperties dataCollectionRulePropertiesType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Resource tags.')
param tags resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.tags?

// =============== //
//   Deployments   //
// =============== //

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
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
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

var dataCollectionRulePropertiesUnion = union(
  {
    description: dataCollectionRuleProperties.?description
  },
  contains(['Linux', 'Windows', 'All', 'PlatformTelemetry', 'AgentDirectToStore'], dataCollectionRuleProperties.kind)
    ? {
        dataSources: dataCollectionRuleProperties.dataSources
      }
    : {},
  contains(
      ['Linux', 'Windows', 'All', 'Direct', 'WorkspaceTransforms', 'PlatformTelemetry', 'AgentDirectToStore'],
      dataCollectionRuleProperties.kind
    )
    ? {
        dataFlows: dataCollectionRuleProperties.dataFlows
        destinations: dataCollectionRuleProperties.destinations
      }
    : {},
  contains(['Linux', 'Windows', 'All', 'Direct', 'WorkspaceTransforms'], dataCollectionRuleProperties.kind)
    ? {
        dataCollectionEndpointId: dataCollectionRuleProperties.?dataCollectionEndpointResourceId
        streamDeclarations: dataCollectionRuleProperties.?streamDeclarations
      }
    : {},
  dataCollectionRuleProperties.kind == 'AgentSettings'
    ? {
        agentSettings: dataCollectionRuleProperties.agentSettings
      }
    : {}
)

var enableReferencedModulesTelemetry = false

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.insights-datacollectionrule.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2024-03-11' = if (dataCollectionRuleProperties.kind != 'All') {
  kind: dataCollectionRuleProperties.kind
  location: location
  name: name
  tags: tags
  identity: identity
  properties: dataCollectionRulePropertiesUnion
}

// Using a separate resource for parameter kind: 'All' as it requires that the "kind' is not set on the resource and 'kind: null' is not allowed for this resource type
resource dataCollectionRuleAll 'Microsoft.Insights/dataCollectionRules@2024-03-11' = if (dataCollectionRuleProperties.kind == 'All') {
  location: location
  name: name
  tags: tags
  identity: identity
  properties: dataCollectionRulePropertiesUnion
}

// Using a module as a workaround for issues with conditional scope: https://github.com/Azure/bicep/issues/7367
module dataCollectionRule_conditionalScopeLock 'modules/nested_lock.bicep' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: '${uniqueString(deployment().name, location)}-DCR-Lock'
  params: {
    dataCollectionRuleName: dataCollectionRuleProperties.kind == 'All'
      ? dataCollectionRuleAll.name
      : dataCollectionRule.name
    lock: lock
  }
}

module dataCollectionRule_roleAssignments 'br/public:avm/ptn/authorization/resource-role-assignment:0.1.2' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: '${uniqueString(deployment().name, location)}-DCR-RoleAssignments-${index}'
    params: {
      resourceId: dataCollectionRuleProperties.kind == 'All' ? dataCollectionRuleAll.id : dataCollectionRule.id
      name: roleAssignment.?name
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      enableTelemetry: enableReferencedModulesTelemetry
    }
  }
]

// =========== //
//   Outputs   //
// =========== //

@description('The name of the dataCollectionRule.')
output name string = dataCollectionRuleProperties.kind == 'All' ? dataCollectionRuleAll.name : dataCollectionRule.name

@description('The resource ID of the dataCollectionRule.')
output resourceId string = dataCollectionRuleProperties.kind == 'All' ? dataCollectionRuleAll.id : dataCollectionRule.id

@description('The name of the resource group the dataCollectionRule was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = dataCollectionRuleProperties.kind == 'All'
  ? dataCollectionRuleAll!.location
  : dataCollectionRule!.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = dataCollectionRuleProperties.kind == 'All'
  ? dataCollectionRuleAll.?identity.?principalId
  : dataCollectionRule.?identity.?principalId

@description('The endpoints of the dataCollectionRule, if created.')
output endpoints resourceOutput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.endpoints? = dataCollectionRuleProperties.kind == 'All'
  ? dataCollectionRuleAll!.properties.?endpoints
  : dataCollectionRule!.properties.?endpoints

@description('The ImmutableId of the dataCollectionRule.')
output immutableId string? = dataCollectionRuleProperties.kind == 'All'
  ? dataCollectionRuleAll!.properties.?immutableId
  : dataCollectionRule!.properties.?immutableId

// =============== //
//   Definitions   //
// =============== //

@export()
@discriminator('kind')
@description('Required. The type for data collection rule properties. Depending on the kind, the properties will be different.')
type dataCollectionRulePropertiesType =
  | linuxDcrPropertiesType
  | windowsDcrPropertiesType
  | allPlatformsDcrPropertiesType
  | agentSettingsDcrPropertiesType
  | directDcrPropertiesType
  | agentDirectToStoreType
  | workspaceTransformsDcrPropertiesType
  | platformTelemetryDcrPropertiesType

@description('The type for the properties of the \'Linux\' data collection rule.')
type linuxDcrPropertiesType = {
  @description('Required. The kind of the resource.')
  kind: 'Linux'

  @description('Required. Specification of data sources that will be collected.')
  dataSources: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.dataSources

  @description('Required. The specification of data flows.')
  dataFlows: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.dataFlows

  @description('Required. Specification of destinations that can be used in data flows.')
  destinations: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.destinations

  @description('Optional. The resource ID of the data collection endpoint that this rule can be used with.')
  dataCollectionEndpointResourceId: string?

  @description('Optional. Declaration of custom streams used in this rule.')
  streamDeclarations: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.streamDeclarations?

  @description('Optional. Description of the data collection rule.')
  description: string?
}

@description('The type for the properties of the \'Windows\' data collection rule.')
type windowsDcrPropertiesType = {
  @description('Required. The kind of the resource.')
  kind: 'Windows'

  @description('Required. Specification of data sources that will be collected.')
  dataSources: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.dataSources

  @description('Required. The specification of data flows.')
  dataFlows: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.dataFlows

  @description('Required. Specification of destinations that can be used in data flows.')
  destinations: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.destinations

  @description('Optional. The resource ID of the data collection endpoint that this rule can be used with.')
  dataCollectionEndpointResourceId: string?

  @description('Optional. Declaration of custom streams used in this rule.')
  streamDeclarations: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.streamDeclarations?

  @description('Optional. Description of the data collection rule.')
  description: string?
}

@description('The type for the properties of the data collection rule of the kind \'All\'.')
type allPlatformsDcrPropertiesType = {
  @description('Required. The kind of the resource.')
  kind: 'All'

  @description('Required. Specification of data sources that will be collected.')
  dataSources: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.dataSources

  @description('Required. The specification of data flows.')
  dataFlows: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.dataFlows

  @description('Required. Specification of destinations that can be used in data flows.')
  destinations: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.destinations

  @description('Optional. The resource ID of the data collection endpoint that this rule can be used with.')
  dataCollectionEndpointResourceId: string?

  @description('Optional. Declaration of custom streams used in this rule.')
  streamDeclarations: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.streamDeclarations?

  @description('Optional. Description of the data collection rule.')
  description: string?
}

@description('The type for the properties of the \'AgentSettings\' data collection rule.')
type agentSettingsDcrPropertiesType = {
  @description('Required. The kind of the resource.')
  kind: 'AgentSettings'

  @description('Optional. Description of the data collection rule.')
  description: string?

  @description('Required. Agent settings used to modify agent behavior on a given host.')
  agentSettings: agentSettingsType
}

@description('The type for the agent settings.')
type agentSettingsType = {
  @description('Required. All the settings that are applicable to the logs agent (AMA).')
  logs: agentSettingType[]
}

@description('The type for the (single) agent setting.')
type agentSettingType = {
  @description('Required. The name of the agent setting.')
  name: ('MaxDiskQuotaInMB' | 'UseTimeReceivedForForwardedEvents')

  @description('Required. The value of the agent setting.')
  value: string
}

@description('The type for the properties of the \'Direct\' data collection rule.')
type directDcrPropertiesType = {
  @description('Required. The kind of the resource.')
  kind: 'Direct'

  @description('Required. The specification of data flows.')
  dataFlows: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.dataFlows

  @description('Required. Specification of destinations that can be used in data flows.')
  destinations: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.destinations

  @description('Optional. The resource ID of the data collection endpoint that this rule can be used with.')
  dataCollectionEndpointResourceId: string?

  @description('Required. Declaration of custom streams used in this rule.')
  streamDeclarations: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.streamDeclarations

  @description('Optional. Description of the data collection rule.')
  description: string?
}

@description('The type for the properties of the \'AgentDirectToStore\' data collection rule.')
type agentDirectToStoreType = {
  @description('Required. The platform type specifies the type of resources this rule can apply to.')
  kind: 'AgentDirectToStore'

  @description('Required. Specification of data sources that will be collected.')
  dataSources: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.dataSources

  @description('Required. The specification of data flows.')
  dataFlows: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.dataFlows

  @description('Required. Specification of destinations that can be used in data flows.')
  destinations: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.destinations

  @description('Optional. Description of the data collection rule.')
  description: string?
}

@description('The type for the properties of the \'WorkspaceTransforms\' data collection rule.')
type workspaceTransformsDcrPropertiesType = {
  @description('Required. The kind of the resource.')
  kind: 'WorkspaceTransforms'

  @description('Required. The specification of data flows. Should include a separate dataflow for each table that will have a transformation. Use a where clause in the query if only certain records should be transformed.')
  dataFlows: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.dataFlows

  @description('Required. Specification of destinations that can be used in data flows. For WorkspaceTransforms, only one Log Analytics workspace destination is supported.')
  destinations: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.destinations

  @description('Optional. Description of the data collection rule.')
  description: string?
}

@description('The type for the properties of the \'PlatformTelemetry\' data collection rule.')
type platformTelemetryDcrPropertiesType = {
  @description('Required. The kind of the resource.')
  kind: 'PlatformTelemetry'

  @description('Optional. Description of the data collection rule.')
  description: string?

  @description('Required. Specification of data sources that will be collected.')
  dataSources: {
    @description('Required. The list of platform telemetry configurations.')
    platformTelemetry: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.dataSources.platformTelemetry
  }

  @description('Required. Specification of destinations. Choose a single destination type of either logAnalytics, storageAccounts, or eventHubs.')
  destinations: {
    @description('Optional. The list of Log Analytics destinations.')
    logAnalytics: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.destinations.logAnalytics?

    @description('Optional. The list of Storage Account destinations.')
    storageAccounts: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.destinations.storageAccounts?

    @description('Optional. The list of Event Hub destinations.')
    eventHubs: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.destinations.eventHubs?
  }

  @description('Required. The specification of data flows.')
  dataFlows: resourceInput<'Microsoft.Insights/dataCollectionRules@2024-03-11'>.properties.dataFlows
}
