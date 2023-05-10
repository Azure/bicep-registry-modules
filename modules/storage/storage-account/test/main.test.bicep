/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location
param blobType string = 'blockBlob'
param minimumTlsVersion string = 'TLS1_2'
param objectReplicationPolicy bool = false
param roleDefinitionIdOrName string = 'StorageBlobDataContributor'
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)
param serviceShort string = 'storageAccount'

//Prerequisites
// module prereq 'prereq.test.bicep' = {
//   name: 'test-prereqs'
//   params: {
//     location: location
//   }
// }

//Test 0.
module test0 '../main.bicep' = {
  name: 'test0'
  params: {
    location: location
  }
}

module prerequisites 'prereq.test.bicep' = {
  name: 'test-prereqs'
  params: {
    name: serviceShort
    location: location
    prefix: uniqueName
  }
}

// One storage account will be created because the objectReplicationPolicy has been disabled and object replication will not take place.
module test1 '../main.bicep' = {
  name: 'test1'
  params: {
      location: location
      blobType: blobType
      daysAfterLastModification: 60
      changeFeedEnabled: false
      versioningEnabled: false
      minimumTlsVersion: minimumTlsVersion
      objectReplicationPolicy: objectReplicationPolicy
      roleDefinitionIdOrName: roleDefinitionIdOrName
  }
}

// Since the objectReplicationPolicy has been enabled, two storage accounts will be created, and object replication will take place using the source and destination storage accounts.
module test2 '../main.bicep' = {
  name: 'test2'
  params: {
      location: location
      blobType: blobType
      daysAfterLastModification: 60
      changeFeedEnabled: true
      versioningEnabled: true
      minimumTlsVersion: minimumTlsVersion
      objectReplicationPolicy: true
      roleDefinitionIdOrName: roleDefinitionIdOrName

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
        subnetId: prerequisites.outputs.subnetIds[0]
      }
      {
        name: 'endpoint2'
        subnetId: prerequisites.outputs.subnetIds[1]
        privateDnsZoneId: prerequisites.outputs.privateDNSZoneId
      }
    ]
  }
}