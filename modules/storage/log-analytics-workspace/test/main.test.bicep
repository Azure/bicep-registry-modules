/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

targetScope = 'resourceGroup'
param location string = resourceGroup().location
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)

param tags object = {
  costcenter: '000'
  environment: 'dev'
  location: resourceGroup().location
}

// ===== //
// Tests //
// ===== //

//test 01 - Minimal Parameters//

module test_01 '../main.bicep' = {
  name: '${uniqueName}-test01'
  params: {
    name: 'test01${uniqueName}'
    location: location
    tags: tags
  }
}
