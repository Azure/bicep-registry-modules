/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
targetScope = 'resourceGroup'

// ========== //
// Parameters //
// ========== //

param location string = 'eastus'
param serviceShort string = 'mysqldb'
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)
param administratorLogin string = 'testlogin'
param administratorLoginPassword string = 'test@passw0rd123'

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
    prefix: 'mysql-test01'
    location: location
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

// Test 02 -  Mysql Deployment - with login creds
module test02 '../main.bicep' = {
  dependsOn: [
    dependencies
   ]
  name: 'test02-${uniqueName}'
  params: {
    prefix: 'mysql-test02'
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
        groupId: 'mysqlServer'
      }
    ]
    databases: [
    {
        name: 'testdb'
        charset: 'UTF8'
        collation: 'utf8_bin'
     }
    ]
    firewallRules: [
    {
        name: 'allowip'
        startIpAddress: '10.0.0.1'
        endIpAddress: '10.0.0.1'
    }
    ]
    serverConfigurations: [
    {
        name: 'flush_time'
        value: '100'
    }
    {
        name: 'innodb_compression_level'
        value: '7'
    }
    ]
  }
}

// Test-03 - Primary server with a replica in paired region
module test_03_primaryMysqlServer '../main.bicep' = {
  name: 'test-03-primary-${uniqueName}'
  params: {
    prefix: 'mysql-test03'
    location: location
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
  }
}

module test_03_replicaMysqlServer '../main.bicep' = {
  name: 'test-03-replica-${uniqueName}'
  dependsOn: [
    test_03_primaryMysqlServer
  ]
  params: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    prefix: 'mysql-test03-replica'
    location: location
    createMode: 'Replica'
    sourceServerResourceId: test_03_primaryMysqlServer.outputs.id
  }
}

// Test 04 -  MySQL Deployment - with Role Assignments
module test04 '../main.bicep' = {
  dependsOn: [
    dependencies
   ]
  name: 'test04-${uniqueName}'
  params: {
    prefix: 'mysql-test04'
    location: location
    createMode : 'Default'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    publicNetworkAccess: 'Enabled'
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
        manualApprovalEnabled: false
        groupId: 'mysqlServer'
      }
    ]
    databases: [
    {
        name: 'testdb'
        charset: 'UTF8'
        collation: 'utf8_bin'
     }
    ]
    firewallRules: [
    {
        name: 'allowip'
        startIpAddress: '10.0.0.1'
        endIpAddress: '10.0.0.254'
    }
    ]
    serverConfigurations: [
    {
        name: 'flush_time'
        value: '100'
    }
    {
        name: 'innodb_compression_level'
        value: '7'
    }
    ]
  }
}

// Test 05 -  Disable TLS
module test05 '../main.bicep' = {
  name: 'test05-${uniqueName}'
  params: {
    prefix: 'mysql-test05'
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
    prefix: 'mysql-test06'
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
