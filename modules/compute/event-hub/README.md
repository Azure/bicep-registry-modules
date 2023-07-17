# Azure Event-Hub

This module deploys Microsoft.data event clusters, event namespaces, event hubs and associated configurations.

## Description

[Azure Event Hubs](https://azure.microsoft.com/en-us/products/event-hubs/) is a fully managed, real-time data ingestion service that’s simple, trusted, and scalable. This module provides an Infrastructure as Code alternative for management of Azure event hubs using Bicep, and is intended to mirror the available functionality of provisioning with Azure Portal or CLI.

## Parameters

| Name                               | Type     | Required | Description                                                                                                                   |
| :--------------------------------- | :------: | :------: | :---------------------------------------------------------------------------------------------------------------------------- |
| `clusterName`                      | `string` | No       | Optional. Name for the Event Hub cluster, Alphanumerics and hyphens characters, Start with letter, End with letter or number. |
| `clusterCapacity`                  | `int`    | No       | Optional. The quantity of Event Hubs Cluster Capacity Units contained in this cluster.                                        |
| `location`                         | `string` | No       | Required. Location for all resources.                                                                                         |
| `tags`                             | `object` | No       | Optional. Tags of the resource.                                                                                               |
| `namespaces`                       | `array`  | No       | Required. The list of the event hub namespaces with its configurations to be created.                                         |
| `namespaceAuthorizationRules`      | `array`  | No       | Optional. Authorization Rules for the Event Hub Namespace.                                                                    |
| `namespaceRoleAssignments`         | `array`  | No       | Optional. Role assignments for the namespace.                                                                                 |
| `namespaceDisasterRecoveryConfigs` | `array`  | No       | Optional. The disaster recovery config for the namespace.                                                                     |
| `namespaceDiagnosticSettings`      | `array`  | No       | Optional. The Diagnostics Settings config for the namespace.                                                                  |
| `eventHubs`                        | `array`  | No       | Optional. Name for the eventhub with its all configurations to be created.                                                    |
| `eventHubAuthorizationRules`       | `array`  | No       | Optional. Authorization Rules for the Event Hub .                                                                             |
| `eventHubConsumerGroups`           | `array`  | No       | Optional. consumer groups for the Event Hub .                                                                                 |
| `namespacePrivateEndpoints`        | `array`  | No       | Private Endpoints that should be created for Azure EventHub Namespaces.                                                       |

## Outputs

| Name                           | Type    | Description                             |
| :----------------------------- | :-----: | :-------------------------------------- |
| `eventHubNamespaceNames`       | `array` | Azure Event Hub namespace names.        |
| `eventHubNamespaceResourceIds` | `array` | Azure Event Hub namespace resource Ids. |

## Examples

### Example 1

```bicep
module evh 'br/public:compute/event-hub:2.0.1' = {
  name: 'evh-${uniqueString(deployment().name, 'eastus2')}'
  params: {
    location: 'eastus2'
    clusterName: 'evhcluster1'
    clusterCapacity: 2
    namespaces: [
      {
        name: 'testns1'
        capacity: 2
        isAutoInflateEnabled: true
        maximumThroughputUnits: 6
        zoneRedundant: true
        publicNetworkAccess: false
      }
      {
        name: 'testns2'
        sku: 'Basic'
      }
    ]
    namespaceAuthorizationRules: [
      {
        name: 'authrule01'
        rights: [ 'Listen', 'Manage', 'Send' ]
        namespaceName: 'testns1'
      }
      {
        name: 'authrule02'
        rights: [ 'Listen' ]
        namespaceName: 'testns1'
      }
    ]
    eventHubs: [
      {
        name: 'evh1'
        messageRetentionInDays: 4
        partitionCount: 4
        namespaceName: 'testns1'
      }
      {
        name: 'evh2'
        messageRetentionInDays: 7
        partitionCount: 2
        namespaceName: 'testns1'
      }
    ]
    eventHubAuthorizationRules: [
      {
        name: 'evh-rule01'
        rights: [ 'Listen', 'Manage', 'Send' ]
        namespaceName: 'testns1'
        eventHubName: 'evh1'
      }
    ]
    eventHubConsumerGroups: [
      {
        name: 'cg01'
        namespaceName: 'testns1'
        eventHubName: 'evh1'
      }
    ]
    tags: {
      tag1: 'tag1value'
      tag2: 'tag2value'
    }
  }
}
```

### Example 2

```bicep
module evhns 'br/public:compute/event-hub:2.0.1' = {
  name: 'evhns-${uniqueString(deployment().name, 'eastus')}'
  params: {
    location: 'eastus'
    namespaces: [
      {
        name: 'testns'
        sku: 'Premium'
        capacity: 2
        zoneRedundant: true
      }
    ]
    namespaceRoleAssignments: [
      {
        name: 'rol01'
        description: 'Reader Role Assignment'
        principalIds: [ '30ec80f4-43d7-1280-99ba-2571db1cc45b' ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'f526a384-b230-433a-b45c-95f59c4a2dec' // Azure Event Hubs Data Owner
        namespaceName: 'testns'
      }
    ]
    eventHubs: [
      {
        name: 'evh'
        messageRetentionInDays: 1
        partitionCount: 1
        namespaceName: 'testns'
        roleAssignments: [
          {
            name: 'role01'
            roleDefinitionIdOrName: 'Contributor'
            description: 'Contributor Role Assignment'
            principalIds: [ '10ec80f4-43d7-1280-99aa-2571db1cc45b' ]
            principalType: 'ServicePrincipal'
          }
        ]
      }
    ]
  }
}
```

### Example 3

```bicep
module evhns 'br/public:compute/event-hub:2.0.1' = {
  name: 'evhns-${uniqueString(deployment().name, 'eastus')}'
  params: {
    location: 'eastus'
    namespaces: [
      {
        name: 'testns3'
        sku: 'Standard'
        capacity: 4
        publicNetworkAccess: 'Disabled'
      }
    ]
    namespacePrivateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: dependencies.outputs.subnetIds[0]
        namespaceName: 'testns3'
        manualApprovalEnabled: true
      }
      {
        name: 'endpoint2'
        subnetId: dependencies.outputs.subnetIds[1]
        privateDnsZoneId: dependencies.outputs.privateDNSZoneId
        namespaceName: 'testns3'
      }
    ]
    namespaceDiagnosticSettings: [
      {
        name: 'testds'
        namespaceName: 'testns3'
        eventHubAuthorizationRuleId: < external evenetHub authorizationRuleId >
        eventHubName: < external eventHub name
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
```

### Example 4

```bicep
module eventhubnamespace 'br/public:compute/event-hub:2.0.1' = {
  name: 'evhns-${uniqueString(deployment().name, 'eastus')}'
  params: {
    location: 'eastus'
    namespaces: [
      {
        name: 'testns4'
        sku: 'Standard'
        capacity: 1
        zoneRedundant: false
      }
    ]
    eventHubs: [
      {
        name: 'testevh'
        messageRetentionInDays: 1
        partitionCount: 2
        namespaceName: 'testns4'
        captureDescriptionEnabled: true
        captureDescriptionDestinationBlobContainer: << external storageAccount blob container name >>
        captureDescriptionDestinationStorageAccountResourceId: << external storageAccount Id >>
      }
    ]
    namespaceDiagnosticSettings: [
      {
        name: 'ds'
        namespaceName: 'testns4'
        storageAccountId: << external storageAccount Id >>
        workspaceId: << external long analytics workspace Id >>
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
```