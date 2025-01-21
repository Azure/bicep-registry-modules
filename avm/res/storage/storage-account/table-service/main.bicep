metadata name = 'Storage Account Table Services'
metadata description = 'This module deploys a Storage Account Table Service.'

@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Optional. tables to create.')
param tables array = []

@description('Optional. The List of CORS rules. You can include up to five CorsRule elements in the request.')
param corsRules corsRuleType[]?

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
  properties: {
    cors: corsRules != null
      ? {
          corsRules: corsRules
        }
      : null
  }
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

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type for a cors rule.')
type corsRuleType = {
  @description('Required. A list of headers allowed to be part of the cross-origin request.')
  allowedHeaders: string[]

  @description('Required. A list of HTTP methods that are allowed to be executed by the origin.')
  allowedMethods: ('CONNECT' | 'DELETE' | 'GET' | 'HEAD' | 'MERGE' | 'OPTIONS' | 'PATCH' | 'POST' | 'PUT' | 'TRACE')[]

  @description('Required. A list of origin domains that will be allowed via CORS, or "*" to allow all domains.')
  allowedOrigins: string[]

  @description('Required. A list of response headers to expose to CORS clients.')
  exposedHeaders: string[]

  @description('Required. The number of seconds that the client/browser should cache a preflight response.')
  maxAgeInSeconds: int
}
