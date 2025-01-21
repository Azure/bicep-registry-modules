metadata name = 'Application Insights'
metadata description = 'This component deploys an Application Insights instance.'

@description('Required. Name of the Application Insights.')
param name string

@description('Optional. Application type.')
@allowed([
  'web'
  'other'
])
param applicationType string = 'web'

@description('Required. Resource ID of the log analytics workspace which the data will be ingested to. This property is required to create an application with this API version. Applications from older versions will not have this property.')
param workspaceResourceId string

@description('Optional. Disable IP masking. Default value is set to true.')
param disableIpMasking bool = true

@description('Optional. Disable Non-AAD based Auth. Default value is set to false.')
param disableLocalAuth bool = false

@description('Optional. Force users to create their own storage account for profiler and debugger.')
param forceCustomerStorageForProfiler bool = false

@description('Optional. Linked storage account resource ID.')
param linkedStorageAccountResourceId string?

@description('Optional. The network access type for accessing Application Insights ingestion. - Enabled or Disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForIngestion string = 'Enabled'

@description('Optional. The network access type for accessing Application Insights query. - Enabled or Disabled.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccessForQuery string = 'Enabled'

@description('Optional. Retention period in days.')
@allowed([
  30
  60
  90
  120
  180
  270
  365
  550
  730
])
param retentionInDays int = 365

@description('Optional. Percentage of the data produced by the application being monitored that is being sampled for Application Insights telemetry.')
@minValue(0)
@maxValue(100)
param samplingPercentage int = 100

@description('Optional. The kind of application that this component refers to, used to customize UI. This value is a freeform string, values should typically be one of the following: web, ios, other, store, java, phone.')
param kind string = ''

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

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
  'Monitoring Metrics Publisher': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '3913510d-42f4-4e42-8a64-420c390055eb'
  )
  'Application Insights Component Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'ae349356-3a1b-4a5e-921d-050484c6347e'
  )
  'Application Insights Snapshot Debugger': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '08954f03-6346-4c2e-81c0-ec3a5cfae23b'
  )
  'Monitoring Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
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
  name: '46d3xbcp.res.insights-component.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource appInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: name
  location: location
  tags: tags
  kind: kind
  properties: {
    Application_Type: applicationType
    DisableIpMasking: disableIpMasking
    DisableLocalAuth: disableLocalAuth
    ForceCustomerStorageForProfiler: forceCustomerStorageForProfiler
    WorkspaceResourceId: workspaceResourceId
    publicNetworkAccessForIngestion: publicNetworkAccessForIngestion
    publicNetworkAccessForQuery: publicNetworkAccessForQuery
    RetentionInDays: retentionInDays
    SamplingPercentage: samplingPercentage
  }
}

module linkedStorageAccount 'linkedStorageAccounts/main.bicep' = if (!empty(linkedStorageAccountResourceId)) {
  name: '${uniqueString(deployment().name, location)}-appInsights-linkedStorageAccount'
  params: {
    appInsightsName: appInsights.name
    storageAccountResourceId: linkedStorageAccountResourceId ?? ''
  }
}

resource appInsights_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(appInsights.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: appInsights
  }
]

resource appInsights_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: appInsights
}

resource appInsights_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: appInsights
  }
]

@description('The name of the application insights component.')
output name string = appInsights.name

@description('The resource ID of the application insights component.')
output resourceId string = appInsights.id

@description('The resource group the application insights component was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The application ID of the application insights component.')
output applicationId string = appInsights.properties.AppId

@description('The location the resource was deployed into.')
output location string = appInsights.location

@description('Application Insights Instrumentation key. A read-only value that applications can use to identify the destination for all telemetry sent to Azure Application Insights. This value will be supplied upon construction of each new Application Insights component.')
output instrumentationKey string = appInsights.properties.InstrumentationKey

@description('Application Insights Connection String.')
output connectionString string = appInsights.properties.ConnectionString
