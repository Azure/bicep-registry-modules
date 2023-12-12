targetScope = 'resourceGroup'
param location string = 'eastus2'
var uniqueName = uniqueString(resourceGroup().id, deployment().name, location)
param serviceShort string = 'eventhub'

// ============= //
// Prerequisites //
// ============= //

module dependencies 'prereq.test.bicep' = {
  name: 'test-prereq'
  params: {
    name: serviceShort
    location: location
    prefix: uniqueName
  }
}

// Test 01 - Standard SKU with cluster and Parameters, AuthorizationRules(namespace,eventHub), EventHuba, ConsumerGroups
module test_01 '../main.bicep' = {
  name: 'test01-${uniqueName}'
  params: {
    location: location
    namespaces: [
      {
        name: 'test01-${uniqueName}-ns1'
        capacity: 2
        isAutoInflateEnabled: true
        maximumThroughputUnits: 6
        zoneRedundant: true
      }
      {
        name: 'test01-${uniqueName}-ns2'
        sku: 'Basic'
      }
    ]
    namespaceAuthorizationRules: [
      {
        name: 'test01-${uniqueName}-ns-authrule01'
        rights: [ 'Listen', 'Manage', 'Send' ]
        namespaceName: 'test01-${uniqueName}-ns1'
      }
      {
        name: 'test01-${uniqueName}-ns-authrule02'
        rights: [ 'Listen' ]
        namespaceName: 'test01-${uniqueName}-ns1'
      }
    ]
    eventHubs: [
      {
        name: 'test01-${uniqueName}-evh1'
        messageRetentionInDays: 4
        partitionCount: 4
        namespaceName: 'test01-${uniqueName}-ns1'
      }
      {
        name: 'test01-${uniqueName}-evh2'
        messageRetentionInDays: 7
        partitionCount: 2
        namespaceName: 'test01-${uniqueName}-ns1'
      }
    ]
    eventHubAuthorizationRules: [
      {
        name: 'test01-${uniqueName}-evh-rule01'
        rights: [ 'Listen', 'Manage', 'Send' ]
        namespaceName: 'test01-${uniqueName}-ns1'
        eventHubName: 'test01-${uniqueName}-evh1'
      }
    ]
    eventHubConsumerGroups: [
      {
        name: 'test01-${uniqueName}-cg01'
        namespaceName: 'test01-${uniqueName}-ns1'
        eventHubName: 'test01-${uniqueName}-evh1'
      }
    ]
    tags: {
      tag1: 'tag1value'
      tag2: 'tag2value'
    }
  }
}

// Test 02 - Premium SKU -  Role Assignments at namespace and eventHub scope
module test_02 '../main.bicep' = {
  name: 'test02-${uniqueName}'
  params: {
    location: location
    namespaces: [
      {
        name: 'test02-${uniqueName}-ns'
        sku: 'Premium'
        capacity: 2
        zoneRedundant: true
      }
    ]
    namespaceRoleAssignments: [
      {
        name: 'test02-${uniqueName}-rol01'
        description: 'Reader Role Assignment'
        principalIds: [ dependencies.outputs.identityPrincipalIds[1] ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'f526a384-b230-433a-b45c-95f59c4a2dec' // Azure Event Hubs Data Owner
        namespaceName: 'test02-${uniqueName}-ns'
      }
    ]
    eventHubs: [
      {
        name: 'test02-${uniqueName}-evh'
        messageRetentionInDays: 1
        partitionCount: 1
        namespaceName: 'test02-${uniqueName}-ns'
        roleAssignments: [
          {
            roleDefinitionIdOrName: 'Contributor'
            description: 'Contributor Role Assignment'
            principalIds: [ dependencies.outputs.identityPrincipalIds[0] ]
            principalType: 'ServicePrincipal'

          }
        ]
      }
    ]
  }
}

// Test 03 - Standard SKU - PrivateEndpoints, DiagnosticSettings with EventHub
module test_03 '../main.bicep' = {
  name: 'test03-${uniqueName}'
  params: {
    location: location
    namespaces: [
      {
        name: 'test03-${uniqueName}-ns'
        sku: 'Standard'
        capacity: 4
        publicNetworkAccess: 'Disabled'
      }
    ]
    namespacePrivateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: dependencies.outputs.subnetIds[0]
        namespaceName: 'test03-${uniqueName}-ns'
        manualApprovalEnabled: true
      }
      {
        name: 'endpoint2'
        subnetId: dependencies.outputs.subnetIds[1]
        privateDnsZoneId: dependencies.outputs.privateDNSZoneId
        namespaceName: 'test03-${uniqueName}-ns'
      }
    ]
    namespaceDiagnosticSettings: [
      {
        name: 'test03-${uniqueName}-ds'
        namespaceName: 'test03-${uniqueName}-ns'
        eventHubAuthorizationRuleId: dependencies.outputs.authorizationRuleId
        eventHubName: dependencies.outputs.eventHubName
        metricsSettings: [
          {
            category: 'AllMetrics'
            timeGrain: 'PT1M'
            enabled: true
            retentionPolicy: {
              days: 7
              enabled: true
            }
          }
        ]
        logsSettings: [
          {
            category: 'OperationalLogs'
            enabled: true
            retentionPolicy: {
              days: 36
              enabled: true
            }
          }
          {
            category: 'ArchiveLogs'
            enabled: true
          }
        ]
      }
    ]
  }
}

// Test 04 - Standard SKU - Event Hub Capture to StorageAccount, DiagnosticSettings with StorageAccount and LogAnalyticsWorkspace
module test_04 '../main.bicep' = {
  name: 'test04-${uniqueName}'
  params: {
    location: location
    namespaces: [
      {
        name: 'test04-${uniqueName}-ns'
        sku: 'Standard'
        capacity: 1
        zoneRedundant: false
      }
    ]
    eventHubs: [
      {
        name: 'test04-${uniqueName}-evh'
        messageRetentionInDays: 1
        partitionCount: 2
        namespaceName: 'test04-${uniqueName}-ns'
        captureDescriptionEnabled: true
        captureDescriptionDestinationBlobContainer: dependencies.outputs.containerName
        captureDescriptionDestinationStorageAccountResourceId: dependencies.outputs.storageAccountId
      }
    ]
    namespaceDiagnosticSettings: [
      {
        name: 'test04-${uniqueName}-ds'
        namespaceName: 'test04-${uniqueName}-ns'
        storageAccountId: dependencies.outputs.storageAccountId
        workspaceId: dependencies.outputs.workspaceId
        metricsSettings: [ { category: 'AllMetrics', enabled: true, retentionPolicy: { days: 365, enabled: true } } ]
        logsSettings: [
          {
            category: 'ArchiveLogs'
            enabled: true
            retentionPolicy: { days: 7, enabled: true }
          }
          {
            category: 'RuntimeAuditLogs'
            enabled: true
            retentionPolicy: { days: 3, enabled: true }
          }
        ]
      }
    ]
  }
}
