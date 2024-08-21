metadata name = 'DevTest Labs'
metadata description = 'This module deploys a DevTest Lab.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the lab.')
param name string

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalIds\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
param roleAssignments roleAssignmentType

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

@description('Optional. The managed identity definition for this resource. DevTest Labs creates a system-assigned identity by default the first time it creates the lab environment.')
param managedIdentities managedIdentitiesType

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
param virtualnetworks array = []

@description('Optional. Policies to create for the lab.')
param policies array = []

@description('Optional. Schedules to create for the lab.')
param schedules array = []

@description('Conditional. Notification Channels to create for the lab. Required if the schedules property "notificationSettingsStatus" is set to "Enabled.')
param notificationchannels array = []

@description('Optional. Artifact sources to create for the lab.')
param artifactsources array = []

@description('Optional. Costs to create for the lab.')
param costs object = {}

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
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : any(null)

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
  for (virtualNetwork, index) in virtualnetworks: {
    name: '${uniqueString(deployment().name, location)}-Lab-VirtualNetwork-${index}'
    params: {
      labName: lab.name
      name: virtualNetwork.name
      tags: virtualNetwork.?tags ?? tags
      externalProviderResourceId: virtualNetwork.externalProviderResourceId
      description: contains(virtualNetwork, 'description') ? virtualNetwork.description : ''
      allowedSubnets: contains(virtualNetwork, 'allowedSubnets') ? virtualNetwork.allowedSubnets : []
      subnetOverrides: contains(virtualNetwork, 'subnetOverrides') ? virtualNetwork.subnetOverrides : []
    }
  }
]

module lab_policies 'policyset/policy/main.bicep' = [
  for (policy, index) in policies: {
    name: '${uniqueString(deployment().name, location)}-Lab-PolicySets-Policy-${index}'
    params: {
      labName: lab.name
      name: policy.name

      description: contains(policy, 'description') ? policy.description : ''
      evaluatorType: policy.evaluatorType
      factData: contains(policy, 'factData') ? policy.factData : ''
      factName: policy.factName
      status: contains(policy, 'status') ? policy.status : 'Enabled'
      threshold: policy.threshold
    }
  }
]

module lab_schedules 'schedule/main.bicep' = [
  for (schedule, index) in schedules: {
    name: '${uniqueString(deployment().name, location)}-Lab-Schedules-${index}'
    params: {
      labName: lab.name
      name: schedule.name
      tags: schedule.?tags ?? tags
      taskType: schedule.taskType
      dailyRecurrence: contains(schedule, 'dailyRecurrence') ? schedule.dailyRecurrence : {}
      hourlyRecurrence: contains(schedule, 'hourlyRecurrence') ? schedule.hourlyRecurrence : {}
      weeklyRecurrence: contains(schedule, 'weeklyRecurrence') ? schedule.weeklyRecurrence : {}
      status: contains(schedule, 'status') ? schedule.status : 'Enabled'
      targetResourceId: contains(schedule, 'targetResourceId') ? schedule.targetResourceId : ''
      timeZoneId: contains(schedule, 'timeZoneId') ? schedule.timeZoneId : 'Pacific Standard time'
      notificationSettingsStatus: contains(schedule, 'notificationSettingsStatus')
        ? schedule.notificationSettingsStatus
        : 'Disabled'
      notificationSettingsTimeInMinutes: contains(schedule, 'notificationSettingsTimeInMinutes')
        ? schedule.notificationSettingsTimeInMinutes
        : 30
    }
  }
]

module lab_notificationChannels 'notificationchannel/main.bicep' = [
  for (notificationChannel, index) in notificationchannels: {
    name: '${uniqueString(deployment().name, location)}-Lab-NotificationChannels-${index}'
    params: {
      labName: lab.name
      name: notificationChannel.name
      tags: notificationChannel.?tags ?? tags
      description: contains(notificationChannel, 'description') ? notificationChannel.description : ''
      events: notificationChannel.events
      emailRecipient: contains(notificationChannel, 'emailRecipient') ? notificationChannel.emailRecipient : ''
      webHookUrl: contains(notificationChannel, 'webhookUrl') ? notificationChannel.webhookUrl : ''
      notificationLocale: contains(notificationChannel, 'notificationLocale')
        ? notificationChannel.notificationLocale
        : 'en'
    }
  }
]

module lab_artifactSources 'artifactsource/main.bicep' = [
  for (artifactSource, index) in artifactsources: {
    name: '${uniqueString(deployment().name, location)}-Lab-ArtifactSources-${index}'
    params: {
      labName: lab.name
      name: artifactSource.name
      tags: artifactSource.?tags ?? tags
      displayName: contains(artifactSource, 'displayName') ? artifactSource.displayName : artifactSource.name
      branchRef: contains(artifactSource, 'branchRef') ? artifactSource.branchRef : ''
      folderPath: contains(artifactSource, 'folderPath') ? artifactSource.folderPath : ''
      armTemplateFolderPath: contains(artifactSource, 'armTemplateFolderPath')
        ? artifactSource.armTemplateFolderPath
        : ''
      sourceType: contains(artifactSource, 'sourceType') ? artifactSource.sourceType : ''
      status: contains(artifactSource, 'status') ? artifactSource.status : 'Enabled'
      uri: artifactSource.uri
    }
  }
]

module lab_costs 'cost/main.bicep' = if (!empty(costs)) {
  name: '${uniqueString(deployment().name, location)}-Lab-Costs'
  params: {
    labName: lab.name
    tags: costs.?tags ?? tags
    currencyCode: contains(costs, 'currencyCode') ? costs.currencyCode : 'USD'
    cycleType: costs.cycleType
    cycleStartDateTime: contains(costs, 'cycleStartDateTime') ? costs.cycleStartDateTime : ''
    cycleEndDateTime: contains(costs, 'cycleEndDateTime') ? costs.cycleEndDateTime : ''
    status: contains(costs, 'status') ? costs.status : 'Enabled'
    target: contains(costs, 'target') ? costs.target : 0
    thresholdValue25DisplayOnChart: contains(costs, 'thresholdValue25DisplayOnChart')
      ? costs.thresholdValue25DisplayOnChart
      : 'Disabled'
    thresholdValue25SendNotificationWhenExceeded: contains(costs, 'thresholdValue25SendNotificationWhenExceeded')
      ? costs.thresholdValue25SendNotificationWhenExceeded
      : 'Disabled'
    thresholdValue50DisplayOnChart: contains(costs, 'thresholdValue50DisplayOnChart')
      ? costs.thresholdValue50DisplayOnChart
      : 'Disabled'
    thresholdValue50SendNotificationWhenExceeded: contains(costs, 'thresholdValue50SendNotificationWhenExceeded')
      ? costs.thresholdValue50SendNotificationWhenExceeded
      : 'Disabled'
    thresholdValue75DisplayOnChart: contains(costs, 'thresholdValue75DisplayOnChart')
      ? costs.thresholdValue75DisplayOnChart
      : 'Disabled'
    thresholdValue75SendNotificationWhenExceeded: contains(costs, 'thresholdValue75SendNotificationWhenExceeded')
      ? costs.thresholdValue75SendNotificationWhenExceeded
      : 'Disabled'
    thresholdValue100DisplayOnChart: contains(costs, 'thresholdValue100DisplayOnChart')
      ? costs.thresholdValue100DisplayOnChart
      : 'Disabled'
    thresholdValue100SendNotificationWhenExceeded: contains(costs, 'thresholdValue100SendNotificationWhenExceeded')
      ? costs.thresholdValue100SendNotificationWhenExceeded
      : 'Disabled'
    thresholdValue125DisplayOnChart: contains(costs, 'thresholdValue125DisplayOnChart')
      ? costs.thresholdValue125DisplayOnChart
      : 'Disabled'
    thresholdValue125SendNotificationWhenExceeded: contains(costs, 'thresholdValue125SendNotificationWhenExceeded')
      ? costs.thresholdValue125SendNotificationWhenExceeded
      : 'Disabled'
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

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

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
