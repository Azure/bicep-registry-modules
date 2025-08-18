targetScope = 'subscription'

// This module supports both subscription and resource group scope deployments
// Use the deploymentScope parameter to specify which scope to use
metadata name = 'Microsoft Edge Site'
metadata description = 'This module deploys a Microsoft Edge Site at subscription or resource group scope.'

// ============== //
//   Parameters   //
// ============== //

@description('Optional. The scope at which to deploy the module. Valid values are "subscription" or "resourceGroup".')
@allowed(['subscription', 'resourceGroup'])
param deploymentScope string = 'resourceGroup'

@description('Required. Name of the resource to create.')
param name string

@description('Required. Location for all Resources.')
param location string

@description('Conditional. Name of the resource group. Required if deploymentScope is "resourceGroup".')
param resourceGroupName string?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The description of the site.')
param siteDescription string?

@description('Required. The display name of the site.')
param displayName string

@description('Optional. Labels for the site.')
param labels resourceInput<'Microsoft.Edge/sites@2025-06-01'>.properties.labels?

@description('Required. The physical address configuration of the site.')
param siteAddress resourceInput<'Microsoft.Edge/sites@2025-06-01'>.properties.siteAddress

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

// ============== //
// Resources      //
// ============== //

// Create resource group when deploying at subscription scope
resource resourceGroup 'Microsoft.Resources/resourceGroups@2024-03-01' = if (deploymentScope == 'resourceGroup') {
  name: resourceGroupName!
  location: location
}

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.edge-site.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  location: location
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

// Deploy Edge Site at subscription scope
resource site 'Microsoft.Edge/sites@2025-06-01' = if (deploymentScope == 'subscription') {
  name: name
  properties: {
    description: siteDescription
    displayName: displayName
    labels: labels
    siteAddress: siteAddress
  }
}

// Deploy Edge Site at resource group scope using module deployment
module siteAtResourceGroup 'site-rg.bicep' = if (deploymentScope == 'resourceGroup') {
  name: 'site-deployment-${uniqueString(deployment().name, location)}'
  scope: az.resourceGroup(resourceGroupName!)
  params: {
    name: name
    location: location
    siteDescription: siteDescription
    displayName: displayName
    labels: labels
    siteAddress: siteAddress
  }
}

resource site_lock 'Microsoft.Authorization/locks@2020-05-01' = if (deploymentScope == 'subscription' && !empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: site
}

resource site_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (deploymentScope == 'subscription' ? (formattedRoleAssignments ?? []) : []): {
    name: roleAssignment.?name ?? guid(site.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condition is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: site
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the site.')
output resourceId string = deploymentScope == 'subscription' ? site.id : siteAtResourceGroup!.outputs.resourceId

@description('The name of the site.')
output name string = deploymentScope == 'subscription' ? site.name : siteAtResourceGroup!.outputs.name

@description('The location the resource was deployed into.')
output location string = location
