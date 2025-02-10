metadata name = 'Network Security Perimeter'
metadata description = 'This module deploys a Network Security Perimeter (NSP).'

@description('Required. Name of the Network Security Perimeter.')
param name string

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Array of Security Rules to deploy to the Network Security Group. When not provided, an NSG including only the built-in roles will be deployed.')
param profiles profileType[]?

@description('Optional. Array of resource associations to create.')
param resourceAssociations resourceAssociationType[]?

import { diagnosticSettingLogsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingLogsOnlyType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the NSG resource.')
param tags object?

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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.network-nwsecurityperimeter.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource networkSecurityPerimeter 'Microsoft.Network/networkSecurityPerimeters@2023-08-01-preview' = {
  name: name
  location: location
  tags: tags
}

module networkSecurityPerimeter_profiles 'profile/main.bicep' = [
  for (profile, index) in (profiles ?? []): {
    name: '${uniqueString(deployment().name, location)}-nsp-profile-${index}'
    params: {
      networkPerimeterName: name
      name: profile.name
      accessRules: profile.?accessRules
    }
  }
]

resource networkSecurityPerimeter_resourceAssociations 'Microsoft.Network/networkSecurityPerimeters/resourceAssociations@2023-08-01-preview' = [
  for (resourceAssociation, index) in (resourceAssociations ?? []): {
    name: '${guid(resourceAssociation.privateLinkResource, name, resourceAssociation.profile)}-nsp-ra'
    parent: networkSecurityPerimeter
    properties: {
      privateLinkResource: {
        id: resourceAssociation.privateLinkResource
      }
      profile: {
        #disable-next-line use-resource-id-functions
        id: '${resourceId('Microsoft.Network/networkSecurityPerimeters/profiles', name, resourceAssociation.profile)}'
      }
      accessMode: resourceAssociation.accessMode ?? 'Learning'
    }
    dependsOn: [
      networkSecurityPerimeter_profiles
    ]
  }
]

resource networkSecurityPerimeter_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  scope: networkSecurityPerimeter
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
}

resource networkSecurityPerimeter_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    scope: networkSecurityPerimeter
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
  }
]

resource networkSecurityPerimeter_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      networkSecurityPerimeter.id,
      roleAssignment.principalId,
      roleAssignment.roleDefinitionId
    )
    scope: networkSecurityPerimeter
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
  }
]

@description('The resource group the network security perimeter was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the network security perimeter.')
output resourceId string = networkSecurityPerimeter.id

@description('The name of the network security perimeter.')
output name string = networkSecurityPerimeter.name

@description('The location the resource was deployed into.')
output location string = networkSecurityPerimeter.location

// =============== //
//   Definitions   //
// =============== //

import { accessRuleType } from 'profile/main.bicep'

@export()
@description('The type for a profile.')
type profileType = {
  @description('Required. The name of the network security perimeter profile.')
  name: string

  @description('Optional. Whether network traffic is allowed or denied.')
  accessRules: accessRuleType[]?
}

@export()
@description('The type for a resource association.')
type resourceAssociationType = {
  @description('Required. The resource identifier of the resource association.')
  privateLinkResource: string

  @description('Required. The name of the resource association.')
  profile: string

  @description('Optional. The access mode of the resource association.')
  accessMode: 'Learning' | 'Audit' | 'Enforced'?
}
