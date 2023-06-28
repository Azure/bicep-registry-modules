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

| Name                         | Type  | Description                             |
| :--------------------------- | :---: | :-------------------------------------- |
| eventHubNamespaceNames       | array | Azure Event Hub namespace names.        |
| eventHubNamespaceResourceIds | array | Azure Event Hub namespace resource Ids. |

## Examples

### Example 1

```
param clusterName string
param clusterCapacity int
param eventHubNamespaces object

module eventhubnamespace 'br/public:compute/event-hub:0.0.1' = {
  name: '${uniqueString(deployment().name, 'eastus')}-event-hub-namespace'
  params: {
    location: 'eastus'
    clusterName: clusterName
    clusterCapacity: clusterCapacity
    eventHubNamespaces: {
        production1: {
            sku: 'Standard'
            capacity:  4
            maximumThroughputUnits: 2
            zoneRedundant: true
            isAutoInflateEnabled: true
        }
        production2: {
            sku: 'Standard'
            capacity:  4
            maximumThroughputUnits: 2
            zoneRedundant: true
        }
    }
    namespaceRoleAssignments: {
      production1: {
        description: 'Reader Role Assignment'
        principalIds: [ '30ec80f4-43d7-1280-99ba-2571db1cc45b' ]
        principalType: 'ServicePrincipal'
        roleDefinitionIdOrName: 'Reader'
        eventHubNamespaceName: 'production1'
      }
    }

  }
}
```

### Example 2

```bicep
param eventHubNamespaces object
param eventHubs object
param namespaceAuthorizationRules object
param eventHubAuthorizationRules object
param consumerGroups object
param disasterRecoveryConfigs object


module eventhubnamespace 'br/public:compute/event-hub:0.0.1' = {
  name: '${uniqueString(deployment().name, 'eastus')}-event-hub-namespace'
  params: {
    location: 'eastus'
    eventHubNamespaces: {
        production1: {
            sku: 'Standard'
            capacity:  4
            maximumThroughputUnits: 2
            zoneRedundant: true
            isAutoInflateEnabled: true
        }
    }
    eventHubs: {
        audit: {
            messageRetentionInDays: 7
            partitionCount: 2
            eventHubNamespaceName: production1
        }
        billing: {
            messageRetentionInDays: 7
            partitionCount: 2
            eventHubNamespaceName: production1
            roleAssignments: [
            {
              roleDefinitionIdOrName: 'Reader'
              description: 'Reader Role Assignment'
              principalIds: [ '10ec80f4-43d7-1280-99aa-2571db1cc45b' ]
              principalType: 'ServicePrincipal'
            }
          ]
        }
    }
    namespaceAuthorizationRules: {
        rule1: {
            rights: ['Listen','Manage','Send']
            eventHubNamespaceName: production1
        }
    }
    eventHubAuthorizationRules: {
        rule1: {
            rights: ['Listen','Manage','Send']
            eventHubNamespaceName: production
            eventHubName: audit
        }
    }
    consumerGroups: {
        consumergroup1: {
            eventHubNamespaceName: production1
            eventHubName: audit
        }
    }
    disasterRecoveryConfigs: {
        disasternamespace: {
            eventHubNamespaceName: production1
            partnerNamespaceId: 'partnerNamespaceId'
        }
    }
  }
}
```

### Example 3

```bicep
module eventhubnamespace 'br/public:compute/event-hub:0.0.1' = {
  name: '${uniqueString(deployment().name, 'eastus')}-event-hub-namespace'
  params: {
    location: 'eastus'
    eventHubNamespaces: {
        productionBasic: {
            sku: 'Basic'
            capacity:  4

        }
    }
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: subnetId
        privateDnsZoneId: privateDnsZoneId
        eventHubNamespaceName: productionBasic
      }
    ]
  }
}
```

### Example 4

```bicep
module eventhubnamespace 'br/public:compute/event-hub:0.0.1' = {
  name: '${uniqueString(deployment().name, 'eastus')}-event-hub-namespace'
  params: {
    location: 'eastus'
    eventHubNamespaces: {
        productionPremium: {
            sku: 'Premium'
            capacity:  4
            zoneRedundant: true
        }
    }
  }
}

```

### Example 5

```bicep
module eventhubnamespace 'br/public:compute/event-hub:0.0.1' = {
  name: '${uniqueString(deployment().name, 'eastus')}-event-hub-namespace'
  params: {
    location: 'eastus'
  }
}

```