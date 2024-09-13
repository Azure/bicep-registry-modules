# Event Hub Namespace Event Hubs `[Microsoft.EventHub/namespaces/eventhubs]`

This module deploys an Event Hub Namespace Event Hub.

## Navigation

- [Resource Types](#Resource-Types)
- [Parameters](#Parameters)
- [Outputs](#Outputs)

## Resource Types

| Resource Type | API Version |
| :-- | :-- |
| `Microsoft.Authorization/locks` | [2020-05-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2020-05-01/locks) |
| `Microsoft.Authorization/roleAssignments` | [2022-04-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.Authorization/2022-04-01/roleAssignments) |
| `Microsoft.EventHub/namespaces/eventhubs` | [2022-10-01-preview](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2022-10-01-preview/namespaces/eventhubs) |
| `Microsoft.EventHub/namespaces/eventhubs/authorizationRules` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2024-01-01/namespaces/eventhubs/authorizationRules) |
| `Microsoft.EventHub/namespaces/eventhubs/consumergroups` | [2024-01-01](https://learn.microsoft.com/en-us/azure/templates/Microsoft.EventHub/2024-01-01/namespaces/eventhubs/consumergroups) |

## Parameters

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`name`](#parameter-name) | string | The name of the event hub. |

**Conditional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`namespaceName`](#parameter-namespacename) | string | The name of the parent event hub namespace. Required if the template is used in a standalone deployment. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`authorizationRules`](#parameter-authorizationrules) | array | Authorization Rules for the event hub. |
| [`captureDescriptionDestinationArchiveNameFormat`](#parameter-capturedescriptiondestinationarchivenameformat) | string | Blob naming convention for archive, e.g. {Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}. Here all the parameters (Namespace,EventHub .. etc) are mandatory irrespective of order. |
| [`captureDescriptionDestinationBlobContainer`](#parameter-capturedescriptiondestinationblobcontainer) | string | Blob container Name. |
| [`captureDescriptionDestinationName`](#parameter-capturedescriptiondestinationname) | string | Name for capture destination. |
| [`captureDescriptionDestinationStorageAccountResourceId`](#parameter-capturedescriptiondestinationstorageaccountresourceid) | string | Resource ID of the storage account to be used to create the blobs. |
| [`captureDescriptionEnabled`](#parameter-capturedescriptionenabled) | bool | A value that indicates whether capture description is enabled. |
| [`captureDescriptionEncoding`](#parameter-capturedescriptionencoding) | string | Enumerates the possible values for the encoding format of capture description. Note: "AvroDeflate" will be deprecated in New API Version. |
| [`captureDescriptionIntervalInSeconds`](#parameter-capturedescriptionintervalinseconds) | int | The time window allows you to set the frequency with which the capture to Azure Blobs will happen. |
| [`captureDescriptionSizeLimitInBytes`](#parameter-capturedescriptionsizelimitinbytes) | int | The size window defines the amount of data built up in your Event Hub before an capture operation. |
| [`captureDescriptionSkipEmptyArchives`](#parameter-capturedescriptionskipemptyarchives) | bool | A value that indicates whether to Skip Empty Archives. |
| [`consumergroups`](#parameter-consumergroups) | array | The consumer groups to create in this event hub instance. |
| [`lock`](#parameter-lock) | object | The lock settings of the service. |
| [`messageRetentionInDays`](#parameter-messageretentionindays) | int | Number of days to retain the events for this Event Hub, value should be 1 to 7 days. Will be automatically set to infinite retention if cleanup policy is set to "Compact". |
| [`partitionCount`](#parameter-partitioncount) | int | Number of partitions created for the Event Hub, allowed values are from 1 to 32 partitions. |
| [`retentionDescriptionCleanupPolicy`](#parameter-retentiondescriptioncleanuppolicy) | string | Retention cleanup policy. Enumerates the possible values for cleanup policy. |
| [`retentionDescriptionRetentionTimeInHours`](#parameter-retentiondescriptionretentiontimeinhours) | int | Retention time in hours. Number of hours to retain the events for this Event Hub. This value is only used when cleanupPolicy is Delete. If cleanupPolicy is Compact the returned value of this property is Long.MaxValue. |
| [`retentionDescriptionTombstoneRetentionTimeInHours`](#parameter-retentiondescriptiontombstoneretentiontimeinhours) | int | Retention cleanup policy. Number of hours to retain the tombstone markers of a compacted Event Hub. This value is only used when cleanupPolicy is Compact. Consumer must complete reading the tombstone marker within this specified amount of time if consumer begins from starting offset to ensure they get a valid snapshot for the specific key described by the tombstone marker within the compacted Event Hub. |
| [`roleAssignments`](#parameter-roleassignments) | array | Array of role assignments to create. |
| [`status`](#parameter-status) | string | Enumerates the possible values for the status of the Event Hub. |

### Parameter: `name`

The name of the event hub.

- Required: Yes
- Type: string

### Parameter: `namespaceName`

The name of the parent event hub namespace. Required if the template is used in a standalone deployment.

- Required: Yes
- Type: string

### Parameter: `authorizationRules`

Authorization Rules for the event hub.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      name: 'RootManageSharedAccessKey'
      rights: [
        'Listen'
        'Manage'
        'Send'
      ]
    }
  ]
  ```

### Parameter: `captureDescriptionDestinationArchiveNameFormat`

Blob naming convention for archive, e.g. {Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}. Here all the parameters (Namespace,EventHub .. etc) are mandatory irrespective of order.

- Required: No
- Type: string
- Default: `'{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}'`

### Parameter: `captureDescriptionDestinationBlobContainer`

Blob container Name.

- Required: No
- Type: string
- Default: `''`

### Parameter: `captureDescriptionDestinationName`

Name for capture destination.

- Required: No
- Type: string
- Default: `'EventHubArchive.AzureBlockBlob'`

### Parameter: `captureDescriptionDestinationStorageAccountResourceId`

Resource ID of the storage account to be used to create the blobs.

- Required: No
- Type: string
- Default: `''`

### Parameter: `captureDescriptionEnabled`

A value that indicates whether capture description is enabled.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `captureDescriptionEncoding`

Enumerates the possible values for the encoding format of capture description. Note: "AvroDeflate" will be deprecated in New API Version.

- Required: No
- Type: string
- Default: `'Avro'`
- Allowed:
  ```Bicep
  [
    'Avro'
    'AvroDeflate'
  ]
  ```

### Parameter: `captureDescriptionIntervalInSeconds`

The time window allows you to set the frequency with which the capture to Azure Blobs will happen.

- Required: No
- Type: int
- Default: `300`

### Parameter: `captureDescriptionSizeLimitInBytes`

The size window defines the amount of data built up in your Event Hub before an capture operation.

- Required: No
- Type: int
- Default: `314572800`

### Parameter: `captureDescriptionSkipEmptyArchives`

A value that indicates whether to Skip Empty Archives.

- Required: No
- Type: bool
- Default: `False`

### Parameter: `consumergroups`

The consumer groups to create in this event hub instance.

- Required: No
- Type: array
- Default:
  ```Bicep
  [
    {
      name: '$Default'
    }
  ]
  ```

### Parameter: `lock`

The lock settings of the service.

- Required: No
- Type: object

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`kind`](#parameter-lockkind) | string | Specify the type of lock. |
| [`name`](#parameter-lockname) | string | Specify the name of lock. |

### Parameter: `lock.kind`

Specify the type of lock.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'CanNotDelete'
    'None'
    'ReadOnly'
  ]
  ```

### Parameter: `lock.name`

Specify the name of lock.

- Required: No
- Type: string

### Parameter: `messageRetentionInDays`

Number of days to retain the events for this Event Hub, value should be 1 to 7 days. Will be automatically set to infinite retention if cleanup policy is set to "Compact".

- Required: No
- Type: int
- Default: `1`

### Parameter: `partitionCount`

Number of partitions created for the Event Hub, allowed values are from 1 to 32 partitions.

- Required: No
- Type: int
- Default: `2`

### Parameter: `retentionDescriptionCleanupPolicy`

Retention cleanup policy. Enumerates the possible values for cleanup policy.

- Required: No
- Type: string
- Default: `'Delete'`
- Allowed:
  ```Bicep
  [
    'Compact'
    'Delete'
  ]
  ```

### Parameter: `retentionDescriptionRetentionTimeInHours`

Retention time in hours. Number of hours to retain the events for this Event Hub. This value is only used when cleanupPolicy is Delete. If cleanupPolicy is Compact the returned value of this property is Long.MaxValue.

- Required: No
- Type: int
- Default: `1`

### Parameter: `retentionDescriptionTombstoneRetentionTimeInHours`

Retention cleanup policy. Number of hours to retain the tombstone markers of a compacted Event Hub. This value is only used when cleanupPolicy is Compact. Consumer must complete reading the tombstone marker within this specified amount of time if consumer begins from starting offset to ensure they get a valid snapshot for the specific key described by the tombstone marker within the compacted Event Hub.

- Required: No
- Type: int
- Default: `1`

### Parameter: `roleAssignments`

Array of role assignments to create.

- Required: No
- Type: array
- Roles configurable by name:
  - `'Azure Event Hubs Data Owner'`
  - `'Azure Event Hubs Data Receiver'`
  - `'Azure Event Hubs Data Sender'`
  - `'Contributor'`
  - `'Owner'`
  - `'Reader'`
  - `'Role Based Access Control Administrator'`
  - `'User Access Administrator'`

**Required parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`principalId`](#parameter-roleassignmentsprincipalid) | string | The principal ID of the principal (user/group/identity) to assign the role to. |
| [`roleDefinitionIdOrName`](#parameter-roleassignmentsroledefinitionidorname) | string | The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'. |

**Optional parameters**

| Parameter | Type | Description |
| :-- | :-- | :-- |
| [`condition`](#parameter-roleassignmentscondition) | string | The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container". |
| [`conditionVersion`](#parameter-roleassignmentsconditionversion) | string | Version of the condition. |
| [`delegatedManagedIdentityResourceId`](#parameter-roleassignmentsdelegatedmanagedidentityresourceid) | string | The Resource Id of the delegated managed identity resource. |
| [`description`](#parameter-roleassignmentsdescription) | string | The description of the role assignment. |
| [`name`](#parameter-roleassignmentsname) | string | The name (as GUID) of the role assignment. If not provided, a GUID will be generated. |
| [`principalType`](#parameter-roleassignmentsprincipaltype) | string | The principal type of the assigned principal ID. |

### Parameter: `roleAssignments.principalId`

The principal ID of the principal (user/group/identity) to assign the role to.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.roleDefinitionIdOrName`

The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: '/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11'.

- Required: Yes
- Type: string

### Parameter: `roleAssignments.condition`

The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".

- Required: No
- Type: string

### Parameter: `roleAssignments.conditionVersion`

Version of the condition.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    '2.0'
  ]
  ```

### Parameter: `roleAssignments.delegatedManagedIdentityResourceId`

The Resource Id of the delegated managed identity resource.

- Required: No
- Type: string

### Parameter: `roleAssignments.description`

The description of the role assignment.

- Required: No
- Type: string

### Parameter: `roleAssignments.name`

The name (as GUID) of the role assignment. If not provided, a GUID will be generated.

- Required: No
- Type: string

### Parameter: `roleAssignments.principalType`

The principal type of the assigned principal ID.

- Required: No
- Type: string
- Allowed:
  ```Bicep
  [
    'Device'
    'ForeignGroup'
    'Group'
    'ServicePrincipal'
    'User'
  ]
  ```

### Parameter: `status`

Enumerates the possible values for the status of the Event Hub.

- Required: No
- Type: string
- Default: `'Active'`
- Allowed:
  ```Bicep
  [
    'Active'
    'Creating'
    'Deleting'
    'Disabled'
    'ReceiveDisabled'
    'Renaming'
    'Restoring'
    'SendDisabled'
    'Unknown'
  ]
  ```

## Outputs

| Output | Type | Description |
| :-- | :-- | :-- |
| `name` | string | The name of the event hub. |
| `resourceGroupName` | string | The resource group the event hub was deployed into. |
| `resourceId` | string | The resource ID of the event hub. |
