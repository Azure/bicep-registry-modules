/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/
/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location

// Prerequisites
module prereq 'prereq.test.bicep' = {
  name: 'test-prereqs${uniqueString(resourceGroup().id, subscription().id)}'
  params: {
    location: location
    uniqueName: 'prereqs${uniqueString(resourceGroup().id, subscription().id)}'
  }
}

//Test 0: Create a Kusto cluster with a database, script, eventhub connection, cosmosdb connections.
module test0 '../main.bicep' = {
  dependsOn: [
    prereq
  ]
  name: 'test0${uniqueString(resourceGroup().id, subscription().id)}'
  params: {
    name: 'ktest0${uniqueString(resourceGroup().id, subscription().id)}'
    location: location
    databases: [
      {
        name: 'kustodb${uniqueString(resourceGroup().id, subscription().id)}'
        kind: 'ReadWrite'
        unlimitedSoftDelete: false
        softDeletePeriod: 30
        unlimitedHotCache: false
        hotCachePeriod: 30
        location: location
      }
    ]
    // It's publicIP
    scripts: [ {
        name: 'script1'
        databaseName: 'kustodb${uniqueString(resourceGroup().id, subscription().id)}'
        content: '.create-merge table RawEvents(document:dynamic)'
      } ]
    dataEventHubConnections: [
      {
        name: 'myconnection'
        databaseName: 'kustodb${uniqueString(resourceGroup().id, subscription().id)}'
        consumerGroup: prereq.outputs.consumerGroupName
        eventHubResourceId: prereq.outputs.eventHubResourceId
        compression: 'None'
        location: location
        tableName: 'RawEvents'
      }
    ]
    dataCosmosDbConnections: [
      {
        name: 'myconnection2'
        databaseName: 'kustodb${uniqueString(resourceGroup().id, subscription().id)}'
        cosmosDbContainer: 'container1'
        cosmosDbDatabase: 'testdb1'
        cosmosDbAccountResourceId: prereq.outputs.cosmosDBId
        location: location
        managedIdentityResourceId: prereq.outputs.identityId
        tableName: 'RawEvents'
      }
    ]
    identityType: 'UserAssigned'
    userAssignedIdentities: {
      '${prereq.outputs.identityId}': {}
    }
  }
}

//Test 1: Create a Kusto cluster with a database, private endpoint
module test1 '../main.bicep' = {
  dependsOn: [
    prereq
  ]
  name: 'test1${uniqueString(resourceGroup().id, subscription().id)}'
  params: {
    name: 'ktest1${uniqueString(resourceGroup().id, subscription().id)}'
    location: location
    databases: [
      {
        name: 'kustodb${uniqueString(resourceGroup().id, subscription().id)}'
        kind: 'ReadWrite'
        unlimitedSoftDelete: false
        softDeletePeriod: 30
        unlimitedHotCache: false
        hotCachePeriod: 30
        location: location
      }
    ]
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: prereq.outputs.subnetIds[0]
        privateDnsZoneId: prereq.outputs.privateDNSZoneId
      }
      {
        name: 'endpoint2'
        subnetId: prereq.outputs.subnetIds[1]
        privateDnsZoneId: prereq.outputs.privateDNSZoneId
      }
    ]
    identityType: 'UserAssigned'
    userAssignedIdentities: {
      '${prereq.outputs.identityId}': {}
    }
    publicNetworkAccess: 'Disabled'
    allowedIpRangeList: [
      '10.233.81.104'
    ]
    managedPrivateEndpoints: [
      {
        name: 'ngt-ep-eventhub'
        groupId: 'namespace'
        privateLinkResourceId: prereq.outputs.eventHubNamespaceId
        requestMessage: 'Please approve the request'
      }
      {
        name: 'mgt-ep-cosmosdb'
        groupId: 'sql'
        requestMessage: 'Please approve the request'
        privateLinkResourceId: prereq.outputs.cosmosDBId
      }
    ]
    principalAssignments: [
      {
        principalId: prereq.outputs.principalId
        role: 'Admin'
        principalType: 'App'
        databaseName: 'kustodb${uniqueString(resourceGroup().id, subscription().id)}'
        tenantId: subscription().tenantId
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Log Analytics Reader'
        principalIds: [ prereq.outputs.principalId ]
      }
    ]
  }
}
