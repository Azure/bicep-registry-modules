# Azure Cosmos DB

Bicep module for simplified deployment of Cosmos DB; enables VNet integration and offers flexible configuration options.

## Description

This Bicep Module simplifies the deployment of a Cosmos DB account by providing a reusable set of parameters and resources.
It allows for the creation of a new Cosmos DB account or use of an existing one with all supported backend types, Apache Cassandra, MongoDB, Gremlin, Table, SQL Database and offers configuration options such as the default consistency level, system-managed failover, and multi-region writes. Also supports adding private endpoints and role assignments.

## Parameters

| Name                                 | Type     | Required | Description                                                                                                                                                                                                                                                                                    |
| :----------------------------------- | :------: | :------: | :--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `backendApi`                         | `string` | No       | The bakend API type of Cosmos DB database account. The API selection cannot be changed after account creation. Possible values: "cassandra", "gremlin", "mongodb", "sql", "table".                                                                                                             |
| `prefix`                             | `string` | No       | Prefix of Cosmos DB Resource Name. Not used if name is provided.                                                                                                                                                                                                                               |
| `name`                               | `string` | No       | The name of the Cosmos DB account. Character limit: 3-44, valid characters: lowercase letters, numbers, and hyphens. It must me unique across Azure.                                                                                                                                           |
| `location`                           | `string` | No       | The primary location of the Cosmos DB account. Default is the location of the resource group.<br />This would be the write region if param.additionalLocations contains more regions for georeplication.                                                                                       |
| `isZoneRedundant`                    | `bool`   | No       | Indicate whether or not to enable zone redundancy for region specified by param.location. It must be an AvailabilityZone region.<br />To enable this feature for other regions, please enable parameter isZoneRedundant in param.additionalLocations.                                          |
| `enableAutomaticFailover`            | `bool`   | No       | Enables automatic failover of the write region in the rare event that the region is unavailable due to an outage. Automatic failover will result in a new write region for the account and is chosen based on the failover priorities configured for the account.                              |
| `enableMultipleWriteLocations`       | `bool`   | No       | Enables the account to write in multiple locations. Once enabled, all regions included in the param.locations will be read/write regions.<br />Multi-region writes capability allows you to take advantage of the provisioned throughput for your databases and containers across the globe.   |
| `enableServerless`                   | `bool`   | No       | Enable Serverless for consumption-based usage.                                                                                                                                                                                                                                                 |
| `enableFreeTier`                     | `bool`   | No       | Flag to indicate whether Free Tier is enabled, up to one account per subscription is allowed.                                                                                                                                                                                                  |
| `totalThroughputLimit`               | `int`    | No       | The total throughput limit of the Cosmos DB account in measurement of requests units (RUs) per second, -1 indicates no limits on provisioning of throughput.                                                                                                                                   |
| `additionalLocations`                | `array`  | No       | The array of geo locations that Cosmos DB account would be hosted in.<br />Each element defines a region of georeplication.<br />The order of regions in this list is the order for region failover. The first element is the primary region which is a write region of the Cosmos DB account. |
| `mongoDBServerVersion`               | `string` | No       | MongoDB server version. Required for mongodb API type Cosmos DB account                                                                                                                                                                                                                        |
| `cors`                               | `array`  | No       | List of CORS rules. Each CORS rule allows or denies requests from a set of origins to a Cosmos DB account or a database                                                                                                                                                                        |
| `createMode`                         | `string` | No       | The mode of the Cosmos Account creation. Set to Restore to restore from an existing account.                                                                                                                                                                                                   |
| `disableKeyBasedMetadataWriteAccess` | `bool`   | No       | Disable write operations on metadata resources (databases, containers, throughput) via account keys.                                                                                                                                                                                           |
| `enablePublicNetworkAccess`          | `bool`   | No       | Whether requests from public network allowed.                                                                                                                                                                                                                                                  |
| `networkAclBypass`                   | `string` | No       | Indicates what services are allowed to bypass firewall checks.                                                                                                                                                                                                                                 |
| `ipRules`                            | `array`  | No       | List of IpRules to be allowed.<br />Each element in this array is either a single IPv4 address or a single IPv4 address range in CIDR format.                                                                                                                                                  |
| `virtualNetworkRules`                | `array`  | No       | The list of virtual network ACL rules. Subnets in this list will be allowed to connect.                                                                                                                                                                                                        |
| `networkAclBypassResourceIds`        | `array`  | No       | An array that contains the Resource Ids for Network Acl Bypass.                                                                                                                                                                                                                                |
| `extraCapabilities`                  | `array`  | No       | Extra capabilities besides the ones required by param.backendApi and param.enableServerless.                                                                                                                                                                                                   |
| `disableLocalAuth`                   | `bool`   | No       | Opt-out of local authentication and ensure only MSI and AAD can be used exclusively for authentication.                                                                                                                                                                                        |
| `enableAnalyticalStorage`            | `bool`   | No       | Flag to indicate whether to enable storage analytics.                                                                                                                                                                                                                                          |
| `analyticalStorageSchemaType`        | `string` | No       | The type of schema for analytical storage.                                                                                                                                                                                                                                                     |
| `cassandraKeyspaces`                 | `array`  | No       | The array of Cassandra keyspaces configurations.                                                                                                                                                                                                                                               |
| `sqlDatabases`                       | `array`  | No       | The object of sql database configurations.                                                                                                                                                                                                                                                     |
| `mongodbDatabases`                   | `array`  | No       | The list of MongoDB databases configurations.                                                                                                                                                                                                                                                  |
| `tables`                             | `array`  | No       | The object of Table databases configurations.                                                                                                                                                                                                                                                  |
| `gremlinDatabases`                   | `array`  | No       | The list of Gremlin databases configurations.                                                                                                                                                                                                                                                  |
| `sqlCustomRoleDefinitions`           | `array`  | No       | The list of SQL role definitions. Only valid when param.backendApi is set to "Sql".                                                                                                                                                                                                            |
| `sqlBuiltinRoleAssignments`          | `array`  | No       | The list of SQL built-in role assignments. Only valid when param.backendApi is set to "Sql".                                                                                                                                                                                                   |
| `roleAssignments`                    | `array`  | No       | The list of role assignments for the Cosmos DB account.                                                                                                                                                                                                                                        |
| `identityType`                       | `string` | No       | The type of identity used for the Cosmos DB account. The type "SystemAssigned, UserAssigned" includes both an implicitly created identity and a set of user-assigned identities. The type "None" will remove any identities from the Cosmos DB account.                                        |
| `userAssignedIdentities`             | `array`  | No       | The list of user-assigned managed identities. The user identity dictionary key references will be ARM resource ids in the form: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}"                 |
| `tags`                               | `object` | No       | A object of key-value pairs that describe the resource.                                                                                                                                                                                                                                        |
| `lock`                               | `string` | No       | Specify the type of lock on Cosmos DB account resource.                                                                                                                                                                                                                                        |
| `consistencyPolicy`                  | `object` | No       | The consistency policy for the Cosmos DB account.                                                                                                                                                                                                                                              |
| `privateEndpoints`                   | `array`  | No       | Private Endpoints that should be created for Azure Cosmos DB account.                                                                                                                                                                                                                          |
| `minimalTlsVersion`                  | `string` | No       | The minimum TLS version to support on this account.                                                                                                                                                                                                                                            |
| `enablePartitionMerge`               | `bool`   | No       | Flag to indicate enabling/disabling of Partition Merge feature on the account.                                                                                                                                                                                                                 |
| `enablePartitionKeyMonitor`          | `bool`   | No       | Flag to indicate enabling/disabling of Partition Split feature on the account.                                                                                                                                                                                                                 |

## Outputs

| Name                                | Type     | Description                                                                       |
| :---------------------------------- | :------: | :-------------------------------------------------------------------------------- |
| `id`                                | `string` | Cosmos DB Account Resource ID                                                     |
| `name`                              | `string` | Cosmos DB Account Resource Name                                                   |
| `systemAssignedIdentityPrincipalId` | `string` | Object Id of system assigned managed identity for Cosmos DB account (if enabled). |
| `sqlRoleDefinitionIds`              | `array`  | Resource Ids of sql role definition resources created for this Cosmos DB account. |

## Examples

### Example 1

An example of how to deploy Azure Cosmosdb Account with _Apache Cassanda backend_ using the minimum required parameters.

```bicep
module cosmosDbAccount 'br/public:storage/cosmos-db:0.0.1' = {
 name: 'cosmosdb-${uniqueString(deployment().name, resourceGroup().location)}-deployment'
  params: {
    backendApi = 'cassandra'
  }
}

output cosmosDbAccountResourceId string = cosmosDbAccount.outputs.id
```

### Example 2

An example of how to deploy a _multi-region_ enabled cassandra backend Cosmosdb account along with access _role assignments_ and _zone redundancy_ for one of secondary locations.

```bicep
module cosmosCassandraDb 'br/public:storage/cosmos-db:0.0.1' = {
  name: 'cosmosdb-${uniqueString(deployment().name, resourceGroup().location)}-deployment'
  params: {
    location: 'eastus'
    name: 'cosmosdb-${uniqueString(deployment().name, resourceGroup().location)}'
    backendApi: 'cassandra'
    location: location
    isZoneRedundant: false
    additionalLocations: [
      {
        name: 'Norway West'
      }
      {
        name: 'Canada East'
        isZoneRedundant: true
      }
    ]
    roleAssignments: [
      {
        roleDefinitionId: 'b24988ac-6180-42a0-ab88-20f7382dd24c' // Contributor
        principalId: 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
      }
      {
        roleDefinitionId: 'acdd72a7-3385-48ef-bd42-f606fba81ae7' // Reader
        principalId: 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee'
      }
    ]
    cassandraKeyspaces: {
      keyspace1: {
        performance: {
          enableAutoScale: true
          throughput: 4000
        }
        tables: {
          table1: {
            defaultTtl: 86400
            schema: {
              columns: [ {
                  name: 'test1'
                  type: 'int'
                } ]
              partitionKeys: [ {
                  name: 'test1'
                } ]
            }
          }
          table2: {
            schema: {
              columns: [ {
                  name: 'test2'
                  type: 'int'
                } ]
              partitionKeys: [ {
                  name: 'test2'
                } ]
            }
          }
        }
      }
    }
  }

output cosmosCassandraDbResourceId string = cosmosCassandraDb.outputs.id
```

> **Importanat note on setting up throughput parameters**<br><br>
> 
> Throughtput can be povisioned for both Keyspaces and tables within it or just for Tables. Provisioned throughput at the keyspace level will be shared across all tables within the keyspace.
> 
> You can optionally provision dedicated throughput for a table within a keyspace that has throughput provisioned. This dedicated throughput amount will not be shared with other tables in the keyspace and does not count towards the throughput you provisioned for the keyspace. This throughput amount will be billed in addition to the throughput amount you provisioned at the keyspace level.
> 
> This is applicable for all other backend api type Cosmos DB account resources.

### Example 3

An example of how to deploy a SQL Databses with Containers with _CORS Policies_, _totalThroughputLimit_ and different _defaultConsistencyLevel_ options.

```bicep
module cosmosSqlDb 'br/public:storage/cosmos-db:0.0.1' = {
  name: 'cosmosdb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    name: 'cosmosdb-${uniqueString(deployment().name, location)}'
    location: 'westus'
    backendApi: 'sql'
    consistencyPolicy: {
      defaultConsistencyLevel: 'BoundedStaleness'
      maxIntervalInSeconds: 10000
      maxStalenessPrefix: 100000
    }
    additionalLocations: [
      {
        name: 'Canada Central'
        isZoneRedundant: false
      }
      {
        name: 'Brazil South'
        isZoneRedundant: true
      }
    ]
    totalThroughputLimit: 100000
    enableMultipleWriteLocations: true
    sqlDatabases: {
      testdb1: {
        containers: {
          container1: {
            performance: {
              enableAutoScale: true
              throughput: 4000
            }
            defaultTtl: 3600
            partitionKey: {
              paths: [ '/definition/id' ]
              kind: 'Hash'
            }
            indexingPolicy: {
              indexingMode: 'consistent'
              automatic: true
              includedPaths: [ { path: '/*' } ]
              excludedPaths: [ { path: '/"_etag"/?' } ]
            }
          }
          container2: {
            performance: {
              enableAutoScale: false
              throughput: 4000
            }
            defaultTtl: 86400
            partitionKey: {
              paths: [
                '/id'
              ]
              kind: 'Hash'
              version: 1
            }
            indexingPolicy: {
              indexingMode: 'consistent'
              automatic: true
              includedPaths: [ { path: '/*' } ]
              excludedPaths: [ { path: '/"_etag"/?' } ]
            }
            conflictResolutionPolicy: {
              mode: 'LastWriterWins'
              conflictResolutionPath: '/_ts'
            }
            triggers: {
              trigger1: {
                triggerType: 'Pre'
                triggerOperation: 'All'
                body: 'function() { var context = getContext(); var response = context.getResponse(); response.setBody("Pre-trigger body."); }'
              }
            }
            storedProcedures: {
              storedProcedure1: {
                body: 'function() { var context = getContext(); var response = context.getResponse(); response.setBody("Stored procedure body."); }'
              }
            }
            userDefinedFunctions: {
              userDefinedFunction1: {
                body: 'function() { var context = getContext(); var response = context.getResponse(); response.setBody("User defined function body."); }'
              }
            }
          }
        }
      }
    }
  }
}

output cosmosSqlDbResourceId string = cosmosSqlDb.outputs.id
```

### Example 4

An example of how to deploy a MongoDB Databases with collections with _CORS Policies_, extra non-default _capabilities_ options and with _systemAssigned managed identity_ enabled.

```bicep
module cosmosMongoDb 'br/public:storage/cosmos-db:0.0.1' = {
  name: 'cosmosdb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: 'eastus'
    backendApi: 'mongodb'
    name: 'cosmosdb-${uniqueString(deployment().name, location)}'
    extraCapabilities: [
      'EnableMongoRetryableWrites'
      'EnableAggregationPipeline'
    ]
    identityType: 'SystemAssigned'
    cors: [
      {
        allowedOrigins: 'https://www.bing.com'
        allowedMethods: 'POST,GET'
        maxAgeInSeconds: 60
      }
    ]
    mongodbDatabases: {
      testdb1: {
        performance: {
          enableAutoScale: true
          throughput: 4000
        }
        collections: {
          collection1: {
            performance: {
              enableAutoScale: false
              throughput: 400
            }
            indexes: [
              {
                key: { keys: [ '_id' ] }
                options: {
                  unique: true
                }
              }
              {
                key: { keys: [ '$**' ] }
                options: {}
              }
            ]
            shardKey: {
              user_id: 'Hash'
            }
          }
        }
      }
    }
  }
}

output cosmosSqlDbResourceId string = cosmosMongoDb.outputs.id
output systemAssignedIdentityPrincipalId string = cosmosMongoDb.outputs.systemAssignedIdentityPrincipalId
```

### Example 5

An example of how to deploy a Cosmmos DB Tables with networking IP and VNet firewall bypass rules.

```bicep
module cosmosTable 'br/public:storage/cosmos-db:0.0.1' = {
  name: 'cosmosdb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: 'westus'
    backendApi: 'table'
    name: 'cosmosdb-${uniqueString(deployment().name, location)}'
    additionalLocations: [
      {
        name: 'canadacentral'
        isZoneRedundant: true
      }
      {
        name: 'centralus'
      }
      {
        name: 'eastus'
      }
    ]
    backendApi: 'table'
    enableServerless: true
    enableAnalyticalStorage: true
    tables: {
      table1: {}
      table2: {}
    }
    ipRules: [
      '1.2.3.4'
      '1.2.3.4/24'
    ]
    virtualNetworkRules: [
      {
        id: dependencies.outputs.subnetIds[0]
        ignoreMissingVNetServiceEndpoint: true
      }
    ]
  }
}

output cosmosTableDbResourceId string = cosmosTable.outputs.id
```

### Example 6

An example of how to deploy a Gremlin DB with graphs along with _private endpoints_.

```bicep
module cosmosGremlinDb 'br/public:storage/cosmos-db:0.0.1' = {
  name: 'cosmosdb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: 'westus'
    backendApi: 'gremlin'
    name: 'cosmosdb-${uniqueString(deployment().name, location)}'
    gremlinDatabases: {
      testdb01: {
        performance: {
          enableAutoScale: false
          throughput: 500
        }
        graphs: {
          graph1: {
            performance: {
              enableAutoScale: true
              throughput: 4000
            }
            defaultTtl: 3600
            partitionKey: {
              paths: [ '/address' ]
              kind: 'Hash'
              version: 1
            }
          }
        }
      }
    }
    enablePublicNetworkAccess: false
    privateEndpoints: {
      endpoint1: {
        subnetId: dependencies.outputs.subnetIds[0]
        isManualApproval: true
        groupId: 'Sql'
      }
      endpoint2: {
        subnetId: dependencies.outputs.subnetIds[1]
        privateDnsZoneId: dependencies.outputs.privateDNSZoneId
        groupId: 'Gremlin'
      }
    }
  }
}

output cosmosGremlinDbResourceId string = cosmosGremlinDb.outputs.id
```

### Example 7

An example of how to deploy a Cosmos DB account with sqlRoleDefinitions and sqlRoleAssignments.

```bicep
module cosmosDb 'br/public:storage/cosmos-db:0.0.1' = {
  name: 'cosmosdb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: 'westus'
    backendApi: 'sql'
    name: 'cosmosdb-${uniqueString(deployment().name, location)}'
    sqlDatabases: {
      testdb1: {
        containers: {
          container1: {
            performance: {
              enableAutoScale: true
              throughput: 4000
            }
            defaultTtl: 3600
            partitionKey: {
              paths: [ '/id' ]
              kind: 'Hash'
              version: 1
            }
          }
        }
      }
    }
    sqlCustomRoleDefinitions: {
      testReadWriteRole1: {
        permissions: [
          {
            dataActions: [
              'Microsoft.DocumentDB/databaseAccounts/readMetadata'
              'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
              'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
            ]
          }
        ]
        assisgnments: [
          {
            principalId: dependencies.outputs.identityPrincipalIds[0]
          }
          {
            principalId: dependencies.outputs.identityPrincipalIds[1]
            scope: '/dbs/testdb1'
          }
        ]
      }
    }
  }
}

output cosmosDbResourceId string = cosmosDb.outputs.id
output sqlRoleDefinitionIds array = cosmosDb.outputs.sqlRoleDefinitionIds
```