# Azure Cosmos DB

Bicep module for simplified deployment of Cosmos DB; enables VNet integration and offers flexible configuration options.

## Description

This Bicep Module simplifies the deployment of a Cosmos DB account by providing a reusable set of parameters and resources.
It allows for the creation of a new Cosmos DB account or use of an existing one, and offers configuration options such as the default consistency level, system-managed failover, and multi-region writes.
The module also allows for the attachment of the Cosmos DB account to a virtual network, if specified.

## Parameters

| Name                           | Type     | Required | Description                                                                                                                                         |
| :----------------------------- | :------: | :------: | :-------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                     | `string` | Yes      | Deployment Location                                                                                                                                 |
| `name`                         | `string` | No       | Name of Cosmos DB                                                                                                                                   |
| `newOrExisting`                | `string` | No       | Specifies whether to create a new Cosmos DB account or use an existing one. Use "new" to create a new account or "existing" to use an existing one. |
| `maxStalenessPrefix`           | `int`    | No       | Max stale requests. Required for BoundedStaleness. Valid ranges, Single Region: 10 to 2147483647. Multi Region: 100000 to 2147483647.               |
| `maxIntervalInSeconds`         | `int`    | No       | Max lag time (minutes). Required for BoundedStaleness. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400.                         |
| `defaultConsistencyLevel`      | `string` | No       | The default consistency level of the Cosmos DB account.                                                                                             |
| `systemManagedFailover`        | `bool`   | No       | Enable system managed failover for regions                                                                                                          |
| `secondaryLocations`           | `array`  | No       | array of region objects or regions: [region: string]                                                                                                |
| `enableMultipleWriteLocations` | `bool`   | No       | Multi-region writes capability allows you to take advantage of the provisioned throughput for your databases and containers across the globe.       |
| `enableCassandra`              | `bool`   | No       | Enable Cassandra Backend.                                                                                                                           |
| `enableServerless`             | `bool`   | No       | Enable Serverless for consumption-based usage.                                                                                                      |
| `isZoneRedundant`              | `bool`   | No       | Toggle to enable or disable zone redudance.                                                                                                         |

## Outputs

| Name       | Type   | Description                               |
| :--------- | :----: | :---------------------------------------- |
| resourceId | string | The resource ID of the Cosmos DB account. |

## Examples

### Example 1

In this example, we're deploying a new Cosmos DB account to the "eastus" region with the prefix "mycosmosdb". The Bicep module is referenced using the module keyword, and the cosmosDb module is passed the required parameters using the params keyword. Finally, the cosmosDbResourceId output is assigned the value of the Cosmos DB account's resource ID using the cosmosDb.outputs.resourceId expression.

```bicep
param location string = 'eastus'
param prefix string = 'mycosmosdb'

module cosmosDb 'br/public:data/cosmos-db:0.0.1' = {
  name: 'cosmosDbDeployment'
  params: {
    location: location
    name: prefix
  }
}

output cosmosDbResourceId string = cosmosDb.outputs.resourceId
```

### Example 2

In this example, we're using the data/cosmos-db module to deploy a new Cosmos DB account with the name ${prefix}-<unique string> in the location provided. We're also specifying enableCassandra to be true, which will enable Apache Cassandra as a backend for the account.

```bicep
param location string = 'eastus'
param prefix string = 'mycassandradb'

module cassandraDb 'br/public:data/cosmos-db:0.0.1' = {
  name: 'cassandraDbDeployment'
  params: {
    location: location
    name: prefix
    enableCassandra: true
  }
}

output cassandraDbResourceId string = cassandraDb.outputs.resourceId
```

### Example 3

In this example, secondaryRegions is an array of strings representing the additional regions where the Cosmos DB account will be deployed.
The secondaryLocations parameter in the cosmosDb module is set to this array of regions using the secondaryRegions variable.

```bicep
param location string = 'eastus'
param name string = 'mycosmosdb'

param secondaryRegions = [
  'westus',
  'centralus'
]

module cosmosDb 'br/public:data/cosmos-db:0.0.1' = {
  name: 'cosmosDbDeployment'
  params: {
    location: location
    name: name
    secondaryLocations: secondaryRegions
  }
}

output cosmosDbResourceId string = cosmosDb.outputs.resourceId
```