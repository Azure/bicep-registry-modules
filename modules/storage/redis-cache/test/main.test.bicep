targetScope = 'resourceGroup'

// ========== //
// Parameters //
// ========== //

param location string = 'eastus'
param serviceShort string = 'redis'
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)

// ============= //
// Prerequisites //
// ============= //

module prerequisites 'prereq.test.bicep' = {
  name: 'test-prereqs'
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
  dependsOn: [
    prerequisites
  ]
  params: {
        name: '${uniqueName}-test-02'
        location: location
    skuName: 'Standard'
    redisVersion: '6.0'
    capacity: 1
    diagnosticSettingsProperties: {
      logs: [
        {
          category: 'ConnectedClientList'
          enabled: true
          retentionPolicy: {
            enabled: true
            days: 30
          }
        }
      ]
      metrics: [
        {
          category: 'AllMetrics'
          enabled: true
          retentionPolicy: {
            enabled: true
            days: 30
          }
        }
      ]
      diagnosticReceivers: {
        eventHub: {
          eventHubAuthorizationRuleId: prerequisites.outputs.eventHubAuthorizationRuleId
          eventHubName: prerequisites.outputs.eventHubName
        }
      }
    }
    firewallRules: [
      {
        name: 'Rule1'
        startIpAddress: '10.2.1.20'
        endIpAddress: '10.2.1.25'
      }
      {
        name: 'Rule2'
        startIpAddress: '10.2.1.30'
        endIpAddress: '10.2.1.35'
      }
    ]
  }
}

// Test 03 - Premium Test - Diagnostic Settings
module test_03 '../main.bicep' = {
  name: '${uniqueName}-test-03'
  dependsOn: [
    prerequisites
  ]
  params: {
    name: '${uniqueName}-test-03'
    location: location
    skuName: 'Premium'
    redisVersion: '6.0'
    capacity: 1
    shardCount: 1
    replicasPerMaster: 1
    diagnosticSettingsProperties: {
      logs: [
        {
          category: 'ConnectedClientList'
          enabled: true
          retentionPolicy: {
            enabled: true
            days: 30
          }
        }
      ]
      metrics: [
        {
          category: 'AllMetrics'
          enabled: true
          retentionPolicy: {
            enabled: true
            days: 30
          }
        }
      ]
      diagnosticReceivers: {
        storageAccountId: prerequisites.outputs.storageAccountId
        workspaceId: prerequisites.outputs.workspaceId
      }
    }
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: prerequisites.outputs.subnetIds[0]
      }
      {
        name: 'endpoint2'
        subnetId: prerequisites.outputs.subnetIds[1]
        privateDnsZoneId: prerequisites.outputs.privateDNSZoneId
      }
    ]
  }
}
