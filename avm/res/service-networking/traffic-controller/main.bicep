metadata name = 'Application Gateway for Containers'
metadata description = 'This module deploys an Application Gateway for Containers'

@description('Required. Name of the Application Gateway for Containers to create.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. Resource tags.')
param tags object?

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@description('Optional. The lock settings for all Resources in the solution.')
param lock lockType?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. List of Application Gateway for Containers frontends.')
param frontends frontendType[]?

@maxLength(1)
@description('Optional. List of Application Gateway for Containers associations. At this time, the number of associations is limited to 1.')
param associations associationType[]?

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
  name: '46d3xbcp.res.servicenetworking-trafficcontroller.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource trafficController 'Microsoft.ServiceNetworking/trafficControllers@2023-11-01' = {
  name: name
  location: location
  tags: tags
  properties: {}
}

resource trafficController_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: trafficController
}

resource trafficController_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
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
    scope: trafficController
  }
]

resource trafficController_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      trafficController.id,
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
    scope: trafficController
  }
]

module trafficController_frontends 'frontend/main.bicep' = [
  for (frontend, index) in (frontends ?? []): {
    name: '${uniqueString(deployment().name, location)}-TrafficController-Frontend-${index}'
    params: {
      trafficControllerName: trafficController.name
      name: frontend.name
      location: location
    }
  }
]

module trafficController_associations 'association/main.bicep' = [
  for (association, index) in (associations ?? []): {
    name: '${uniqueString(deployment().name, location)}-TrafficController-Association-${index}'
    params: {
      trafficControllerName: trafficController.name
      name: association.name
      location: location
      subnetResourceId: association.subnetResourceId
    }
  }
]

// ============ //
// Outputs      //
// ============ //

@description('The resource ID of the Application Gateway for Containers.')
output resourceId string = trafficController.id

@description('The name of the Application Gateway for Containers.')
output name string = trafficController.name

@description('The name of the resource group the resource was created in.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = trafficController.location

@description('The configuration endpoints of the Application Gateway for Containers.')
output configurationEndpoints string[] = trafficController.properties.configurationEndpoints

@description('The frontends of the Application Gateway for Containers.')
output frontends array = [
  for (frontend, i) in (!empty(frontends) ? array(frontends) : []): {
    name: trafficController_frontends[i].outputs.name
    resourceId: trafficController_frontends[i].outputs.resourceId
    fqdn: trafficController_frontends[i].outputs.fqdn
  }
]

@description('The associations of the Application Gateway for Containers.')
output associations array = [
  for (association, i) in (!empty(associations) ? array(associations) : []): {
    name: trafficController_associations[i].outputs.name
    resourceId: trafficController_associations[i].outputs.resourceId
    subnetResourceId: trafficController_associations[i].outputs.subnetResourceId
  }
]

// ================ //
// Definitions      //
// ================ //

@export()
type frontendType = {
  @description('Required. The name of the Application Gateway for Containers frontend.')
  name: string
}

@export()
type associationType = {
  @description('Required. The name of the Application Gateway for Containers association.')
  name: string

  @description('Required. The resource ID of the subnet to associate with the Application Gateway for Containers.')
  subnetResourceId: string
}
