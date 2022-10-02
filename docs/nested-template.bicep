// Required Parameters
@description('Deployment Location')
param location string

@description('Resource Group Name')
param resourceGroupName string = resourceGroup().name

@description('Deployment Name')
param name string = uniqueString(resourceGroup().id, subscription().id)

@description('Deployment Name Prefix')
param prefix string = ''

@description('Deploy new or existing resource')
@allowed([ 'new', 'existing' ])
param newOrExisting string = 'new'

// Required Resource Parameters (one set per resource)
@description('Storage Account Location')
param locationStorage string = location

@description('Resource Group Name')
param resourceGroupStorageAccountName string = resourceGroupName

@description('Storage Account Name')
param nameStorageAccount string = name

@description('Storage Account Name Prefix')
param prefixStorageAccount string = ''

@description('Deploy new or existing resource')
@allowed([ 'new', 'existing' ])
param newOrExistingStorageAccount string = newOrExisting

@description('Example of Storage Account parameters')
param propertiesStorageAccount object = {}

// ...Additional Resource Parameters

var configuration = {
  location: location
  resourceGroupName: resourceGroupName
  name: '${prefix}${name}'
  newOrExisting: newOrExisting
  resources: {
    storageAccount: {
      location: locationStorage
      resourceGroupName: resourceGroupStorageAccountName
      name: take(toLower('${prefixStorageAccount}${nameStorageAccount}'), 30)
      newOrExisting: newOrExistingStorageAccount
    }
    // ...Additional Resources
  }
}

// Resource Definitions
resource storageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' = if (configuration.resources.storageAccount.newOrExisting == 'new') {
  name: configuration.resources.storageAccount.name
  location: configuration.resources.storageAccount.location
  properties: propertiesStorageAccount
}

resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2022-05-01' existing = if (configuration.resources.storageAccount.newOrExisting == 'existing') {
  name: configuration.resources.storageAccount.name
}

// ...Additional Resource Declarations

// Required Outputs
@description('Deployed Location')
output location string = location

@description('Deployed Resource Group Name')
output resourceGroupName string = resourceGroupName

@description('Deployed Name')
output name string = name

@description('Deployed new or existing resource')
output newOrExisting string = newOrExisting

// Required Outputs (one set per resource)
@description('Deployed Location')
output locationStorageAccount string = configuration.resources.storageAccount.location

@description('Resource Group Name of Storage Account')
output resourceGroupStorageAccountName string = configuration.resources.storageAccount.resourceGroupName

@description('Storage Account Name')
output nameStorageAccount string = configuration.resources.storageAccount.name

@description('Storage Account ID')
output idStorageAccount string = newOrExistingStorageAccount == 'new' ? storageAccount.id : existingStorageAccount.id

@description('Deployed new or existing resource')
output newOrExistingStorageAccount string = configuration.resources.storageAccount.newOrExisting

// ...Additional Resource Outputs

@description('Deployment Configuration')
output configuration object = configuration
