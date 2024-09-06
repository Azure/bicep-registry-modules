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

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Resource tags.')
param tags object?

// =============== //
//   Deployments   //
// =============== //

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
  properties: dataCollectionRulePropertiesUnion
}

// Using a separate resource for parameter kind: 'All' as it requires that the "kind' is not set on the resource and 'kind: null' is not allowed for this resource type
resource dataCollectionRuleAll 'Microsoft.Insights/dataCollectionRules@2023-03-11' = if (dataCollectionRuleProperties.kind == 'All') {
  location: location
  name: name
  tags: tags
  properties: dataCollectionRulePropertiesUnion
}

// Using a module as a workaround for issues with conditional scope: https://github.com/Azure/bicep/issues/7367
module dataCollectionRule_lock 'modules/nested_lock.bicep' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: '${uniqueString(deployment().name, location)}-DCR-Lock'
  params: {
    lock: lock
    dataCollectionRuleName: dataCollectionRuleProperties.kind == 'All'
      ? dataCollectionRuleAll.name
      : dataCollectionRule.name
  }
}

// Using a module as a workaround for issues with conditional scope: https://github.com/Azure/bicep/issues/7367
module dataCollectionRule_roleAssignments 'modules/nested_roleAssignments.bicep' = if (!empty(roleAssignments ?? [])) {
  name: '${uniqueString(deployment().name, location)}-DCR-RoleAssignments'
  params: {
    roleAssignments: roleAssignments
    dataCollectionRuleName: dataCollectionRuleProperties.kind == 'All'
      ? dataCollectionRuleAll.name
      : dataCollectionRule.name
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

// =============== //
//   Definitions   //
// =============== //

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
