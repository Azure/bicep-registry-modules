<h1 style="color: steelblue;">⚠️ Retired ⚠️</h1>

This module has been retired without a replacement module in Azure Verified Modules (AVM).

For more information, see the informational notice [here](https://github.com/Azure/bicep-registry-modules?tab=readme-ov-file#%EF%B8%8F-new-standard-for-bicep-modules---avm-%EF%B8%8F).

# Azure Data Explorer

This Bicep module creates a Kusto Cluster with the specified number of nodes and version.

## Details

Azure Data Explorer is a fast, fully managed data analytics service for real-time analysis on large volumes of data streaming from applications, websites, IoT devices, and more. Azure Data Explorer clusters are the fundamental resource in Azure Data Explorer. A cluster is a collection of compute resources that host databases and tables.

This Bicep module allows users to create or use existing Kusto Clusters with options to control the number of nodes and version. The output of the module is the ID of the created or existing Kusto Cluster, which can be used in other Azure resource deployments.

## Parameters

| Name                              | Type     | Required | Description                                                                                                                                                                                                                                               |
| :-------------------------------- | :------: | :------: | :-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                        | `string` | Yes      | Deployment Location                                                                                                                                                                                                                                       |
| `name`                            | `string` | No       | Name of the Kusto Cluster. Must be unique within Azure.                                                                                                                                                                                                   |
| `sku`                             | `string` | No       | The SKU of the Kusto Cluster.                                                                                                                                                                                                                             |
| `tier`                            | `string` | No       | The tier of the Kusto Cluster.                                                                                                                                                                                                                            |
| `numberOfNodes`                   | `int`    | No       | The number of nodes in the Kusto Cluster.                                                                                                                                                                                                                 |
| `version`                         | `int`    | No       | The version of the Kusto Cluster.                                                                                                                                                                                                                         |
| `enableAutoScale`                 | `bool`   | No       | Enable or disable auto scale.                                                                                                                                                                                                                             |
| `autoScaleMin`                    | `int`    | No       | The minimum number of nodes in the Kusto Cluster.                                                                                                                                                                                                         |
| `autoScaleMax`                    | `int`    | No       | The maximum number of nodes in the Kusto Cluster.                                                                                                                                                                                                         |
| `tags`                            | `object` | No       | The tags of the Kusto Cluster.                                                                                                                                                                                                                            |
| `scripts`                         | `array`  | No       | The script content of the Kusto Database. Use [loadTextContent('script.kql')] to load the script content from a file.                                                                                                                                     |
| `continueOnErrors`                | `bool`   | No       | Continue if there are errors running a script.                                                                                                                                                                                                            |
| `enableStreamingIngest`           | `bool`   | No       | Enable or disable streaming ingest.                                                                                                                                                                                                                       |
| `enablePurge`                     | `bool`   | No       | Enable or disable purge.                                                                                                                                                                                                                                  |
| `enableDiskEncryption`            | `bool`   | No       | Enable or disable disk encryption.                                                                                                                                                                                                                        |
| `enableDoubleEncryption`          | `bool`   | No       | Enable or disable double encryption.                                                                                                                                                                                                                      |
| `trustAllTenants`                 | `bool`   | No       | Enable or disable public access from all Tenants.                                                                                                                                                                                                         |
| `trustedExternalTenants`          | `array`  | No       | The list of trusted external tenants.                                                                                                                                                                                                                     |
| `enableAutoStop`                  | `bool`   | No       | Enable or disable auto stop.                                                                                                                                                                                                                              |
| `enableZoneRedundant`             | `bool`   | No       | Enable or disable zone redundant.                                                                                                                                                                                                                         |
| `privateEndpointsApprovalEnabled` | `bool`   | No       | Toggle if Private Endpoints manual approval for Kusto Cluster should be enabled.                                                                                                                                                                          |
| `privateEndpoints`                | `array`  | No       | Define Private Endpoints that should be created for Kusto Cluster.                                                                                                                                                                                        |
| `databases`                       | `array`  | Yes      | optional. database list of kustoCluster to be created.                                                                                                                                                                                                    |
| `dataCosmosDbConnections`         | `array`  | No       | optional. data connection for specied database and resource cosmosdb                                                                                                                                                                                      |
| `dataEventHubConnections`         | `array`  | No       | optional. data connection for specied database and resource eventhub.                                                                                                                                                                                     |
| `identityType`                    | `string` | No       | Optional. The identity type attach to kustoCluster.                                                                                                                                                                                                       |
| `userAssignedIdentities`          | `object` | No       | Optional. Gets or sets a list of key value pairs that describe the set of User Assigned identities that will be used with this kustoCluster.<br />The key is the ARM resource identifier of the identity. Only 1 User Assigned identity is permitted here |
| `publicNetworkAccess`             | `string` | No       | Enable or disable public network access.                                                                                                                                                                                                                  |
| `managedPrivateEndpoints`         | `array`  | No       | The list of managed private endpoints.                                                                                                                                                                                                                    |
| `principalAssignments`            | `array`  | No       | list of principalAssignments for database                                                                                                                                                                                                                 |
| `roleAssignments`                 | `array`  | No       | List of role assignments for kustoCluster.                                                                                                                                                                                                                |
| `allowedIpRangeList`              | `array`  | No       | allowedIpRangeList for kustoCluster.                                                                                                                                                                                                                      |

## Outputs

| Name          | Type     | Description                                                                                                                      |
| :------------ | :------: | :------------------------------------------------------------------------------------------------------------------------------- |
| `id`          | `string` | The ID of the created or existing Kusto Cluster. Use this ID to reference the Kusto Cluster in other Azure resource deployments. |
| `clusterName` | `string` | Name of the kusto cluster created                                                                                                |
| `clusterUri`  | `string` | Uri of the kusto cluster created                                                                                                 |

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

```bicep
//Test 1: Create a Kusto cluster with a database, private endpoint
module kustoCluster 'br/public:data-analytics/kusto-clusters:0.0.1' = {
  dependsOn: [
    prereq
  ]
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
        requestMessage: 'Please approve the request'
      }
      {
        name: 'mgt-ep-cosmosdb'
        groupId: 'sql'
        requestMessage: 'Please approve the request'
        privateLinkResourceId: prereq.outputs.cosmosDBId
      }
    ]
    principalAssignments: [
      {
        principalId: prereq.outputs.principalId
        role: 'Admin'
        principalType: 'App'
        databaseName: 'kustodb${uniqueString(resourceGroup().id, subscription().id)}'
        tenantId: subscription().tenantId
      }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'Log Analytics Reader'
        principalIds: [ prereq.outputs.principalId ]
      }
    ]
  }
}

@description('The ID of the created or existing Kusto Cluster. Use this ID to reference the Kusto Cluster in other Azure resource deployments.')
output id string = kustoCluster.id

@description('Name of the kusto cluster created.')
output clusterName string = kustoCluster.name
```
