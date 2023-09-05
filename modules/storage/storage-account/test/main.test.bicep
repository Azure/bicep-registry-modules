/*
Write deployment tests in this file. Any module that references the main
module file is a deployment test. Make sure at least one test is added.
*/

param location string = resourceGroup().location
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)

var maxNameLength = 24
var uniqueStoragename = replace(guid(uniqueName), '-', '')
var names = {
  test1: {
    storage: take('st1${uniqueStoragename}', maxNameLength)
  }
  test2: {
    storage: take('st2${uniqueStoragename}', maxNameLength)
    containers: [ 'test2container1', 'test2container2' ]
  }
  test3d1: {
    storage: take('st3dest1${uniqueStoragename}', maxNameLength)
    containers: [ 'destinationcontainer1' ]
  }
  test3d2: {
    storage: take('st3dest2${uniqueStoragename}', maxNameLength)
    containers: [ 'destinationcontainer2' ]
  }
  test3s: {
    storage: take('st3sour${uniqueStoragename}', maxNameLength)
    containers: [ 'sourcecontainer1', 'sourcecontainer2' ]
  }
}

module prereq 'prereq.test.bicep' = {
  name: 'test-prereqs'
  params: {
    name: 'storage'
    location: location
    prefix: uniqueName
  }
}

module test1 '../main.bicep' = {
  name: 'test1'
  params: {
    name: names.test1.storage
    location: location
  }
}

module test2 '../main.bicep' = {
  name: 'test2'
  dependsOn: [
    prereq
  ]
  params: {
    name: names.test2.storage
    location: location
    encryption: {
      enable: true
      configurations: {
        keySource: 'Microsoft.Storage'
        requireInfrastructureEncryption: true
      }
    }
    blobServiceProperties: {
      isVersioningEnabled: true
      changeFeed: {
        enabled: true
      }
      lastAccessTimeTrackingPolicy: {
        enable: true
      }
    }
    blobContainers: [
      {
        name: names.test2.containers[0]
      }
      {
        name: names.test2.containers[1]
        properties: {
          publicAccess: 'None'
        }
      }
    ]
    storageRoleAssignments: [
      {
        principalId: prereq.outputs.identityPrincipalIds[0]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Storage Blob Data Reader'
        description: 'roleAssignment for calllog SA'
      }
      {
        principalId: prereq.outputs.identityPrincipalIds[1]
        roleDefinitionIdOrName: 'Storage Blob Data Reader'
      }
    ]
    containerRoleAssignments: [
      {
        principalId: prereq.outputs.identityPrincipalIds[0]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Storage Blob Data Owner'
        containerName: 'test2container1'
        description: 'roleAssignment for audiolog Container'
      }
    ]
    managementPolicyRules: [
      {
        name: 'rule1'
        definition: {
          actions: {
            baseBlob: {
              enableAutoTierToHotFromCool: true
              tierToCool: { daysAfterLastAccessTimeGreaterThan: 30 }
            }
            snapshot: {
              delete: { daysAfterCreationGreaterThan: 30 }
            }
          }
          filters: {
            blobTypes: [ 'blockBlob' ]
            prefixMatch: [ 'test' ]
          }
        }
      }
    ]
    privateEndpoints: [
      {
        name: 'Test2pep-blob'
        subnetId: prereq.outputs.subnetIds[0]
        groupId: 'blob'
        privateDnsZoneId: prereq.outputs.privateDNSZoneId
        isManualApproval: false
      }
      {
        name: 'Test2pep-file'
        subnetId: prereq.outputs.subnetIds[0]
        groupId: 'file'
        privateDnsZoneId: prereq.outputs.privateDNSZoneId
        isManualApproval: false
      }
    ]
  }
}

@description('''
Test 3
create destination SA1 for object replication
''')
module test3Destination1 '../main.bicep' = {
  name: 'test3Destination1'
  dependsOn: [
    prereq
  ]
  params: {
    name: names.test3d1.storage
    location: location
    blobServiceProperties: {
      isVersioningEnabled: true
      changeFeed: {
        enabled: true
      }
    }
    blobContainers: [
      {
        name: names.test3d1.containers[0]
      }
    ]
    objectReplicationDestinationPolicy: [
      {
        sourceStorageAccountId: '/subscription/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Storage/storageAccounts/${names.test3s.storage}'
        rules: [
          {
            destinationContainer: names.test3d1.containers[0]
            sourceContainer: names.test3s.containers[0]
          }
        ]
      }
    ]
  }
}

@description('''
Test 3
create destination SA2 for object replication
''')
module test3Destination2 '../main.bicep' = {
  name: 'test3Destination2'
  dependsOn: [
    prereq
  ]
  params: {
    name: names.test3d2.storage
    location: location
    blobServiceProperties: {
      isVersioningEnabled: true
      changeFeed: {
        enabled: true
      }
    }
    blobContainers: [
      {
        name: names.test3d2.containers[0]
      }
    ]
    objectReplicationDestinationPolicy: [
      {
        sourceStorageAccountId: '/subscription/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Storage/storageAccounts/${names.test3s.storage}'
        rules: [
          {
            destinationContainer: names.test3d2.containers[0]
            sourceContainer: names.test3s.containers[1]
          }
        ]
      }
    ]
  }
}

@description('''
Test 3
create source SA for object replication
''')
module test3Source '../main.bicep' = {
  name: 'test3Source'
  dependsOn: [
    prereq
  ]
  params: {
    name: names.test3s.storage
    location: location
    blobServiceProperties: {
      isVersioningEnabled: true
      changeFeed: {
        enabled: true
      }
    }
    blobContainers: [
      {
        name: names.test3s.containers[0]
      }
      {
        name: names.test3s.containers[1]
      }
    ]
    objectReplicationSourcePolicy: [
      {
        destinationStorageAccountId: test3Destination1.outputs.id
        policyId: test3Destination1.outputs.objectReplicationDestinationPolicyIdsAndRuleIds[0].policyId
        rules: [
          {
            ruleId: test3Destination1.outputs.objectReplicationDestinationPolicyIdsAndRuleIds[0].ruleIds[0]
            destinationContainer: names.test3d1.containers[0]
            sourceContainer: names.test3s.containers[0]
            filters: {
              prefixMatch: [ 'test' ]
              minCreationTime: '2020-02-19T16:05:00Z'
            }
          }
        ]
      }
      {
        destinationStorageAccountId: test3Destination2.outputs.id
        policyId: test3Destination2.outputs.objectReplicationDestinationPolicyIdsAndRuleIds[0].policyId
        rules: [
          {
            ruleId: test3Destination2.outputs.objectReplicationDestinationPolicyIdsAndRuleIds[0].ruleIds[0]
            destinationContainer: names.test3d2.containers[0]
            sourceContainer: names.test3s.containers[1]
            filters: {
              prefixMatch: [ 'test' ]
              minCreationTime: '2020-02-19T16:05:00Z'
            }
          }
        ]
      }
    ]
  }
}

output resourceIds object = {
  test1: test1.outputs.id
  test2: test2.outputs.id
  test3Destination1: test3Destination1.outputs.id
  test3Destination2: test3Destination2.outputs.id
  test3Source: test3Source.outputs.id
}
