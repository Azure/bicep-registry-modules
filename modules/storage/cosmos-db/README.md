# Azure Cosmos DB

Bicep module for simplified deployment of Cosmos DB; enables VNet integration and offers flexible configuration options.

## Description

This Bicep Module simplifies the deployment of a Cosmos DB account by providing a reusable set of parameters and resources.
It allows for the creation of a new Cosmos DB account or use of an existing one with all supported backend types, Apache Cassandra, MongoDB, Gremlin, Table, SQL Database and offers configuration options such as the default consistency level, system-managed failover, and multi-region writes. Also supports adding private endpoints and role assignments.

## Parameters

| Name                                 | Type     | Required | Description                                                                                                                                                                                                                                                                                                                                                                                  |
| :----------------------------------- | :------: | :------: | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `location`                           | `string` | No       | Deployment region name. Default is the location of the resource group.                                                                                                                                                                                                                                                                                                                       |
| `backendApi`                         | `string` | No       | The bakend API type of Cosmos DB database account. The API selection cannot be changed after account creation. Possible values: "cassandra", "gremlin", "mongodb", "sql", "table".                                                                                                                                                                                                           |
| `prefix`                             | `string` | No       | Prefix of Cosmos DB Resource Name. Not used if name is provided.                                                                                                                                                                                                                                                                                                                             |
| `name`                               | `string` | No       | The name of the Cosmos DB account. Character limit: 3-44, valid characters: lowercase letters, numbers, and hyphens. It must me unique across Azure.                                                                                                                                                                                                                                         |
| `enableAutomaticFailover`            | `bool`   | No       | Enables automatic failover of the write region in the rare event that the region is unavailable due to an outage. Automatic failover will result in a new write region for the account and is chosen based on the failover priorities configured for the account.                                                                                                                            |
| `enableMultipleWriteLocations`       | `bool`   | No       | Multi-region writes capability allows you to take advantage of the provisioned throughput for your databases and containers across the globe.                                                                                                                                                                                                                                                |
| `enableServerless`                   | `bool`   | No       | Enable Serverless for consumption-based usage.                                                                                                                                                                                                                                                                                                                                               |
| `isZoneRedundant`                    | `bool`   | No       | Flag to indicate whether or not this region is an AvailabilityZone region                                                                                                                                                                                                                                                                                                                    |
| `enableFreeTier`                     | `bool`   | No       | Flag to indicate whether Free Tier is enabled, up to one account per subscription is allowed.                                                                                                                                                                                                                                                                                                |
| `totalThroughputLimit`               | `int`    | No       | The total throughput limit of the Cosmos DB account in measurement of requests units (RUs) per second, -1 indicates no limits on provisioning of throughput.                                                                                                                                                                                                                                 |
| `secondaryLocations`                 | `array`  | No       | The array of secondary locations.                                                                                                                                                                                                                                                                                                                                                            |
| `defaultConsistencyLevel`            | `string` | No       | The default consistency level. Possible values: "Eventual", "ConsistentPrefix", "Session", "BoundedStaleness", "Strong".                                                                                                                                                                                                                                                                     |
| `maxStalenessPrefix`                 | `int`    | No       | Max stale requests required for "BoundedStaleness" Consistency Level. Valid ranges, Single Region: 10 to 2147483647. Multi Region: 100000 to 2147483647.                                                                                                                                                                                                                                     |
| `maxIntervalInSeconds`               | `int`    | No       | Max lag time (minutes). Required for BoundedStaleness. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400.                                                                                                                                                                                                                                                                  |
| `serverVersion`                      | `string` | No       | MongoDB server version. Required for mongodb API type Cosmos DB account                                                                                                                                                                                                                                                                                                                      |
| `cors`                               | `array`  | No       | List of CORS rules.                                                                                                                                                                                                                                                                                                                                                                          |
| `disableKeyBasedMetadataWriteAccess` | `bool`   | No       | Disable write operations on metadata resources (databases, containers, throughput) via account keys.                                                                                                                                                                                                                                                                                         |
| `publicNetworkAccess`                | `string` | No       | Whether requests from public network allowed.                                                                                                                                                                                                                                                                                                                                                |
| `isVirtualNetworkFilterEnabled`      | `bool`   | No       | Flag to indicate whether to enable/disable Virtual Network ACL rules.                                                                                                                                                                                                                                                                                                                        |
| `networkAclBypass`                   | `string` | No       | Indicates what services are allowed to bypass firewall checks.                                                                                                                                                                                                                                                                                                                               |
| `ipRules`                            | `array`  | No       | List of IpRules to be allowed. A single IPv4 address or a single IPv4 address range in CIDR format.                                                                                                                                                                                                                                                                                          |
| `virtualNetworkRules`                | `array`  | No       | The list of virtual network ACL rules, "isVirtualNetworkFilterEnabled" must be set to "true". format: {id: string, ignoreMissingVNetServiceEndpoint: bool}                                                                                                                                                                                                                                   |
| `networkAclBypassResourceIds`        | `array`  | No       | An array that contains the Resource Ids for Network Acl Bypass.                                                                                                                                                                                                                                                                                                                              |
| `capabilities`                       | `array`  | No       | Non-default extra capabilities.                                                                                                                                                                                                                                                                                                                                                              |
| `disableLocalAuth`                   | `bool`   | No       | Opt-out of local authentication and ensure only MSI and AAD can be used exclusively for authentication.                                                                                                                                                                                                                                                                                      |
| `enableAnalyticalStorage`            | `bool`   | No       | Flag to indicate whether to enable storage analytics.                                                                                                                                                                                                                                                                                                                                        |
| `analyticalStorageSchemaType`        | `string` | No       | The type of schema for analytical storage.                                                                                                                                                                                                                                                                                                                                                   |
| `cassandraKeyspaces`                 | `array`  | No       | The list of Cassandra keyspaces configurations with tables.                                                                                                                                                                                                                                                                                                                                  |
| `sqlDatabases`                       | `array`  | No       | The list of SQL databases configurations with containers, its triggers, storedProcedures and userDefinedFunctions.                                                                                                                                                                                                                                                                           |
| `sqlRoleDefinitions`                 | `array`  | No       | The list of SQL role definitions.                                                                                                                                                                                                                                                                                                                                                            |
| `sqlRoleAssignments`                 | `array`  | No       | The list of SQL role assignments.                                                                                                                                                                                                                                                                                                                                                            |
| `mongodbDatabases`                   | `array`  | No       | The list of MongoDB databases configurations with collections, its indexes, Shard Keys.                                                                                                                                                                                                                                                                                                      |
| `gremlinDatabases`                   | `array`  | No       | The list of Gremlin databases configurations with graphs.                                                                                                                                                                                                                                                                                                                                    |
| `tables`                             | `array`  | No       | The list of Table databases configurations.                                                                                                                                                                                                                                                                                                                                                  |
| `roleAssignments`                    | `array`  | No       | Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11" |
| `identityType`                       | `string` | No       | The type of identity used for the Cosmos DB account. The type "SystemAssigned, UserAssigned" includes both an implicitly created identity and a set of user-assigned identities. The type "None" will remove any identities from the Cosmos DB account.                                                                                                                                      |
| `userAssignedIdentities`             | `object` | No       | The list of user-assigned managed identities. The user identity dictionary key references will be ARM resource ids in the form: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}"                                                                                                               |
| `privateEndpoints`                   | `array`  | No       | Private Endpoints that should be created for Azure Cosmos DB account.                                                                                                                                                                                                                                                                                                                        |
| `tags`                               | `object` | No       | List of key-value pairs that describe the resource.                                                                                                                                                                                                                                                                                                                                          |
| `lock`                               | `string` | No       | Specify the type of lock on Cosmos DB account resource.                                                                                                                                                                                                                                                                                                                                      |

## Outputs

| Name                              | Type   | Description                                                                       |
| :-------------------------------- | :----: | :-------------------------------------------------------------------------------- |
| id                                | string | Cosmos DB Account Resource ID                                                     |
| name                              | string | Cosmos DB Account Resource Name                                                   |
| systemAssignedIdentityPrincipalId | string | Object Id of system assigned managed identity for Cosmos DB account (if enabled). |
| sqlRoleDefinitionIds              | array  | Resource Ids of sql role definition resources created for this Cosmos DB account. |

## Examples

### Example 1

An example of how to deploy Azure Cosmosdb Account with _Apache Cassanda backend_ using the minimum required parameters.

```bicep
module cosmosDbAccount 'br/public:storage/cosmos-db:2.0.0' = {
 name: 'cosmosdb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    name: 'cosmosdb-${uniqueString(deployment().name, location)}'
    location: 'eastus'
  }
}

output cosmosDbAccountResourceId string = cosmosDbAccount.outputs.id
```

### Example 2

An example of how to deploy a _multi-region_ enabled cassandra backend Cosmosdb account along with access _role assignments_ and _zone redundancy_ for one of secondary locations.

```bicep
module cosmosCassandraDb 'br/public:storage/cosmos-db:2.0.0' = {
  name: 'cosmosdb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: 'eastus'
    name: 'cosmosdb-${uniqueString(deployment().name, location)}'
    secondaryLocations: [
        {
          locationName: 'westus'
        }
        {
          locationName: 'centralus'
          isZoneRedundant: true
        }
    ]
    roleAssignments: [
      {
        roleDefinitionIdOrName: 'CosmosBackupOperator'
        principalIds: [ '5f82d7a7-1d09-401a-b473-c723972e8676' ]
      }
      {
        roleDefinitionIdOrName: '5bd9cd88-fe45-4216-938b-f97437e15450' // DocumentDB Account Contributor
        principalIds: [ 'cdac5946-f757-43a9-8657-31f59048deb5' ]
      }
    ]
    cassandraKeyspaces: [
      {
        name: 'keyspace1'
        autoscaleMaxThroughput: 1000
        tables: [
          {
            name: 'table1'
            // Optional: autoscaleMaxThroughput: int or manualProvisionedThroughput: int
            defaultTtl: 86400
            schemaColumns: [
              {
                name: 'id'
                type: 'text'
              }
              {
                name: 'data'
                type: 'blob'
              }
            ]
            schemaPartitionKeys: [
              {
                name: 'id'
              }
            ]
            schemaClusteringKeys: [
              {
                name: 'data'
                orderBy: 'Desc'
              }
            ]
          }
          {
            name: 'table2'
            manualProvisionedThroughput: 400
            schemaColumns: [
              {
                name: 'id'
                type: 'text'
              }
            ]
            schemaPartitionKeys: [
              {
                name: 'id'
              }
            ]
          }
        ]
      }
    ]
  }
}

output cosmosCassandraDbResourceId string = cosmosCassandraDb.outputs.id
```

> **Importanat note on setting up throughput parameters**<br><br>
> Make sure to provide only one of **_manualProvisionedThroughput_** and **_autoscaleMaxThroughput_** at any scope level.
> 
> Throughtput can be povisioned for both Keyspaces and tables within it or just for Tables. Provisioned throughput at the keyspace level will be shared across all tables within the keyspace.
> 
> You can optionally provision dedicated throughput for a table within a keyspace that has throughput provisioned. This dedicated throughput amount will not be shared with other tables in the keyspace and does not count towards the throughput you provisioned for the keyspace. This throughput amount will be billed in addition to the throughput amount you provisioned at the keyspace level.
> 
> This is applicable for all other backend api type Cosmos DB account resources.

### Example 3

An example of how to deploy a SQL Databses with Containers with _CORS Policies_, _totalThroughputLimit_ and different _defaultConsistencyLevel_ options.

```bicep
module cosmosSqlDb 'br/public:storage/cosmos-db:2.0.0' = {
  name: 'cosmosdb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: 'westus'
    backendApi: 'sql'
    name: 'cosmosdb-${uniqueString(deployment().name, location)}'
    defaultConsistencyLevel: 'BoundedStaleness'
    maxIntervalInSeconds: 3600
    maxStalenessPrefix: 86400
    totalThroughputLimit: 10000
    sqlDatabases: [
      {
        name: 'testdb1'
        // Optional: autoscaleMaxThroughput: int or manualProvisionedThroughput: int
        containers: [
          {
            name: 'container1'
            autoscaleMaxThroughput: 4000
            defaultTtl: 3600
            partitionKey: {
              paths: [
                '/id'
              ]
              kind: 'Hash'
              version: 1
            }
          }
          {
            name: 'container2'
            manualProvisionedThroughput: 400
            defaultTtl: 86400
            partitionKey: {
              paths: [
                '/id'
              ]
              kind: 'Hash'
              version: 1
            }
            indexingPolicy: {
              indexingMode: 'Consistent'
              automatic: true
              includedPaths: [
                {
                  path: '/*'
                }
              ]
              excludedPaths: [
                {
                  path: '/"_etag"/?'
                }
              ]
            }
            uniqueKeyPolicy: {
              uniqueKeys: []
            }
            conflictResolutionPolicy: {
              mode: 'LastWriterWins'
              conflictResolutionPath: '/_ts'
            }
            triggers: [
              {
                name: 'trigger1'
                type: 'Pre'
                operation: 'All'
                body: 'function() { var context = getContext(); var response = context.getResponse(); response.setBody("Pre-trigger body."); }'
              }
            ]
            storedProcedures: [
              {
                name: 'storedProcedure1'
                body: 'function() { var context = getContext(); var response = context.getResponse(); response.setBody("Stored procedure body."); }'
              }
            ]
            userDefinedFunctions: [
              {
                name: 'userDefinedFunction1'
                body: 'function() { var context = getContext(); var response = context.getResponse(); response.setBody("User defined function body."); }'
              }
            ]
          }
        ]
      }
    ]
  }
}

output cosmosSqlDbResourceId string = cosmosSqlDb.outputs.id
```

### Example 4

An example of how to deploy a MongoDB Databases with collections with _CORS Policies_, extra non-default _capabilities_ options and with _systemAssigned managed identity_ enabled.

```bicep
module cosmosMongoDb 'br/public:storage/cosmos-db:2.0.0' = {
  name: 'cosmosdb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: 'eastus'
    backendApi: 'mongodb'
    name: 'cosmosdb-${uniqueString(deployment().name, location)}'
    capabilities: [
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
    mongodbDatabases: [
      {
        name: 'testdb1'
        autoscaleMaxThroughput: 4000
        collections: [
          {
            name: 'collection1'
            manualProvisionedThroughput: 400
            indexes: [
              {
                key: {
                  keys: [
                    '_id'
                  ]
                }
              }
              {
                key: {
                  keys: [
                    '$**'
                  ]
                }
              }
            ]
            shardkey: {
              user_id: 'Hash'
            }
          }
        ]
      }
    ]
  }
}

output cosmosSqlDbResourceId string = cosmosMongoDb.outputs.id
output systemAssignedIdentityPrincipalId string = cosmosMongoDb.outputs.systemAssignedIdentityPrincipalId
```

### Example 5

An example of how to deploy a Cosmmos DB Tables with networking IP and VNet firewall bypass rules.

```bicep
module cosmosTable 'br/public:storage/cosmos-db:2.0.0' = {
  name: 'cosmosdb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: 'westus'
    backendApi: 'table'
    name: 'cosmosdb-${uniqueString(deployment().name, location)}'
    enableServerless: true
    defaultConsistencyLevel: 'BoundedStaleness'
    maxIntervalInSeconds: 10000
    maxStalenessPrefix: 100000
    tables: [
      {
        name: 'table1'
      }
      {
        name: 'table2'
      }
    ]
    publicNetworkAccess: 'Enabled'
    ipRules: [
      '20.112.52.29'
      '20.53.0.0/31'
    ]
    isVirtualNetworkFilterEnabled: true
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
module cosmosGremlinDb 'br/public:storage/cosmos-db:2.0.0' = {
  name: 'cosmosdb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: 'westus'
    backendApi: 'gremlin'
    name: 'cosmosdb-${uniqueString(deployment().name, location)}'
    gremlinDatabases: [
      {
        name: 'testdb01'
        manualProvisionedThroughput: 500
        graphs: [
          {
            name: 'graph1'
            autoscaleMaxThroughput: 1000
            defaultTtl: 3600
            partitionKey: {
              paths: [
                '/address'
              ]
              kind: 'Hash'
              version: 1
            }
            indexingPolicy: {}
            uniqueKeyPolicy: {}
          }
        ]
      }
    ]
    publicNetworkAccess: 'Disabled'
    privateEndpoints: [
      {
        name: 'endpoint1'
        subnetId: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}"
        manualApprovalEnabled: true
        groupId: 'Sql'
      }
      {
        name: 'endpoint2'
        subnetId: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}"
        privateDnsZoneId: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateDnsZones/{privateDnsZoneName}"
        groupId: 'Gremlin'
      }
    ]
  }
}

output cosmosGremlinDbResourceId string = cosmosGremlinDb.outputs.id
```

### Example 7

An example of how to deploy a Cosmos DB account with sqlRoleDefinitions and sqlRoleAssignments.

```bicep
module cosmosDb 'br/public:storage/cosmos-db:2.0.0' = {
  name: 'cosmosdb-${uniqueString(deployment().name, location)}-deployment'
  params: {
    location: 'westus'
    backendApi: 'sql'
    name: 'cosmosdb-${uniqueString(deployment().name, location)}'
    sqlDatabases: [
      {
        name: 'testdb1'
        containers: [
          {
            name: 'container1'
            autoscaleMaxThroughput: 4000
            defaultTtl: 3600
            partitionKey: {
              paths: [
                '/id'
              ]
              kind: 'Hash'
              version: 1
            }
          }
        ]
      }
    ]
    sqlRoleDefinitions: [
      {
        // A user-friendly name for the Role Definition. Must be unique for the database account.
        roleName: 'testReadWriteRole'
        // A set of fully qualified Scopes at or below which Role Assignments may be created using this Role Definition. This will allow application of this Role Definition on the entire database account or any underlying Database / Collection.
        // Must have at least one element.
        assignableScopes: [
          '/' // This role definition can be assigned at the database account level
        ]
        // The set of operations allowed through this Role Definition.
        permissions: [
          {
            dataActions: [
              'Microsoft.DocumentDB/databaseAccounts/readMetadata'
              'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*'
              'Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*'
            ]
          }
        ]
      }
    ]
    sqlRoleAssignments: [
      {
        principalId: dependencies.outputs.identityPrincipalIds[0]
        roleDefinitionId: '00000000-0000-0000-0000-000000000001'
        scope: '/'
      }
      {
        principalId: dependencies.outputs.identityPrincipalIds[1]
        roleDefinitionId: '00000000-0000-0000-0000-000000000002'
        scope: '/dbs/testdb1'
      }
    ]
  }
}

output cosmosDbResourceId string = cosmosDb.outputs.id
output sqlRoleDefinitionIds array = cosmosDb.outputs.sqlRoleDefinitionIds
```