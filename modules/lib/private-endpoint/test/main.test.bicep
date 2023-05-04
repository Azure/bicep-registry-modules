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

// Test 01 - check the module can be included by default even when no Private Endpoints required.
module test_01 '../main.bicep' = {
  name: '${uniqueName}-test-01'
  params: {
    location: location
  }
}

// Test 02 - validate both use cases with and without Private DNS Registration
module test_02 '../main.bicep' = {
  name: '${uniqueName}-test-02'
  params: {
    location: location
    privateEndpoints: [
      {
        name: '${uniqueName}-${serviceShort}-0'
        privateLinkServiceId: dependencies.outputs.acrId
        groupIds: [
          'registry'
        ]
        subnetId: dependencies.outputs.subnetIds[0]
        privateDnsZones: []
      }
      {
        name: '${uniqueName}-${serviceShort}-1'
        privateLinkServiceId: dependencies.outputs.acrId
        groupIds: [
          'registry'
        ]
        subnetId: dependencies.outputs.subnetIds[1]
        privateDnsZones: [
          {
            name: 'default'
            zoneId: dependencies.outputs.privateDNSZoneId
          }
        ]
      }
    ]
  }
}
