/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location
param blobType string = 'blockBlob'
param minimumTlsVersion string = 'TLS1_2'
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)

var maxNameLength = 23
var uniqueStoragename = substring(replace(guid(uniqueName, resourceGroup().name, subscription().id), '-', ''), 0, maxNameLength)

module prereq 'prereq.test.bicep' = {
  name: 'test-prereqs'
  params: {
    name: 'storage'
    location: location
    prefix: uniqueName
  }
}

//Test 1, Create Source SA.
module test1 '../main.bicep' = {
  name: 'test1'
  params: {
    name: '1${uniqueStoragename}'
    location: location
    blobProperties: {
    }
    blobContainers:[{
      name: 'container1'
      properties: { 
        publicAccess: 'None'
      }
    }]
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: prereq.outputs.subnetIds[0]
      }
      {
        name: 'endpoint2'
        subnetId: prereq.outputs.subnetIds[1]
        privateDnsZoneId: prereq.outputs.privateDNSZoneId
      }
    ]
  }
}

//Test 2, Create Source SA with versioning and change feed enabled & rback policies for SA and containers and enabling public access
module test2 '../main.bicep' = {
  name: 'test2'
  dependsOn: [
    prereq
  ]
  params: {
    name: '2${uniqueStoragename}'
    blobType: blobType
    minimumTlsVersion: minimumTlsVersion
    location: location
    blobProperties: {
      isVersioningEnabled: true
       changeFeed: {
         enabled: true
       }
    }
    blobContainers:[
      {
        name: 'sourcecontainer'
        properties: { 
        }
      }
      {
        name: 'testcontainer2'
        properties: { 
          publicAccess: 'None'
        }
      }
    ]
    storageRoleAssignments: [
      {
        principalIds: [ prereq.outputs.identityPrincipalIds[0], prereq.outputs.identityPrincipalIds[1] ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Storage Blob Data Reader'
        description: 'roleAssignment for calllog SA'        
      }
    ]
    containerRoleAssignments: [
      {
        principalIds: [ prereq.outputs.identityPrincipalIds[0] ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Storage Blob Data Owner'
        containerName: 'sourcecontainer'
        description: 'roleAssignment for audiolog Container'
      }
    ]
  }
}

//Test 3, Create Destination1 SA with versioning enabled and setting lifecycleManagementPolicy 
module test3 '../main.bicep' = {
  name: 'test3'
  dependsOn: [
    prereq
  ]
  params: {
    name: '3${uniqueStoragename}'
    location: location
    blobProperties: {
      isVersioningEnabled: true
    }
    blobContainers:[{
      name: 'destinationcontainer'
    }]
    lifecycleManagementPolicy:{
      moveToCool: true
      moveToCoolAfterLastModificationDays: 30
      deleteBlob: false
      deleteBlobAfterLastModificationDays: 30
      deleteSnapshotAfterLastModificationDays: 30
    }
  }
}

//Test 3, Create Destination2 SA with versioning enabled and setting lifecycleManagementPolicy 
module test4 '../main.bicep' = {
  name: 'test4'
  dependsOn: [
    prereq
  ]
  params: {
    name: '4${uniqueStoragename}'
    location: location
    blobProperties: {
      isVersioningEnabled: true
    }
    blobContainers:[{
      name: 'destinationcontainer'
    }]
    lifecycleManagementPolicy:{
      moveToCool: true
      moveToCoolAfterLastModificationDays: 30
      deleteBlob: false
      deleteBlobAfterLastModificationDays: 30
      deleteSnapshotAfterLastModificationDays: 30
    }
  }
}

//Test 5, Update Destination1 SA with destination objectReplicationPolicy (setting objectReplicationPolicy.sourcePolicy-> false and objectReplicationPolicy.policyId->'default', objectReplicationPolicy.objReplicationRules[0].ruleId-> null)
module test5 '../main.bicep' = {
  name: 'test5'
  dependsOn: [
    prereq
    test3
  ]
  params: {
    name: '3${uniqueStoragename}'
    location: location
    blobProperties: {
      isVersioningEnabled: true
    }
    blobContainers:[{
      name: 'destinationcontainer'
    }]
    lifecycleManagementPolicy:{
      moveToCool: true
      moveToCoolAfterLastModificationDays: 30
      deleteBlob: false
      deleteBlobAfterLastModificationDays: 30
      deleteSnapshotAfterLastModificationDays: 30
    }
    objectReplicationPolicies: [{
      policyId: 'default'
      sourceSaName: '2${uniqueStoragename}'
      destinationSaName: '3${uniqueStoragename}'
      sourceSaId: test2.outputs.id
      destinationSaId: test3.outputs.id
      sourcePolicy: false
      objReplicationRules: [
        {
          sourceContainer: 'sourcecontainer'
          destinationContainer: 'destinationcontainer'
        }
      ]
     }]   
  }
}

//Test 6, Update Destination2 SA with destination objectReplicationPolicy (setting objectReplicationPolicy.sourcePolicy-> false and objectReplicationPolicy.policyId->'default', objectReplicationPolicy.objReplicationRules[0].ruleId-> null)
module test6 '../main.bicep' = {
  name: 'test6'
  dependsOn: [
    prereq
    test4
  ]
  params: {
    name: '4${uniqueStoragename}'
    location: location
    blobProperties: {
      isVersioningEnabled: true
    }
    blobContainers:[{
      name: 'destinationcontainer'
    }]
    lifecycleManagementPolicy:{
      moveToCool: true
      moveToCoolAfterLastModificationDays: 30
      deleteBlob: false
      deleteBlobAfterLastModificationDays: 30
      deleteSnapshotAfterLastModificationDays: 30
    }
    objectReplicationPolicies: [{
      policyId: 'default'
      sourceSaName: '2${uniqueStoragename}'
      destinationSaName: '4${uniqueStoragename}'
      sourceSaId: test2.outputs.id
      destinationSaId: test4.outputs.id
      sourcePolicy: false
      objReplicationRules: [
        {
          sourceContainer: 'sourcecontainer'
          destinationContainer: 'destinationcontainer'
        }
      ]
     }]   
  }
}

//Test 7, Update Source SA with source objectReplicationPolicy (setting 'sourcePolicy-> true', 'policyId-> OR policyId & ruleIds created for the Destination1 and Destination2 SA'. PEPs created for test2rbac SA.
module test7 '../main.bicep' = {
  name: 'test7'
  dependsOn: [
    prereq
    test4
  ]
  params: {
    name: '2${uniqueStoragename}'
    location: location
    blobProperties: {
      isVersioningEnabled: true
       changeFeed: {
         enabled: true
       }
    }
    blobContainers:[
      {
        name: 'sourcecontainer'
        properties: { 
        }
      }
      {
        name: 'testcontainer2'
        properties: { 
          publicAccess: 'None'
        }
      }
    ]
    storageRoleAssignments: [
      {
        principalIds: [ prereq.outputs.identityPrincipalIds[0], prereq.outputs.identityPrincipalIds[1] ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Storage Blob Data Reader'
        description: 'roleAssignment for calllog SA'        
      }
    ]
    containerRoleAssignments: [
      {
        principalIds: [ prereq.outputs.identityPrincipalIds[0] ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Storage Blob Data Owner'
        containerName: 'sourcecontainer'
        description: 'roleAssignment for audiolog Container'
      }
    ]
    objectReplicationPolicies: [
      {
      policyId: test5.outputs.orpIDnRules[0].orpId
      sourceSaName: '2${uniqueStoragename}'
      destinationSaName: '3${uniqueStoragename}'
      sourceSaId: test2.outputs.id
      destinationSaId: test3.outputs.id
      sourcePolicy: true
      objReplicationRules: [
        {
          sourceContainer: 'sourcecontainer'
          destinationContainer: 'destinationcontainer'
          ruleId: test5.outputs.orpIDnRules[0].orpIdRules[0].ruleId
        }
      ]
     }
     {
      policyId: test6.outputs.orpIDnRules[0].orpId
      sourceSaName: '2${uniqueStoragename}'
      destinationSaName: '4${uniqueStoragename}'
      sourceSaId: test2.outputs.id
      destinationSaId: test4.outputs.id
      sourcePolicy: true
      objReplicationRules: [
        {
          sourceContainer: 'sourcecontainer'
          destinationContainer: 'destinationcontainer'
          ruleId: test6.outputs.orpIDnRules[0].orpIdRules[0].ruleId
        }
      ]
     }
    ]
  }
}
