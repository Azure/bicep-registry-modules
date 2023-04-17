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

// Test 0.
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


// Test 3
// Insert Secerts into existing Key Vault later in template
module testCosmos2KeyVault 'cosmos.test.bicep' = {
  name: 'test3-comsos-keyvault'
  params: {
    location: location
  }
}
