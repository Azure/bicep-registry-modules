param namespaceName string
param name string
param messageRetentionInDays int = 1
param partitionCount int = 2
param status string = 'Active'
param captureDescriptionEnabled bool = false
param captureDescriptionDestinationName string = 'EventHubArchive.AzureBlockBlob'
param captureDescriptionDestinationArchiveNameFormat string = '{Namespace}/{EventHub}/{PartitionId}/{Year}/{Month}/{Day}/{Hour}/{Minute}/{Second}'
param captureDescriptionDestinationBlobContainer string = ''
param captureDescriptionDestinationStorageAccountResourceId string = ''
param captureDescriptionEncoding string = 'Avro'
param captureDescriptionIntervalInSeconds int = 300
param captureDescriptionSizeLimitInBytes int = 314572800
param captureDescriptionSkipEmptyArchives bool = false
param roleAssignments array = []


var eventHubPropertiesSimple = {
  messageRetentionInDays: messageRetentionInDays
  partitionCount: partitionCount
  status: status
}

var eventHubPropertiesWithCapture = {
  messageRetentionInDays: messageRetentionInDays
  partitionCount: partitionCount
  status: status
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

resource namespace 'Microsoft.EventHub/namespaces@2021-11-01' existing = {
  name: namespaceName
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2021-11-01' = {
  name: name
  parent: namespace
  properties: captureDescriptionEnabled ? eventHubPropertiesWithCapture : eventHubPropertiesSimple
}

module eventHub_roleAssignments './roleAssignments.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: '${deployment().name}-Rbac-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    resourceId: eventHub.id
  }
}]
