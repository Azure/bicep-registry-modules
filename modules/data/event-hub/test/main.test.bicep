targetScope = 'resourceGroup'
param location string = 'eastus'
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)
param serviceShort string = 'eventhub'

// ============= //
// Prerequisites //
// ============= //

module prerequisites 'prereq.test.bicep' = {
  name: 'test-prereq'
  params: {
    name: serviceShort
    location: location
    prefix: uniqueName
  }
}

/*
//Disabled this test case becuase it was showing error Status Message: Free provisioned clusters currently not available for internal tenants. Currently working on provisioning more clusters
// Test 01 - Standard SKU with cluster and Parameters, AuthRule(namespace,eventHub), EventHub, ConsumerGroups
module test_01 '../main.bicep' = {
  name: '${uniqueName}-test-01'
  params: {
    clusterName: '${uniqueName}-test01'
    tags: {
      tag1: 'tag1value'
      tag2: 'tag2value'
    }
    location: location
    eventHubNamespaces: {
      'test01${uniqueName}': {

          sku: 'Standard'
          capacity:  4
          isAutoInflateEnabled: true
          maximumThroughputUnits: 6
      }
      'test01a${uniqueName}': {
        sku: 'Standard'
        capacity:  2
      }
    }
    namespaceAuthorizationRules: {
      'test01${uniqueName}': {
          rights: ['Listen','Manage','Send']
          eventHubNamespaceName: 'test01${uniqueName}'
      }
      'test01a${uniqueName}': {
        rights: ['Listen','Manage','Send']
        eventHubNamespaceName: 'test01${uniqueName}'
      }
    }
    eventHubs: {
      'test01${uniqueName}': {
          messageRetentionInDays: 4
          partitionCount: 4
          eventHubNamespaceName: 'test01${uniqueName}'
      }
      'test01a${uniqueName}': {
          messageRetentionInDays: 7
          partitionCount: 2
          eventHubNamespaceName: 'test01${uniqueName}'
      }
    }
    eventHubAuthorizationRules: {
      'test01${uniqueName}': {
          rights: ['Listen','Manage','Send']
          eventHubNamespaceName: 'test01${uniqueName}'
          eventHubName: 'test01${uniqueName}'
      }
    }
    consumerGroups: {
      'test01${uniqueName}': {
          eventHubNamespaceName: 'test01${uniqueName}'
          eventHubName: 'test01${uniqueName}'
      }
    }
  }
}
*/

// Test 02 - Basic SKU Minimal Parameters
module test_02 '../main.bicep' = {
  name: '${uniqueName}-test-02'
  params: {
    location: location
    eventHubNamespaces: {
      'test02na${uniqueName}': {
          sku: 'Basic'
          capacity:  3
      }
    }
  }
}

// Test 03 - Premium SKU Minimal Parameters
module test_03 '../main.bicep' = {
  name: '${uniqueName}-test-03'
  params: {
    location: location
    eventHubNamespaces: {
      'test03na${uniqueName}': {
          sku: 'Premium'
          capacity:  4
          zoneRedundant: true
      }
    }
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: prerequisites.outputs.subnetIds[0]
        eventHubNamespaceName: 'test03na${uniqueName}'
      }
      {
        name: 'endpoint2'
        subnetId: prerequisites.outputs.subnetIds[1]
        privateDnsZoneId: prerequisites.outputs.privateDNSZoneId
        eventHubNamespaceName: 'test03na${uniqueName}'
      }
    ]
    diagnosticSettings: {
      'test03digno${uniqueName}': {
        diagnosticEnablenamespaceName: 'test03na${uniqueName}'
        diagnosticEventHubAuthorizationRuleId: prerequisites.outputs.authorizationRuleId
        diagnosticEventHubName: prerequisites.outputs.eventHubName
        diagnosticsMetrics: [{category: 'AllMetrics', enabled:true, retentionPolicy: {days:365,enabled:true}}]
        diagnosticsLogs: [
          {
            category:'OperationalLogs'
            enabled: true
            retentionPolicy: {days:36,enabled:true}
          }
          {
            category:'ArchiveLogs'
            enabled: true
            retentionPolicy: {days:3,enabled:true}
          }
        ]
      }
    }
  }
}


// Test 04 - Standard SKU Minimal Parameters
module test_04 '../main.bicep' = {
  name: '${uniqueName}-test-04'
  params: {
    location: location
    eventHubNamespaces: {
      'test04na${uniqueName}': {
          sku: 'Standard'
          capacity:  1
          zoneRedundant: false
      }
    }
    eventHubs: {
      'test04${uniqueName}': {
          messageRetentionInDays: 1
          partitionCount: 2
          eventHubNamespaceName: 'test04na${uniqueName}'
          captureDescriptionDestinationBlobContainer: prerequisites.outputs.containerName
          captureDescriptionDestinationStorageAccountResourceId: prerequisites.outputs.storageAccountId
          captureDescriptionEnabled: true
      }
    }
    diagnosticSettings: {
      'test04digno${uniqueName}': {
        diagnosticEnablenamespaceName: 'test04na${uniqueName}'
        diagnosticStorageAccountId: prerequisites.outputs.storageAccountId
        diagnosticWorkspaceId: prerequisites.outputs.workspaceId
        diagnosticsMetrics: [{category: 'AllMetrics', enabled:true, retentionPolicy: {days:365,enabled:true}}]
        diagnosticsLogs: [
          {
            category:'ArchiveLogs'
            enabled: true
            retentionPolicy: {days:365,enabled:true}
          }
          {
            category:'RuntimeAuditLogs'
            enabled: true
            retentionPolicy: {days:3,enabled:true}
          }
        ]
      }
    }
  }
}
