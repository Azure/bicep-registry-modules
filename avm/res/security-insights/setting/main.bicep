metadata name = 'Security Insights Settings'
metadata description = 'This module deploys a Security Insights Setting.'
metadata owner = 'Azure/module-maintainers'

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Required. Name of the Security Insights Setting.')
param name string

@description('Required. The resource ID of the Log Analytics workspace.')
param workspaceResourceId string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Required. Kind of the setting. Must be one of: [Anomalies, EntityAnalytics, EyesOn, Ueba].')
@allowed([
  'Anomalies'
  'EntityAnalytics'
  'EyesOn'
  'Ueba'
])
param settingsType string

@description('Optional. Properties for the Security Insights Setting based on kind.')
param properties object = {}

var builtInRoleNames = {
  'Security Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'fb1c8493-542b-48eb-b624-b4c8fea62acd'
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
  name: '46d3xbcp.res.securityinsights-setting.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: last(split(workspaceResourceId, '/'))
}

resource setting 'Microsoft.SecurityInsights/settings@2024-10-01-preview' = {
  scope: workspace
  name: name
  kind: settingsType
  properties: properties
}

resource settings_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: guid(setting.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.description
      principalType: roleAssignment.principalType
      condition: roleAssignment.condition
      conditionVersion: !empty(roleAssignment.condition) ? (roleAssignment.conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.delegatedManagedIdentityResourceId
    }
    scope: setting
  }
]

@description('The name of the Security Insights Setting.')
output name string = setting.name

@description('The resource ID of the Security Insights Setting.')
output resourceId string = setting.id

@description('The resource group where the Security Insights Setting is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = location
