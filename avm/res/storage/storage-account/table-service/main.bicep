metadata name = 'Storage Account Table Services'
metadata description = 'This module deploys a Storage Account Table Service.'
metadata owner = 'Azure/module-maintainers'

@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Optional. tables to create.')
param tables array = []

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.2.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

// The name of the table service
var name = 'default'

resource storageAccount 'Microsoft.Storage/storageAccounts@2023-04-01' existing = {
  name: storageAccountName
}

resource tableServices 'Microsoft.Storage/storageAccounts/tableServices@2023-04-01' = {
  name: name
  parent: storageAccount
  properties: {}
}

resource tableServices_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: tableServices
  }
]

module tableServices_tables 'table/main.bicep' = [
  for (table, index) in tables: {
    name: '${deployment().name}-Table-${index}'
    params: {
      name: table.name
      storageAccountName: storageAccount.name
      roleAssignments: table.?roleAssignments
    }
  }
]

@description('The name of the deployed table service.')
output name string = tableServices.name

@description('The resource ID of the deployed table service.')
output resourceId string = tableServices.id

@description('The resource group of the deployed table service.')
output resourceGroupName string = resourceGroup().name
