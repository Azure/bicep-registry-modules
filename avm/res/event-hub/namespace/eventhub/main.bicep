metadata name = 'Event Hub Namespace Event Hubs'
metadata description = 'This module deploys an Event Hub Namespace Event Hub.'

@description('Conditional. The name of the parent Event Hub namespace. Required if the template is used in a standalone deployment.')
param namespaceName string

@description('Required. The name of the Event Hub.')
param name string

@description('Optional. Authorization Rules for the Event Hub.')
param authorizationRules eventHubAuthorizationRuleType[] = [
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
@maxValue(90)
param messageRetentionInDays int = 1

@description('Optional. Number of partitions created for the Event Hub, allowed values are from 1 to 32 partitions.')
@minValue(1)
@maxValue(32)
param partitionCount int = 2

@description('Optional. Enumerates the possible values for the status of the Event Hub.')
param status resourceInput<'Microsoft.EventHub/namespaces/eventhubs@2024-01-01'>.properties.status?

@description('Optional. The consumer groups to create in this Event Hub instance.')
param consumergroups consumerGroupType[] = [
  {
    name: '$Default'
  }
]

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Properties of capture description. Note: The chose identity needs the required permissions on the target before the assignment can be executed. For example \'Storage Data Blob Contributor\' for a container. Also, the identity must be configured on the namespace level.')
param captureDescription captureDescriptionType?

@description('Optional. A value that indicates whether to enable retention description properties. If it is set to true the messageRetentionInDays property is ignored.')
param retentionDescriptionEnabled bool = false

@allowed([
  'Compact'
  'Delete'
])
@description('Optional. Retention cleanup policy. Enumerates the possible values for cleanup policy.')
param retentionDescriptionCleanupPolicy string = 'Delete'

@minValue(1)
@maxValue(2160)
@description('Optional. Retention time in hours. Number of hours to retain the events for this Event Hub. This value is only used when cleanupPolicy is Delete and it overrides the messageRetentionInDays. If cleanupPolicy is Compact the returned value of this property is Long.MaxValue.')
param retentionDescriptionRetentionTimeInHours int = 1

@minValue(1)
@maxValue(2160)
@description('Optional. Retention cleanup policy. Number of hours to retain the tombstone markers of a compacted Event Hub. This value is only used when cleanupPolicy is Compact. Consumer must complete reading the tombstone marker within this specified amount of time if consumer begins from starting offset to ensure they get a valid snapshot for the specific key described by the tombstone marker within the compacted Event Hub.')
param retentionDescriptionTombstoneRetentionTimeInHours int = 1

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

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
  'Role Based Access Control Administrator': subscriptionResourceId(
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

var captureIdentity = !empty(captureDescription.?destination.?identity)
  ? {
      type: (captureDescription!.destination!.identity!.?systemAssigned ?? false)
        ? 'SystemAssigned'
        : (!empty(captureDescription!.destination!.identity!.?userAssignedResourceId) ? 'UserAssigned' : null)
      userAssignedIdentity: !empty(captureDescription!.destination!.identity!.?userAssignedResourceId)
        ? captureDescription!.destination!.identity!.userAssignedResourceId!
        : null
    }
  : null

// ============== //
// Resources      //
// ============== //

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.eventhub-nseventhub.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name), 0, 4)}'
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

resource namespace 'Microsoft.EventHub/namespaces@2024-01-01' existing = {
  name: namespaceName
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2024-01-01' = {
  name: name
  parent: namespace
  properties: {
    messageRetentionInDays: retentionDescriptionEnabled ? null : messageRetentionInDays
    partitionCount: partitionCount
    status: status
    retentionDescription: retentionDescriptionEnabled
      ? {
          cleanupPolicy: retentionDescriptionCleanupPolicy
          retentionTimeInHours: retentionDescriptionCleanupPolicy == 'Delete'
            ? retentionDescriptionRetentionTimeInHours
            : null
          tombstoneRetentionTimeInHours: retentionDescriptionCleanupPolicy == 'Compact'
            ? retentionDescriptionTombstoneRetentionTimeInHours
            : null
        }
      : null
    ...(!empty(captureDescription) && (captureDescription!.?enabled != false)
      ? {
          captureDescription: {
            destination: {
              name: captureDescription!.destination!.?name
              identity: captureIdentity
              properties: captureDescription!.destination!.?properties
            }
            enabled: captureDescription!.?enabled ?? true // Assuming that if captureDescription is provided, it's intended to be used
            encoding: captureDescription!.?encoding
            intervalInSeconds: captureDescription!.?intervalInSeconds
            sizeLimitInBytes: captureDescription!.?sizeLimitInBytes
            skipEmptyArchives: captureDescription!.?skipEmptyArchives
          }
        }
      : {})
  }
}

resource eventHub_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
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
      userMetadata: consumerGroup.?userMetadata
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
      rights: authorizationRule.?rights
    }
  }
]

resource eventHub_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(eventHub.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
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

// ============ //
// Outputs      //
// ============ //

@description('The name of the Event Hub.')
output name string = eventHub.name

@description('The resource ID of the Event Hub.')
output resourceId string = eventHub.id

@description('The resource group the Event Hub was deployed into.')
output resourceGroupName string = resourceGroup().name

// ================ //
// Definitions      //
// ================ //

@export()
@description('Type definition for an Event Hub authorization rule.')
type eventHubAuthorizationRuleType = {
  @description('Required. The name of the Event Hub authorization rule.')
  name: string

  @description('Required. The allowed rights for an Event Hub authorization rule.')
  rights: ('Listen' | 'Send' | 'Manage')[]
}

@export()
@description('Type definition for an Event Hub consumer group.')
type consumerGroupType = {
  @description('Required. The name of the consumer group.')
  name: string

  @description('Optional. User Metadata is a placeholder to store user-defined string data with maximum length 1024. e.g. it can be used to store descriptive data, such as list of teams and their contact information also user-defined configuration settings can be stored.')
  userMetadata: string?
}

@export()
@description('The type of a capture description.')
type captureDescriptionType = {
  @description('Optional. Properties of Destination where capture will be stored. (Storage Account, Blob Names).')
  destination: {
    @description('Optional. The identity used for the capture destination.')
    identity: managedIdentityType?

    @description('Optional. Name for capture destination.')
    name: string?

    @description('Optional. Properties describing the storage account, blob container and archive name format for capture destination.')
    properties: resourceInput<'Microsoft.EventHub/namespaces/eventhubs@2024-01-01'>.properties.captureDescription.destination.properties?
  }?

  @description('Optional. A value that indicates whether capture description is enabled. Defaults to true if `captureDescription` is provided.')
  enabled: bool?

  @description('Optional. Enumerates the possible values for the encoding format of capture description. Note: "AvroDeflate" will be deprecated in New API Version.')
  encoding: ('Avro' | 'AvroDeflate')?

  @description('Optional. The time window allows you to set the frequency with which the capture to Azure Blobs will happen.')
  @minValue(60)
  @maxValue(900)
  intervalInSeconds: int?

  @description('Optional. The size window defines the amount of data built up in your Event Hub before an capture operation.')
  @minValue(10485760)
  @maxValue(524288000)
  sizeLimitInBytes: int?

  @description('Optional. A value that indicates whether to Skip Empty Archives.')
  skipEmptyArchives: bool?
}

@export()
@description('An AVM-aligned type for a managed identity configuration. Supports a muturally exclusive system- & user-assigned identity.')
type managedIdentityType = {
  @description('Optional. Enables system assigned managed identity on the resource. Mutually exclusive with `userAssignedResourceId`.')
  systemAssigned: bool?

  @description('Optional. The resource ID to assign to the resource. Mutually exclusive with `systemAssigned`.')
  userAssignedResourceId: string?
}
