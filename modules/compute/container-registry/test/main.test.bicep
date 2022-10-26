targetScope = 'resourceGroup'

// ========== //
// Parameters //
// ========== //

param location string = 'westus2'
param serviceShort string = 'acr'
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
    name: 'test01${uniqueName}'
    location: location
  }
}

// Test 02 - Standard SKU - Parameters, RBAC and Diagnostic Settings
module test_02 '../main.bicep' = {
  name: '${uniqueName}-test-02'
  params: {
    name: 'test02${uniqueName}'
    location: location
    skuName: 'Standard'
    adminUserEnabled: true
    tags: {
      tag1: 'tag1value'
      tag2: 'tag2value'
    }
    diagnosticStorageAccountId: dependencies.outputs.storageAccountId
    diagnosticWorkspaceId: dependencies.outputs.workspaceId
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'AcrPull'
        principalIds: [ dependencies.outputs.identityPrincipalIds[0] ]
      }
    ]
  }
}

// Test 03 - Standard SKU - Parameters, RBAC and Diagnostic Settings
module test_03 '../main.bicep' = {
  name: '${uniqueName}-test-03'
  params: {
    name: 'test03${uniqueName}'
    location: location
    skuName: 'Standard'
    adminUserEnabled: false
    diagnosticEventHubAuthorizationRuleId: dependencies.outputs.authorizationRuleId
    diagnosticEventHubName: dependencies.outputs.eventHubName
    roleAssignments: [
      {
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '7f951dda-4ed3-4680-a7ca-43fe172d538d') // AcrPull
        principalIds: [ dependencies.outputs.identityPrincipalIds[1] ]
      }
    ]
  }
}

// Test 04 - Premium Test - Network Rules & Zone Redundancy
module test_04 '../main.bicep' = {
  name: '${uniqueName}-test-04'
  params: {
    name: 'test04${uniqueName}'
    location: location
    skuName: 'Premium'
    publicAzureAccessEnabled: false
    networkAllowedIpRanges: [
      '20.112.52.29'
      '20.53.204.50'
    ]
    zoneRedundancyEnabled: true
  }
}

// Test 05 - Premium Test - Private Endpoint
module test_05 '../main.bicep' = {
  name: '${uniqueName}-test-05'
  params: {
    name: 'test05${uniqueName}'
    location: location
    skuName: 'Premium'
    publicNetworkAccessEnabled: false
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

// Test 06 - Premium Test - Private Endpoint
module test_06 '../main.bicep' = {
  name: '${uniqueName}-test-06'
  params: {
    name: 'test06${uniqueName}'
    location: location
    skuName: 'Premium'
    publicNetworkAccessEnabled: false
    exportPolicyEnabled: true
    quarantinePolicyEnabled: true
    retentionPolicyEnabled: true
    retentionPolicyInDays: 5
    trustPolicyEnabled: true
  }
}

// Test 07 - Premium Test - Replication
module test_07 '../main.bicep' = {
  name: '${uniqueName}-test-07'
  params: {
    name: 'test07${uniqueName}'
    location: location
    skuName: 'Premium'
    replicationLocations: [
      {
        location: 'eastus2'
      }
      {
        location: 'northeurope'
        regionEndpointEnabled: true
        zoneRedundancy: true
      }
    ]
  }
}
