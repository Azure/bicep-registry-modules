/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location

var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)

//Prerequisites
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
  params: {
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
        principalIds: [ prereq.outputs.identityPrincipalIds[0] ]
      }
      {
        roleDefinitionIdOrName: 'Storage Blob Data Contributor'
        principalIds: [ prereq.outputs.identityPrincipalIds[0] ]
        resourceType: 'blobContainer'
      }
      {
        roleDefinitionIdOrName: 'Reader and Data Access'
        principalIds: [ prereq.outputs.identityPrincipalIds[1] ]
      }      
    ]
  }
}
