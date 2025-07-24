@description('Required. The Resource ID or name of the existing Storage Account to connect to.')
param resourceIdOrName string

module parsedResourceId '../../parseResourceId.bicep' = {
  name: take('project-storage-conn-${take(uniqueString(resourceIdOrName), 5)}-parse-resource-id', 64)
  params: {
    resourceIdOrName: resourceIdOrName
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2025-01-01' existing = {
  #disable-next-line no-unnecessary-dependson
  dependsOn: [parsedResourceId]
  name: parsedResourceId!.outputs.name
  scope: resourceGroup(parsedResourceId!.outputs.subscriptionId, parsedResourceId!.outputs.resourceGroupName)
}

@description('Name of the Storage Account.')
output name string = storageAccount.name

@description('Resource ID of the Storage Account.')
output resourceId string = storageAccount.id

@description('Blob endpoint of the Storage Account.')
output blobEndpoint string = storageAccount!.properties.primaryEndpoints.blob

@description('Location of the Storage Account.')
output location string = storageAccount!.location
