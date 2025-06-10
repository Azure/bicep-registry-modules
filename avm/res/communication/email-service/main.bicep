metadata name = 'Email Services'
metadata description = 'This module deploys an Email Service'

@minLength(1)
@maxLength(63)
@description('Required. Name of the email service to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = 'global'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Endpoint tags.')
param tags object?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Required. The location where the communication service stores its data at rest.')
param dataLocation string

@description('Optional. The domains to deploy into this namespace.')
param domains array?

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

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.communication-emailservice.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource email 'Microsoft.Communication/emailServices@2023-04-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    dataLocation: dataLocation
  }
}

module email_domains 'domain/main.bicep' = [
  for (domain, index) in (domains ?? []): {
    name: '${uniqueString(deployment().name, location)}-email-domain-${index}'
    params: {
      emailServiceName: email.name
      name: domain.name
      location: location
      domainManagement: domain.?domainManagement
      userEngagementTracking: domain.?userEngagementTracking
      senderUsernames: domain.?senderUsernames
      roleAssignments: domain.?roleAssignments
      lock: domain.?lock ?? lock
      tags: domain.?tags ?? tags
    }
  }
]

resource email_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: email
}

resource email_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(email.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: email
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The name of the email service.')
output name string = email.name

@description('The resource ID of the email service.')
output resourceId string = email.id

@description('The resource group the email service was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the email service was deployed into.')
output location string = email.location

@description('The list of the email domain resource ids.')
output domainResourceIds array = [for (domain, index) in (domains ?? []): email_domains[index].outputs.resourceId]

@description('The list of the email domain names.')
output domainNamess array = [for (domain, index) in (domains ?? []): email_domains[index].outputs.name]
