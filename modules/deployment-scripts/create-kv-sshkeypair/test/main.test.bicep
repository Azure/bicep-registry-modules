/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

targetScope = 'resourceGroup'

param name string = deployment().name
param location string = resourceGroup().location
param akvName string = take('kvsshkeypair${uniqueString(resourceGroup().id, deployment().name)}', 24)

// Create a key vault and managed identity for testing
module prereq './prereq.test.bicep' = {
  name: 'test'
  params: {
    akvName: akvName
    location: location
    name: name
  }
}

// Test with new managed identity
module test0 '../main.bicep' = {
  name: 'test0-${uniqueString(name)}'
  params: {
    akvName: prereq.outputs.akvName
    location: location
    sshKeyName: 'first-key'
  }
}

// Test with existing managed identity
module test1 '../main.bicep' = {
  dependsOn: [
    test0
  ]
  name: 'test1-${uniqueString(name)}'
  params: {
    akvName: prereq.outputs.akvName
    location: location
    sshKeyName: 'second-key'
    existingManagedIdentityResourceGroupName: resourceGroup().name
    useExistingManagedIdentity: true
    managedIdentityName: prereq.outputs.identityName
    existingManagedIdentitySubId: subscription().subscriptionId
  }
}
