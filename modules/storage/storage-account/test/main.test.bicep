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
