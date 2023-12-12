param namespaceName string
param name string
param messageRetentionInDays int
param partitionCount int
param captureDescriptionEnabled bool
param captureDescriptionDestinationName string
param captureDescriptionDestinationArchiveNameFormat string
param captureDescriptionDestinationBlobContainer string
param captureDescriptionDestinationStorageAccountResourceId string
param captureDescriptionDestinationdataLakeAccountName string
param captureDescriptionDestinationdataLakeFolderPath string
param captureDescriptionDestinationdataLakeSubscriptionId string
param captureDescriptionEncoding string
param captureDescriptionIntervalInSeconds int
param captureDescriptionSizeLimitInBytes int
param captureDescriptionSkipEmptyArchives bool
param roleAssignments array
param status string

var eventHubPropertiesSimple = {
  messageRetentionInDays: messageRetentionInDays
  partitionCount: partitionCount
  status: status
}

var eventHubPropertiesWithCapture = {
  messageRetentionInDays: messageRetentionInDays
  partitionCount: partitionCount
  captureDescription: {
    destination: {
      name: captureDescriptionDestinationName
      properties: {
        archiveNameFormat: captureDescriptionDestinationArchiveNameFormat
        blobContainer: captureDescriptionDestinationBlobContainer
        storageAccountResourceId: captureDescriptionDestinationStorageAccountResourceId
        dataLakeAccountName: captureDescriptionDestinationdataLakeAccountName
        dataLakeFolderPath: captureDescriptionDestinationdataLakeFolderPath
        dataLakeSubscriptionId: captureDescriptionDestinationdataLakeSubscriptionId
      }
    }
    enabled: captureDescriptionEnabled
    encoding: captureDescriptionEncoding
    intervalInSeconds: captureDescriptionIntervalInSeconds
    sizeLimitInBytes: captureDescriptionSizeLimitInBytes
    skipEmptyArchives: captureDescriptionSkipEmptyArchives
    status: status
  }
}

resource namespace 'Microsoft.EventHub/namespaces@2022-10-01-preview' existing = {
  name: namespaceName
}

resource eventHub 'Microsoft.EventHub/namespaces/eventhubs@2022-10-01-preview' = {
  name: name
  parent: namespace
  properties: captureDescriptionEnabled ? eventHubPropertiesWithCapture : eventHubPropertiesSimple
}

module eventHub_roleAssignments './roleAssignment.bicep' = [for (role, index) in roleAssignments: {
  name: '${deployment().name}-evh-role-${index}'
  params: {
    description: role.?description ?? ''
    principalIds: role.principalIds
    principalType: role.?principalType ?? ''
    roleDefinitionIdOrName: role.roleDefinitionIdOrName
    roleName: role.?name ?? ''
    namespaceName: namespaceName
    eventHubName: name
  }
}]
