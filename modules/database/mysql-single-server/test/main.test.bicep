/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
targetScope = 'resourceGroup'
param location string = 'canadacentral'
var serverName = uniqueString(resourceGroup().id, deployment().name, location)
@secure()
param administratorLogin string
@secure()
param administratorLoginPassword string
param resourceId string = ''
param resourceName string = 'mysqlserver'
param skuName string = 'B_Gen5_1'
param createMode string = 'Default'
param databases array = [{
    name: 'testdb'
    charset: 'UTF8'
    collation: 'en_US.UTF8'
  }
]
param firewallRules array = [{
    name: 'AllowAll'
    startIpAddress: '10.0.0.0'
    endIpAddress: '10.255.255.255'
  }
]
param privateDnsZoneName string = 'privatelink.mysql.database.azure.com'
param serverConfigurations array = [ {
    name: 'flush_time'
    value: '100'
  }
  {
    name: 'innodb_compression_level'
    value: '7'
  }
]
param privateEndpoints array = [{
    name: 'pep-${resourceName}-${uniqueString(resourceGroup().id)}'
    id: resourceId
    description: 'Auto-approved by Bicep module'
    status: 'Approved'
  }
]

// Test 01 -  Basic Deployment - Minimal Parameters
module test01 '../main.bicep' = {
  name: 'test01-${serverName}'
  params: {
    location: location
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    serverName: 'test01-${serverName}'
  }
}

// Test 02 -  Basic Deployment - with login creds


module test02 '../main.bicep' = {
  name: 'test02-${serverName}'
  params: {
    location: location
    createMode : createMode
    serverName: 'test02-${serverName}'
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    databases: databases
    skuName: skuName
    firewallRules: firewallRules
    privateDnsZoneName: privateDnsZoneName
    serverConfigurations: serverConfigurations
    privateEndpoints: privateEndpoints
  }
}
