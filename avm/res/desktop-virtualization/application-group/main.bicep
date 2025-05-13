metadata name = 'Azure Virtual Desktop Application Group'
metadata description = 'This module deploys an Azure Virtual Desktop Application Group.'

@sys.description('Required. Name of the Application Group.')
@minLength(3)
param name string

@sys.description('Optional. Location for all resources.')
param location string = resourceGroup().location

@sys.description('Required. The type of the Application Group to be created. Allowed values: RemoteApp or Desktop.')
@allowed([
  'RemoteApp'
  'Desktop'
])
param applicationGroupType string

@sys.description('Required. Name of the Host Pool to be linked to this Application Group.')
param hostpoolName string

@sys.description('Optional. The friendly name of the Application Group to be created.')
param friendlyName string = name

@sys.description('Optional. Description of the application group.')
param description string?

@sys.description('Optional. List of applications to be created in the Application Group.')
param applications array?

@sys.description('Optional. Tags of the resource.')
param tags object?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The lock settings of the service.')
param lock lockType?

@sys.description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { diagnosticSettingLogsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@sys.description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingLogsOnlyType[]?

var builtInRoleNames = {
  Owner: '/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635'
  Contributor: '/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
  Reader: '/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7'
  'Role Based Access Control Administrator': '/providers/Microsoft.Authorization/roleDefinitions/f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  'User Access Administrator': '/providers/Microsoft.Authorization/roleDefinitions/18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  'Application Group Contributor': '/providers/Microsoft.Authorization/roleDefinitions/ca6382a4-1721-4bcf-a114-ff0c70227b6b'
  'Desktop Virtualization Application Group Contributor': '/providers/Microsoft.Authorization/roleDefinitions/86240b0e-9422-4c43-887b-b61143f32ba8'
  'Desktop Virtualization Application Group Reader': '/providers/Microsoft.Authorization/roleDefinitions/aebf23d0-b568-4e86-b8f9-fe83a2c6ab55'
  'Desktop Virtualization Contributor': '/providers/Microsoft.Authorization/roleDefinitions/082f0a83-3be5-4ba1-904c-961cca79b387'
  'Desktop Virtualization Host Pool Contributor': '/providers/Microsoft.Authorization/roleDefinitions/e307426c-f9b6-4e81-87de-d99efb3c32bc'
  'Desktop Virtualization Host Pool Reader': '/providers/Microsoft.Authorization/roleDefinitions/ceadfde2-b300-400a-ab7b-6143895aa822'
  'Desktop Virtualization Power On Off Contributor': '/providers/Microsoft.Authorization/roleDefinitions/40c5ff49-9181-41f8-ae61-143b0e78555e'
  'Desktop Virtualization Reader': '/providers/Microsoft.Authorization/roleDefinitions/49a72310-ab8d-41df-bbb0-79b649203868'
  'Desktop Virtualization Session Host Operator': '/providers/Microsoft.Authorization/roleDefinitions/2ad6aaab-ead9-4eaa-8ac5-da422f562408'
  'Desktop Virtualization User': '/providers/Microsoft.Authorization/roleDefinitions/1d18fff3-a72a-46b5-b4a9-0b38a3cd7e63'
  'Desktop Virtualization User Session Operator': '/providers/Microsoft.Authorization/roleDefinitions/ea4bfff8-7fb4-485a-aadd-d4129a0ffaa6'
  'Desktop Virtualization Virtual Machine Contributor': '/providers/Microsoft.Authorization/roleDefinitions/a959dbd1-f747-45e3-8ba6-dd80f235f97c'
  'Desktop Virtualization Workspace Contributor': '/providers/Microsoft.Authorization/roleDefinitions/21efdde3-836f-432b-bf3d-3e8e734d4b2b'
  'Desktop Virtualization Workspace Reader': '/providers/Microsoft.Authorization/roleDefinitions/0fa44ee9-7a7d-466b-9bb2-2bf446b1204d'
  'Managed Application Contributor Role': '/providers/Microsoft.Authorization/roleDefinitions/641177b8-a67a-45b9-a033-47bc880bb21e'
  'Managed Application Operator Role': '/providers/Microsoft.Authorization/roleDefinitions/c7393b34-138c-406f-901b-d8cf2b17e6ae'
  'Managed Applications Reader': '/providers/Microsoft.Authorization/roleDefinitions/b9331d33-8a36-4f8c-b097-4f54124fdb44'
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
  name: '46d3xbcp.res.desktopvirtualization-appgroup.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource appGroup_hostpool 'Microsoft.DesktopVirtualization/hostPools@2022-09-09' existing = {
  name: hostpoolName
}

resource appGroup 'Microsoft.DesktopVirtualization/applicationGroups@2023-09-05' = {
  name: name
  location: location
  tags: tags
  properties: {
    hostPoolArmPath: appGroup_hostpool.id
    friendlyName: friendlyName
    description: description
    applicationGroupType: applicationGroupType
  }
}

module appGroup_applications 'application/main.bicep' = [
  for (application, index) in applications ?? []: {
    name: '${uniqueString(deployment().name, location)}-AppGroup-App-${index}'
    params: {
      name: application.name
      applicationGroupName: appGroup.name
      description: application.?description
      friendlyName: application.?friendlyName ?? appGroup.name
      filePath: application.filePath
      commandLineSetting: application.?commandLineSetting
      commandLineArguments: application.?commandLineArguments
      showInPortal: application.?showInPortal
      iconPath: application.?iconPath ?? application.filePath
      iconIndex: application.?iconIndex
    }
  }
]

resource appGroup_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: appGroup
}

resource appGroup_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(appGroup.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: appGroup
  }
]

resource appGroup_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
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
    scope: appGroup
  }
]

@sys.description('The resource ID of the scaling plan.')
output resourceId string = appGroup.id

@sys.description('The name of the resource group the scaling plan was created in.')
output resourceGroupName string = resourceGroup().name

@sys.description('The name of the scaling plan.')
output name string = appGroup.name

@sys.description('The location of the scaling plan.')
output location string = appGroup.location
