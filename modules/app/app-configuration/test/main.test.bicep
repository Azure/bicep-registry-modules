targetScope = 'resourceGroup'

// ========== //
// Parameters //
// ========== //

param location string = 'eastus'
param serviceShort string = 'appconf'

@maxLength(6)
param uniqueName string = substring(newGuid(), 0, 6)

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

// Test 01 -  Basic Deployment - Minimal Parameters
module test01 '../main.bicep' = {
  name: 'test01-${uniqueName}'
  params: {
    location: location
    skuName: 'Standard'
    name: 'test01-${uniqueName}'
  }
}

// Test 02 - Deployment with Standard SKU - softDeleteRetentionInDays - enablePurgeProtection - RoleAssignments - diagnostics
module test02 '../main.bicep' = {
  name: 'test02-${uniqueName}'
  params: {
    location: location
    name: 'test02-${uniqueName}'
    skuName: 'Standard'
    softDeleteRetentionInDays: 2
    enablePurgeProtection: true
    diagnosticWorkspaceId: dependencies.outputs.workspaceId
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'App Configuration Data Owner'
        principalIds: [ dependencies.outputs.identityPrincipalIds[0] ]
      }
      {
        roleDefinitionIdOrName: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '516239f1-63e1-4d78-a4de-a74fb236a071') // App Configuration Data Reader
        principalIds: [ dependencies.outputs.identityPrincipalIds[1] ]
      }
    ]
  }
}

// Test 03 - Deployment with 2 replicas - tags - SystemAssigned managed identity.
module test03 '../main.bicep' = {
  name: 'test03-${uniqueName}'
  params: {
    location: location
    name: 'test03-${uniqueName}'
    skuName: 'Standard'
    publicNetworkAccess: 'Disabled'
    replicas: [
      {
        name: 'centralindia'
        location: 'centralindia'
      }
      {
        name: 'northeurope'
        location: 'northeurope'
      }
    ]
    identityType: 'SystemAssigned'
    tags: {
      tag1: 'value1'
      tag2: 'value2'
    }
  }
}

// Test 04 - Deployment with private endpoints - Private DNS Zone
module test04 '../main.bicep' = {
  name: 'test04-${uniqueName}'
  params: {
    location: location
    name: 'test04-${uniqueName}'
    skuName: 'Standard'
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: dependencies.outputs.subnetIds[0]
        manualApprovalEnabled: true
      }
      {
        name: 'endpoint2'
        subnetId: dependencies.outputs.subnetIds[1]
        privateDnsZoneId: dependencies.outputs.privateDNSZoneId
      }
    ]
  }
}

// Test 05 - Deployment with data encryption enabled with customer managed key
module test05 '../main.bicep' = {
  name: 'test05-${uniqueName}'
  params: {
    location: location
    name: 'test05-${uniqueName}'
    skuName: 'Standard'
    identityType: 'UserAssigned'
    userAssignedIdentities: {
      '${dependencies.outputs.identityIds[0]}': {}
    }
    keyVaultKeyIdentifier: dependencies.outputs.keyVaultKeyUri
    identityClientId: dependencies.outputs.identityClientIds[0]
  }
}


// Test 06 -  Basic Deployment - Minimal Parameters
module test06 '../main.bicep' = {
  name: 'test06-${uniqueName}'
  params: {
    location: location
    skuName: 'Standard'
    name: 'test06-${uniqueName}'
    appConfigurationStoreKeyValues: [{
      name: 'json-example'
      value: '{"ObjectSetting":{"Targeting":{"Default":true,"Level":"Information"}}}'
      tags: {
        example: 'use a json'
      }
      contentType: 'application/json'
    }, {
      name: 'key-1'
      value: 'value-1'
      tags: {
        example: 'use a key-value pair'
      }
    }
  ]
  }
}
