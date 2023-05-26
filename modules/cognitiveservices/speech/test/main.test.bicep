/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
targetScope = 'resourceGroup'
param location string = resourceGroup().location
param serviceShort string = 'speechservice'

// Dependencies
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

// Test-01 - Service with minimal params

module test_01_speechService '../main.bicep' = {
  name: 'test-01-service'
  params: {
    name: 'test-01-service-${uniqueName}'
    location: location
  }
}

// Test-02 - Service with role assignments and private endpoints

module test_02_speechService '../main.bicep' = {
  name: 'test-02-service'
  params: {
    name: 'test-02-service-${uniqueName}'
    location: location
    publicNetworkAccess: 'Disabled'
    customSubDomainName: 'test02service'
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Cognitive Services Speech Contributor'
        principalIds: [ dependencies.outputs.identityPrincipalIds[0] ]
      }
      {
        roleDefinitionIdOrName: 'Cognitive Services Speech User'
        principalIds: [ dependencies.outputs.identityPrincipalIds[1] ]
      }
   ]
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: dependencies.outputs.subnetIds[0]
        manualApprovalEnabled: true
        groupId: 'account'
      }
    ]
  }
}
