metadata name = 'Azure Code Signing Account'
metadata description = 'This module deploys an Azure Code Signing Account.'

@description('Required. The name of the Azure Code Signing Account.')
param name string

@description('Optional. Defaults to the current resource group scope location. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The name of the Azure Code Signing Account SKU.')
param skuName resourceInput<'Microsoft.CodeSigning/codeSigningAccounts@2025-10-13'>.sku.name

@sys.description('Optional. Certificate profiles to create.')
param certificateProfiles certificateProfile[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Resource tags.')
param tags resourceInput<'Microsoft.CodeSigning/codeSigningAccounts@2025-10-13'>.tags?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.7.0'
@description('Optional. The diagnostic settings of the service. If neither metrics nor logs are specified, all metrics & logs are configured by default. If only one of them is specified, the other one will not be configured.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

// =========== //
// Variables   //
// =========== //

var enableReferencedModulesTelemetry bool = false

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

// ============ //
// Dependencies //
// ============ //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2025-04-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.devices-codeSigningAccount.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource codeSigningAccount 'Microsoft.CodeSigning/codeSigningAccounts@2025-10-13' = {
  name: name
  location: location
  tags: tags
  properties: {
    sku: {
      name: skuName
    }
  }
}

module certificateProfile_deploy 'certificate-profiles/main.bicep' = [
  for (certificateProfile, index) in (certificateProfiles ?? []): {
    name: '${deployment().name}-CertificateProfile-${index}'
    params: {
      codeSigningAccountName: codeSigningAccount.name
      name: certificateProfile
      enableTelemetry: enableReferencedModulesTelemetry
      identityValidationId: certificateProfile.?identityValidationId
      profileType: certificateProfile.?profileType
      includeCity: certificateProfile.?includeCity
      includeCountry: certificateProfile.?includeCountry
      includePostalCode: certificateProfile.?includePostalCode
      includeState: certificateProfile.?includeState
      includeStreetAddress: certificateProfile.?includeStreetAddress
      location: certificateProfile.?location
      lock: certificateProfile.?lock
      programType: certificateProfile.programType
      roleAssignments: certificateProfile.?roleAssignments
    }
  }
]

resource codeSigningAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
  }
  scope: codeSigningAccount
}

resource codeSigningAccount_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? (empty(diagnosticSetting.?logCategoriesAndGroups)
          ? [{ category: 'AllMetrics' }]
          : [])): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? (empty(diagnosticSetting.?metricCategories)
          ? [{ categoryGroup: 'allLogs' }]
          : [])): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: codeSigningAccount
  }
]

resource codeSigningAccount_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      codeSigningAccount.id,
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
    scope: codeSigningAccount
  }
]

// =========== //
// Outputs     //
// =========== //
@description('The resource ID of the codeSigningAccount.')
output resourceId string = codeSigningAccount.id

@description('The name of the resource group the codeSigningAccount was created in.')
output resourceGroupName string = resourceGroup().name

@description('The name of the codeSigningAccount.')
output name string = codeSigningAccount.name

@description('The location the resource was deployed into.')
output location string = codeSigningAccount.location

// ================ //
// Definitions      //
// ================ //

@description('The type for Dev Center Attached Network.')
type certificateProfile = {
  @description('Required. The name of the attached network.')
  name: string
  @description('Required. The identity validation ID for the certificate profile.')
  identityValidationId: string
  @description('Optional. Whether to include L in the certificate subject name. Applicable only for private trust, private trust ci profile types.')
  includeCity: bool?
  @description('Optional. Whether to include C in the certificate subject name. Applicable only for private trust, private trust ci profile types')
  includeCountry: bool?
  @description('Optional. Whether to include PC in the certificate subject name.')
  includePostalCoe: bool?
  @description('Optional. Whether to include S in the certificate subject name. Applicable only for private trust, private trust ci profile types.')
  includeState: bool?
  @description('Optional. Whether to include STREET in the certificate subject name.')
  includeStreetAddress: bool?
  @description('Required.Profile type of the certificate.')
  profileType: ('PrivateTrust' | 'PrivateTrustCIPolicy' | 'PublicTrust' | 'PublicTrustTest' | 'VBSEnclave')
  @description('Optional. Indicates whether the resource is intended for a specific usage scenario.')
  programType: string?
}
