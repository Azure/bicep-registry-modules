metadata name = 'App Service Plan'
metadata description = 'This module deploys an App Service Plan.'

@description('Required. Name of the app service plan.')
@minLength(1)
@maxLength(60)
param name string

@description('Optional. The name of the SKU will Determine the tier, size, family of the App Service Plan. This defaults to P1v3 to leverage availability zones.')
@metadata({
  example: '''
  'F1'
  'B1'
  'P1v3'
  'I1v2'
  'FC1'
  '''
})
param skuName string = 'P1v3'

@description('Optional. Number of workers associated with the App Service Plan. This defaults to 3, to leverage availability zones.')
param skuCapacity int = 3

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Kind of server OS.')
@allowed([
  'app'
  'elastic'
  'functionApp'
  'windows'
  'linux'
])
param kind string = 'app'

@description('Conditional. Defaults to false when creating Windows/app App Service Plan. Required if creating a Linux App Service Plan and must be set to true.')
param reserved bool = (kind == 'linux')

@description('Optional. The Resource ID of the App Service Environment to use for the App Service Plan.')
param appServiceEnvironmentId string = ''

@description('Optional. Target worker tier assigned to the App Service plan.')
param workerTierName string = ''

@description('Optional. If true, apps assigned to this App Service plan can be scaled independently. If false, apps assigned to this App Service plan will scale to all instances of the plan.')
param perSiteScaling bool = false

@description('Optional. Enable/Disable ElasticScaleEnabled App Service Plan.')
param elasticScaleEnabled bool = maximumElasticWorkerCount > 1

@description('Optional. Maximum number of total workers allowed for this ElasticScaleEnabled App Service Plan.')
param maximumElasticWorkerCount int = 1

@description('Optional. Scaling worker count.')
param targetWorkerCount int = 0

@description('Optional. The instance size of the hosting plan (small, medium, or large).')
@allowed([
  0
  1
  2
])
param targetWorkerSize int = 0

@description('Optional. Zone Redundant server farms can only be used on Premium or ElasticPremium SKU tiers within ZRS Supported regions (https://learn.microsoft.com/en-us/azure/storage/common/redundancy-regions-zrs).')
param zoneRedundant bool = startsWith(skuName, 'P') || startsWith(skuName, 'EP') ? true : false

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { diagnosticSettingMetricsOnlyType } from 'br/public:avm/utl/types/avm-common-types:0.4.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingMetricsOnlyType[]?

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
  'Web Plan Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '2cc479cb-7b4d-49a8-b449-8c00fd0f0a4b'
  )
  'Website Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'de139f84-1756-47ae-9be6-808fbbe84772'
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
  name: '46d3xbcp.res.web-serverfarm.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: name
  kind: kind
  location: location
  tags: tags
  sku: {
    name: skuName
    capacity: skuName == 'FC1' ? null : skuCapacity
    tier: skuName == 'FC1' ? 'FlexConsumption' : null
  }
  properties: {
    workerTierName: workerTierName
    hostingEnvironmentProfile: !empty(appServiceEnvironmentId)
      ? {
          id: appServiceEnvironmentId
        }
      : null
    perSiteScaling: perSiteScaling
    maximumElasticWorkerCount: maximumElasticWorkerCount
    elasticScaleEnabled: elasticScaleEnabled
    reserved: reserved
    targetWorkerCount: targetWorkerCount
    targetWorkerSizeId: targetWorkerSize
    zoneRedundant: zoneRedundant
  }
}

resource appServicePlan_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: appServicePlan
  }
]

resource appServicePlan_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: appServicePlan
}

resource appServicePlan_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(appServicePlan.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: appServicePlan
  }
]

@description('The resource group the app service plan was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The name of the app service plan.')
output name string = appServicePlan.name

@description('The resource ID of the app service plan.')
output resourceId string = appServicePlan.id

@description('The location the resource was deployed into.')
output location string = appServicePlan.location
