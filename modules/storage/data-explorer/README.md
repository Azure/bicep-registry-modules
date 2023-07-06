# Azure Data Explorer

This Bicep module creates a Kusto Cluster with the specified number of nodes and version.

## Description

Azure Data Explorer is a fast, fully managed data analytics service for real-time analysis on large volumes of data streaming from applications, websites, IoT devices, and more. Azure Data Explorer clusters are the fundamental resource in Azure Data Explorer. A cluster is a collection of compute resources that host databases and tables.

This Bicep module allows users to create or use existing Kusto Clusters with options to control the number of nodes and version. The output of the module is the ID of the created or existing Kusto Cluster, which can be used in other Azure resource deployments.

## Parameters

| Name                      |   Type   | Required | Description                                                                                                           |
| :------------------------ | :------: | :------: | :-------------------------------------------------------------------------------------------------------------------- |
| `location`                | `string` |   Yes    | Deployment Location                                                                                                   |
| `name`                    | `string` |    No    | Name of the Kusto Cluster. Must be unique within Azure.                                                               |
| `databaseName`            | `string` |    No    | Name of the Kusto Database. Must be unique within Kusto Cluster.                                                      |
| `sku`                     | `string` |    No    | The SKU of the Kusto Cluster.                                                                                         |
| `tier`                    | `string` |    No    | The tier of the Kusto Cluster.                                                                                        |
| `numberOfNodes`           |  `int`   |    No    | The number of nodes in the Kusto Cluster.                                                                             |
| `version`                 |  `int`   |    No    | The version of the Kusto Cluster.                                                                                     |
| `enableAutoScale`         |  `bool`  |    No    | Enable or disable auto scale.                                                                                         |
| `autoScaleMin`            |  `int`   |    No    | The minimum number of nodes in the Kusto Cluster.                                                                     |
| `autoScaleMax`            |  `int`   |    No    | The maximum number of nodes in the Kusto Cluster.                                                                     |
| `tags`                    | `object` |    No    | The tags of the Kusto Cluster.                                                                                        |
| `scripts`                 | `array`  |    No    | The script content of the Kusto Database. Use [loadTextContent('script.kql')] to load the script content from a file. |
| `continueOnErrors`        |  `bool`  |    No    | Continue if there are errors running a script.                                                                        |
| `enableManagedIdentity`   |  `bool`  |    No    | Enable or disable the use of a Managed Identity with Data Explorer.                                                   |
| `enableStreamingIngest`   |  `bool`  |    No    | Enable or disable streaming ingest.                                                                                   |
| `enablePurge`             |  `bool`  |    No    | Enable or disable purge.                                                                                              |
| `enableDiskEncryption`    |  `bool`  |    No    | Enable or disable disk encryption.                                                                                    |
| `enableDoubleEncryption`  |  `bool`  |    No    | Enable or disable double encryption.                                                                                  |
| `trustAllTenants`         |  `bool`  |    No    | Enable or disable public access from all Tenants.                                                                     |
| `trustedExternalTenants`  | `array`  |    No    | The list of trusted external tenants.                                                                                 |
| `enableAutoStop`          |  `bool`  |    No    | Enable or disable auto stop.                                                                                          |
| `enableZoneRedundant`     |  `bool`  |    No    | Enable or disable zone redundant.                                                                                     |
| `databaseKind`            | `string` |    No    | The kind of the Kusto Database.                                                                                       |
| `unlimitedSoftDelete`     |  `bool`  |    No    | Enable or disable soft delete.                                                                                        |
| `softDeletePeriod`        |  `int`   |    No    | The soft delete period of the Kusto Database.                                                                         |
| `unlimitedHotCache`       |  `bool`  |    No    | Enable or disable unlimited hot cache.                                                                                |
| `hotCachePeriod`          |  `int`   |    No    | The hot cache period of the Kusto Database.                                                                           |
| `enableEventHubConnector` |  `bool`  |    No    | Enable or disable the Event Hub connector.                                                                            |
| `eventHubNamespaceName`   | `string` |    No    | Name of Event Hub's namespace                                                                                         |
| `eventHubName`            | `string` |    No    | Name of Event Hub                                                                                                     |
| `enableCosmosDBConnector` |  `bool`  |    No    | Enable or disable the Cosmos DB connector.                                                                            |
| `cosmosDDAccountName`     | `string` |    No    | Name of Cosmos DB account                                                                                             |
| `cosmosDBDatabaseName`    | `string` |    No    | Name of Cosmos DB database                                                                                            |
| `cosmosDBContainerName`   | `string` |    No    | Name of Cosmos DB container                                                                                           |
| `newOrExistingEventHub`   | `string` |    No    | Create a new Event Hub namespace or use an existing one. If none, the Event Hub connector will be disabled.           |
| `eventHubSku`             | `object` |    No    | EventHub Sku Configuration Properties.                                                                                |
| `eventHubProperties`      | `object` |    No    | EventHub Properties.                                                                                                  |
| `newOrExistingCosmosDB`   | `string` |    No    | Create a new Cosmos DB account or use an existing one. If none, the Cosmos DB connector will be disabled.             |

## Outputs

| Name |  Type  | Description                                                                                                                      |
| :--- | :----: | :------------------------------------------------------------------------------------------------------------------------------- |
| id   | string | The ID of the created or existing Kusto Cluster. Use this ID to reference the Kusto Cluster in other Azure resource deployments. |

## Examples

### Example 1

This example creates a new Kusto Cluster with dataconnection with existing cosmosdb and eventhub.

```bicep
module kustoCluster 'br/public:data-analytics/kusto-clusters:0.0.1' = {
  name: 'test0${uniqueString(resourceGroup().id, subscription().id)}'
  params: {
    name: 'ktest0${uniqueString(resourceGroup().id, subscription().id)}'
    location: location
    databases: [
      {
        name: 'kustodb${uniqueString(resourceGroup().id, subscription().id)}'
        kind: 'ReadWrite'
        unlimitedSoftDelete: false
        softDeletePeriod: 30
        unlimitedHotCache: false
        hotCachePeriod: 30
        location: location
      }
    ]
    // It's publicIP
    scripts: [ {
        name: 'script1'
        databaseName: 'kustodb${uniqueString(resourceGroup().id, subscription().id)}'
        content: '.create-merge table RawEvents(document:dynamic)'
      } ]
    dataEventHubConnections: [
      {
        name: 'myconnection'
        databaseName: 'kustodb${uniqueString(resourceGroup().id, subscription().id)}'
        consumerGroup: prereq.outputs.consumerGroupName
        eventHubResourceId: prereq.outputs.eventHubResourceId
        compression: 'None'
        location: location
        tableName: 'RawEvents'
      }
    ]
    dataCosmosDbConnections: [
      {
        name: 'myconnection2'
        databaseName: 'kustodb${uniqueString(resourceGroup().id, subscription().id)}'
        cosmosDbContainer: 'container1'
        cosmosDbDatabase: 'testdb1'
        cosmosDbAccountResourceId: prereq.outputs.cosmosDBId
        location: location
        managedIdentityResourceId: prereq.outputs.identityId
        tableName: 'RawEvents'
      }
    ]
    identityType: 'UserAssigned'
    userAssignedIdentities: {
      '${prereq.outputs.identityId}': {}
    }
  }
}

@description('The ID of the created or existing Kusto Cluster. Use this ID to reference the Kusto Cluster in other Azure resource deployments.')
output id string = kustoCluster.id

@description('Name of the kusto cluster created.')
output clusterName string = kustoCluster.name
```

### Example 2

Create a Kusto cluster with a database, private endpoint and managedEndpoints

``` bicep
//Test 1: Create a Kusto cluster with a database, private endpoint
module kustoCluster 'br/public:data-analytics/kusto-clusters:0.0.1' = {
  name: 'test1${uniqueString(resourceGroup().id, subscription().id)}'
  params: {
    name: 'ktest1${uniqueString(resourceGroup().id, subscription().id)}'
    location: location
    databases: [
      {
        name: 'kustodb${uniqueString(resourceGroup().id, subscription().id)}'
        kind: 'ReadWrite'
        unlimitedSoftDelete: false
        softDeletePeriod: 30
        unlimitedHotCache: false
        hotCachePeriod: 30
        location: location
      }
    ]
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: prereq.outputs.subnetIds[0]
        privateDnsZoneId: prereq.outputs.privateDNSZoneId
      }
      {
        name: 'endpoint2'
        subnetId: prereq.outputs.subnetIds[1]
        privateDnsZoneId: prereq.outputs.privateDNSZoneId
      }
    ]
    identityType: 'UserAssigned'
    userAssignedIdentities: {
      '${prereq.outputs.identityId}': {}
    }
    publicNetworkAccess: 'Disabled'
    managedPrivateEndpoints: [
      {
        name: 'ngt-ep-eventhub'
        groupId: 'namespace'
        privateLinkResourceId: prereq.outputs.eventHubNamespaceId
        privateLinkResourceRegion: location
        requestMessage: 'Please approve the request'
      }
      {
        name: 'mgt-ep-cosmosdb'
        groupId: 'sql'
        requestMessage: 'Please approve the request'
        privateLinkResourceId: prereq.outputs.cosmosDBId
        privateLinkResourceRegion: location
      }
    ]
  }

@description('The ID of the created or existing Kusto Cluster. Use this ID to reference the Kusto Cluster in other Azure resource deployments.')
output id string = kustoCluster.id

@description('Name of the kusto cluster created.')
output clusterName string = kustoCluster.name
```