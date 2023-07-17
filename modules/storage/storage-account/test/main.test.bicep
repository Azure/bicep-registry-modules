/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location
param blobType string = 'blockBlob'
param minimumTlsVersion string = 'TLS1_2'
param objectReplicationPolicy bool = false
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)

module prereq 'prereq.test.bicep' = {
  name: 'test-prereqs'
  params: {
    name: 'storage'
    location: location
    prefix: uniqueName
  }
}

//Test 0.
module test0 '../main.bicep' = {
  name: 'test0'
  params: {
    location: location
  }
}

//Test 1.
module test1 '../main.bicep' = {
  name: 'test1'
  params: {
    name: 'test1blobcontainers'
    location: location
    blobProperties: {
      isVersioningEnabled: true
    }
    blobContainerProperties: {
      publicAccess: 'None'
    }
  }
}

//Test 2.
module test2 '../main.bicep' = {
  name: 'test2'
  dependsOn: [
    prereq
  ]
  params: {
    name: 'test2rbac'
    location: location
    blobProperties: {
      isVersioningEnabled: true
    }
    blobContainerProperties: {
      publicAccess: 'None'
    }
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Reader and Data Access'
        principalIds: [ prereq.outputs.identityPrincipalIds[0], prereq.outputs.identityPrincipalIds[1] ]
      }
      {
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalIds: [ prereq.outputs.identityPrincipalIds[0] ]
        resourceType: 'blobContainer'
      }
    ]
  }
}

// One storage account will be created because the objectReplicationPolicy has been disabled and object replication will not take place.
module test3 '../main.bicep' = {
  name: 'test3'
  params: {
      location: location
      blobType: blobType
      daysAfterLastModification: 60
      blobProperties: {
        isVersioningEnabled: false
      }
      blobContainerProperties: {
        publicAccess: 'None'
      }
      minimumTlsVersion: minimumTlsVersion
      objectReplicationPolicy: objectReplicationPolicy
  }
}

// Since the objectReplicationPolicy has been enabled, two storage accounts will be created, and object replication will take place using the source and destination storage accounts.
module test4 '../main.bicep' = {
  name: 'test4'
  params: {
      location: location
      blobType: blobType
      daysAfterLastModification: 60
      blobProperties: {
        isVersioningEnabled: true
        changeFeed: {
          enabled: true
        }
      }
      blobContainerProperties: {
        publicAccess: 'None'
      }
      minimumTlsVersion: minimumTlsVersion
      objectReplicationPolicy: true

      // Only provide values related to destination storage accounts if objectReplicationPolicies is true. By default, the primary storage account's values will be applied to destination parameters.
      // By adding a param here, we can override. Added few paramaters below as an example.
      destLocation: location
      destDaysAfterLastModification: 60
      destChangeFeedEnabled: true
      destVersioningEnabled: true
      destSupportHttpsTrafficOnly: true
      destAllowBlobPublicAccess: false
      destAllowCrossTenantReplication: false
      destPublicNetworkAccess: 'Disabled'
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