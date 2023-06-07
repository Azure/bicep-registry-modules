targetScope = 'resourceGroup'

// ========== //
// Parameters //
// ========== //

param location string = 'eastus'
param serviceShort string = 'appconf'
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)

// ============ //
// Dependencies //
// ============ //

module dependencies 'prereq.test.bicep' = {
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
    prefix: 'appconf-test01'
    location: location
    skuName: 'Standard'
  }
}

// Test 02 - Deployment with Standard SKU - softDeleteRetentionInDays - RoleAssignments
module test02 '../main.bicep' = {
  name: 'test02-${uniqueName}'
  params: {
    prefix: 'appconf-test02'
    location: location
    skuName: 'Standard'
    softDeleteRetentionInDays: 2
    enablePurgeProtection: false
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'App Configuration Data Owner'
        principalIds: [ dependencies.outputs.identityPrincipalIds[0] ]
      }
      {
        roleDefinitionIdOrName: 'App Configuration Data Reader'
        principalIds: [ dependencies.outputs.identityPrincipalIds[1] ]
      }
    ]
  }
}

// Test 03 - Deployment with 2 replicas - tags - SystemAssigned managed identity.
module test03 '../main.bicep' = {
  name: 'test03-${uniqueName}'
  params: {
    prefix: 'appconf-test03'
    location: location
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
    prefix: 'appconf-test04'
    location: location
    skuName: 'Standard'
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: dependencies.outputs.subnetIds[0]
        manualApprovalEnabled: false
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
    prefix: 'appconf-test05'
    location: location
    skuName: 'Standard'
    identityType: 'UserAssigned'
    userAssignedIdentities: {
      '${dependencies.outputs.identityIds[0]}': {}
    }
    appConfigEncryption: {
      keyIdentifier: dependencies.outputs.keyVaultKeyUri
      identityClientId: dependencies.outputs.identityClientIds[0]
    }
  }
}


// Test 06 -  Configure key-values pair - diagnosticSettings
module test06 '../main.bicep' = {
  name: 'test06-${uniqueName}'
  params: {
    prefix: 'appconf-test06'
    location: location
    skuName: 'Standard'
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
  diagnosticSettingsProperties: {
    logs: [{
        categoryGroup: 'allLogs'
        enabled: true
    }]
    metrics: [{
      category: 'AllMetrics'
      enabled: true
      retentionPolicy: {
        days: 2
        enabled: true
      }
    }]
    diagnosticReceivers: {
      eventHub: {
        EventHubName: dependencies.outputs.eventHubName
        EventHubAuthorizationRuleId: dependencies.outputs.eventHubAuthorizationRuleId
      }
      storageAccountId: dependencies.outputs.storageAccountId
      workspaceId: dependencies.outputs.workspaceId
    }
  }
  }
}
