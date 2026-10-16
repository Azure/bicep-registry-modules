metadata name = 'Azure Stack HCI Storage Container'
metadata description = 'This module deploys an Azure Stack HCI Storage Container.'

@description('Required. Name of the storage container.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. Resource ID of the associated custom location.')
param customLocationResourceId string

@description('Required. Path of the storage container on the cluster shared volume. For example: `C:\\ClusterStorage\\UserStorage_1\\myStorageContainer`. Note: On creation, Azure Local appends a unique subfolder to the given path and stores the extended path in the resource\'s `properties.path`. The path can\'t be changed after creation, so re-deploying with the original value fails with "Path cannot be changed after resource creation". To re-deploy an existing storage container, provide the path stored on the resource.')
param path string

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.AzureStackHCI/storageContainers@2024-01-01'>.tags?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  'Azure Stack HCI Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'bda0d508-adf1-4af0-9c28-88919fc3ae06'
  )
  'Azure Stack HCI VM Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '874d1c73-6003-4e60-a13a-cb31ea190a85'
  )
  'Azure Stack HCI VM Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4b3fe76c-f777-4d24-a2d7-b027b0f7b273'
  )
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

// ============== //
// Resources      //
// ============== //

var telemetryIdPrefix = loadJsonContent('metadata.json', 'telemetryIdPrefix')

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '${telemetryIdPrefix}.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource storageContainer 'Microsoft.AzureStackHCI/storageContainers@2024-01-01' = {
  name: name
  location: location
  tags: tags
  extendedLocation: {
    type: 'CustomLocation'
    name: customLocationResourceId
  }
  properties: {
    path: path
  }
}

resource storageContainer_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: storageContainer
}

resource storageContainer_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(storageContainer.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: storageContainer
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The name of the storage container.')
output name string = storageContainer.name

@description('The resource ID of the storage container.')
output resourceId string = storageContainer.id

@description('The resource group the storage container was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the storage container was deployed into.')
output location string = storageContainer.location
