/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
targetScope = 'resourceGroup'

// ========== //
// Parameters //
// ========== //

param location string = resourceGroup().location
param serviceShort string = 'postgresqldb'
param administratorLogin string = 'testlogin'
param administratorLoginPassword string = 'test@passw0rd123'

// Dependencies
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

// Test 01 - Basic server with minimal params
module test01 '../main.bicep' = {
  name: 'test01-${uniqueName}'
  params: {
    prefix: 'postgres-test01'
    location: location
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

// Test 02 - Server with databases, configurations, tags and firewalls
module test02_primaryPostgresqlServer '../main.bicep' = {
  dependsOn: [
    dependencies
   ]
  name: 'test02-${uniqueName}'
  params: {
    prefix: 'postgres-test02'
    location: location
    createMode : 'Default'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    publicNetworkAccess: 'Enabled'
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: dependencies.outputs.subnetIds[0]
        manualApprovalEnabled: true
        groupId: 'postgresqlServer'
      }
    ]
    databases: [
      {
        name: 'contoso1'
        charset: 'UTF8'
        collation: 'en_US.UTF8'
      }
      {
        name: 'contoso2'
        charset: 'UTF8'
        collation: 'en_US.UTF8'
      }
    ]
    firewallRules: [
    {
        name: 'allowip'
        // those numbers don't make sense but they are set to validate the logic
        startIpAddress: '10.0.0.1'
        endIpAddress: '10.0.0.254'
    }
    ]
    serverConfigurations: [
      {
        name: 'backend_flush_after'
        value: '256'
      }
      {
        name: 'backslash_quote'
        value: 'OFF'
      }
      {
        name: 'checkpoint_warning'
        value: '45'
      }
    ]
    tags: {
      tag1: 'tag1value'
      tag2: 'tag2value'
    }
  }
}

// Test 03 - Primary server with a replica in paired region
module test03_primaryPostgresqlServer '../main.bicep' = {
  name: 'test03-primary-${uniqueName}'
  params: {
    prefix: 'postgres-test03'
    location: location
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

module test03_replicaPostgresqlServer '../main.bicep' = {
  name: 'test03-replica-${uniqueName}'
  dependsOn: [
    test03_primaryPostgresqlServer
  ]
  params: {
    prefix: 'postgres-test-03-replica'
    location: location
    createMode: 'Replica'
    sourceServerResourceId: test03_primaryPostgresqlServer.outputs.id
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword

  }
}


// Test 04 - Postgres Server with RBAC and private endpoints
module test04 '../main.bicep' = {
  dependsOn: [
    dependencies
   ]
  name: 'test04-${uniqueName}'
  params: {
    prefix: 'postgres-test04'
    location: location
    createMode : 'Default'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'SQL DB Contributor'
        principalIds: [ dependencies.outputs.identityPrincipalIds[0] ]
      }
      {
        roleDefinitionIdOrName: 'Log Analytics Reader'
        principalIds: [ dependencies.outputs.identityPrincipalIds[1] ]
      }
   ]
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: dependencies.outputs.subnetIds[0]
        manualApprovalEnabled: true
        groupId: 'postgresqlServer'
      }
    ]
  }
}

// Test 05 -  Disable TLS
module test05 '../main.bicep' = {
  name: 'test05-${uniqueName}'
  params: {
    prefix: 'postgres-test05'
    location: location
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    minimalTlsVersion: 'TLSEnforcementDisabled'
  }
}

// Test 06 -  Enable TLS - Enable Diagnostic Settings
module test06 '../main.bicep' = {
  name: 'test06-${uniqueName}'
  params: {
    prefix: 'postgres-test06'
    location: location
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    minimalTlsVersion: 'TLS1_0'
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
