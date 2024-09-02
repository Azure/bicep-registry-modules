metadata name = 'Storage Account blob Services'
metadata description = 'This module deploys a Storage Account Blob Service.'
metadata owner = 'Azure/module-maintainers'

@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Optional. Automatic Snapshot is enabled if set to true.')
param automaticSnapshotPolicyEnabled bool = false

@description('Optional. The blob service properties for change feed events. Indicates whether change feed event logging is enabled for the Blob service.')
param changeFeedEnabled bool = false

@minValue(1)
@maxValue(146000)
@description('Optional. Indicates whether change feed event logging is enabled for the Blob service. Indicates the duration of changeFeed retention in days. If left blank, it indicates an infinite retention of the change feed.')
param changeFeedRetentionInDays int?

@description('Optional. The blob service properties for container soft delete. Indicates whether DeleteRetentionPolicy is enabled.')
param containerDeleteRetentionPolicyEnabled bool = true

@minValue(1)
@maxValue(365)
@description('Optional. Indicates the number of days that the deleted item should be retained.')
param containerDeleteRetentionPolicyDays int?

@description('Optional. This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share.')
param containerDeleteRetentionPolicyAllowPermanentDelete bool = false

@description('Optional. Specifies CORS rules for the Blob service. You can include up to five CorsRule elements in the request. If no CorsRule elements are included in the request body, all CORS rules will be deleted, and CORS will be disabled for the Blob service.')
param corsRules array = []

@description('Optional. Indicates the default version to use for requests to the Blob service if an incoming request\'s version is not specified. Possible values include version 2008-10-27 and all more recent versions.')
param defaultServiceVersion string = ''

@description('Optional. The blob service properties for blob soft delete.')
param deleteRetentionPolicyEnabled bool = true

@minValue(1)
@maxValue(365)
@description('Optional. Indicates the number of days that the deleted blob should be retained.')
param deleteRetentionPolicyDays int = 7

@description('Optional. This property when set to true allows deletion of the soft deleted blob versions and snapshots. This property cannot be used with blob restore policy. This property only applies to blob service and does not apply to containers or file share.')
param deleteRetentionPolicyAllowPermanentDelete bool = false

@description('Optional. Use versioning to automatically maintain previous versions of your blobs.')
param isVersioningEnabled bool = false

@description('Optional. The blob service property to configure last access time based tracking policy. When set to true last access time based tracking is enabled.')
param lastAccessTimeTrackingPolicyEnabled bool = false

@description('Optional. The blob service properties for blob restore policy. If point-in-time restore is enabled, then versioning, change feed, and blob soft delete must also be enabled.')
param restorePolicyEnabled bool = false

@minValue(1)
@description('Optional. How long this blob can be restored. It should be less than DeleteRetentionPolicy days.')
param restorePolicyDays int = 6

@description('Optional. Blob containers to create.')
param containers array?

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

// The name of the blob services
var name = 'default'

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

resource blobServices 'Microsoft.Storage/storageAccounts/blobServices@2022-09-01' = {
  name: name
  parent: storageAccount
  properties: {
    automaticSnapshotPolicyEnabled: automaticSnapshotPolicyEnabled
    changeFeed: changeFeedEnabled
      ? {
          enabled: true
          retentionInDays: changeFeedRetentionInDays
        }
      : null
    containerDeleteRetentionPolicy: {
      enabled: containerDeleteRetentionPolicyEnabled
      days: containerDeleteRetentionPolicyDays
      allowPermanentDelete: containerDeleteRetentionPolicyEnabled == true
        ? containerDeleteRetentionPolicyAllowPermanentDelete
        : null
    }
    cors: {
      corsRules: corsRules
    }
    defaultServiceVersion: !empty(defaultServiceVersion) ? defaultServiceVersion : null
    deleteRetentionPolicy: {
      enabled: deleteRetentionPolicyEnabled
      days: deleteRetentionPolicyDays
      allowPermanentDelete: deleteRetentionPolicyEnabled && deleteRetentionPolicyAllowPermanentDelete ? true : null
    }
    isVersioningEnabled: isVersioningEnabled
    lastAccessTimeTrackingPolicy: storageAccount.kind != 'Storage'
      ? {
          enable: lastAccessTimeTrackingPolicyEnabled
          name: lastAccessTimeTrackingPolicyEnabled == true ? 'AccessTimeTracking' : null
          trackingGranularityInDays: lastAccessTimeTrackingPolicyEnabled == true ? 1 : null
        }
      : null
    restorePolicy: restorePolicyEnabled
      ? {
          enabled: true
          days: restorePolicyDays
        }
      : null
  }
}

resource blobServices_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: blobServices
  }
]

module blobServices_container 'container/main.bicep' = [
  for (container, index) in (containers ?? []): {
    name: '${deployment().name}-Container-${index}'
    params: {
      storageAccountName: storageAccount.name
      name: container.name
      defaultEncryptionScope: container.?defaultEncryptionScope
      denyEncryptionScopeOverride: container.?denyEncryptionScopeOverride
      enableNfsV3AllSquash: container.?enableNfsV3AllSquash
      enableNfsV3RootSquash: container.?enableNfsV3RootSquash
      immutableStorageWithVersioningEnabled: container.?immutableStorageWithVersioningEnabled
      metadata: container.?metadata
      publicAccess: container.?publicAccess
      roleAssignments: container.?roleAssignments
      immutabilityPolicyProperties: container.?immutabilityPolicyProperties
    }
  }
]

@description('The name of the deployed blob service.')
output name string = blobServices.name

@description('The resource ID of the deployed blob service.')
output resourceId string = blobServices.id

@description('The name of the deployed blob service.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?
