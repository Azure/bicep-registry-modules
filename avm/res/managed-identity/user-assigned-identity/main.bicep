metadata name = 'User Assigned Identities'
metadata description = 'This module deploys a User Assigned Identity.'

@description('Required. Name of the User Assigned Identity.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The federated identity credentials list to indicate which token from the external IdP should be trusted by your application. Federated identity credentials are supported on applications only. A maximum of 20 federated identity credentials can be added per application object.')
param federatedIdentityCredentials federatedIdentityCredentialType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'Managed Identity Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'e40ec5ca-96e0-45a2-b4ff-59039f2c2b59'
  )
  'Managed Identity Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f1a07417-d97a-45cb-824c-7a7467783830'
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.managedidentity-userassignedidentity.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource userAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30' = {
  name: name
  location: location
  tags: tags
}

resource userAssignedIdentity_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: userAssignedIdentity
}

@batchSize(1)
module userAssignedIdentity_federatedIdentityCredentials 'federated-identity-credential/main.bicep' = [
  for (federatedIdentityCredential, index) in (federatedIdentityCredentials ?? []): {
    name: '${uniqueString(deployment().name, location)}-UserMSI-FederatedIdentityCred-${index}'
    params: {
      name: federatedIdentityCredential.name
      userAssignedIdentityName: userAssignedIdentity.name
      audiences: federatedIdentityCredential.audiences
      issuer: federatedIdentityCredential.issuer
      subject: federatedIdentityCredential.subject
    }
  }
]

resource userAssignedIdentity_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      userAssignedIdentity.id,
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
    scope: userAssignedIdentity
  }
]

@description('The name of the user assigned identity.')
output name string = userAssignedIdentity.name

@description('The resource ID of the user assigned identity.')
output resourceId string = userAssignedIdentity.id

@description('The principal ID (object ID) of the user assigned identity.')
output principalId string = userAssignedIdentity.properties.principalId

@description('The client ID (application ID) of the user assigned identity.')
output clientId string = userAssignedIdentity.properties.clientId

@description('The resource group the user assigned identity was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = userAssignedIdentity.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for the federated identity credential.')
type federatedIdentityCredentialType = {
  @description('Required. The name of the federated identity credential.')
  name: string

  @description('Required. The list of audiences that can appear in the issued token.')
  audiences: string[]

  @description('Required. The URL of the issuer to be trusted.')
  issuer: string

  @description('Required. The identifier of the external identity.')
  subject: string
}
