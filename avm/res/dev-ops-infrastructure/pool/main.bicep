metadata name = 'Managed DevOps Pool'
metadata description = 'This module deploys the Managed DevOps Pool resource.'

// ============ //
// Parameters   //
// ============ //

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
param storageProfile storageProfileType?

@description('Required. Defines the organization in which the pool will be used.')
param organizationProfile organizationProfileType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The lock settings of the service.')
param lock lockType?
import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?
import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?
import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'

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
param managedIdentities managedIdentityAllType?
import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.3.0'

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

var formattedDaysData = !empty(agentProfile.?resourcePredictions.?daysData)
  ? map(
      ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
      day =>
        contains(agentProfile.resourcePredictions.daysData, day)
          ? {
              '${agentProfile.resourcePredictions.daysData[day].startTime}': agentProfile.resourcePredictions.daysData[day].startAgentCount
              '${agentProfile.resourcePredictions.daysData[day].endTime}': agentProfile.resourcePredictions.daysData[day].endAgentCount
            }
          : {}
    )
  : null

// ============== //
// Resources      //
// ============== //

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

resource managedDevOpsPool 'Microsoft.DevOpsInfrastructure/pools@2024-10-19' = {
  name: name
  location: location
  tags: tags
  identity: identity
  properties: {
    // agentProfile: agentProfile
    agentProfile: agentProfile.kind == 'Stateful'
      ? {
          kind: 'Stateful'
          maxAgentLifetime: agentProfile.maxAgentLifetime
          gracePeriodTimeSpan: agentProfile.gracePeriodTimeSpan
          resourcePredictions: !empty(agentProfile.?resourcePredictions)
            ? {
                timeZone: agentProfile.?resourcePredictions.timeZone
                daysData: formattedDaysData
              }
            : null
          resourcePredictionsProfile: agentProfile.?resourcePredictionsProfile
        }
      : {
          kind: 'Stateless'
          resourcePredictions: !empty(agentProfile.?resourcePredictions)
            ? {
                timeZone: agentProfile.?resourcePredictions.timeZone
                daysData: formattedDaysData
              }
            : null
          resourcePredictionsProfile: agentProfile.?resourcePredictionsProfile
        }
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

// ============ //
// Outputs      //
// ============ //

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

// =============== //
//   Definitions   //
// =============== //

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
  dataDisks: dataDiskType[]?
}

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
}

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
  resourcePredictions: {
    @description('Required. The time zone in which the daysData is provided. To see the list of available time zones, see: https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/default-time-zones?view=windows-11#time-zones or via PowerShell command `(Get-TimeZone -ListAvailable).StandardName`.')
    timeZone: string

    @description('Optional. The number of agents needed at a specific time.')
    daysData: daysDataType?
  }?

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
    daysData: daysDataType?
  }?

  @discriminator('kind')
  @description('Optional. Determines how the stand-by scheme should be provided.')
  resourcePredictionsProfile: (resourcePredictionsProfileAutomaticType | resourcePredictionsProfileManualType)?
}

@discriminator('kind')
@export()
type agentProfileType = agentStatefulType | agentStatelessType

@export()
type standbyAgentsConfigType = {
  @description('Required. The time at which the agents are needed.')
  startTime: string

  @description('Required. The time at which the agents are no longer needed.')
  endTime: string

  @description('Required. The number of agents needed at the start time.')
  startAgentCount: int

  @description('Required. The number of agents needed at the end time.')
  endAgentCount: int
}

@export()
type daysDataType = {
  @description('Optional. The number of agents needed at a specific time for Monday.')
  monday: standbyAgentsConfigType?

  @description('Optional. The number of agents needed at a specific time for Tuesday.')
  tuesday: standbyAgentsConfigType?

  @description('Optional. The number of agents needed at a specific time for Wednesday.')
  wednesday: standbyAgentsConfigType?

  @description('Optional. The number of agents needed at a specific time for Thursday.')
  thursday: standbyAgentsConfigType?

  @description('Optional. The number of agents needed at a specific time for Friday.')
  friday: standbyAgentsConfigType?

  @description('Optional. The number of agents needed at a specific time for Saturday.')
  saturday: standbyAgentsConfigType?

  @description('Optional. The number of agents needed at a specific time for Sunday.')
  sunday: standbyAgentsConfigType?
}
