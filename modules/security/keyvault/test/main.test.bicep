/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
param location string = resourceGroup().location

//Prerequisites
module prereq 'prereq.test.bicep' = {
  name: 'test-prereqs'
  params: {
    location: location
  }
}

//Test 0.
module test0 '../main.bicep' = {
  name: 'test0'
  params: {
    location: location
  }
}

// Test 1
// Insert Secerts into existing Key Vault later in template
module test1InsertSecret '../main.bicep' = {
  name: 'test1-insert-secret'
  params: {
    location: location
    #disable-next-line BCP334 BCP335 // These are false positives, the output is configured with annotations
    name: prereq.outputs.name
    newOrExisting: 'existing'
    secretName: 'SampleName'
    secretValue: 'SampleValue'
  }
}

// Test 2
// Insert Secerts into existing Key Vault later in template
module testStorage2KeyVault 'storage.test.bicep' = {
  name: 'test2-storage-keyvault'
  params: {
    location: location
  }
}

var keyVaultName = 'kv${uniqueString(resourceGroup().id, location, 'Test3-Storage2keyvault')}'
var storageAccountName = 'sa${uniqueString(resourceGroup().id, location, 'Test3-Storage2keyvault')}'


// Test 3
module storageAccount 'br/public:storage/storage-account:0.0.1' = {
  name: 'test3-storage-account'
  params: {
    location: location
    name: storageAccountName
  }
}

resource existingStorageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' existing = {
  name: storageAccountName
}

module keyVault '../main.bicep' = {
  name: 'test3-myKeyVault'
  dependsOn: [
    storageAccount
  ]
  params: {
    location: location
    name: keyVaultName
    secretName: 'storage-secret'
    secretValue: existingStorageAccount.listKeys().keys[0].value
  }
}
