metadata name = 'Storage Container Stored Path'
metadata description = 'Returns the path stored on an existing storage container, or an empty string if the storage container doesn\'t exist.'

@description('Required. Name of the storage container.')
param name string

@nullIfNotFound()
resource storageContainer 'Microsoft.AzureStackHCI/storageContainers@2024-01-01' existing = {
  name: name
}

@description('The path stored on the storage container, or an empty string if the storage container doesn\'t exist.')
output path string = storageContainer.?properties.?path ?? ''
