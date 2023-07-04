/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location
param blobType string = 'blockBlob'
param minimumTlsVersion string = 'TLS1_2'
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)

var maxNameLength = 24
var uniqueStoragename = length(uniqueString(uniqueName)) > maxNameLength ? substring(replace(guid(uniqueName, resourceGroup().name, subscription().id), '-', ''), 0, maxNameLength) : replace(guid(uniqueName, resourceGroup().name, subscription().id), '-', '')

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
    blobProperties: {}
    blobContainers: [ {
        name: 'container1'
        properties: {
          publicAccess: 'None'
        }
      } ]
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
    blobContainers: [
      {
        name: 'sourcecontainer'
        properties: {}
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

//Test 3, Create Destination SA with versioning enabled and setting lifecycleManagementPolicy
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
    blobContainers: [ {
        name: 'destinationcontainer'
      } ]
    lifecycleManagementPolicy: {
      moveToCool: true
      moveToCoolAfterLastModificationDays: 30
      deleteBlob: false
      deleteBlobAfterLastModificationDays: 30
      deleteSnapshotAfterLastModificationDays: 30
    }
  }
}

//Test 4, Update Destination SA with objectReplicationPolicy for destreplicationsa (setting objectReplicationPolicy.sourcePolicy-> false and objectReplicationPolicy.policyId->'default', objectReplicationPolicy.objReplicationRules[0].ruleId-> null)
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
    blobContainers: [ {
        name: 'destinationcontainer'
      } ]
    lifecycleManagementPolicy: {
      moveToCool: true
      moveToCoolAfterLastModificationDays: 30
      deleteBlob: false
      deleteBlobAfterLastModificationDays: 30
      deleteSnapshotAfterLastModificationDays: 30
    }
    objectReplicationPolicy: {
      enabled: true
      policyId: 'default'
      sourceSaName: 'test2rbac'
      destinationSaName: 'destreplicationsa'
      sourceSaId: test2.outputs.id
      destinationSaId: test3.outputs.id
      sourcePolicy: false
      objReplicationRules: [
        {
          sourceContainer: 'sourcecontainer'
          destinationContainer: 'destinationcontainer'
        }
      ]
    }
  }
}

//Test 5, Update Source SA with objectReplicationPolicy for destreplicationsa (setting 'objectReplicationPolicy.sourcePolicy-> true', 'objectReplicationPolicy.policyId-> OR policyId created for the destreplicationsa' and objectReplicationPolicy.objReplicationRules[0].ruleId-> the OR ruleID for the destreplicationsa). PEPs created for test2rbac SA.
module test5 '../main.bicep' = {
  name: 'test5'
  dependsOn: [
    prereq
  ]
  params: {
    name: '5${uniqueStoragename}'
    location: location
    blobProperties: {
      isVersioningEnabled: true
      changeFeed: {
        enabled: true
      }
    }
    blobContainers: [
      {
        name: 'sourcecontainer'
        properties: {}
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
    objectReplicationPolicy: {
      enabled: true
      policyId: test4.outputs.orpId
      sourceSaName: 'test2rbac'
      destinationSaName: 'destreplicationsa'
      sourceSaId: test2.outputs.id
      destinationSaId: test3.outputs.id
      sourcePolicy: true
      objReplicationRules: [
        {
          sourceContainer: 'sourcecontainer'
          destinationContainer: 'destinationcontainer'
          ruleId: test4.outputs.orpIdRules[0].ruleId
        }
      ]
    }
  }
}
