metadata name = 'Event Hub Namespace Event Hubs'
metadata description = 'This module deploys an Event Hub Namespace Event Hub.'
metadata owner = 'Azure/module-maintainers'

@description('Conditional. The name of the parent event hub namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@description('Required. The name of the event hub.')
param name string

@description('Optional. Authorization Rules for the event hub.')
param authorizationRules array = [
  {
    name: 'RootManageSharedAccessKey'
    rights: [
      'Listen'
      'Manage'
      'Send'
    ]
  }
]

@description('Optional. Number of days to retain the events for this Event Hub, value should be 1 to 7 days. Will be automatically set to infinite retention if cleanup policy is set to "Compact".')
@minValue(1)
@maxValue(7)
param messageRetentionInDays int = 1

@description('Optional. Number of partitions created for the Event Hub, allowed values are from 1 to 32 partitions.')
@minValue(1)
@maxValue(32)
param partitionCount int = 2

@description('Optional. Enumerates the possible values for the status of the Event Hub.')
@allowed([
  'Active'
  'Creating'
  'Deleting'
  'Disabled'
  'ReceiveDisabled'
  'Renaming'
  'Restoring'
  'SendDisabled'
  'Unknown'
])
param status string = 'Active'

@description('Optional. The consumer groups to create in this event hub instance.')
param consumergroups array = [
  {
    name: '$Default'
  }
]

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Name for capture destination.')
param captureDescriptionDestinationName string = 'EventHubArchive.AzureBlockBlob'

@description('Optional. Blob naming convention for archive, e.g. {Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}. Here all the parameters (Namespace,EventHub .. etc) are mandatory irrespective of order.')
param captureDescriptionDestinationArchiveNameFormat string = '{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}'

@description('Optional. Blob container Name.')
param captureDescriptionDestinationBlobContainer string = ''

@description('Optional. Resource ID of the storage account to be used to create the blobs.')
param captureDescriptionDestinationStorageAccountResourceId string = ''

@description('Optional. A value that indicates whether capture description is enabled.')
param captureDescriptionEnabled bool = false

@description('Optional. Enumerates the possible values for the encoding format of capture description. Note: "AvroDeflate" will be deprecated in New API Version.')
@allowed([
  'Avro'
  'AvroDeflate'
])
param captureDescriptionEncoding string = 'Avro'

@description('Optional. The time window allows you to set the frequency with which the capture to Azure Blobs will happen.')
@minValue(60)
@maxValue(900)
param captureDescriptionIntervalInSeconds int = 300

@description('Optional. The size window defines the amount of data built up in your Event Hub before an capture operation.')
@minValue(10485760)
@maxValue(524288000)
param captureDescriptionSizeLimitInBytes int = 314572800

@description('Optional. A value that indicates whether to Skip Empty Archives.')
param captureDescriptionSkipEmptyArchives bool = false

@allowed([
  'Compact'
  'Delete'
])
@description('Optional. Retention cleanup policy. Enumerates the possible values for cleanup policy.')
param retentionDescriptionCleanupPolicy string = 'Delete'

@minValue(1)
@maxValue(168)
@description('Optional. Retention time in hours. Number of hours to retain the events for this Event Hub. This value is only used when cleanupPolicy is Delete. If cleanupPolicy is Compact the returned value of this property is Long.MaxValue.')
param retentionDescriptionRetentionTimeInHours int = 1

@minValue(1)
@maxValue(168)
@description('Optional. Retention cleanup policy. Number of hours to retain the tombstone markers of a compacted Event Hub. This value is only used when cleanupPolicy is Compact. Consumer must complete reading the tombstone marker within this specified amount of time if consumer begins from starting offset to ensure they get a valid snapshot for the specific key described by the tombstone marker within the compacted Event Hub.')
param retentionDescriptionTombstoneRetentionTimeInHours int = 1

var eventHubProperties = {
  messageRetentionInDays: messageRetentionInDays
  partitionCount: partitionCount
  status: status
  retentionDescription: {
    cleanupPolicy: retentionDescriptionCleanupPolicy
    retentionTimeInHours: retentionDescriptionCleanupPolicy == 'Delete'
      ? retentionDescriptionRetentionTimeInHours
      : null
    tombstoneRetentionTimeInHours: retentionDescriptionCleanupPolicy == 'Compact'
      ? retentionDescriptionTombstoneRetentionTimeInHours
      : null
  }
}

var eventHubPropertiesCapture = {
  captureDescription: {
    destination: {
      name: captureDescriptionDestinationName
      properties: {
        archiveNameFormat: captureDescriptionDestinationArchiveNameFormat
        blobContainer: captureDescriptionDestinationBlobContainer
        storageAccountResourceId: captureDescriptionDestinationStorageAccountResourceId
      }
    }
    enabled: captureDescriptionEnabled
    encoding: captureDescriptionEncoding
    intervalInSeconds: captureDescriptionIntervalInSeconds
    sizeLimitInBytes: captureDescriptionSizeLimitInBytes
    skipEmptyArchives: captureDescriptionSkipEmptyArchives
  }
}

var builtInRoleNames = {
  'Azure Event Hubs Data Owner': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f526a384-b230-433a-b45c-95f59c4a2dec'
  )
  'Azure Event Hubs Data Receiver': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'a638d3c7-ab3a-418d-83e6-5f17a39d4fde'
  )
  'Azure Event Hubs Data Sender': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '2b629674-e913-4c01-ae53-ef4638d8f975'
  )
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

resource namespace 'Microsoft.EventHub/namespaces@2024-01-01' existing = {
  name: namespaceName
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2022-10-01-preview' = {
  name: name
  parent: namespace
  properties: captureDescriptionEnabled ? union(eventHubProperties, eventHubPropertiesCapture) : eventHubProperties
}

resource eventHub_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: eventHub
}

module eventHub_consumergroups 'consumergroup/main.bicep' = [
  for (consumerGroup, index) in consumergroups: {
    name: '${deployment().name}-ConsumerGroup-${index}'
    params: {
      namespaceName: namespaceName
      eventHubName: eventHub.name
      name: consumerGroup.name
      userMetadata: contains(consumerGroup, 'userMetadata') ? consumerGroup.userMetadata : ''
    }
  }
]

module eventHub_authorizationRules 'authorization-rule/main.bicep' = [
  for (authorizationRule, index) in authorizationRules: {
    name: '${deployment().name}-AuthRule-${index}'
    params: {
      namespaceName: namespaceName
      eventHubName: eventHub.name
      name: authorizationRule.name
      rights: contains(authorizationRule, 'rights') ? authorizationRule.rights : []
    }
  }
]

resource eventHub_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (roleAssignments ?? []): {
    name: guid(eventHub.id, roleAssignment.principalId, roleAssignment.roleDefinitionIdOrName)
    properties: {
      roleDefinitionId: contains(builtInRoleNames, roleAssignment.roleDefinitionIdOrName)
        ? builtInRoleNames[roleAssignment.roleDefinitionIdOrName]
        : contains(roleAssignment.roleDefinitionIdOrName, '/providers/Microsoft.Authorization/roleDefinitions/')
            ? roleAssignment.roleDefinitionIdOrName
            : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName)
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: eventHub
  }
]

@description('The name of the event hub.')
output name string = eventHub.name

@description('The resource ID of the event hub.')
output resourceId string = eventHub.id

@description('The resource group the event hub was deployed into.')
output resourceGroupName string = resourceGroup().name

// =============== //
//   Definitions   //
// =============== //

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
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
