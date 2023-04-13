/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
targetScope = 'subscription'

param name string = deployment().name

param location string = deployment().location

resource testResourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: name
  location: location
}

module dependencies1 './dependencies1.bicep' = {
  scope: testResourceGroup
  name: 'dependency1-${uniqueString(testResourceGroup.id)}'
  params: {
    name: uniqueString(name)
    location: location
  }
}

module dependencies2 './dependencies2.bicep' = {
  scope: testResourceGroup
  name: 'dependency2-${uniqueString(testResourceGroup.id)}'
  params: {
    name: uniqueString(name)
    location: location
  }
}

@description('Create key rotation function app for the multiple cosmosdb keys.')
module testMultipleKeys '../main.bicep' = {
  name: 'akv-rotate-test1'
  scope: testResourceGroup
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
        resourceRg: testResourceGroup.name
        keyvaultName: dependencies1.outputs.keyvaultName
        keyvaultRg: testResourceGroup.name
        secretName: 'secret2'
        isCreate: true
        validityDays: 10
      }
      {
        type: 'redis'
        resourceName: dependencies1.outputs.redisName
        keyvaultName: dependencies1.outputs.keyvaultName
        keyvaultRg: testResourceGroup.name
        secretName: 'secret3'
        isCreate: true
      }
    ]
    functionAppIdentityType: 'UserAssigned'
    userAssignedIdentityName: dependencies1.outputs.identityName
    userAssignedIdentityRg: testResourceGroup.name
    systemTopicName: dependencies1.outputs.topicName
    isAssignResourceRole: true
  }
}

@description('Create key rotation func app without VNET')
module testNoVnet '../main.bicep' = {
  name: 'akv-rotate-test2'
  scope: testResourceGroup
  params: {
    location: location
    functionStorageAccountName: dependencies2.outputs.storageAccountName
    analyticWorkspaceId: dependencies2.outputs.workspaceId
    secrets: [
      {
        type: 'cosmosdb'
        resourceName: dependencies2.outputs.cosmosdbName
        resourceRg: testResourceGroup.name
        keyvaultName: dependencies2.outputs.keyvaultName
        keyvaultRg: testResourceGroup.name
        secretName: dependencies2.outputs.secretName
      }
    ]
    userAssignedIdentityName: dependencies2.outputs.identityName
    deploymentScriptStorage: dependencies2.outputs.storageAccountName
  }
}
