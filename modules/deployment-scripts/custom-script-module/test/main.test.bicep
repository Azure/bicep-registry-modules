/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)

module test1 '../main.bicep' = {
  name: 'test1'
  params: {
    name: uniqueName
    location: location
  }
}
