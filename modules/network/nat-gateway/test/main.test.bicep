/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
targetScope = 'resourceGroup'
param location string = resourceGroup().location
param name string = replace(take(deployment().name, 55), '.', '')

param tags object = {
  costcenter: '000'
  environment: 'dev'
  location: resourceGroup().location
}

//Prerequisites
module prereq 'prereq.test.bicep' = {
  name: 'test-prereqs-${uniqueString(name)}'
  params: {
    location: location
    name: name
    tags: tags
  }
}

// Test 0
module test0 '../main.bicep' = {
  name: 'test0-${uniqueString(name)}'
  params: {
    name: 'test0-${name}'
    location: location
  }
}

// Test 1
module test1 '../main.bicep' = {
  name: 'test01-${uniqueString(name)}'
  params: {
    name: 'test1-${name}'
    location: location
    publicIpAddresses: [
      {
        id: prereq.outputs.publicIpId
      }
    ]
    publicIpPrefixes: [
      {
        id: prereq.outputs.publicIpPrefixId
      }
    ]
  }
}
