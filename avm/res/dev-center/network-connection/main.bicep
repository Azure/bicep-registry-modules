metadata name = 'Dev Center Network Connection'
metadata description = 'This module deploys an Azure Dev Center Network Connection.'

@description('Required. Name of the Dev Center Network Connection.')
@minLength(3)
@maxLength(63)
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. AAD Join type for the network connection.')
@allowed([
  'AzureADJoin'
  'HybridAzureADJoin'
  'None'
])
param domainJoinType string = 'None'

@description('Required. The subnet to attach Virtual Machines to.')
param subnetResourceId string

@description('Conditional. Active Directory domain name. Required if domainJoinType is "HybridAzureADJoin"".')
param domainName string?

@description('Conditional. The password for the account used to join the domain. Required if domainJoinType is "HybridAzureADJoin".')
@secure()
param domainPassword string?

@description('Conditional. The username of an Active Directory account (user or service account) that has permissions to create computer objects in Active Directory. Required format: admin@contoso.com. Required if domainJoinType is "HybridAzureADJoin".')
param domainUsername string?

@description('Conditional. Active Directory domain Organization Unit (OU). Required if domainJoinType is "HybridAzureADJoin".')
param organizationUnit string?

@description('Optional. The name for the resource group where NICs will be placed. If not provided, the default name "NI_networkConnectionName_region" (e.g. "NI_myNetworkConnection_eastus") will be used. It cannot be an existing resource group. It will also contain a health check Network Interface (NIC) resource for the network connection. This NIC name will be "nic-CPC-Hth-<randomString>_<date>" (e.g. "nic-CPC-Hth-12345678_2023-10-01").')
param networkingResourceGroupName string?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Network Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '4d97b98b-1d4f-4787-a291-c67834d212e7'
  )
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res-devcenter-networkconnection.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource networkConnection 'Microsoft.DevCenter/networkConnections@2025-02-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    domainJoinType: domainJoinType
    domainName: domainName
    domainPassword: domainPassword!
    domainUsername: domainUsername
    networkingResourceGroupName: networkingResourceGroupName
    organizationUnit: organizationUnit
    subnetId: subnetResourceId
  }
}

resource devCenter_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: networkConnection
}

resource devCenter_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      networkConnection.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: networkConnection
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The name of the deployed network connection.')
output name string = networkConnection.name

@description('The resource ID of the deployed network connection.')
output resourceId string = networkConnection.id

@description('The name of the resource group the network connection was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = networkConnection.location
