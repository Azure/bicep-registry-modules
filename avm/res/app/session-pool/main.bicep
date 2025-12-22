metadata name = 'Container App Session Pool'
metadata description = 'This module deploys a Container App Session Pool.'

@description('Required. Name of the Container App Session Pool.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Required. The container type of the sessions.')
@allowed(['PythonLTS', 'CustomContainer'])
param containerType string

@description('Optional. The custom container configuration if the containerType is CustomContainer. Only set if containerType is CustomContainer.')
param customContainerTemplate resourceInput<'Microsoft.App/sessionPools@2025-07-01'>.properties.customContainerTemplate?

@description('Optional. The pool configuration if the poolManagementType is dynamic.')
param dynamicPoolConfiguration resourceInput<'Microsoft.App/sessionPools@2025-07-01'>.properties.dynamicPoolConfiguration = {
  lifecycleConfiguration: {
    cooldownPeriodInSeconds: 300
    lifecycleType: 'Timed'
  }
}

@description('Optional. The scale configuration of the session pool.')
param scaleConfiguration resourceInput<'Microsoft.App/sessionPools@2025-07-01'>.properties.scaleConfiguration = {
  maxConcurrentSessions: 5
}

@description('Optional. The network configuration of the sessions in the session pool.')
param sessionNetworkConfiguration resourceInput<'Microsoft.App/sessionPools@2025-07-01'>.properties.sessionNetworkConfiguration = {
  status: 'EgressDisabled'
}

@description('Optional. The pool management type of the session pool. Defaults to Dynamic.')
@allowed(['Dynamic', 'Manual'])
param poolManagementType string = 'Dynamic'

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. Settings for a Managed Identity that is assigned to the Session pool.')
param managedIdentitySettings resourceInput<'Microsoft.App/sessionPools@2025-07-01'>.properties.managedIdentitySettings?

@description('Optional. The secrets of the session pool.')
param secrets resourceInput<'Microsoft.App/sessionPools@2025-07-01'>.properties.secrets?

@description('Optional. Resource ID of the session pool\'s environment.')
param environmentResourceId string?

@description('Optional. Tags of the Automation Account resource.')
param tags resourceInput<'Microsoft.App/sessionPools@2024-10-02-preview'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(formattedUserAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(formattedUserAssignedIdentities) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  'Azure ContainerApps Session Executor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '0fb8eba5-a2bb-4abe-b1c1-49dfad359bb0'
  )
  'Container Apps SessionPools Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f7669afb-68b2-44b4-9c5f-6d2a47fddda0'
  )
  'Container Apps SessionPools Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'af61e8fc-2633-4b95-bed3-421ad6826515'
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.app-sessionpool.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '#_moduleVersion_#.0'
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

resource sessionPool 'Microsoft.App/sessionPools@2025-07-01' = {
  name: name
  location: location
  identity: identity
  properties: {
    containerType: containerType
    environmentId: environmentResourceId
    customContainerTemplate: containerType == 'CustomContainer' ? customContainerTemplate : null
    dynamicPoolConfiguration: poolManagementType == 'Dynamic' ? dynamicPoolConfiguration : null
    secrets: secrets
    managedIdentitySettings: managedIdentitySettings
    scaleConfiguration: scaleConfiguration
    sessionNetworkConfiguration: sessionNetworkConfiguration
    poolManagementType: poolManagementType
  }
  tags: tags
}

resource sessionPool_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: sessionPool
}

resource sessionPool_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(sessionPool.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: sessionPool
  }
]

@description('The name of the session pool.')
output name string = sessionPool.name

@description('The resource ID of the deployed session pool.')
output resourceId string = sessionPool.id

@description('The name of the resource group in which the session pool was created.')
output resourceGroupName string = resourceGroup().name

@description('The management endpoint of the session pool.')
output managementEndpoint string = sessionPool.properties.poolManagementEndpoint

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = sessionPool.?identity.?principalId
