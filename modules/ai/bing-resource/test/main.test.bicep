/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

targetScope = 'resourceGroup'
param accountName string = 'Bing_SearchTest'
// ===== //
// Tests //
// ===== //

// Test-01 - Bing Search v7 resource


module test_01_Bing '../main.bicep' = {
  name: 'test_01_Bing_resource'
  params: {
     kind: 'Bing.Search.v7'
     accountName: accountName
     skuName: 'F1'
  }
}


// Test-02 - Bing Custom Search resource test

module test_02_Bing '../main.bicep' = {
  name: 'test_02_Bing_resource'
  params: {
     kind: 'Bing.CustomSearch'
     accountName: accountName
     skuName: 'F0'
  }
}
