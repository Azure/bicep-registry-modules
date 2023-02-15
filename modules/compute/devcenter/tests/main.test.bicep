/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
@description('Deployment Location')
param location string = 'eastus'

module test1 '../main.bicep' = {
  name: 'Test1'
  params: {
    location: location
  }
}

