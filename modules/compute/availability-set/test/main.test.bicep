// ========== //
// Parameters //
// ========== //

// Shared
@description('Optional. The location to deploy resources to')
param location string = resourceGroup().location

@description('Optional. A short identifier for the kind of deployment. Should be kept short to not run into resource-name length-constraints')
param serviceShort string = 'avs'

// ========== //
// Test Setup //
// ========== //

// General resources
// =================
resource proximityPlacementGroup 'Microsoft.Compute/proximityPlacementGroups@2021-11-01' = {
  name: 'adp-${serviceShort}-az-ppg-x-01'
  location: location
}

resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'adp-${serviceShort}-az-msi-x-01'
  location: location
}

// ============== //
// Test Execution //
// ============== //

// TEST 1 - MIN
module minavs '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-minavs'
  params: {
    name: '${serviceShort}-az-avs-min-01'
    location: location
  }
}

// TEST 2 - GENERAL
module genavs '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-genavs'
  params: {
    name: '${serviceShort}-az-avs-gen-01'
    proximityPlacementGroupId: proximityPlacementGroup.id
    availabilitySetSku: 'aligned'
    availabilitySetUpdateDomain: 2
    availabilitySetFaultDomain: 2
    tags: {
      tag1: 'tag1Value'
      tag2: 'tag2Value'
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader'
        principalIds: [
          managedIdentity.properties.principalId
        ]
        principalType: 'ServicePrincipal'
      }
    ]
    location: location
  }
}
