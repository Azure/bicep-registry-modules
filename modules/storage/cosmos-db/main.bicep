@description('The bakend API type of Cosmos DB database account. The API selection cannot be changed after account creation. Possible values: "cassandra", "gremlin", "mongodb", "sql", "table".')
@allowed([ 'cassandra', 'gremlin', 'mongodb', 'sql', 'table' ])
param backendApi string = 'sql'

@description('The name of the Cosmos DB account. Character limit: 3-44, valid characters: lowercase letters, numbers, and hyphens. It must me unique across Azure.')
@maxLength(44)
@minLength(3)
param name string = uniqueString(resourceGroup().id, resourceGroup().location, 'cosmosdb', backendApi)

@description('Enables automatic failover of the write region in the rare event that the region is unavailable due to an outage. Automatic failover will result in a new write region for the account and is chosen based on the failover priorities configured for the account.')
param enableAutomaticFailover bool = true

@description('Multi-region writes capability allows you to take advantage of the provisioned throughput for your databases and containers across the globe.')
param enableMultipleWriteLocations bool = true

@description('Enable Serverless for consumption-based usage.')
param enableServerless bool = false

@description('Flag to indicate whether Free Tier is enabled, up to one account per subscription is allowed.')
param enableFreeTier bool = false

@description('The total throughput limit of the Cosmos DB account in measurement of requests units (RUs) per second, -1 indicates no limits on provisioning of throughput.')
@minValue(-1)
param totalThroughputLimit int = -1

@minLength(1)
@description('''
The array of secondary locations.
Each element defines a region of georeplication. The first element in this array is the primary region which is a write region of the Cosmos DB account.
The order of regions in this list is the order for region failover.
''')
param locations {
  @description('The name of the Azure region.')
  name: string
  @description('Flag to indicate whether or not this region is an AvailabilityZone region')
  isZoneRedundant: bool?
}[]

var primaryLocation = locations[0].name

@description('MongoDB server version. Required for mongodb API type Cosmos DB account')
@allowed([ '3.2', '3.6', '4.0', '4.2' ])
param MongoDBServerVersion string = '4.2'

type corsType = {
  @description('The origin domains that are permitted to make a request against the service via CORS.')
  allowedOrigins: string
  @description('The methods (HTTP request verbs) that the origin domain may use for a CORS request. (comma separated)')
  allowedMethods: string?
  @description('The response headers that should be sent back to the client for CORS requests. (comma separated)')
  allowedHeaders: string?
  @description('The response headers that should be exposed to the client for CORS requests. (comma separated)')
  exposedHeaders: string?
  @description('The maximum amount time that a browser should cache the preflight OPTIONS request.')
  maxAgeInSeconds: int?
}

@description('List of CORS rules. Each CORS rule allows or denies requests from a set of origins to a Cosmos DB account or a database')
param cors corsType[] = []

@description('The mode of the Cosmos Account creation. Set to Restore to restore from an existing account.')
@allowed([ 'Default', 'Restore' ])
param createMode string = 'Default'

@description('Disable write operations on metadata resources (databases, containers, throughput) via account keys.')
param disableKeyBasedMetadataWriteAccess bool = false

@description('Whether requests from public network allowed.')
param enablePublicNetworkAccess bool = true

@allowed([ 'AzureServices', 'None' ])
@description('Indicates what services are allowed to bypass firewall checks.')
param networkAclBypass string = 'AzureServices'

@description('''
List of IpRules to be allowed.
Each element in this array is either a single IPv4 address or a single IPv4 address range in CIDR format.
''')
param ipRules string[] = []

@description('The list of virtual network ACL rules.')
param virtualNetworkRules {
  @description('The id of the subnet. For example: /subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}.')
  id: string
  @description('Whether to ignore missing virtual network service endpoint.')
  ignoreMissingVNetServiceEndpoint: bool?
}[] = []

@description('An array that contains the Resource Ids for Network Acl Bypass.')
param networkAclBypassResourceIds string[] = []

@description('Extra capabilities besides the ones required by param.backendApi and param.enableServerless.')
param extraCapabilities string[] = []

@description('Opt-out of local authentication and ensure only MSI and AAD can be used exclusively for authentication.')
param disableLocalAuth bool = false

@description('Flag to indicate whether to enable storage analytics.')
param enableAnalyticalStorage bool = false

@description('The type of schema for analytical storage.')
@allowed([ 'FullFidelity', 'WellDefined' ])
param analyticalStorageSchemaType string = 'WellDefined'

@description('Schema of the Cosmos DB Cassandra table.')
type schema = {
  @description('List of Cassandra table columns.')
  columns: {
    name: string
    type: string
  }[]?
  @description('List of Cassandra table partition keys.')
  partitionKeys: {
    name: string
  }[]?
  @description('List of Cassandra table cluster keys.')
  clusterKeys: {
    name: string
    orderBy: string
  }[]?
}

@description('Performance configurations.')
type performanceConfig = {
  @description('Flag to enable/disable automatic throughput scaling.')
  enableAutoScale: bool
  @maxValue(100000)
  @minValue(400)
  @description('''
  When enableAutoScale is set to true, this parameter is the static throughput capability  expressed in units of 100 requests per second. 400 RU/s is the minimum for production workloads. It ranges from 400 to 100,000 inclusive.
  When enableAutoScale is set to false, this parameter is the maximum of the autoscaled throughput capability. It would scale down to a minimum of 10% of this max throughput based on usage. It ranges from 4000 to 100,000 inclusive.
  ''')
  throughput: int
}

@description('Cassandra table configurations.')
type cassandraTable = {
  @description('Performance configuration.')
  performance: performanceConfig
  @description('Default time to live (TTL) in seconds.')
  defaultTtl: int?
  @description('The analytical storage TTL in seconds.')
  analyticalStorageTtl: int?
  @description('The schema of the Cassandra table.')
  schema: schema?
  @description('Tags for the Cassandra table.')
  tags: { *: string }
}

@description('Cassandra keyspaces configurations.')
type cassandrakeyspace = {
  @description('Throughtput configuration.')
  performance: performanceConfig
  @description('''
  The object of Cassandra table configurations.
  The key of each element is the name of the  table.
  The value of each element is an configuration object.''')
  tables: { *: cassandraTable }
  @description('Tags for the Cassandra keyspace.')
  tags: { *: string }
}

@description('''
The object of Cassandra keyspaces configurations.
The key of each element is the name of the Cassandra keyspace.
The value of each element is an configuration object.
''')
param cassandraKeyspaces { *: cassandrakeyspace } = {}

@description('The type definition of sql container client encryption policy included paths.')
type sqlContainerClientEncryptionPolicyIncludedPathsType = {
  @description('The identifier of the Client Encryption Key to be used to encrypt the path.')
  clientEncryptionKeyId: string
  @description('The encryption algorithm which will be used. Eg - AEAD_AES_256_CBC_HMAC_SHA256.')
  encryptionAlgorithm: string
  @description('The type of encryption to be performed. Eg - Deterministic, Randomized.')
  encryptionType: string
  @description('Path that needs to be encrypted.')
  path: string
}

@description('Type definition of client encryption policy for the container.')
type sqlContainerClientEncryptionPolicyType = {
  @description('Paths of the item that need encryption along with path-specific settings.')
  includedPaths: sqlContainerClientEncryptionPolicyIncludedPathsType
  @description('Version of the client encryption policy definition. Supported versions are 1 and 2. Version 2 supports id and partition key path encryption.')
  policyFormatVersion: 1 | 2
}

type sqlContainerIndexingPolicyIncludedPathsIndexesType = {
  @description('The type of index.')
  kind: 'Hash' | 'Range' | 'Spatial'?
  @description('The precision of the index. -1 is maximum precision.')
  precision: int?
  @description('The datatype for which the indexing behavior is applied to.')
  dataType: 'String' | 'Number' | 'Point' | 'Polygon' | 'LineString' | 'MultiPolygon'?
}

@description('Type definition of container indexing policy\'s included paths.')
type sqlContainerIndexingPolicyIncludedPathsType = {
  @description('The path for which the indexing behavior applies to. Index paths typically start with root and end with wildcard (/path/*).')
  path: string?
  @description('List of indexes for this path.')
  indexes: sqlContainerIndexingPolicyIncludedPathsIndexesType[]?
}

@description('Type definition of container indexing policy\'s composite indexes.')
type sqlContainerIndexingPolicyCompositeIndexesType = {
  @description('The path for which the indexing behavior applies to. Index paths typically start with root and end with wildcard (/path/*).')
  path: string?
  @description('The sort order for composite paths.')
  order: 'ascending' | 'descending'?
}

@description('Type definition of container indexing policy\'s spatial indexes.')
type sqlContainerIndexingPolicySpatialIndexesType = {
  @description('The path for which the indexing behavior applies to. Index paths typically start with root and end with wildcard (/path/*).')
  path: string?
  @description('The spatial type')
  types: 'Point' | 'Polygon' | 'LineString' | 'MultiPolygon'?
}

type graphIndexingPolicyTypeForSqlContainerAndGremlinGraph = {
  @description('The indexing mode.')
  indexingMode: 'consistent' | 'lazy' | 'none'?
  @description('Indicates if the indexing policy is automatic.')
  automatic: bool?
  @description('The indexing paths')
  includedPaths: sqlContainerIndexingPolicyIncludedPathsType[]?
  @description('List of paths to exclude from indexing.')
  excludedPaths: {
    @description('The path for which the indexing behavior applies to. Index paths typically start with root and end with wildcard (/path/*).')
    path: string?
  }[]?
  @description('List of composite path list.')
  compositeIndexes: sqlContainerIndexingPolicyCompositeIndexesType[]?
  @description('The spatial indexes')
  spatialIndexes: sqlContainerIndexingPolicySpatialIndexesType[]?
}

@description('The type definition of SQL database container conflict resolution policy.')
type conflictResolutionPolicyTypeForSqlContainerAndGremlinGraph = {
  @description('The conflict resolution path in the container.')
  conflictResolutionPath: string?
  @description('The conflict resolution procedure in the container.')
  conflictResolutionProcedure: string?
  @description('The conflict resolution mode.')
  mode: 'Custom' | 'LastWriterWins'?
}

@description('The type definition of SQL database container partition key.')
type partitionKeyTypeForSqlContainerAndGremlinGraph = {
  @description('Indicates the kind of algorithm used for partitioning. For MultiHash, multiple partition keys (upto three maximum) are supported for container create')
  kind: 'Hash' | 'MultiHash' | 'Range'?
  @description('List of paths using which data within the container can be partitioned.')
  paths: string[]?
  @description('Indicates the version of the partition key definition.')
  version: int?
}

@description('The type definition of SQL database container unique key policy.')
type graphUniqueKeyPolicyTypeForSqlContainerAndGremlinGraph = {
  @description('List of unique keys.')
  uniqueKeys: {
    @description('List of paths must be unique for each document in the Azure Cosmos DB service.')
    paths: string[]?
  }[]?
}

@description('The type definition of SQL database container stored procedures.')
type sqlContainerStoredProceduresType = {
  @description('The body of the stored procedure.')
  body: string?
  @description('Performance configs.')
  performance: performanceConfig?
}

@description('The type definition of SQL database container user defined functions.')
type sqlContainerUserDefinedFunctionsType = {
  @description('The body of the user defined functions.')
  body: string?
  @description('Performance configs.')
  performance: performanceConfig?
}

@description('The type definition of SQL database container triggers.')
type sqlContainerTriggersType = {
  @description('The body of the triggers.')
  body: string?
  @description('Performance configs.')
  performance: performanceConfig?
  @description('Type of the Trigger')
  triggerType: 'Pre' | 'Post'?
  @description('The operation the trigger is associated with.')
  triggerOperation: ('Create' | 'Delete' | 'Replace' | 'Update')[]?
}

@description('The type definition of SQL database container.')
type sqlContainerType = {
  @description('The analytical storage TTL in seconds.')
  analyticalStorageTtl: int?
  @description('Default time to live (TTL) in seconds.')
  defaultTtl: int?
  @description('The client encryption policy for the container.')
  clientEncryptionPolicy: sqlContainerClientEncryptionPolicyType?
  @description('The conflict resolution policy for the container.')
  conflictResolutionPolicy: conflictResolutionPolicyTypeForSqlContainerAndGremlinGraph?
  @description('The indexing policy for the container. The configuration of the indexing policy. By default, the indexing is automatic for all document paths within the container.')
  indexingPolicy: graphIndexingPolicyTypeForSqlContainerAndGremlinGraph?
  @description('The configuration of the partition key to be used for partitioning data into multiple partitions.')
  partitionKey: partitionKeyTypeForSqlContainerAndGremlinGraph?
  @description('The unique key policy configuration for specifying uniqueness constraints on documents in the collection in the Azure Cosmos DB service.')
  uniqueKeyPolicy: graphUniqueKeyPolicyTypeForSqlContainerAndGremlinGraph?
  @description('Configuration of stored procedures in the container.')
  storedProcedures: { *: sqlContainerStoredProceduresType }?
  @description('Configuration of user defined functions in the container.')
  userDefinedFunctions: { *: sqlContainerUserDefinedFunctionsType }?
  @description('Configuration of triggers in the container.')
  triggers: { *: sqlContainerTriggersType }?
}

@description('The type definition of SQL database configuration.')
type sqlDatabasetype = {
  @description('Performance configs.')
  performance: performanceConfig

  @description('sql Container configurations.')
  containers: { *: sqlContainerType }?

  @description('Tags for the SQL database.')
  tags: { *: string }
}

@description('''
The object of sql database configurations.
The key of each element is the name of the sql database.
The value of each element is an configuration object.
''')
param sqlDatabases { *: sqlDatabasetype } = {}

@description('The type of identity used for the Cosmos DB account. The type "SystemAssigned, UserAssigned" includes both an implicitly created identity and a set of user-assigned identities. The type "None" will remove any identities from the Cosmos DB account.')
@allowed([ 'None', 'SystemAssigned', 'SystemAssigned,UserAssigned', 'UserAssigned' ])
param identityType string = 'None'

@description('The list of user-assigned managed identities. The user identity dictionary key references will be ARM resource ids in the form: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}"')
param userAssignedIdentities string[] = []

@description('List of key-value pairs that describe the resource.')
param tags { *: string } = {}

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Specify the type of lock on Cosmos DB account resource.')
param lock string = 'NotSpecified'

type consistencyPolicyType = {
  @description('The default consistency level and configuration settings of the Cosmos DB account.')
  defaultConsistencyLevel: 'Eventual' | 'ConsistentPrefix' | 'Session' | 'BoundedStaleness' | 'Strong'
  @description('''
  When used with the Bounded Staleness consistency level, this value represents the time amount of staleness (in seconds) tolerated.
  Required only when defaultConsistencyPolicy is set to 'BoundedStaleness'.
  Valid ranges:
  - Single Region: 10 to 2147483647
  - Multi Region: 100000 to 2147483647.
  ''')
  @minValue(10)
  @maxValue(2147483647)
  maxStalenessPrefix: int?
  @description('''
  When used with the Bounded Staleness consistency level, this value represents the number of stale requests tolerated.
  Required only when defaultConsistencyPolicy is set to 'BoundedStaleness'.
  Valid ranges:
  - Single Region: 5 to 84600.
  - Multi Region: 300 to 86400.
  ''')
  @minValue(5)
  @maxValue(86400)
  maxIntervalInSeconds: int?
}

@description('The consistency policy for the Cosmos DB account.')
param consistencyPolicy consistencyPolicyType = {
  defaultConsistencyLevel: 'Session'
}

var locationsWithCompleteInfo = [for (location, i) in locations: {
  locationName: location.name
  failoverPriority: i
  isZoneRedundant: location.?isZoneRedundant
}]

var capabilityNeededForBackendApi = {
  cassandra: 'EnableCassandra'
  gremlin: 'EnableGremlin'
  mongodb: 'EnableMongo'
  table: 'EnableTable'
  sql: ''
}

var capabilitiesCompleteList = [for capability in union(
  extraCapabilities,
  enableServerless ? [ 'EnableServerless' ] : [],
  [ capabilityNeededForBackendApi[backendApi] ]
): { name: capability }]

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: toLower(name)
  location: primaryLocation
  kind: (backendApi == 'mongodb') ? 'MongoDB' : 'GlobalDocumentDB'
  properties: {
    analyticalStorageConfiguration: enableAnalyticalStorage ? { schemaType: analyticalStorageSchemaType } : null
    apiProperties: (backendApi == 'mongodb') ? { serverVersion: MongoDBServerVersion } : null
    capabilities: capabilitiesCompleteList
    capacity: enableServerless ? null : { totalThroughputLimit: totalThroughputLimit }
    consistencyPolicy: consistencyPolicy
    cors: cors
    createMode: createMode
    databaseAccountOfferType: 'Standard'
    disableKeyBasedMetadataWriteAccess: disableKeyBasedMetadataWriteAccess
    disableLocalAuth: disableLocalAuth
    enableAnalyticalStorage: enableAnalyticalStorage
    enableAutomaticFailover: enableAutomaticFailover
    enableFreeTier: enableFreeTier
    enableMultipleWriteLocations: enableServerless ? false : enableMultipleWriteLocations
    ipRules: [for ipRule in ipRules: { ipAddressOrRange: ipRule }]
    locations: enableServerless ? [ locationsWithCompleteInfo[0] ] : locationsWithCompleteInfo
    networkAclBypass: networkAclBypass
    networkAclBypassResourceIds: networkAclBypassResourceIds
    publicNetworkAccess: enablePublicNetworkAccess ? 'Enabled' : 'Disabled'
    isVirtualNetworkFilterEnabled: length(virtualNetworkRules) > 0
    virtualNetworkRules: virtualNetworkRules
  }
  identity: {
    type: identityType
    userAssignedIdentities: contains(identityType, 'UserAssigned') ? toObject(userAssignedIdentities, id => id, id => {}) : null
  }
  tags: tags
}

@batchSize(1)
module cosmosDBAccount_cassandraKeyspaces 'modules/cassandra.bicep' = [for keyspace in items(cassandraKeyspaces): if (backendApi == 'cassandra') {
  dependsOn: [ cosmosDBAccount ]

  name: keyspace.key
  params: {
    cosmosDBAccountName: name
    keyspace: keyspace
    enableServerless: enableServerless
  }
}]

@batchSize(1)
module cosmosDBAccount_sqlDatabases 'modules/sql.bicep' = [for sql in items(sqlDatabases): if (backendApi == 'sql') {
  dependsOn: [ cosmosDBAccount ]

  name: sql.key
  params: {
    cosmosDBAccountName: name
    database: sql.value
    enableServerless: enableServerless
  }
}]

type mongodbDatabaseIndexOptionsType = {
  @description('Expire after seconds.')
  expireAfterSeconds: int?
  @description('Is it unique or not.')
  unique: bool?
}

type mongodbDatabaseIndexType = {
  @description('Cosmos DB MongoDB collection index keys.')
  key: {
    @description('List of keys for the MongoDB collection.')
    keys: string[]?
  }?
  @description('Cosmos DB MongoDB collection index key options.')
  options: mongodbDatabaseIndexOptionsType
}

type mongodbDatabaseCollectionType = {
  indexes: mongodbDatabaseIndexType[]?
  @description('A key-value pair of shard keys to be applied for the request.')
  shardKey: { *: string }?
}

type mongodbDatabaseType = {
  @description('Performance configs.')
  performance: performanceConfig
  @description('The analytical storage TTL in seconds.')
  analyticalStorageTtl: int?
  collections: { *: mongodbDatabaseCollectionType }?

}

@description('The list of MongoDB databases configurations with collections, its indexes, Shard Keys.')
param mongodbDatabases { *: mongodbDatabaseType } = {}

@batchSize(1)
module cosmosDBAccount_mongodbDatabases 'modules/mongodb.bicep' = [for database in items(mongodbDatabases): if (backendApi == 'mongodb') {
  dependsOn: [ cosmosDBAccount ]

  name: database.key
  params: {
    cosmosDBAccountName: name
    database: database
    enableServerless: enableServerless
  }
}]

type tableType = {
  @description('Performance configs.')
  performance: performanceConfig
}

@description('The object of Table databases configurations.')
param tables { *: tableType } = {}

@batchSize(1)
module cosmosDBAccount_tables 'modules/table.bicep' = [for table in items(tables): if (backendApi == 'table') {
  name: table.key
  dependsOn: [ cosmosDBAccount ]
  params: {
    cosmosDBAccountName: name
    table: table
    enableServerless: enableServerless
  }
}]

type gremlinGraphType = {
  @description('Performance configs.')
  performance: performanceConfig
  @description('The analytical storage TTL in seconds.')
  analyticalStorageTtl: int?
  @description('The default time to live in seconds.')
  defaultTtl: int?
  @description('The conflict resolution policy for the graph.')
  conflictResolutionPolicy: conflictResolutionPolicyTypeForSqlContainerAndGremlinGraph?
  @description('The configuration of the indexing policy. By default, the indexing is automatic for all document paths within the graph.')
  indexingPolicy: graphIndexingPolicyTypeForSqlContainerAndGremlinGraph?
  @description('The configuration of the partition key to be used for partitioning data into multiple partitions.')
  partitionKey: partitionKeyTypeForSqlContainerAndGremlinGraph?
  @description('The unique key policy configuration for specifying uniqueness constraints on documents in the collection in the Azure Cosmos DB service.')
  uniqueKeyPolicy: graphUniqueKeyPolicyTypeForSqlContainerAndGremlinGraph?
}

type gremlinDatabaseType = {
  @description('Performance configs.')
  performance: performanceConfig
  tags: { *: string }?
  @description('The object of Gremlin database graphs.')
  graphs: { *: gremlinGraphType }?
}

@description('The list of Gremlin databases configurations with graphs.')
param gremlinDatabases { *: gremlinDatabaseType } = {}

@batchSize(1)
module cosmosDBAccount_gremlinDatabases 'modules/gremlin.bicep' = [for database in items(gremlinDatabases): if (backendApi == 'gremlin') {
  name: database.key
  dependsOn: [ cosmosDBAccount ]
  params: {
    cosmosDBAccountName: name
    database: database
    enableServerless: enableServerless
  }
}]

@description('Type definition for the SQL Role Definition Permission.')
type sqlRoleDefinitionPermissionType = {
  @description('The set of permissions that the role definition contains.')
  actions: string[]?
  @description('The set of Data Actions that the role definition contains.')
  dataActions: string[]?
}

type sqlRoleAssignmentType = {
  @description('The principal ID of the assigment.')
  principalId: string
  @description('''
  The scope of the assignment. It can be the entire cosmosDB account, or a specific database or container.
  If omitted, it means the entire cosmosDB account.
  ''')
  scope: string?
}

type sqlRoleDefinitionType = {
  @description('''
  Indicates whether the Role Definition was built-in or user created.
  If type=BuiltInRole, the name of this role should be a Azure built-in role name, like Contributor, Reader, etc, and permissions should be null or omitted.
  ''')
  roleType: 'BuiltInRole' | 'CustomRole'
  permissions: sqlRoleDefinitionPermissionType[]?
  @description('The list of SQL role assignments.')
  assisgnments: sqlRoleAssignmentType[]?
}

@description('''
The list of SQL role definitions.
The keys are the role name.
The values are the role definition.''')
param sqlRoleDefinitions { *: sqlRoleDefinitionType } = {}

module cosmosDBAccount_sqlRoles 'modules/sql_roles.bicep' = [for role in items(sqlRoleDefinitions): {
  name: role.key
  dependsOn: [ cosmosDBAccount ]
  params: {
    cosmosDBAccountName: name
    role: role
  }
}]

type privateEndpointType = {
  subnetId: string
  groupId: string
  privateDnsZoneId: string?
  isManualApproval: bool?
}

@description('Private Endpoints that should be created for Azure Cosmos DB account.')
param privateEndpoints { *: privateEndpointType } = {}

var privateEndpointsWithDefaults = [for endpoint in items(privateEndpoints): {
  name: '${cosmosDBAccount.name}-${endpoint.key}'
  groupIds: [ endpoint.value.groupId ]
  subnetId: endpoint.value.subnetId
  privateDnsZoneId: endpoint.value.privateDnsZoneId
  manualApprovalEnabled: endpoint.value.isManualApproval ?? false
}]


module cosmosDBAccount_privateEndpoints 'modules/privateEndpoint.bicep' = [for endpoint in privateEndpointsWithDefaults: {
  name: endpoint.name
  params: {
    cosmosDBAccount: cosmosDBAccount
    location:primaryLocation
    endpoint: endpoint
  }
}]



resource cosmosDBAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (lock != 'NotSpecified') {
  name: '${cosmosDBAccount.name}-${toLower(lock)}-lock'
  scope: cosmosDBAccount
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
}

@description('Cosmos DB Account Resource ID')
output id string = cosmosDBAccount.id

@description('Cosmos DB Account Resource Name')
output name string = cosmosDBAccount.name

@description('Object Id of system assigned managed identity for Cosmos DB account (if enabled).')
output systemAssignedIdentityPrincipalId string = contains(identityType, 'SystemAssigned') ? cosmosDBAccount.identity.principalId : ''

@description('Resource Ids of sql role definition resources created for this Cosmos DB account.')
output sqlRoleDefinitionIds array = [for (role, i) in items(sqlRoleDefinitions): cosmosDBAccount_sqlRoles[i].outputs.roleDefinitionId]
