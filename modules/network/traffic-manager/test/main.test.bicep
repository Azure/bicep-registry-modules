/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
targetScope = 'resourceGroup'

//Prerequisites
// module prereq 'prereq.test.bicep' = {
//   name: 'test-prereqs'
//   params: {
//     location: location
//   }
// }
param prefix string = 'traf'
@maxLength(60)
param name string = take('${prefix}-${uniqueString(resourceGroup().id, subscription().id)}', 60)

// Test 0
module test0 '../main.bicep' = {
  name: 'test0'
  params: {
    name: 't0${name}'
    tags: {
      env: 'test'
    }
    trafficManagerDnsName: 'tmp0-${uniqueString(resourceGroup().id, subscription().id, name)}'
  }
}

// Test 1
// Set Traffic Manager Endpoint
module test1 '../main.bicep' = {
  name: 'test1'
  params: {
    name: 't1${name}'
    trafficManagerDnsName: 'tmp1-${uniqueString(resourceGroup().id, subscription().id, name)}'
    endpoints: [ {
        name: 'my-endpoint-1'
        target: 'www.bing.com'
        endpointStatus: 'Enabled'
        endpointLocation: 'eastus'
      } ]
  }
}
