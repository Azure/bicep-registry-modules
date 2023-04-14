param name string = resourceGroup().name

param location string = resourceGroup().location

module dependencies1 './dependencies1.bicep' = {
  name: 'dependency1-${uniqueString(resourceGroup().id)}'
  params: {
    name: uniqueString(name)
    location: location
  }
}

module dependencies2 './dependencies2.bicep' = {
  name: 'dependency2-${uniqueString(resourceGroup().id)}'
  params: {
    name: uniqueString(name)
    location: location
  }
}

@description('Create key rotation function app for the multiple cosmosdb keys.')
module testMultipleKeys '../main.bicep' = {
  name: 'akv-rotate-test1'
  params: {
    location: location
    functionAppName: '${uniqueString(name)}-1'
    isEnableVnet: true
    functionAppSubnetId: dependencies1.outputs.functionAppSubnetId
    functionStorageAccountName: dependencies1.outputs.storageAccountName
    isCreateFileShare: true
    isAssignStorageRole: true
    isStoragePrivate: true
    analyticWorkspaceId: dependencies1.outputs.workspaceId
    secrets: [
      {
        type: 'cosmosdb'
        resourceName: dependencies1.outputs.cosmosdbName1
        keyvaultName: dependencies1.outputs.keyvaultName
        secretName: dependencies1.outputs.secretName1
      }
      {
        type: 'cosmosdb'
        resourceName: dependencies1.outputs.cosmosdbName2
        resourceRg: resourceGroup().name
        keyvaultName: dependencies1.outputs.keyvaultName
        keyvaultRg: resourceGroup().name
        secretName: 'secret2'
        isCreate: true
        validityDays: 10
      }
      {
        type: 'redis'
        resourceName: dependencies1.outputs.redisName
        keyvaultName: dependencies1.outputs.keyvaultName
        keyvaultRg: resourceGroup().name
        secretName: 'secret3'
        isCreate: true
      }
    ]
    functionAppIdentityType: 'UserAssigned'
    userAssignedIdentityName: dependencies1.outputs.identityName
    userAssignedIdentityRg: resourceGroup().name
    systemTopicName: dependencies1.outputs.topicName
    isAssignResourceRole: true
  }
}

@description('Create key rotation func app without VNET')
module testNoVnet '../main.bicep' = {
  name: 'akv-rotate-test2'
  params: {
    location: location
    functionStorageAccountName: dependencies2.outputs.storageAccountName
    analyticWorkspaceId: dependencies2.outputs.workspaceId
    secrets: [
      {
        type: 'cosmosdb'
        resourceName: dependencies2.outputs.cosmosdbName
        resourceRg: resourceGroup().name
        keyvaultName: dependencies2.outputs.keyvaultName
        keyvaultRg: resourceGroup().name
        secretName: dependencies2.outputs.secretName
      }
    ]
    userAssignedIdentityName: dependencies2.outputs.identityName
    deploymentScriptStorage: dependencies2.outputs.storageAccountName
  }
}
