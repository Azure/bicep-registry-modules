/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location
param blobType string = 'blockBlob'
param minimumTlsVersion string = 'TLS1_2'
param kind string = 'StorageV2'
param sourcePolicy bool = false
param managedIdentityName string = 'MyManagedIdentity'
param roleDefinitionIdOrName string = 'Storage Blob Data Contributor'
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)
param serviceShort string = 'storageAccount'

//Prerequisites
// module prereq 'prereq.test.bicep' = {
//   name: 'test-prereqs'
//   params: {
//     location: location
//   }
// }

module prerequisites 'prereq.test.bicep' = {
  name: 'test-prereqs'
  params: {
    name: serviceShort
    location: location
    prefix: uniqueName
  }
}

//Test 0.
module test0 '../main.bicep' = {
  name: 'test0'
  params: {
      location: location
      blobType: blobType
      daysAfterLastModification: 60
      changeFeedEnabled: false
      versioningEnabled: false
      minimumTlsVersion: minimumTlsVersion

      destLocation: location
      destKind: kind
      destSkuName: 'Standard_GRS'
      destBlobType: blobType
      destDaysAfterLastModification: 60
      destChangeFeedEnabled: true
      destVersioningEnabled: true
      destSupportHttpsTrafficOnly: true
      destAllowBlobPublicAccess: false
      destAllowCrossTenantReplication: false
      destPublicNetworkAccess: 'Disabled'
      destMinimumTlsVersion: minimumTlsVersion

      sourcePolicy: sourcePolicy
      managedIdentityName: managedIdentityName
      managedIdentityLocation: location
      roleDefinitionIdOrName: roleDefinitionIdOrName
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
