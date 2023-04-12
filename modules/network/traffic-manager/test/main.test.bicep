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
param endpoints array = [
  {
    name: 'my-endpoint-1'
    target: 'http://www.bing.com'
    endpointStatus: 'Enabled'
    endpointLocation: 'eastus'
  }
]

module test1 '../main.bicep' = {
  name: 'test1'
  params: {
    endpoints: endpoints
  }
}
