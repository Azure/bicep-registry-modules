/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

//Prerequisites
// module prereq 'prereq.test.bicep' = {
//   name: 'test-prereqs'
//   params: {
//     location: location
//   }
// }

// Test 0
module test0 '../main.bicep' = {
  name: 'test0'
}

// Test 1
// Set Traffic Manager Endpoint
module test1 '../main.bicep' = {
  name: 'test1'
  params: {
    prefix: 'traf1'
    endpoints: [{
        name: 'my-endpoint-1'
        target: 'www.bing.com'
        endpointStatus: 'Enabled'
        endpointLocation: 'eastus'
    }]
  }
}
