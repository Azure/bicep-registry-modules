# Azure Data Explorer

This Bicep module creates a Kusto Cluster with the specified number of nodes and version.

## Description

Azure Data Explorer is a fast, fully managed data analytics service for real-time analysis on large volumes of data streaming from applications, websites, IoT devices, and more. Azure Data Explorer clusters are the fundamental resource in Azure Data Explorer. A cluster is a collection of compute resources that host databases and tables.

This Bicep module allows users to create or use existing Kusto Clusters with options to control the number of nodes and version. The output of the module is the ID of the created or existing Kusto Cluster, which can be used in other Azure resource deployments.

## Parameters

| Name                      | Type     | Required | Description                                                                                                           |
| :------------------------ | :------: | :------: | :-------------------------------------------------------------------------------------------------------------------- |
| `location`                | `string` | Yes      | Deployment Location                                                                                                   |
| `name`                    | `string` | No       | Name of the Kusto Cluster. Must be unique within Azure.                                                               |
| `databaseName`            | `string` | No       | Name of the Kusto Database. Must be unique within Kusto Cluster.                                                      |
| `sku`                     | `string` | No       | The SKU of the Kusto Cluster.                                                                                         |
| `tier`                    | `string` | No       | The tier of the Kusto Cluster.                                                                                        |
| `numberOfNodes`           | `int`    | No       | The number of nodes in the Kusto Cluster.                                                                             |
| `version`                 | `int`    | No       | The version of the Kusto Cluster.                                                                                     |
| `enableAutoScale`         | `bool`   | No       | Enable or disable auto scale.                                                                                         |
| `autoScaleMin`            | `int`    | No       | The minimum number of nodes in the Kusto Cluster.                                                                     |
| `autoScaleMax`            | `int`    | No       | The maximum number of nodes in the Kusto Cluster.                                                                     |
| `tags`                    | `object` | No       | The tags of the Kusto Cluster.                                                                                        |
| `scripts`                 | `array`  | No       | The script content of the Kusto Database. Use [loadTextContent('script.kql')] to load the script content from a file. |
| `continueOnErrors`        | `bool`   | No       | Continue if there are errors running a script.                                                                        |
| `enableManagedIdentity`   | `bool`   | No       | Enable or disable the use of a Managed Identity with Data Explorer.                                                   |
| `enableStreamingIngest`   | `bool`   | No       | Enable or disable streaming ingest.                                                                                   |
| `enablePurge`             | `bool`   | No       | Enable or disable purge.                                                                                              |
| `enableDiskEncryption`    | `bool`   | No       | Enable or disable disk encryption.                                                                                    |
| `enableDoubleEncryption`  | `bool`   | No       | Enable or disable double encryption.                                                                                  |
| `trustAllTenants`         | `bool`   | No       |                                                                                                                       |
| `trustedExternalTenants`  | `array`  | No       | The list of trusted external tenants.                                                                                 |
| `enableAutoStop`          | `bool`   | No       | Enable or disable auto stop.                                                                                          |
| `enableZoneRedundant`     | `bool`   | No       | Enable or disable zone redundant.                                                                                     |
| `databaseKind`            | `string` | No       | The kind of the Kusto Database.                                                                                       |
| `unlimitedSoftDelete`     | `bool`   | No       | Enable or disable soft delete.                                                                                        |
| `softDeletePeriod`        | `int`    | No       | The soft delete period of the Kusto Database.                                                                         |
| `unlimitedHotCache`       | `bool`   | No       | Enable or disable unlimited hot cache.                                                                                |
| `hotCachePeriod`          | `int`    | No       | The hot cache period of the Kusto Database.                                                                           |
| `enableEventHubConnector` | `bool`   | No       | Enable or disable the Event Hub connector.                                                                            |
| `eventHubNamespaceName`   | `string` | No       | Name of Event Hub's namespace                                                                                         |
| `eventHubName`            | `string` | No       | Name of Event Hub                                                                                                     |
| `enableCosmosDBConnector` | `bool`   | No       | Enable or disable the Cosmos DB connector.                                                                            |
| `cosmosDDAccountName`     | `string` | No       | Name of Cosmos DB account                                                                                             |
| `cosmosDBDatabaseName`    | `string` | No       | Name of Cosmos DB database                                                                                            |
| `cosmosDBContainerName`   | `string` | No       | Name of Cosmos DB container                                                                                           |
| `newOrExistingEventHub`   | `string` | No       |                                                                                                                       |
| `eventHubSku`             | `object` | No       |                                                                                                                       |
| `eventHubProperties`      | `object` | No       |                                                                                                                       |
| `newOrExistingCosmosDB`   | `string` | No       |                                                                                                                       |

## Outputs

| Name | Type   | Description                                                                                                                      |
| :--- | :----: | :------------------------------------------------------------------------------------------------------------------------------- |
| id   | string | The ID of the created or existing Kusto Cluster. Use this ID to reference the Kusto Cluster in other Azure resource deployments. |

## Examples

### Example 1

This example creates a new Kusto Cluster with a unique name in the East US region using the default Kusto Cluster configuration settings. The module output is the ID of the created Kusto Cluster, which can be used in other Azure resource deployments.

```bicep
module kustoCluster 'br/public:data-analytics/kusto-clusters:0.0.1' = {
  name: 'mykustocluster'
  params: {
    location: 'eastus'
  }
}

output kustoClusterID string = kustoCluster.outputs.id
```

### Example 2

This example creates a new Kusto Cluster with the name "mykustocluster" in the "myresourcegroup" resource group located in the East US region. The Kusto Cluster is configured to use a specific version and number of nodes. The module output is the ID of the created or existing Kusto Cluster, which can be used in other Azure resource deployments.

```bicep
param location string = 'eastus'
param name string = 'mykustocluster'
param resourceGroupName string = 'myresourcegroup'
param version string = 'latest'
param numberOfNodes int = 1

module kustoCluster 'br/public:data-analytics/kusto-clusters:0.0.1' = {
  name: 'mykustocluster'
  params: {
    location: location
    name: name
    resourceGroupName: resourceGroupName
    version: version
    numberOfNodes: numberOfNodes
  }
}

output kustoClusterID string = kustoCluster.outputs.id
```

### Example 3

#### New Event Hub.

```bicep
module kustoCluster 'br/public:data-analytics/kusto-clusters:0.0.1' = {
  name: 'mykustocluster'
  params: {
    location: 'eastus'
    newOrExistingEventHub: 'new'
  }
}

output kustoClusterID string = kustoCluster.outputs.id
```

#### Existing Event Hub.

```bicep
param location = 'eastus'

module eventHub 'br/public:data/event-hub:0.0.1' = {
    name: 'myeventhub'
    params: {
        location: location
    }
}

module kustoCluster 'br/public:data-analytics/kusto-clusters:0.0.1' = {
  name: 'mykustocluster'
  params: {
    location: location
    newOrExistingEventHub: 'existing'
    eventHubNamespaceName: eventhub.outputs.namespaceName
    eventHubName: eventhub.outputs.name
  }
}

output kustoClusterID string = kustoCluster.outputs.id
```

### Examle 4

#### New Cosmos DB.

```bicep
module kustoCluster 'br/public:data-analytics/kusto-clusters:0.0.1' = {
  name: 'mykustocluster'
  params: {
    location: 'eastus'
    newOrExistingCosmosDB: 'new'
  }
}

output kustoClusterID string = kustoCluster.outputs.id
```

#### Existing Cosmos DB.

```bicep
module cosmosdb 'br/public:database/cosmosdb:0.0.1' = {
    name: 'mycosmosdb'
    params: {
        location: location
    }
}

module kustoCluster 'br/public:data-analytics/kusto-clusters:0.0.1' = {
  name: 'mykustocluster'
  params: {
    location: 'eastus'
    newOrExistingCosmosDB: 'existing'
    cosmosDbAccountName: comosdb.outputs.name
  }
}

output kustoClusterID string = kustoCluster.outputs.id
```