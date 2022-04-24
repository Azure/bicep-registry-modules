@maxLength(24)
@description('Required. Name of the Storage Account.')
param storageAccountName string

@description('Optional. Name of the blob service.')
param blobServicesName string = 'default'

@description('Required. Name of the container to apply the policy to')
param containerName string

@description('Optional. Name of the immutable policy.')
param name string = 'default'

@description('Optional. The immutability period for the blobs in the container since the policy creation, in days.')
param immutabilityPeriodSinceCreationInDays int = 365

@description('Optional. This property can only be changed for unlocked time-based retention policies. When enabled, new blocks can be written to an append blob while maintaining immutability protection and compliance. Only new blocks can be added and any existing blocks cannot be modified or deleted. This property cannot be changed with ExtendImmutabilityPolicy API')
param allowProtectedAppendWrites bool = true

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-06-01' existing = {
  name: storageAccountName

  resource blobServices 'blobServices@2021-06-01' existing = {
    name: blobServicesName

    resource container 'containers@2019-06-01' existing = {
      name: containerName
    }
  }
}

resource immutabilityPolicy 'Microsoft.Storage/storageAccounts/blobServices/containers/immutabilityPolicies@2019-06-01' = {
  name: name
  parent: storageAccount::blobServices::container
  properties: {
    immutabilityPeriodSinceCreationInDays: immutabilityPeriodSinceCreationInDays
    allowProtectedAppendWrites: allowProtectedAppendWrites
  }
}

@description('The name of the deployed immutability policy.')
output name string = immutabilityPolicy.name

@description('The resource ID of the deployed immutability policy.')
output resourceId string = immutabilityPolicy.id

@description('The resource group of the deployed immutability policy.')
output resourceGroupName string = resourceGroup().name
