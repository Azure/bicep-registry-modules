/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
targetScope = 'resourceGroup'

//params for testcases
param prefix string = 'traf'
param location string = resourceGroup().location

//Prerequisites
module prereq 'prereq.test.bicep' = {
  name: 'test-dependencies'
  params: {
    location: location
    prefix: prefix
  }
}

// Test 0
module test0 '../main.bicep' = {
  name: 'test0'
  params: {
    prefix: 't0${prefix}'
    tags: {
      env: 'test'
    }
  }
}

// Test 1
// Set Traffic Manager Endpoint and dignostic settings
module test1 '../main.bicep' = {
  name: 'test1'
  params: {
    prefix: 't1${prefix}'
    trafficManagerDnsName: 'tmp1-${uniqueString(resourceGroup().id, subscription().id, prefix)}'
    endpoints: [ {
        name: 'my-endpoint-1'
        target: 'www.bing.com'
        endpointStatus: 'Enabled'
        endpointLocation: 'eastus'
      } ]
    enableDiagnostics: true
    diagnosticStorageAccountId: prereq.outputs.storageAccountId
    diagnosticWorkspaceId: prereq.outputs.workspaceId
    diagnosticEventHubName: prereq.outputs.eventHubName
    diagnosticEventHubAuthorizationRuleId: prereq.outputs.authorizationRuleId
  }
}
