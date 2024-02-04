metadata name = 'Storage Account Blob Container Immutability Policies'
metadata description = 'This module deploys a Storage Account Blob Container Immutability Policy.'
metadata owner = 'Azure/module-maintainers'

@maxLength(24)
@description('Conditional. The name of the parent Storage Account. Required if the template is used in a standalone deployment.')
param storageAccountName string

@description('Conditional. The name of the parent container to apply the policy to. Required if the template is used in a standalone deployment.')
param containerName string

@description('Optional. The immutability period for the blobs in the container since the policy creation, in days.')
param immutabilityPeriodSinceCreationInDays int = 365

@description('Optional. This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API.')
param allowProtectedAppendWrites bool = true

@description('Optional. This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to both "Append and Block Blobs" while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API. The "allowProtectedAppendWrites" and "allowProtectedAppendWritesAll" properties are mutually exclusive.')
param allowProtectedAppendWritesAll bool = true

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName

  resource blobServices 'blobServices@2022-09-01' existing = {
    name: 'default'

    resource container 'containers@2022-09-01' existing = {
      name: containerName
    }
  }
}

resource immutabilityPolicy 'Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies@2022-09-01' = {
  name: 'default'
  parent: storageAccount::blobServices::container
  properties: {
    immutabilityPeriodSinceCreationInDays: immutabilityPeriodSinceCreationInDays
    allowProtectedAppendWrites: allowProtectedAppendWrites
    allowProtectedAppendWritesAll: allowProtectedAppendWritesAll
  }
}

@description('The name of the deployed immutability policy.')
output name string = immutabilityPolicy.name

@description('The resource ID of the deployed immutability policy.')
output resourceId string = immutabilityPolicy.id

@description('The resource group of the deployed immutability policy.')
output resourceGroupName string = resourceGroup().name
