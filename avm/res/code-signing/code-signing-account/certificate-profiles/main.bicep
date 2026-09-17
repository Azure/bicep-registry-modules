metadata name = 'Certificate Profiles'
metadata description = 'This module deploys certificate profiles for a code signing account.'

@description('Required. The name of the certificate profile to create.')
param name string

@description('Required. The name of the code signing account to which the certificate profile belongs.')
param codeSigningAccountName string

@description('Required. The identity validation ID for the certificate profile.')
param identityValidationId string
@description('Required. Whether to include L in the certificate subject name. Applicable only for private trust, private trust ci profile types.')
param includeCity bool?
@description('Optional. Whether to include C in the certificate subject name. Applicable only for private trust, private trust ci profile types')
param includeCountry bool?
@description('Optional. Whether to include PC in the certificate subject name.')
param includePostalCode bool?
@description('Optional. Whether to include S in the certificate subject name. Applicable only for private trust, private trust ci profile types.')
param includeState bool?
@description('Optional. Whether to include STREET in the certificate subject name.')
param includeStreetAddress bool?
@description('Required. Profile type of the certificate.')
param profileType ('PrivateTrust' | 'PrivateTrustCIPolicy' | 'PublicTrust' | 'PublicTrustTest' | 'VBSEnclave')
@description('Optional. Indicates whether the resource is intended for a specific usage scenario.')
param programType string?

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.databricks-accessconnector.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource codeSigningAccount 'Microsoft.CodeSigning/codeSigningAccounts@2025-10-13' existing = {
  name: codeSigningAccountName
}

resource certificateProfile 'Microsoft.CodeSigning/codeSigningAccounts/certificateProfiles@2026-05-15-preview' = {
  parent: codeSigningAccount
  name: name
  properties: {
    identityValidationId: identityValidationId
    profileType: profileType
    includeCity: includeCity
    includeCountry: includeCountry
    includePostalCode: includePostalCode
    includeState: includeState
    includeStreetAddress: includeStreetAddress
    programType: programType
  }
}

resource accessConnector_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: certificateProfile
}

resource certificateProfile_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      certificateProfile.id,
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
    scope: certificateProfile
  }
]

@description('The name of the deployed certificate profile.')
output name string = certificateProfile.name

@description('The resource ID of the deployed certificate profile.')
output resourceId string = certificateProfile.id

@description('The resource group of the deployed certificate profile.')
output resourceGroupName string = resourceGroup().name
