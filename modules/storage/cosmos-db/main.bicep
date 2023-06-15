@description('The bakend API type of Cosmos DB database account. The API selection cannot be changed after account creation. Possible values: "cassandra", "gremlin", "mongodb", "sql", "table".')
@allowed([ 'cassandra', 'gremlin', 'mongodb', 'sql', 'table' ])
param backendApi string = 'sql'

@description('Prefix of Cosmos DB Resource Name. Not used if name is provided.')
param prefix string = { cassandra: 'coscas', gremlin: 'cosgrm', mongodb: 'cosmon', sql: 'cosmos', table: 'costab' }[backendApi]

@description('The name of the Cosmos DB account. Character limit: 3-44, valid characters: lowercase letters, numbers, and hyphens. It must me unique across Azure.')
@maxLength(44)
@minLength(3)
param name string = '${prefix}-${uniqueString(resourceGroup().id, resourceGroup().location, 'cosmosdb', backendApi)}'

@description('''
The primary location of the Cosmos DB account. Default is the location of the resource group.
This would be the write region if param.additionalLocations contains more regions for georeplication.
''')
param location string = resourceGroup().location

@description('''
Indicate whether or not to enable zone redundancy for region specified by param.location. It must be an AvailabilityZone region.
To enable this feature for other regions, please enable parameter isZoneRedundant in param.additionalLocations.
''')
param isZoneRedundant bool = false

@description('Enables automatic failover of the write region in the rare event that the region is unavailable due to an outage. Automatic failover will result in a new write region for the account and is chosen based on the failover priorities configured for the account.')
param enableAutomaticFailover bool = true

@description('''
Enables the account to write in multiple locations. Once enabled, all regions included in the param.locations will be read/write regions.
Multi-region writes capability allows you to take advantage of the provisioned throughput for your databases and containers across the globe.''')
param enableMultipleWriteLocations bool = true

@description('Enable Serverless for consumption-based usage.')
param enableServerless bool = false

@description('Flag to indicate whether Free Tier is enabled, up to one account per subscription is allowed.')
param enableFreeTier bool = false

@description('The total throughput limit of the Cosmos DB account in measurement of requests units (RUs) per second, -1 indicates no limits on provisioning of throughput.')
@minValue(-1)
param totalThroughputLimit int = -1

@description('''
The array of geo locations that Cosmos DB account would be hosted in.
Each element defines a region of georeplication.
The order of regions in this list is the order for region failover. The first element is the primary region which is a write region of the Cosmos DB account.
''')
param additionalLocations locationType[] = []

@description('MongoDB server version. Required for mongodb API type Cosmos DB account')
@allowed([ '3.2', '3.6', '4.0', '4.2' ])
param mongoDBServerVersion string = '4.2'

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

@description('The list of virtual network ACL rules. Subnets in this list will be allowed to connect.')
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

@description('The array of Cassandra keyspaces configurations.')
param cassandraKeyspaces cassandraKeyspaceType[] = []

@description('The object of sql database configurations.')
param sqlDatabases sqlDatabaseType[] = []

@description('The list of MongoDB databases configurations.')
param mongodbDatabases mongodbDatabaseType[] = []

@description('The object of Table databases configurations.')
param tables tableType[] = []

@description('The list of Gremlin databases configurations.')
param gremlinDatabases gremlinDatabaseType[] = []

@description('The list of SQL role definitions. Only valid when param.backendApi is set to "Sql".')
param sqlCustomRoleDefinitions sqlCustomRoleDefinitionType[] = []

@description('The list of SQL built-in role assignments. Only valid when param.backendApi is set to "Sql".')
param sqlBuiltinRoleAssignments sqlBuiltinRoleAsignmentType[] = []

@description('The list of role assignments for the Cosmos DB account.')
param roleAssignments roleAssignmentType[] = []

@description('The type of identity used for the Cosmos DB account. The type "SystemAssigned, UserAssigned" includes both an implicitly created identity and a set of user-assigned identities. The type "None" will remove any identities from the Cosmos DB account.')
@allowed([ 'None', 'SystemAssigned', 'SystemAssigned,UserAssigned', 'UserAssigned' ])
param identityType string = 'None'

@description('The list of user-assigned managed identities. The user identity dictionary key references will be ARM resource ids in the form: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}"')
param userAssignedIdentities string[] = []

@description('A object of key-value pairs that describe the resource.')
param tags { *: string } = {}

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Specify the type of lock on Cosmos DB account resource.')
param lock string = 'NotSpecified'

@description('The consistency policy for the Cosmos DB account.')
param consistencyPolicy consistencyPolicyType = {
  defaultConsistencyLevel: 'Session'
}

@description('Private Endpoints that should be created for Azure Cosmos DB account.')
param privateEndpoints privateEndpointType[] = []

@allowed([ 'Tls', 'Tls11', 'Tls12' ])
@description('The minimum TLS version to support on this account.')
param minimalTlsVersion string = 'Tls12'

@description('Flag to indicate enabling/disabling of Partition Merge feature on the account.')
param enablePartitionMerge bool = false

@description('Flag to indicate enabling/disabling of Partition Split feature on the account.')
param enablePartitionKeyMonitor bool = true

var allLocations = [for (location, i) in union([ { name: location, isZoneRedundant: isZoneRedundant } ], additionalLocations): {
  locationName: location.name
  failoverPriority: i
  isZoneRedundant: location.?isZoneRedundant ?? false
}]

var capabilityNeededForBackendApi = {
  cassandra: [ 'EnableCassandra' ]
  gremlin: [ 'EnableGremlin' ]
  mongodb: [ 'EnableMongo' ]
  table: [ 'EnableTable' ]
  sql: []
}

var capabilities = [for capability in union(
  extraCapabilities,
  enableServerless ? [ 'EnableServerless' ] : [],
  capabilityNeededForBackendApi[backendApi]
): { name: capability }]

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2023-04-15' = {
  name: toLower(name)
  location: location
  kind: (backendApi == 'mongodb') ? 'MongoDB' : 'GlobalDocumentDB'
  properties: {
    analyticalStorageConfiguration: enableAnalyticalStorage ? { schemaType: analyticalStorageSchemaType } : null
    apiProperties: (backendApi == 'mongodb') ? { serverVersion: mongoDBServerVersion } : null
    capabilities: capabilities
    capacity: enableServerless ? null : { totalThroughputLimit: totalThroughputLimit }
    consistencyPolicy: consistencyPolicy
    cors: cors
    createMode: createMode
    databaseAccountOfferType: 'Standard'
    disableKeyBasedMetadataWriteAccess: disableKeyBasedMetadataWriteAccess
    disableLocalAuth: backendApi == 'sql' ? disableLocalAuth : any(null)
    enableAnalyticalStorage: enableAnalyticalStorage
    enableAutomaticFailover: enableAutomaticFailover
    enableFreeTier: enableFreeTier
    enableMultipleWriteLocations: enableServerless ? false : enableMultipleWriteLocations
    enablePartitionMerge: enablePartitionMerge
    enablePartitionKeyMonitor: enablePartitionKeyMonitor
    ipRules: [for ipRule in ipRules: { ipAddressOrRange: ipRule }]
    isVirtualNetworkFilterEnabled: length(virtualNetworkRules) > 0
    locations: enableServerless ? [ allLocations[0] ] : allLocations
    minimalTlsVersion: minimalTlsVersion
    networkAclBypass: networkAclBypass
    networkAclBypassResourceIds: networkAclBypassResourceIds
    publicNetworkAccess: enablePublicNetworkAccess ? 'Enabled' : 'Disabled'
    virtualNetworkRules: virtualNetworkRules
  }
  identity: {
    type: identityType
    userAssignedIdentities: contains(identityType, 'UserAssigned') ? toObject(userAssignedIdentities, id => id, id => {}) : null
  }
  tags: tags
}

module cosmosDBAccount_cassandraKeyspaces 'modules/cassandra.bicep' = [for keyspace in cassandraKeyspaces: if (backendApi == 'cassandra') {
  name: uniqueString(cosmosDBAccount.id, keyspace.name)
  params: {
    cosmosDBAccountName: name
    keyspace: keyspace
    enableServerless: enableServerless
  }
}]

module cosmosDBAccount_sqlDatabases 'modules/sql.bicep' = [for sql in sqlDatabases: if (backendApi == 'sql') {
  name: uniqueString(cosmosDBAccount.id, sql.name)
  params: {
    cosmosDBAccountName: name
    database: sql
    enableServerless: enableServerless
  }
}]

module cosmosDBAccount_mongodbDatabases 'modules/mongodb.bicep' = [for database in mongodbDatabases: if (backendApi == 'mongodb') {
  name: uniqueString(cosmosDBAccount.id, database.name)
  params: {
    cosmosDBAccountName: name
    database: database
    enableServerless: enableServerless
  }
}]

module cosmosDBAccount_tables 'modules/table.bicep' = [for table in tables: if (backendApi == 'table') {
  name: uniqueString(cosmosDBAccount.id, table.name)
  params: {
    cosmosDBAccountName: name
    table: table
    enableServerless: enableServerless
  }
}]

module cosmosDBAccount_gremlinDatabases 'modules/gremlin.bicep' = [for database in gremlinDatabases: if (backendApi == 'gremlin') {
  name: uniqueString(cosmosDBAccount.id, database.name)
  params: {
    cosmosDBAccountName: name
    database: database
    enableServerless: enableServerless
  }
}]

module cosmosDBAccount_sqlRoles 'modules/sql_custom_roles.bicep' = [for role in sqlCustomRoleDefinitions: if (backendApi == 'sql') {
  dependsOn: [ cosmosDBAccount_sqlDatabases ]
  name: uniqueString(cosmosDBAccount.id, role.name)
  params: {
    cosmosDBAccountName: name
    role: role
  }
}]

resource cosmosDBAccount_sqlBuiltinRoleAssignments 'Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments@2023-04-15' = [for assignment in sqlBuiltinRoleAssignments: if (backendApi == 'sql') {
  parent: cosmosDBAccount
  dependsOn: [ cosmosDBAccount_sqlDatabases ]

  name: guid(cosmosDBAccount.id, assignment.builtinRoleId, assignment.principalId)
  properties: {
    roleDefinitionId: resourceId('Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions', cosmosDBAccount.name, assignment.builtinRoleId)
    principalId: assignment.principalId
    scope: '${cosmosDBAccount.id}${assignment.?scope ?? ''}'
  }
}]

resource cosmosDBAccount_roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = [for assignment in roleAssignments: {
  name: guid(cosmosDBAccount.id, assignment.roleDefinitionId, assignment.principalId)
  scope: cosmosDBAccount
  properties: {
    roleDefinitionId: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', assignment.roleDefinitionId)
    principalId: assignment.principalId
    principalType: assignment.?principalType
    description: assignment.?description
    delegatedManagedIdentityResourceId: assignment.?delegatedManagedIdentityResourceId
  }
}]

module cosmosDBAccount_privateEndpoints 'modules/privateEndpoint.bicep' = [for endpoint in privateEndpoints: {
  name: uniqueString(cosmosDBAccount.id, endpoint.name)
  params: {
    cosmosDBAccountId: cosmosDBAccount.id
    location: location
    endpoint: endpoint
  }
}]

resource cosmosDBAccount_lock 'Microsoft.Authorization/locks@2020-05-01' = if (lock != 'NotSpecified') {
  name: uniqueString(cosmosDBAccount.id, lock)
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
output sqlRoleDefinitionIds array = [for (role, i) in sqlCustomRoleDefinitions: cosmosDBAccount_sqlRoles[i].outputs.roleDefinitionId]

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

@description('Schema of the Cosmos DB Cassandra table.')
type schemaType = {
  @description('List of Cassandra table columns.')
  columns: {
    name: string
    type: string
  }[]
  @description('List of Cassandra table partition keys.')
  partitionKeys: {
    name: string
  }[]
  @description('List of Cassandra table cluster keys.')
  clusterKeys: {
    name: string
    @description('Order of the Cosmos DB Cassandra table cluster key, only support "Asc" and "Desc"')
    orderBy: string
  }[]?
}

@description('Performance configurations.')
type performanceConfigType = {
  @description('Flag to enable/disable automatic throughput scaling.')
  enableAutoScale: bool
  @minValue(400)
  @description('''
  When enableAutoScale is set to false, this parameter is the static throughput capability. 400 RU/s is the minimum for production workloads and must be set in increments of 100. The maxium is 100,000 unless a higher limit is requested via Azure Support.
  When enableAutoScale is set to true, this parameter is the maximum of the autoscaled throughput capability. It would scale down to a minimum of 10% of this max throughput based on usage. It ranges from 1000 to 100,000 inclusive.
  ''')
  throughput: int
}

@description('Cassandra table configurations.')
type cassandraTableType = {
  @description('The name of the Cassandra table.')
  name: string
  @description('Performance configuration.')
  performance: performanceConfigType?
  @description('Default time to live (TTL) in seconds.')
  defaultTtl: int?
  @description('The schema of the Cassandra table.')
  schema: schemaType
  @description('Tags for the Cassandra table.')
  tags: { *: string }?
}

@description('Cassandra keyspaces configurations.')
type cassandraKeyspaceType = {
  @description('The name of the Cassandra keyspace.')
  name: string
  @description('Throughtput configuration.')
  performance: performanceConfigType?
  @description('The object of Cassandra table configurations.')
  tables: cassandraTableType[]?
  @description('Tags for the Cassandra keyspace.')
  tags: { *: string }?
}

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
  indexingMode: ('consistent' | 'lazy' | 'none')?
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
  @description('The name of the stored procedure.')
  name: string
  @description('The body of the stored procedure.')
  body: string?
  @description('Performance configs.')
  performance: performanceConfigType?
  @description('Tags for the resource.')
  tags: { *: string }?
}

@description('The type definition of SQL database container user defined functions.')
type sqlContainerUserDefinedFunctionsType = {
  @description('The name of the user defined function.')
  name: string
  @description('The body of the user defined functions.')
  body: string?
  @description('Performance configs.')
  performance: performanceConfigType?
  @description('Tags for the resource.')
  tags: { *: string }?
}

@description('The type definition of SQL database container triggers.')
type sqlContainerTriggersType = {
  @description('The name of the trigger.')
  name: string
  @description('The body of the triggers.')
  body: string?
  @description('Performance configs.')
  performance: performanceConfigType?
  @description('Type of the Trigger')
  triggerType: ('Pre' | 'Post')?
  @description('The operation the trigger is associated with.')
  triggerOperation: ('Create' | 'Delete' | 'Replace' | 'Update' | 'All')?
  @description('Tags for the resource.')
  tags: { *: string }?
}

@description('The type definition of SQL database container.')
type sqlContainerType = {
  @description('The name of the container.')
  name: string
  @description('Performance configs.')
  performance: performanceConfigType?
  @description('Default time to live (TTL) in seconds.')
  defaultTtl: int?
  @description('The conflict resolution policy for the container.')
  conflictResolutionPolicy: conflictResolutionPolicyTypeForSqlContainerAndGremlinGraph?
  @description('The indexing policy for the container. The configuration of the indexing policy. By default, the indexing is automatic for all document paths within the container.')
  indexingPolicy: graphIndexingPolicyTypeForSqlContainerAndGremlinGraph?
  @description('The configuration of the partition key to be used for partitioning data into multiple partitions.')
  partitionKey: partitionKeyTypeForSqlContainerAndGremlinGraph?
  @description('The unique key policy configuration for specifying uniqueness constraints on documents in the collection in the Azure Cosmos DB service.')
  uniqueKeyPolicy: graphUniqueKeyPolicyTypeForSqlContainerAndGremlinGraph?
  @description('Configuration of stored procedures in the container.')
  storedProcedures: sqlContainerStoredProceduresType[]?
  @description('Configuration of user defined functions in the container.')
  userDefinedFunctions: sqlContainerUserDefinedFunctionsType[]?
  @description('Configuration of triggers in the container.')
  triggers: sqlContainerTriggersType[]?
  @description('Tags for the resource.')
  tags: { *: string }?
}

@description('The type definition of SQL database configuration.')
type sqlDatabaseType = {
  @description('The name of the SQL database.')
  name: string
  @description('Performance configs.')
  performance: performanceConfigType?
  @description('sql Container configurations.')
  containers: sqlContainerType[]?
  @description('Tags for the SQL database.')
  tags: { *: string }?
}

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
  @description('Name of the collection.')
  name: string
  @description('Performance configs.')
  performance: performanceConfigType?
  @description('	List of index keys.')
  indexes: mongodbDatabaseIndexType[]?
  @description('A key-value pair of shard keys to be applied for the request.')
  shardKey: { *: string }?
  @description('Tags for the resource.')
  tags: { *: string }?
}

type mongodbDatabaseType = {
  @description('Name of the database.')
  name: string
  @description('Performance configs.')
  performance: performanceConfigType?
  collections: mongodbDatabaseCollectionType[]?
  @description('Tags for the resource.')
  tags: { *: string }?
}

type tableType = {
  @description('Name of the table.')
  name: string
  @description('Performance configs.')
  performance: performanceConfigType?
  @description('Tags for the resource.')
  tags: { *: string }?
}

type gremlinGraphType = {
  @description('Name fo the graph.')
  name: string
  @description('Performance configs.')
  performance: performanceConfigType?
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
  @description('Tags for the resource.')
  tags: { *: string }?
}

type gremlinDatabaseType = {
  @description('name of the database.')
  name: string
  @description('Performance configs.')
  performance: performanceConfigType?
  @description('Tags for the resource.')
  tags: { *: string }?
  @description('The object of Gremlin database graphs.')
  graphs: gremlinGraphType[]?
}

@description('Type definition for the SQL Role Definition Permission.')
type sqlRoleDefinitionPermissionType = {
  @description('The set of permissions that the role definition contains.')
  actions: string[]?
  @description('The set of Data Actions that the role definition contains.')
  dataActions: string[]?
}

type sqlCustomRoleAssignmentType = {
  @description('The principal ID of the assigment.')
  principalId: string
  @description('''
  The scope of the assignment. It can be the entire cosmosDB account, or a specific database or container.
  If omitted, it means the entire cosmosDB account.
  ''')
  scope: string?
}

type sqlBuiltinRoleAsignmentType = {
  @description('The principal ID of the assigment.')
  principalId: string
  @description('''
  The ID of the builtin role.
  See https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-setup-rbac#built-in-role-definitions for defail about the built-in roles.
  ''')
  builtinRoleId: '00000000-0000-0000-0000-000000000001' | '00000000-0000-0000-0000-000000000002'
  @description('''
  The scope of the assignment. It can be the entire cosmosDB account, or a specific database or container.
  If omitted, it means the entire cosmosDB account.
  ''')
  scope: string?
}

type sqlCustomRoleDefinitionType = {
  @description('The name of the SQL role definition.')
  name: string
  permissions: sqlRoleDefinitionPermissionType[]?
  @description('The list of SQL role assignments.')
  assisgnments: sqlCustomRoleAssignmentType[]?
}

type privateEndpointType = {
  @description('The name of the private endpoint.')
  name: string
  @description('The subnet that the private endpoint should be created in.')
  subnetId: string
  @description('The subresource name of the target Azure resource that private endpoint will connect to.')
  groupId: string
  @description('The ID of the private DNS zone in which private endpoint will register its private IP address.')
  privateDnsZoneId: string?
  @description('When set to true, users will need to manually approve the private endpoint connection request.')
  isManualApproval: bool?
  @description('Tags for the resource.')
  tags: { *: string }?
}

type locationType = {
  @description('The name of the Azure region.')
  name: string
  @description('Flag to indicate whether or not this region is an AvailabilityZone region')
  isZoneRedundant: bool?
}

type roleAssignmentType = {
  @description('The ID of the role definition.')
  roleDefinitionId: string
  @description('The ID of the principal to whom the role is assigned.')
  principalId: string
  @description('The type of principal to whom the role is assigned.')
  principalType: ('Device' | 'ForeignGroup' | 'Group' | 'ServicePrincipal' | 'User')?
  @description('The description of the role assignment.')
  description: string?
  @description('The ID of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}