targetScope = 'resourceGroup'

// ========== //
// Parameters //
// ========== //

param location string = 'westus2'
param serviceShort string = 'pep'
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

// Test 01 - check the module can be called with minimal parameters for use with an ACR
module test_01 '../main.bicep' = {
  name: '${uniqueName}-test-01'
  params: {
    location: location
    name: 'test01'
    privateLinkServiceId: dependencies.outputs.acrId
    subnetId: dependencies.outputs.subnetIds[0]
    groupIds: [
      'registry'
    ]
  }
}

// Test 02 - check the module can be called with optional parameters for use with an ACR
module test_02 '../main.bicep' = {
  name: '${uniqueName}-test-02'
  params: {
    location: location
    name: 'test02'
    privateLinkServiceId: dependencies.outputs.acrId
    subnetId: dependencies.outputs.subnetIds[1]
    groupIds: [
      'registry'
    ]
    privateDnsZones: [
      {
        name: 'default'
        zoneId: dependencies.outputs.privateDNSZoneId
      }
    ]
    manualApprovalEnabled: true
  }
}
