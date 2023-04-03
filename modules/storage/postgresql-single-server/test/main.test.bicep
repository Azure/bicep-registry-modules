/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
targetScope = 'resourceGroup'
param location string = resourceGroup().location
param serviceShort string = 'postgresqldb'
param adminLogin string = 'testlogin'

@minLength(8)
@maxLength(128)
// Passing inline only for testing purposes
param adminPassword string = 'test@passw0rd123'

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

// Test-01 - Basic server with minimal params

module test_01_postgresqlServer '../main.bicep' = {
  name: 'test-01-server'
  params: {
    location: location
    sqlServerAdministratorLogin: adminLogin
    sqlServerAdministratorPassword: adminPassword
    sqlServerName: 'test-01-server-${uniqueName}'
  }
}

// Test-02 - Primary server with a replica in paired region

module test_02_primaryPostgresqlServer '../main.bicep' = {
  name: 'test-02-primary-server'
  params: {
    location: location
    sqlServerAdministratorLogin: adminLogin
    sqlServerAdministratorPassword: adminPassword
    sqlServerName: 'test-02-primary-server-${uniqueName}'
  }
}

module test_02_replicaPostgresqlServer '../main.bicep' = {
  name: 'test-02-replica-server'
  dependsOn: [
    test_02_primaryPostgresqlServer
  ]
  params: {
    location: location
    createMode: 'Replica'
    sourceServerResourceId: test_02_primaryPostgresqlServer.outputs.id
    sqlServerAdministratorLogin: adminLogin
    sqlServerAdministratorPassword: adminPassword
    sqlServerName: 'test-02-replica-server-${uniqueName}'
  }
}

// Test-03 - Server with databases, configurations, tags and firewalls

var tags = {
  tag1: 'tag1value'
  tag2: 'tag2value'
}

var databases = [
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

var firewallRules = [
  {
    name: 'AllowAll'
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
]

var sqlServerConfigurations = [
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

module test_03_postgresqlServer '../main.bicep' = {
  name: 'test-03-server'
  params: {
    location: location
    publicNetworkAccess: true
    tags: tags
    sqlServerAdministratorLogin: adminLogin
    sqlServerAdministratorPassword: adminPassword
    sqlServerName: 'test-03-server-${uniqueName}'
    databases: databases
    firewallRules: firewallRules
    sqlServerConfigurations: sqlServerConfigurations
  }
}
