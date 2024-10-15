metadata name = 'Managed DevOps Pool'
metadata description = 'This module deploys the Managed DevOps Pool resource.'
metadata owner = 'Azure/module-maintainers'

@description('Required. Name of the pool. It needs to be globally unique.')
param name string

@description('Required. The Azure SKU name of the machines in the pool.')
param fabricProfileSkuName string

@minValue(1)
@maxValue(10000)
@description('Required. Defines how many resources can there be created at any given time.')
param concurrency int

@description('Required. The VM images of the machines in the pool.')
param images imageType[]

@description('Optional. The geo-location where the resource lives.')
param location string = resourceGroup().location

@description('Required. The resource id of the DevCenter Project the pool belongs to.')
param devCenterProjectResourceId string

@description('Optional. The subnet id on which to put all machines created in the pool.')
param subnetResourceId string?

@description('Required. Defines how the machine will be handled once it executed a job.')
param agentProfile agentProfileType

@description('Optional. The OS profile of the agents in the pool.')
param osProfile osProfileType = {
  logonType: 'Interactive'
  secretsManagementSettings: {
    keyExportable: false
    observedCertificates: []
  }
}

@description('Optional. The storage profile of the machines in the pool.')
param storageProfile storageProfileType

@description('Required. Defines the organization in which the pool will be used.')
param organizationProfile organizationProfileType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. The managed service identities assigned to this resource.')
@metadata({
  example: '''
  {
    systemAssigned: true,
    userAssignedResourceIds: [
      '/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/myResourceGroup/providers/Microsoft.ManagedIdentity/userAssignedIdentities/myManagedIdentity'
    ]
  }
  {
    systemAssigned: true
  }
  '''
})
param managedIdentities managedIdentitiesType

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator (Preview)': subscriptionResourceId(
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

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.devopsinfrastructure-pool.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource managedDevOpsPool 'Microsoft.DevOpsInfrastructure/pools@2024-04-04-preview' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    agentProfile: agentProfile
    devCenterProjectResourceId: devCenterProjectResourceId
    fabricProfile: {
      sku: {
        name: fabricProfileSkuName
      }
      networkProfile: !empty(subnetResourceId)
        ? {
            subnetId: subnetResourceId!
          }
        : null
      osProfile: osProfile
      storageProfile: storageProfile
      kind: 'Vmss'
      images: images
    }
    maximumConcurrency: concurrency
    organizationProfile: organizationProfile
  }
}

resource managedDevOpsPool_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: managedDevOpsPool
}

resource managedDevOpsPool_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(
      managedDevOpsPool.id,
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
    scope: managedDevOpsPool
  }
]

resource managedDevOpsPool_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
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
    scope: managedDevOpsPool
  }
]

@description('The name of the Managed DevOps Pool.')
output name string = managedDevOpsPool.name

@description('The resource ID of the Managed DevOps Pool.')
output resourceId string = managedDevOpsPool.id

@description('The name of the resource group the Managed DevOps Pool resource was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The location the Managed DevOps Pool resource was deployed into.')
output location string = managedDevOpsPool.location

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = managedDevOpsPool.?identity.?principalId

@export()
type osProfileType = {
  @description('Required. The logon type of the machine.')
  logonType: ('Interactive' | 'Service')

  @description('Optional. The secret management settings of the machines in the pool.')
  secretsManagementSettings: {
    @description('Required. The secret management settings of the machines in the pool.')
    keyExportable: bool

    @description('Required. The list of certificates to install on all machines in the pool.')
    observedCertificates: string[]

    @description('Optional. Where to store certificates on the machine.')
    certificateStoreLocation: string?
  }?
}

@export()
type storageProfileType = {
  @description('Optional. The Azure SKU name of the machines in the pool.')
  osDiskStorageAccountType: ('Premium' | 'StandardSSD' | 'Standard')?

  @description('Optional. A list of empty data disks to attach.')
  dataDisks: {
    @description('Optional. The type of caching to be enabled for the data disks. The default value for caching is readwrite. For information about the caching options see: https://blogs.msdn.microsoft.com/windowsazurestorage/2012/06/27/exploring-windows-azure-drives-disks-and-images/.')
    caching: ('None' | 'ReadOnly' | 'ReadWrite')?

    @description('Optional. The initial disk size in gigabytes.')
    diskSizeGiB: int?

    @description('Optional. The drive letter for the empty data disk. If not specified, it will be the first available letter. Letters A, C, D, and E are not allowed.')
    driveLetter: string?

    @description('Optional. The storage Account type to be used for the data disk. If omitted, the default is Standard_LRS.')
    storageAccountType: ('Premium_LRS' | 'Premium_ZRS' | 'StandardSSD_LRS' | 'StandardSSD_ZRS' | 'Standard_LRS')?
  }[]?
}?

@export()
type imageType = {
  @description('Optional. List of aliases to reference the image by.')
  aliases: string[]?

  @description('Optional. The percentage of the buffer to be allocated to this image.')
  buffer: string?

  @description('Conditional. The image to use from a well-known set of images made available to customers. Required if `resourceId` is not set.')
  wellKnownImageName: string?

  @description('Conditional. The specific resource id of the marketplace or compute gallery image. Required if `wellKnownImageName` is not set.')
  resourceId: string?
}

@export()
type organizationProfileType = {
  @description('Required. Azure DevOps organization profile.')
  kind: 'AzureDevOps'

  @description('Optional. The type of permission which determines which accounts are admins on the Azure DevOps pool.')
  permissionProfile: {
    @description('Required. Determines who has admin permissions to the Azure DevOps pool.')
    kind: 'CreatorOnly' | 'Inherit' | 'SpecificAccounts'

    @description('Optional. Group email addresses.')
    groups: string[]?

    @description('Optional. User email addresses.')
    users: string[]?
  }?

  @description('Required. The list of Azure DevOps organizations the pool should be present in..')
  organizations: {
    @description('Required. The Azure DevOps organization URL in which the pool should be created.')
    url: string

    @description('Optional. List of projects in which the pool should be created.')
    projects: string[]?

    @description('Optional. How many machines can be created at maximum in this organization out of the maximumConcurrency of the pool.')
    @minValue(1)
    @maxValue(10000)
    parallelism: int?
  }[]
}

@export()
type dataDiskType = {
  @description('Optional. The type of caching to be enabled for the data disks. The default value for caching is readwrite. For information about the caching options see: https://blogs.msdn.microsoft.com/windowsazurestorage/2012/06/27/exploring-windows-azure-drives-disks-and-images/.')
  caching: ('None' | 'ReadOnly' | 'ReadWrite')?

  @description('Optional. The initial disk size in gigabytes.')
  diskSizeGiB: int?

  @description('Optional. The drive letter for the empty data disk. If not specified, it will be the first available letter. Letters A, C, D, and E are not allowed.')
  driveLetter: string?

  @description('Optional. The storage Account type to be used for the data disk. If omitted, the default is Standard_LRS.')
  storageAccountType: ('Premium_LRS' | 'Premium_ZRS' | 'StandardSSD_LRS' | 'StandardSSD_ZRS' | 'Standard_LRS')?
}[]?

@export()
type resourcePredictionsProfileAutomaticType = {
  @description('Required. The stand-by agent scheme is determined based on historical demand.')
  kind: 'Automatic'

  @description('Required. Determines the balance between cost and performance.')
  predictionPreference: 'Balanced' | 'MostCostEffective' | 'MoreCostEffective' | 'MorePerformance' | 'BestPerformance'
}

@export()
type resourcePredictionsProfileManualType = {
  @description('Required. Customer provides the stand-by agent scheme.')
  kind: 'Manual'
}

@export()
type agentStatefulType = {
  @description('Required. Stateful profile meaning that the machines will be returned to the pool after running a job.')
  kind: 'Stateful'

  @description('Required. How long should stateful machines be kept around. The maximum is one week.')
  maxAgentLifetime: string

  @description('Required. How long should the machine be kept around after it ran a workload when there are no stand-by agents. The maximum is one week.')
  gracePeriodTimeSpan: string

  @description('Optional. Defines pool buffer/stand-by agents.')
  resourcePredictions: object?

  @discriminator('kind')
  @description('Optional. Determines how the stand-by scheme should be provided.')
  resourcePredictionsProfile: (resourcePredictionsProfileAutomaticType | resourcePredictionsProfileManualType)?
}

@export()
type agentStatelessType = {
  @description('Required. Stateless profile meaning that the machines will be cleaned up after running a job.')
  kind: 'Stateless'

  @description('Optional. Defines pool buffer/stand-by agents.')
  resourcePredictions: {
    @description('Required. The time zone in which the daysData is provided. To see the list of available time zones, see: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-time-zones?view=windows-11#time-zones or via PowerShell command `(Get-TimeZone -ListAvailable).StandardName`.')
    timeZone: string

    @description('Optional. The number of agents needed at a specific time.')
    @metadata({
      example: '''
      [
        { // Monday
          '09:00': 5
          '22:00': 0
        }
        {} // Tuesday
        {} // Wednesday
        {} // Thursday
        { // Friday
          '09:00': 5
          '22:00': 0
        }
        {} // Saturday
        {} // Sunday
      ]
      '''
    })
    daysData: object[]?
  }?

  @discriminator('kind')
  @description('Optional. Determines how the stand-by scheme should be provided.')
  resourcePredictionsProfile: (resourcePredictionsProfileAutomaticType | resourcePredictionsProfileManualType)?
}

@discriminator('kind')
@export()
type agentProfileType = agentStatefulType | agentStatelessType

@export()
type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

@export()
type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

@export()
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

  @description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
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

@export()
type managedIdentitiesType = {
  @description('Optional. Enables system assigned managed identity on the resource.')
  systemAssigned: bool?

  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]?
}?
