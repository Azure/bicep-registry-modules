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
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    serverName: 'test01-${uniqueName}'
  }
}

// Test 02 -  Mysql Deployment - with login creds


module test02 '../main.bicep' = {
  name: 'test02-${uniqueName}'
  params: {
    location: location
    createMode : 'Default'
    serverName: 'test02-${uniqueName}'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    skuName: 'GP_Gen5_2'
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


// Test 03 -  MySQL Deployment - with Role Assignments

module test03 '../main.bicep' = {
  name: 'test03-${uniqueName}'
  params: {
    location: location
    createMode : 'GeoRestore'
    serverName: 'test03-${uniqueName}'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    publicNetworkAccess: 'Enabled'
    skuName: 'GP_Gen5_2'
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
