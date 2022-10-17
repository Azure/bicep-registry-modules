targetScope = 'resourceGroup'

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

// Test 01 - Basic SKU - Minimal Parameters
module test_01 '../main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-test-01'
  params: {
    name: 'test01${uniqueString(deployment().name, location)}'
    location: location
  }
}

// Test 02 - Standard SKU - Parameters, RBAC and Diagnostic Settings
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
  name: '${uniqueString(deployment().name, location)}-test-03'
  params: {
    name: 'test03${uniqueString(deployment().name, location)}'
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
  name: '${uniqueString(deployment().name, location)}-test-04'
  params: {
    name: 'test04${uniqueString(deployment().name, location)}'
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
  name: '${uniqueString(deployment().name, location)}-test-05'
  params: {
    name: 'test05${uniqueString(deployment().name, location)}'
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
  name: '${uniqueString(deployment().name, location)}-test-06'
  params: {
    name: 'test06${uniqueString(deployment().name, location)}'
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
