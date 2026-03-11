targetScope = 'tenant'

metadata name = 'Service Groups'
metadata description = 'This module will allow you to create a service group and also associate resource to this service group, if you have permissions upon those resources.'

@description('Required. Name of the service group to create. Must be globally unique.')
param name string

@description('Optional. Display name of the service group to create. If not provided, the name parameter input value will be used.')
param displayName string?

@description('Optional. The parent service group resource ID, e.g. "/providers/Microsoft.Management/serviceGroups/<name>", of the service group to create. If not provided, the service group will be created under the root service group, e.g. "/providers/Microsoft.Management/serviceGroups/<TENANT ID>".')
param parentServiceGroupResourceId string?

@description('Optional. An array of subscription IDs to associate to the service group. The deployment principal must have the necessary permissions to perform this action on the target subscriptions. The relationship name is generated using uniqueString() function with the service group ID and the subscription ID as inputs.')
param subscriptionIdsToAssociateToServiceGroup string[]?

@description('Optional. An array of resource group resource IDs to associate to the service group. The deployment principal must have the necessary permissions to perform this action on the target resource groups. The relationship name is generated using uniqueString() function with the service group ID and the resource group resource ID as inputs.')
param resourceGroupResourceIdsToAssociateToServiceGroup string[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

var builtInRoleNames = {
  Contributor: tenantResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: tenantResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: tenantResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': tenantResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': tenantResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
  'Service Group Administrator': tenantResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4e50c84c-c78e-4e37-b47e-e60ffea0a775'
  )
  'Service Group Contributor': tenantResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '32e6a4ec-6095-4e37-b54b-12aa350ba81f'
  )
  'Service Group Reader': tenantResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'de754d53-652d-4c75-a67f-1e48d8b49c97'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : tenantResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.management-servicegroup.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, deployment().location), 0, 4)}'
  location: deployment().location
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

resource serviceGroup 'Microsoft.Management/serviceGroups@2024-02-01-preview' = {
  name: name
  properties: {
    displayName: displayName ?? name
    parent: {
      resourceId: parentServiceGroupResourceId ?? '/providers/Microsoft.Management/serviceGroups/${tenant().tenantId}'
    }
  }
}

module serviceGroup_subscriptionMember 'modules/subscriptionMember.bicep' = [
  for sub in (subscriptionIdsToAssociateToServiceGroup ?? []): {
    scope: subscription(sub)
    params: {
      serviceGroupResourceId: serviceGroup.id
    }
  }
]

module serviceGroup_resourceGroupMember 'modules/resourceGroupMember.bicep' = [
  for rg in (resourceGroupResourceIdsToAssociateToServiceGroup ?? []): {
    scope: resourceGroup(split(rg, '/')[2], split(rg, '/')[4])
    params: {
      serviceGroupResourceId: serviceGroup.id
    }
  }
]

resource serviceGroup_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(serviceGroup.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condition is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: serviceGroup
  }
]

resource serviceGroup_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: serviceGroup
}

@description('The resource ID of the service group.')
output resourceId string = serviceGroup.id

@description('The name of the service group.')
output name string = serviceGroup.name
