// ========== //
// Parameters //
// ========== //

param location string = resourceGroup().location
param serviceShort string = 'acr'

// ============ //
// Dependencies //
// ============ //

module dependencies 'dependencies.test.bicep' = {
  name: 'test-dependencies'
  params: {
    name: serviceShort
    location: location
  }
}

// ===== //
// Tests //
// ===== //

// Test 01 - Basic SKU - Minimal Params
module test_01 '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-01'
  params: {
    name: 'test01${uniqueString(deployment().name, location)}'
    location: location
  }
}

// Test 02 - Standard SKU - Basic params, RBAC and Diagnostic Settings
module test_02 '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-02'
  params: {
    name: 'test02${uniqueString(deployment().name, location)}'
    location: location
    skuName: 'Standard'
    adminUserEnabled: true
    tags: {
      tag1: 'tag1value'
      tag2: 'tag2value'
    }
    diagnosticStorageAccountId: dependencies.outputs.storageAccountId
    diagnosticWorkspaceId: dependencies.outputs.workspaceId
    diagnosticEventHubAuthorizationRuleId: dependencies.outputs.authorizationRuleId
    diagnosticEventHubName: dependencies.outputs.eventHubNamespaceId
  }
}

// Test 03 - Premium Test - Network Rules
module test_03 '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-03'
  params: {
    name: 'test03${uniqueString(deployment().name, location)}'
    location: location
    skuName: 'Premium'
    publicNetworkAccessEnabled: false
    publicAzureAccessEnabled: false
    networkAllowedIpRanges: [
      '20.112.52.29'
      '20.53.203.50'
    ]
  }
}

// Test 04 - Premium Test - Private Endpoint
module test_04 '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-04'
  params: {
    name: 'test04${uniqueString(deployment().name, location)}'
    location: location
    skuName: 'Premium'
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
