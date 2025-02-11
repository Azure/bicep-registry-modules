metadata name = 'DevTest Labs'
metadata description = 'This module deploys a DevTest Lab.'

@description('Required. The name of the lab.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The properties of any lab announcement associated with this lab.')
param announcement object = {}

@allowed([
  'Contributor'
  'Reader'
])
@description('Optional. The access rights to be granted to the user when provisioning an environment.')
param environmentPermission string = 'Reader'

@description('Optional. Extended properties of the lab used for experimental features.')
param extendedProperties object = {}

@allowed([
  'Standard'
  'StandardSSD'
  'Premium'
])
@description('Optional. Type of storage used by the lab. It can be either Premium or Standard.')
param labStorageType string = 'Premium'

@description('Optional. The resource ID of the storage account used to store artifacts and images by the lab. Also used for defaultStorageAccount, defaultPremiumStorageAccount and premiumDataDiskStorageAccount properties. If left empty, a default storage account will be created by the lab and used.')
param artifactsStorageAccount string = ''

@description('Optional. The ordered list of artifact resource IDs that should be applied on all Linux VM creations by default, prior to the artifacts specified by the user.')
param mandatoryArtifactsResourceIdsLinux array = []

@description('Optional. The ordered list of artifact resource IDs that should be applied on all Windows VM creations by default, prior to the artifacts specified by the user.')
param mandatoryArtifactsResourceIdsWindows array = []

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. The setting to enable usage of premium data disks. When its value is "Enabled", creation of standard or premium data disks is allowed. When its value is "Disabled", only creation of standard data disks is allowed. Default is "Disabled".')
param premiumDataDisks string = 'Disabled'

@description('Optional. The properties of any lab support message associated with this lab.')
param support object = {}

import { managedIdentityOnlyUserAssignedType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The managed identity definition for this resource. For new labs created after 8/10/2020, the lab\'s system assigned identity is set to On by default and lab owner will not be able to turn this off for the lifecycle of the lab.')
param managedIdentities managedIdentityOnlyUserAssignedType?

@description('Optional. The resource ID(s) to assign to the virtual machines associated with this lab.')
param managementIdentitiesResourceIds string[] = []

@description('Optional. Resource Group allocation for virtual machines. If left empty, virtual machines will be deployed in their own Resource Groups. Default is the same Resource Group for DevTest Lab.')
param vmCreationResourceGroupId string = resourceGroup().id

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Enable browser connect on virtual machines if the lab\'s VNETs have configured Azure Bastion.')
param browserConnect string = 'Disabled'

@description('Optional. Disable auto upgrade custom script extension minor version.')
param disableAutoUpgradeCseMinorVersion bool = false

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Enable lab resources isolation from the public internet.')
param isolateLabResources string = 'Enabled'

@allowed([
  'EncryptionAtRestWithPlatformKey'
  'EncryptionAtRestWithCustomerKey'
])
@description('Optional. Specify how OS and data disks created as part of the lab are encrypted.')
param encryptionType string = 'EncryptionAtRestWithPlatformKey'

@description('Conditional. The Disk Encryption Set Resource ID used to encrypt OS and data disks created as part of the the lab. Required if encryptionType is set to "EncryptionAtRestWithCustomerKey".')
param encryptionDiskEncryptionSetId string = ''

@description('Optional. Virtual networks to create for the lab.')
param virtualnetworks virtualNetworkType

@description('Optional. Policies to create for the lab.')
param policies policiesType

@description('Optional. Schedules to create for the lab.')
param schedules scheduleType

@description('Conditional. Notification Channels to create for the lab. Required if the schedules property "notificationSettingsStatus" is set to "Enabled.')
param notificationchannels notificationChannelType

@description('Optional. Artifact sources to create for the lab.')
param artifactsources artifactsourcesType

@description('Optional. Costs to create for the lab.')
param costs costsType

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: !empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned'
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : {}
    }
  : {
      type: 'SystemAssigned'
    }

var formattedManagementIdentities = !empty(managementIdentitiesResourceIds)
  ? reduce(map((managementIdentitiesResourceIds ?? []), (id) => { '${id}': {} }), {}, (cur, next) => union(cur, next))
  : {} // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'DevTest Labs User': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '76283e04-6283-4c54-8f91-bcf1374a3c64'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Resource Policy Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '36243c78-bf99-498c-9df9-86d9f8d28608'
  )
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
  )
  'Virtual Machine Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '9980e02c-c2be-4d73-94e8-173b1dc7cf3c'
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
  name: '46d3xbcp.res.devtestlab-lab.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource lab 'Microsoft.DevTestLab/labs@2018-10-15-preview' = {
  name: name
  location: location
  tags: tags ?? {}
  identity: identity
  properties: {
    artifactsStorageAccount: artifactsStorageAccount
    announcement: announcement
    environmentPermission: environmentPermission
    extendedProperties: extendedProperties
    labStorageType: labStorageType
    mandatoryArtifactsResourceIdsLinux: mandatoryArtifactsResourceIdsLinux
    mandatoryArtifactsResourceIdsWindows: mandatoryArtifactsResourceIdsWindows
    premiumDataDisks: premiumDataDisks
    support: support
    managementIdentities: formattedManagementIdentities
    vmCreationResourceGroupId: vmCreationResourceGroupId
    browserConnect: browserConnect
    disableAutoUpgradeCseMinorVersion: disableAutoUpgradeCseMinorVersion
    isolateLabResources: isolateLabResources
    encryption: {
      type: encryptionType
      diskEncryptionSetId: !empty(encryptionDiskEncryptionSetId) ? encryptionDiskEncryptionSetId : null
    }
  }
}

resource lab_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: lab
}

module lab_virtualNetworks 'virtualnetwork/main.bicep' = [
  for (virtualNetwork, index) in (virtualnetworks ?? []): {
    name: '${uniqueString(deployment().name, location)}-Lab-VirtualNetwork-${index}'
    params: {
      labName: lab.name
      name: virtualNetwork.name
      tags: virtualNetwork.?tags ?? tags
      externalProviderResourceId: virtualNetwork.externalProviderResourceId
      description: virtualNetwork.?description
      allowedSubnets: virtualNetwork.?allowedSubnets
      subnetOverrides: virtualNetwork.?subnetOverrides
    }
  }
]

module lab_policies 'policyset/policy/main.bicep' = [
  for (policy, index) in (policies ?? []): {
    name: '${uniqueString(deployment().name, location)}-Lab-PolicySets-Policy-${index}'
    params: {
      labName: lab.name
      name: policy.name
      description: policy.?description
      evaluatorType: policy.evaluatorType
      factData: policy.?factData
      factName: policy.factName
      status: policy.?status ?? 'Enabled'
      threshold: policy.threshold
    }
  }
]

module lab_schedules 'schedule/main.bicep' = [
  for (schedule, index) in (schedules ?? []): {
    name: '${uniqueString(deployment().name, location)}-Lab-Schedules-${index}'
    params: {
      labName: lab.name
      name: schedule.name
      tags: schedule.?tags ?? tags
      taskType: schedule.taskType
      dailyRecurrence: schedule.?dailyRecurrence
      hourlyRecurrence: schedule.?hourlyRecurrence
      weeklyRecurrence: schedule.?weeklyRecurrence
      status: schedule.?status ?? 'Enabled'
      targetResourceId: schedule.?targetResourceId
      timeZoneId: schedule.?timeZoneId ?? 'Pacific Standard time'
      notificationSettings: schedule.?notificationSettings
    }
  }
]

module lab_notificationChannels 'notificationchannel/main.bicep' = [
  for (notificationChannel, index) in (notificationchannels ?? []): {
    name: '${uniqueString(deployment().name, location)}-Lab-NotificationChannels-${index}'
    params: {
      labName: lab.name
      name: notificationChannel.name
      tags: notificationChannel.?tags ?? tags
      description: notificationChannel.?description
      events: notificationChannel.events
      emailRecipient: notificationChannel.?emailRecipient
      webHookUrl: notificationChannel.?webHookUrl
      notificationLocale: notificationChannel.?notificationLocale ?? 'en'
    }
  }
]

module lab_artifactSources 'artifactsource/main.bicep' = [
  for (artifactSource, index) in (artifactsources ?? []): {
    name: '${uniqueString(deployment().name, location)}-Lab-ArtifactSources-${index}'
    params: {
      labName: lab.name
      name: artifactSource.name
      tags: artifactSource.?tags ?? tags
      displayName: artifactSource.?displayName ?? artifactSource.name
      branchRef: artifactSource.?branchRef
      folderPath: artifactSource.?folderPath
      armTemplateFolderPath: artifactSource.?armTemplateFolderPath
      sourceType: artifactSource.?sourceType
      status: artifactSource.?status ?? 'Enabled'
      uri: artifactSource.uri
      securityToken: artifactSource.?securityToken
    }
  }
]

module lab_costs 'cost/main.bicep' = if (!empty(costs)) {
  name: '${uniqueString(deployment().name, location)}-Lab-Costs'
  params: {
    labName: lab.name
    tags: costs.?tags ?? tags
    currencyCode: costs.?currencyCode ?? 'USD'
    cycleType: costs!.cycleType
    cycleStartDateTime: costs.?cycleStartDateTime
    cycleEndDateTime: costs.?cycleEndDateTime
    status: costs.?status ?? 'Enabled'
    target: costs.?target ?? 0
    thresholdValue25DisplayOnChart: costs.?thresholdValue25DisplayOnChart ?? 'Disabled'
    thresholdValue25SendNotificationWhenExceeded: costs.?thresholdValue25SendNotificationWhenExceeded ?? 'Disabled'
    thresholdValue50DisplayOnChart: costs.?thresholdValue50DisplayOnChart ?? 'Disabled'
    thresholdValue50SendNotificationWhenExceeded: costs.?thresholdValue50SendNotificationWhenExceeded ?? 'Disabled'
    thresholdValue75DisplayOnChart: costs.?thresholdValue75DisplayOnChart ?? 'Disabled'
    thresholdValue75SendNotificationWhenExceeded: costs.?thresholdValue75SendNotificationWhenExceeded ?? 'Disabled'
    thresholdValue100DisplayOnChart: costs.?thresholdValue100DisplayOnChart ?? 'Disabled'
    thresholdValue100SendNotificationWhenExceeded: costs.?thresholdValue100SendNotificationWhenExceeded ?? 'Disabled'
    thresholdValue125DisplayOnChart: costs.?thresholdValue125DisplayOnChart ?? 'Disabled'
    thresholdValue125SendNotificationWhenExceeded: costs.?thresholdValue125SendNotificationWhenExceeded ?? 'Disabled'
  }
}

resource lab_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(lab.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: lab
  }
]

@description('The unique identifier for the lab. Used to track tags that the lab applies to each resource that it creates.')
output uniqueIdentifier string = lab.properties.uniqueIdentifier

@description('The resource group the lab was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('The resource ID of the lab.')
output resourceId string = lab.id

@description('The name of the lab.')
output name string = lab.name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string = lab.identity.principalId

@description('The location the resource was deployed into.')
output location string = lab.location

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. The resource ID(s) to assign to the resource. Currently, a single user-assigned identity is supported per lab.')
  userAssignedResourceIds: string[]
}?

type artifactsourcesType = {
  @description('Required. The name of the artifact source.')
  name: string

  @description('Optional. The tags of the artifact source.')
  tags: object?

  @description('Optional. The display name of the artifact source. Default is the name of the artifact source.')
  displayName: string?

  @description('Optional. The artifact source\'s branch reference (e.g. main or master).')
  branchRef: string?

  @description('Conditional. The folder containing artifacts. At least one folder path is required. Required if "armTemplateFolderPath" is empty.')
  folderPath: string?

  @description('Conditional. The folder containing Azure Resource Manager templates. Required if "folderPath" is empty.')
  armTemplateFolderPath: string?

  @description('Optional. The artifact source\'s type.')
  sourceType: 'GitHub' | 'StorageAccount' | 'VsoGit'?

  @description('Optional. Indicates if the artifact source is enabled (values: Enabled, Disabled). Default is "Enabled".')
  status: 'Enabled' | 'Disabled'?

  @description('Required. The artifact source\'s URI.')
  uri: string

  @description('Optional. The security token to authenticate to the artifact source. Private artifacts use the system-identity of the lab to store the security token for the artifact source in the lab\'s managed Azure Key Vault. Access to the Azure Key Vault is granted automatically only when the lab is created with a system-assigned identity.')
  @secure()
  securityToken: string?
}[]?

import { allowedSubnetType, subnetOverrideType } from 'virtualnetwork/main.bicep'
type virtualNetworkType = {
  @description('Required. The name of the virtual network.')
  name: string

  @description('Optional. The tags of the virtual network.')
  tags: object?

  @description('Required. The external provider resource ID of the virtual network.')
  externalProviderResourceId: string

  @description('Optional. The description of the virtual network.')
  description: string?

  @description('Optional. The allowed subnets of the virtual network.')
  allowedSubnets: allowedSubnetType?

  @description('Optional. The subnet overrides of the virtual network.')
  subnetOverrides: subnetOverrideType?
}[]?

type costsType = {
  @description('Optional. The tags of the resource.')
  tags: object?

  @description('Required. Reporting cycle type.')
  cycleType: 'Custom' | 'CalendarMonth'

  @description('Conditional. Reporting cycle start date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom".')
  cycleStartDateTime: string?

  @description('Conditional. Reporting cycle end date in the zulu time format (e.g. 2023-12-01T00:00:00.000Z). Required if cycleType is set to "Custom".')
  cycleEndDateTime: string?

  @description('Optional. Target cost status.')
  status: 'Enabled' | 'Disabled'?

  @description('Optional. Lab target cost (e.g. 100). The target cost will appear in the "Cost trend" chart to allow tracking lab spending relative to the target cost for the current reporting cycleSetting the target cost to 0 will disable all thresholds.')
  target: int?

  @description('Optional. The currency code of the cost. Default is "USD".')
  currencyCode: string?

  @description('Optional. Target Cost threshold at 25% display on chart. Indicates whether this threshold will be displayed on cost charts.')
  thresholdValue25DisplayOnChart: 'Enabled' | 'Disabled'?

  @description('Optional. Target cost threshold at 25% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.')
  thresholdValue25SendNotificationWhenExceeded: 'Enabled' | 'Disabled'?

  @description('Optional. Target Cost threshold at 50% display on chart. Indicates whether this threshold will be displayed on cost charts.')
  thresholdValue50DisplayOnChart: 'Enabled' | 'Disabled'?

  @description('Optional. Target cost threshold at 50% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.')
  thresholdValue50SendNotificationWhenExceeded: 'Enabled' | 'Disabled'?

  @description('Optional. Target Cost threshold at 75% display on chart. Indicates whether this threshold will be displayed on cost charts.')
  thresholdValue75DisplayOnChart: 'Enabled' | 'Disabled'?

  @description('Optional. Target cost threshold at 75% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.')
  thresholdValue75SendNotificationWhenExceeded: 'Enabled' | 'Disabled'?

  @description('Optional. Target Cost threshold at 100% display on chart. Indicates whether this threshold will be displayed on cost charts.')
  thresholdValue100DisplayOnChart: 'Enabled' | 'Disabled'?

  @description('Optional. Target cost threshold at 100% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.')
  thresholdValue100SendNotificationWhenExceeded: 'Enabled' | 'Disabled'?

  @description('Optional. Target Cost threshold at 125% display on chart. Indicates whether this threshold will be displayed on cost charts.')
  thresholdValue125DisplayOnChart: 'Enabled' | 'Disabled'?

  @description('Optional. Target cost threshold at 125% send notification when exceeded. Indicates whether notifications will be sent when this threshold is exceeded.')
  thresholdValue125SendNotificationWhenExceeded: 'Enabled' | 'Disabled'?
}?

type notificationChannelType = {
  @description('Required. The name of the notification channel.')
  name: 'autoShutdown' | 'costThreshold'

  @description('Optional. The tags of the notification channel.')
  tags: object?

  @description('Optional. The description of the notification.')
  description: string?

  @description('Required. The list of event for which this notification is enabled. Can be "AutoShutdown" or "Cost".')
  events: string[]

  @description('Conditional. The email recipient to send notifications to (can be a list of semi-colon separated email addresses). Required if "webHookUrl" is empty.')
  emailRecipient: string?

  @description('Conditional. The webhook URL to which the notification will be sent. Required if "emailRecipient" is empty.')
  webHookUrl: string?

  @description('Optional. The locale to use when sending a notification (fallback for unsupported languages is EN).')
  notificationLocale: string?
}[]?

type policiesType = {
  @description('Required. The name of the policy.')
  name: string

  @description('Optional. The description of the policy.')
  description: string?

  @description('Required. The evaluator type of the policy (i.e. AllowedValuesPolicy, MaxValuePolicy).')
  evaluatorType: 'AllowedValuesPolicy' | 'MaxValuePolicy'

  @description('Optional. The fact data of the policy.')
  factData: string?

  @description('Required. The fact name of the policy.')
  factName:
    | 'EnvironmentTemplate'
    | 'GalleryImage'
    | 'LabPremiumVmCount'
    | 'LabTargetCost'
    | 'LabVmCount'
    | 'LabVmSize'
    | 'ScheduleEditPermission'
    | 'UserOwnedLabPremiumVmCount'
    | 'UserOwnedLabVmCount'
    | 'UserOwnedLabVmCountInSubnet'

  @description('Optional. The status of the policy. Default is "Enabled".')
  status: 'Disabled' | 'Enabled'?

  @description('Required. The threshold of the policy (i.e. a number for MaxValuePolicy, and a JSON array of values for AllowedValuesPolicy).')
  threshold: string
}[]?

import { dailyRecurrenceType, hourlyRecurrenceType, notificationSettingsType, weeklyRecurrenceType } from 'schedule/main.bicep'
type scheduleType = {
  @description('Required. The name of the schedule.')
  name: 'LabVmsShutdown' | 'LabVmAutoStart'

  @description('Optional. The tags of the schedule.')
  tags: object?

  @description('Required. The task type of the schedule (e.g. LabVmsShutdownTask, LabVmsStartupTask).')
  taskType: 'LabVmsShutdownTask' | 'LabVmsStartupTask'

  @description('Optional. The daily recurrence of the schedule.')
  dailyRecurrence: dailyRecurrenceType?

  @description('Optional. If the schedule will occur multiple times a day, specify the hourly recurrence.')
  hourlyRecurrence: hourlyRecurrenceType?

  @description('Optional. If the schedule will occur only some days of the week, specify the weekly recurrence.')
  weeklyRecurrence: weeklyRecurrenceType?

  @description('Optional. The status of the schedule (i.e. Enabled, Disabled). Default is "Enabled".')
  status: 'Disabled' | 'Enabled'?

  @description('Optional. The resource ID to which the schedule belongs.')
  targetResourceId: string?

  @description('Optional. The time zone ID of the schedule. Defaults to "Pacific Standard time".')
  timeZoneId: string?

  @description('Optional. The notification settings for the schedule.')
  notificationSettings: notificationSettingsType?
}[]?
