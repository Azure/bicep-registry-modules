metadata name = 'Metric Alerts'
metadata description = 'This module deploys a Metric Alert.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the alert.')
param name string

@description('Optional. Description of the alert.')
param alertDescription string = ''

@description('Optional. Location for all resources.')
param location string = 'global'

@description('Optional. Indicates whether this alert is enabled.')
param enabled bool = true

@description('Optional. The severity of the alert.')
@allowed([
  0
  1
  2
  3
  4
])
param severity int = 3

@description('Optional. how often the metric alert is evaluated represented in ISO 8601 duration format.')
@allowed([
  'PT1M'
  'PT5M'
  'PT15M'
  'PT30M'
  'PT1H'
])
param evaluationFrequency string = 'PT5M'

@description('Optional. the period of time (in ISO 8601 duration format) that is used to monitor alert activity based on the threshold.')
@allowed([
  'PT1M'
  'PT5M'
  'PT15M'
  'PT30M'
  'PT1H'
  'PT6H'
  'PT12H'
  'P1D'
])
param windowSize string = 'PT15M'

@description('Optional. the list of resource IDs that this metric alert is scoped to.')
param scopes array = [
  subscription().id
]

@description('Conditional. The resource type of the target resource(s) on which the alert is created/updated. Required if alertCriteriaType is MultipleResourceMultipleMetricCriteria.')
param targetResourceType string = ''

@description('Conditional. The region of the target resource(s) on which the alert is created/updated. Required if alertCriteriaType is MultipleResourceMultipleMetricCriteria.')
param targetResourceRegion string = ''

@description('Optional. The flag that indicates whether the alert should be auto resolved or not.')
param autoMitigate bool = true

@description('Optional. The list of actions to take when alert triggers.')
param actions array = []

@description('Optional. Maps to the \'odata.type\' field. Specifies the type of the alert criteria.')
@allowed([
  'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria'
  'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'
  'Microsoft.Azure.Monitor.WebtestLocationAvailabilityCriteria'
])
param alertCriteriaType string = 'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria'

@description('Required. Criterias to trigger the alert. Array of \'Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria\' or \'Microsoft.Azure.Monitor.MultipleResourceMultipleMetricCriteria\' objects. When using MultipleResourceMultipleMetricCriteria criteria type, some parameters becomes mandatory. It is not possible to convert from SingleResourceMultipleMetricCriteria to MultipleResourceMultipleMetricCriteria. The alert must be deleted and recreated.')
param criterias array

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var actionGroups = [
  for action in actions: {
    actionGroupId: contains(action, 'actionGroupId') ? action.actionGroupId : action
    webHookProperties: contains(action, 'webHookProperties') ? action.webHookProperties : null
  }
]

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
    name: '46d3xbcp.res.insights-metricalert.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource metricAlert 'Microsoft.Insights/metricAlerts@2018-03-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    description: alertDescription
    severity: severity
    enabled: enabled
    scopes: scopes
    evaluationFrequency: evaluationFrequency
    windowSize: windowSize
    targetResourceType: targetResourceType
    targetResourceRegion: targetResourceRegion
    criteria: {
      'odata.type': any(alertCriteriaType)
      allOf: criterias
    }
    autoMitigate: autoMitigate
    actions: actionGroups
  }
}

resource metricAlert_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(metricAlert.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
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
    scope: metricAlert
  }
]

@description('The resource group the metric alert was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the metric alert.')
output name string = metricAlert.name

@description('The resource ID of the metric alert.')
output resourceId string = metricAlert.id

@description('The location the resource was deployed into.')
output location string = metricAlert.location
// =============== //
//   Definitions   //
// =============== //

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
