/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
targetScope = 'resourceGroup'

//params for testcases
param prefix string = 'traf'
@maxLength(60)
param name string = take('${prefix}-${uniqueString(resourceGroup().id, subscription().id)}', 60)
param location string = resourceGroup().location

//Prerequisites
module prereq 'prereq.test.bicep' = {
  name: 'test-dependencies'
  params: {
    location: location
    prefix: prefix
    name: name
  }
}

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
// Set Traffic Manager Endpoint and dignostic settings
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
    enableDiagnostics: true
    diagnosticStorageAccountId: prereq.outputs.storageAccountId
    diagnosticWorkspaceId: prereq.outputs.workspaceId
    diagnosticEventHubName: prereq.outputs.eventHubName
    diagnosticEventHubAuthorizationRuleId: prereq.outputs.authorizationRuleId
  }
}
