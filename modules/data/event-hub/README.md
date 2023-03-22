# Azure Event-Hub

This module deploys Microsoft.data event clusters, event namespace, event hub

## Description

[Azure Event Hubs](https://azure.microsoft.com/en-us/products/event-hubs/) is a fully managed, real-time data ingestion service that’s simple, trusted, and scalable. This module provides an Infrastructure as Code alternative for management of Azure event hubs using Bicep, and is intended to mirror the available functionality of provisioning with Azure Portal or CLI.

## Parameters

| Name                          | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| :---------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `clusterName`                 | `string` | No       | Optional. Name for the Event Hub cluster, Alphanumerics and hyphens characters, Start with letter, End with letter or number.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `clusterCapacity`             | `int`    | No       | Optional. The quantity of Event Hubs Cluster Capacity Units contained in this cluster.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         |
| `location`                    | `string` | No       | Optional. Location for all resources.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| `tags`                        | `object` | No       | Optional. Tags of the resource.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| `eventHubNamespaces`          | `object` | No       | Optional. The name of the event hub namespace to be created.<br />Below paramters you can pass while creating the Azure Event Hub namespace.<br />sku: (Optional) Possible values are "Basic" or "Standard" or "Premium". Detault to 'Standard'.<br />capacity: (Optional) int, The Event Hubs throughput units for Basic or Standard tiers, where value should be 0 to 20 throughput units.The Event Hubs premium units for Premium tier, where value should be 0 to 10 premium units. Default to 1.<br />zoneRedundant: (Optional) bool, Enabling this property creates a Standard Event Hubs Namespace in regions supported availability zones. Default to false.<br />isAutoInflateEnabled: (Optional) bool,  Value that indicates whether AutoInflate is enabled for eventhub namespace. Only available for "Standard" sku. Default to false.<br />maximumThroughputUnits: (Optional) int, Upper limit of throughput units when AutoInflate is enabled, value should be within 0 to 20 throughput units. ( '0' if AutoInflateEnabled = true)<br />disableLocalAuth: (Optional) bool, This property disables SAS authentication for the Event Hubs namespace. Default to false.<br />kafkaEnabled: (Optional) bool, Value that indicates whether Kafka is enabled for eventhub namespace. Default to true. |
| `eventHubs`                   | `object` | No       | Optional. Name for the eventhub to be created.<br />Below paramters you can pass while the creating Azure Event Hub<br />messageRetentionInDays: (Optional) int, Number of days to retain the events for this Event Hub, value should be 1 to 7 days. Default to 1.<br />partitionCount: (Optional) int, Number of partitions created for the Event Hub. Default to 2<br />eventHubNamespaceName: (Optional) string, Name of the Azure Event Hub Namespace<br />status: (Optional) string, Enumerates the possible values for the status of the Event Hub. 'Active','Creating','Deleting','Disabled','ReceiveDisabled','Renaming','Restoring','SendDisabled','Unknown'. Default to 'Active'                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    |
| `namespaceAuthorizationRules` | `object` | No       | Optional. Authorization Rules for the Event Hub Namespace.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| `eventHubAuthorizationRules`  | `object` | No       | Optional. Authorization Rules for the Event Hub .                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| `consumerGroups`              | `object` | No       | Optional. consumer groups for the Event Hub .                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  |
| `disasterRecoveryConfigs`     | `object` | No       | Optional. The disaster recovery config for the namespace.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| `diagnosticSettings`          | `object` | No       | Optional. The Diagnostics Settings config for the namespace.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |

## Outputs

| Name                     | Type   | Description                                               |
| :----------------------- | :----: | :-------------------------------------------------------- |
| resourceGroupName        | string | The resource group the Azure Event Hub was deployed into. |
| eventHubNamespaceDetails | array  | Azure Event Hub namespace details.                        |

## Examples

### Example 1

```
param clusterName string
param clusterCapacity int
param eventHubNamespaces object

module eventhubnamespace 'br/public:data/event-hub:1.0.0' = {
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


module eventhubnamespace 'br/public:data/event-hub:1.0.0' = {
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
module eventhubnamespace 'br/public:data/event-hub:1.0.0' = {
  name: '${uniqueString(deployment().name, 'eastus')}-event-hub-namespace'
  params: {
    location: 'eastus'
    eventHubNamespaces: {
        productionBasic: {
            sku: 'Basic'
            capacity:  4

        }
    }
  }
}  
```

### Example 4

```bicep
module eventhubnamespace 'br/public:data/event-hub:1.0.0' = {
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