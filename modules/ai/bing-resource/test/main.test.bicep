/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

targetScope = 'resourceGroup'
// ===== //
// Tests //
// ===== //

// Test-01 - Bing Search v7 resource

module test_01_Bing '../main.bicep' = {
  name: 'test_01_Bing_resource'
  params: {
    location: 'global'
    kind: 'Bing.Search.v7'
    name: 'Bing_SearchTest01'
    skuName: 'S1'
  }
}

// Test-02 - Bing Custom Search resource test

module test_02_Bing '../main.bicep' = {
  name: 'test_02_Bing_resource'
  params: {
    location: 'global'
    kind: 'Bing.CustomSearch'
    name: 'Bing_SearchTest02'
    skuName: 'S1'
  }
}
