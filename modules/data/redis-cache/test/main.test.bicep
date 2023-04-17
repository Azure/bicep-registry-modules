targetScope = 'resourceGroup'

// ========== //
// Parameters //
// ========== //

param location string = 'eastus'
param serviceShort string = 'redis'
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)

// ============ //
// Dependencies //
// ============ //

module dependencies 'dependencies.test.bicep' = {
  name: 'test-dependencies'
  params: {
    name: serviceShort
    location: location
    prefix: uniqueName
  }
}

// ===== //
// Tests //
// ===== //

// Test 01 - Basic SKU - Minimal Parameters

module test_01 '../main.bicep' = {
  name: '${uniqueName}-test-01'
  params: {
    location: location
    name: '${uniqueName}-test-01'
    skuName: 'Basic'
    redisVersion: '6.0'
    capacity: 1

  }
}

// Test 02 - Standard SKU - Parameters,  Diagnostic Settings
module test_02 '../main.bicep' = {
  name: '${uniqueName}-test-02'
  params: {
        name: '${uniqueName}-test-02'
        location: location
    skuName: 'Standard'
    redisVersion: '6.0'
    capacity: 1
    diagnosticEventHubAuthorizationRuleId: dependencies.outputs.authorizationRuleId
    diagnosticEventHubName: dependencies.outputs.eventHubName
    redisFirewallRules: {
      Rule1: {
        startIP: '10.2.1.20'
        endIP: '10.2.1.25'

      }
      Rule2: {
        startIP: '10.2.1.30'
        endIP: '10.2.1.35'
      }
    }
  }
}

// Test 03 - Premium Test - Diagnostic Settings
module test_03 '../main.bicep' = {
  name: '${uniqueName}-test-03'
  params: {
    name: '${uniqueName}-test-03'
    location: location
    skuName: 'Premium'
    redisVersion: '6.0'
    capacity: 1
    shardCount: 1
    replicasPerMaster: 1
    diagnosticStorageAccountId: dependencies.outputs.storageAccountId
    diagnosticWorkspaceId: dependencies.outputs.workspaceId
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: dependencies.outputs.subnetIds[0]
      }
      {
        name: 'endpoint2'
        subnetId: dependencies.outputs.subnetIds[1]
        privateDnsZoneId: dependencies.outputs.privateDNSZoneId
      }
    ]
  }
}
