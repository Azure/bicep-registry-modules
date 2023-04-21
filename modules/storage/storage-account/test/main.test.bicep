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

// This 'wait' is needed because RBAC (Identities/Roles/Role Assignemnts etc) in Azure always take some time to reflect!
module delayDeployment 'br/public:deployment-scripts/wait:1.0.1' = {
  name: 'delayDeployment'
  params: {
    waitSeconds: 120
    location: location
  }
}

//Test 0. 
module test0 '../main.bicep' = {
  name: 'test0'
  params: {
    name: 'test0sablobcontainers'
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
// module test2 '../main.bicep' = {
//   name: 'test2'
//   dependsOn: [
//     prereq
//   ]
//   params: {
//     location: location
//     blobProperties: {
//       isVersioningEnabled: true
//     }
//     blobContainerProperties: {
//       publicAccess: 'None'
//     }
//     roleAssignments: [
//       {
//         roleDefinitionIdOrName: 'Reader and Data Access'
//         principalIds: [ prereq.outputs.identityPrincipalIds[0] ]
//         principalType: 'ServicePrincipal'
//       }
//       {
//         roleDefinitionIdOrName: 'Storage Blob Data Contributor'
//         principalIds: [ prereq.outputs.identityPrincipalIds[0] ]
//         principalType: 'ServicePrincipal'
//         resourceType: 'blobContainer'
//       }
//       {
//         roleDefinitionIdOrName: 'Reader and Data Access'
//         principalIds: [ prereq.outputs.identityPrincipalIds[1] ]
//         principalType: 'ServicePrincipal'
//       }
//     ]
//   }
// }
