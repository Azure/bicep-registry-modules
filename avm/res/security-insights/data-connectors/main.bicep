metadata name = 'Security Insights Data Connectors'
metadata description = 'This module deploys a Security Insights Data Connector.'
metadata owner = 'Azure/module-maintainers'

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'

@description('Required. Name of the Security Insights Data Connector.')
param name string

@description('Required. The resource ID of the Log Analytics workspace.')
param workspaceResourceId string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Enable telemetry via a Globally Unique Identifier (GUID).')
param enableDefaultTelemetry bool = true

@description('Required. Kind of the Data Connector.')
@allowed([
  'AmazonWebServicesCloudTrail'
  'AzureActiveDirectory'
  'AzureActiveDirectoryIdentityProtection'
  'AzureSecurityCenter'
  'MicrosoftCloudAppSecurity'
  'MicrosoftDefenderAdvancedThreatProtection'
  'MicrosoftThreatIntelligence'
  'Office365'
  'PremiumMicrosoftDefenderForThreatIntelligence'
  'RestApiPoller'
  'ThreatIntelligence'
])
param kind string

@description('Optional. Properties for the Data Connector based on kind.')
param properties object = {}

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

var builtInRoleNames = {
  'Security Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'fb1c8493-542b-48eb-b624-b4c8fea62acd'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
      ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
      : roleAssignment.roleDefinitionIdOrName
  })
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-11-01' = if (enableDefaultTelemetry) {
  name: '46d3xbcp.res.security-insights-dataconnectors.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
    }
  }
}

resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' existing = {
  name: last(split(workspaceResourceId, '/'))
}

resource dataConnector 'Microsoft.SecurityInsights/dataConnectors@2024-10-01-preview' = {
  scope: workspace
  name: name
  kind: kind
  properties: properties
}

@description('The name of the Security Insights Data Connector.')
output name string = dataConnector.name

@description('The resource ID of the Security Insights Data Connector.')
output resourceId string = dataConnector.id

@description('The resource group where the Security Insights Data Connector is deployed.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = location

resource dataConnector_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: guid(dataConnector.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.description
      principalType: roleAssignment.principalType
      condition: roleAssignment.condition
      conditionVersion: !empty(roleAssignment.condition) ? (roleAssignment.conditionVersion ?? '2.0') : null
      delegatedManagedIdentityResourceId: roleAssignment.delegatedManagedIdentityResourceId
    }
    scope: dataConnector
  }
]
