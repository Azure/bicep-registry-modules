/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
param location string = resourceGroup().location

//Prerequisites
// module prereq 'prereq.test.bicep' = {
//   name: 'test-prereqs'
//   params: {
//     location: location
//   }
// }

//Test 0. 
module test0 '../main.bicep' = {
  name: 'test0'
  params: {
    location: location
  }
}

// Test 1
// Insert Secerts into existing Key Vault later in template
module test1_new '../main.bicep' = {
  name: 'test1-new'
  params: {
    location: location
    prefix: 'kv2'
  }
}

module test1_existing '../main.bicep' = {
  name: 'test1-existing'
  params: {
    location: location
    name: test1_new.outputs.name
    newOrExisting: 'existing'
    secrets: [{ secretName: 'SampleName', secretValue: 'SampleValue'}]
  }
}
