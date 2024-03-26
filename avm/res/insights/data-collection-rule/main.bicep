metadata name = 'Data Collection Rules'
metadata description = 'This module deploys a Data Collection Rule.'
metadata owner = 'Azure/module-maintainers'

// ============== //
//   Parameters   //
// ============== //

@sys.description('Required. The name of the data collection rule. The name is case insensitive.')
param name string

@sys.description('Optional. The resource ID of the data collection endpoint that this rule can be used with.')
param dataCollectionEndpointId string?

@sys.description('Required. The specification of data flows.')
param dataFlows array

@sys.description('Required. Specification of data sources that will be collected.')
param dataSources object

@sys.description('Optional. Description of the data collection rule.')
param description string?

@sys.description('Required. Specification of destinations that can be used in data flows.')
param destinations object

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@sys.description('Optional. The kind of the resource.')
@allowed([
  'Linux'
  'Windows'
])
param kind string = 'Linux'

@sys.description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@sys.description('Optional. The lock settings of the service.')
param lock lockType

@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@sys.description('Optional. Declaration of custom streams used in this rule.')
param streamDeclarations object?

@sys.description('Optional. Resource tags.')
param tags object?

// =============== //
//   Deployments   //
// =============== //

var builtInRoleNames = {
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

resource avmTelemetry 'Microsoft.Resources/deployments@2023-07-01' =
  if (enableTelemetry) {
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

resource dataCollectionRule 'Microsoft.Insights/dataCollectionRules@2021-09-01-preview' = {
  kind: kind
  location: location
  name: name
  tags: tags
  properties: {
    dataSources: dataSources
    destinations: destinations
    dataFlows: dataFlows
    dataCollectionEndpointId: dataCollectionEndpointId
    streamDeclarations: streamDeclarations
    description: description
  }
}

resource dataCollectionRule_lock 'Microsoft.Authorization/locks@2020-05-01' =
  if (!empty(lock ?? {}) && lock.?kind != 'None') {
    name: lock.?name ?? 'lock-${name}'
    properties: {
      level: lock.?kind ?? ''
      notes: lock.?kind == 'CanNotDelete'
        ? 'Cannot delete resource or child resources.'
        : 'Cannot delete or modify the resource or child resources.'
    }
    scope: dataCollectionRule
  }

resource dataCollectionRule_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(dataCollectionRule.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
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
    scope: dataCollectionRule
  }
]

// =========== //
//   Outputs   //
// =========== //

@sys.description('The name of the dataCollectionRule.')
output name string = dataCollectionRule.name

@sys.description('The resource ID of the dataCollectionRule.')
output resourceId string = dataCollectionRule.id

@sys.description('The name of the resource group the dataCollectionRule was created in.')
output resourceGroupName string = resourceGroup().name

@sys.description('The location the resource was deployed into.')
output location string = dataCollectionRule.location

// =============== //
//   Definitions   //
// =============== //

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
