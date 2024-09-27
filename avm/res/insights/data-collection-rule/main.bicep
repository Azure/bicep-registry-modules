metadata name = 'Data Collection Rules'
metadata description = 'This module deploys a Data Collection Rule.'
metadata owner = 'Azure/module-maintainers'

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

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. The managed identity definition for this resource. Only one type of, and up to one managed identity is supported.')
param managedIdentities managedIdentitiesType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Resource tags.')
param tags object?

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

var dataCollectionRulePropertiesUnion = union(
  {
    description: dataCollectionRuleProperties.?description
  },
  dataCollectionRuleProperties.kind == 'Linux' || dataCollectionRuleProperties.kind == 'Windows' || dataCollectionRuleProperties.kind == 'All'
    ? {
        dataSources: dataCollectionRuleProperties.dataSources
        dataFlows: dataCollectionRuleProperties.dataFlows
        destinations: dataCollectionRuleProperties.destinations
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
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

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2023-03-11' = if (dataCollectionRuleProperties.kind != 'All') {
  kind: dataCollectionRuleProperties.kind
  location: location
  name: name
  tags: tags
  identity: identity
  properties: dataCollectionRulePropertiesUnion
}

// Using a separate resource for parameter kind: 'All' as it requires that the "kind' is not set on the resource and 'kind: null' is not allowed for this resource type
resource dataCollectionRuleAll 'Microsoft.Insights/dataCollectionRules@2023-03-11' = if (dataCollectionRuleProperties.kind == 'All') {
  location: location
  name: name
  tags: tags
  identity: identity
  properties: dataCollectionRulePropertiesUnion
}

// Using a module as a workaround for issues with conditional scope: https://github.com/Azure/bicep/issues/7367
module dataCollectionRule_conditionalScopeResources 'modules/nested_conditionalScope.bicep' = if ((!empty(lock ?? {}) && lock.?kind != 'None') || (!empty(roleAssignments ?? []))) {
  name: '${uniqueString(deployment().name, location)}-DCR-ConditionalScope'
  params: {
    dataCollectionRuleName: dataCollectionRuleProperties.kind == 'All'
      ? dataCollectionRuleAll.name
      : dataCollectionRule.name
    builtInRoleNames: builtInRoleNames
    lock: lock
    roleAssignments: roleAssignments
  }
}

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
  ? dataCollectionRuleAll.location
  : dataCollectionRule.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = dataCollectionRuleProperties.kind == 'All'
  ? dataCollectionRuleAll.?identity.?principalId ?? ''
  : dataCollectionRule.?identity.?principalId ?? ''

// =============== //
//   Definitions   //
// =============== //

import { roleAssignmentType, lockType } from 'modules/nested_conditionalScope.bicep'

type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource. Required if a user assigned identity is used for encryption.')
  userAssignedResourceIds: string[]?
}?

@discriminator('kind')
type dataCollectionRulePropertiesType =
  | linuxDcrPropertiesType
  | windowsDcrPropertiesType
  | allPlatformsDcrPropertiesType
  | agentSettingsDcrPropertiesType

type linuxDcrPropertiesType = {
  @description('Required. The platform type specifies the type of resources this rule can apply to.')
  kind: 'Linux'

  @description('Required. Specification of data sources that will be collected.')
  dataSources: object

  @description('Required. The specification of data flows.')
  dataFlows: array

  @description('Required. Specification of destinations that can be used in data flows.')
  destinations: object

  @description('Optional. The resource ID of the data collection endpoint that this rule can be used with.')
  dataCollectionEndpointResourceId: string?

  @description('Optional. Declaration of custom streams used in this rule.')
  streamDeclarations: object?

  @description('Optional. Description of the data collection rule.')
  description: string?
}

type windowsDcrPropertiesType = {
  @description('Required. The platform type specifies the type of resources this rule can apply to.')
  kind: 'Windows'

  @description('Required. Specification of data sources that will be collected.')
  dataSources: object

  @description('Required. The specification of data flows.')
  dataFlows: array

  @description('Required. Specification of destinations that can be used in data flows.')
  destinations: object

  @description('Optional. The resource ID of the data collection endpoint that this rule can be used with.')
  dataCollectionEndpointResourceId: string?

  @description('Optional. Declaration of custom streams used in this rule.')
  streamDeclarations: object?

  @description('Optional. Description of the data collection rule.')
  description: string?
}

type allPlatformsDcrPropertiesType = {
  @description('Required. The platform type specifies the type of resources this rule can apply to.')
  kind: 'All'

  @description('Required. Specification of data sources that will be collected.')
  dataSources: object

  @description('Required. The specification of data flows.')
  dataFlows: array

  @description('Required. Specification of destinations that can be used in data flows.')
  destinations: object

  @description('Optional. The resource ID of the data collection endpoint that this rule can be used with.')
  dataCollectionEndpointResourceId: string?

  @description('Optional. Declaration of custom streams used in this rule.')
  streamDeclarations: object?

  @description('Optional. Description of the data collection rule.')
  description: string?
}

type agentSettingsDcrPropertiesType = {
  @description('Required. The platform type specifies the type of resources this rule can apply to.')
  kind: 'AgentSettings'

  @description('Optional. Description of the data collection rule.')
  description: string?

  @description('Required. Agent settings used to modify agent behavior on a given host.')
  agentSettings: agentSettingsType
}

type agentSettingsType = {
  @description('Required. All the settings that are applicable to the logs agent (AMA).')
  logs: agentSettingType[]
}

type agentSettingType = {
  @description('Required. The name of the agent setting.')
  name: ('MaxDiskQuotaInMB' | 'UseTimeReceivedForForwardedEvents')

  @description('Required. The value of the agent setting.')
  value: string
}
