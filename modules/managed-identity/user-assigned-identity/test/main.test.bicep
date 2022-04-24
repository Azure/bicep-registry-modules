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
resource managedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2018-11-30' = {
  name: 'adp-${serviceShort}-az-msi-x-01'
  location: location
}

// ============== //
// Test Execution //
// ============== //

// TEST 1 - MIN
module minuai '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-min'
  params: {
    name: '${serviceShort}-az-uai-min-01'
    location: location
  }
}

// TEST 2 - All properties
module genuai '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-gen-uai'
  params: {
    name: '${serviceShort}-az-uai-gen-01'
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


