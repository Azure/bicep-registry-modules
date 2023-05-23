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
The order of regions in this list is the order of regions to be used for failover.
Parameters:
- Name: name
  Description: The name of the Azure region.
- Name: isZoneRedundant
  Description: Flag to indicate whether or not this region is an AvailabilityZone region
''')
param locations {
  name: string
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

@description('''
The list of virtual network ACL rules.
parameters:
- Name: id
  Description: The id of the subnet. For example: /subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}.
- Name: ignoreMissingVNetServiceEndpoint
  Description: Whether to ignore missing virtual network service endpoint.
''')
param virtualNetworkRules {
  id: string
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

@description('Type definition of client encryption policy for the container.')
type ClientEncryptionPolicyType = {
  @description('Paths of the item that need encryption along with path-specific settings.')
  includedPaths: {
    @description('The identifier of the Client Encryption Key to be used to encrypt the path.')
    clientEncryptionKeyId: string
    @description('The encryption algorithm which will be used. Eg - AEAD_AES_256_CBC_HMAC_SHA256.')
    encryptionAlgorithm: string
    @description('The type of encryption to be performed. Eg - Deterministic, Randomized.')
    encryptionType: string
    @description('Path that needs to be encrypted.')
    path: string
  }
  @description('Version of the client encryption policy definition. Supported versions are 1 and 2. Version 2 supports id and partition key path encryption.')
  policyFormatVersion: 1 | 2
}

type sqlDatabaseContainerIndexingPolicyType = {
  @description('The indexing mode.')
  indexingMode: 'consistent' | 'lazy' | 'none'?
  @description('Indicates if the indexing policy is automatic.')
  automatic: bool?
  @description('The indexing paths')
  includedPaths: {
    @description('The path for which the indexing behavior applies to. Index paths typically start with root and end with wildcard (/path/*).')
    path: string?
    @description('List of indexes for this path.')
    indexes: {
      @description('The type of index.')
      kind: 'Hash' | 'Range' | 'Spatial'?
      @description('The precision of the index. -1 is maximum precision.')
      precision: int?
      @description('The datatype for which the indexing behavior is applied to.')
      dataType: 'String' | 'Number' | 'Point' | 'Polygon' | 'LineString' | 'MultiPolygon'?
    }[]?
  }[]?
  @description('List of paths to exclude from indexing.')
  excludedPaths: {
    @description('The path for which the indexing behavior applies to. Index paths typically start with root and end with wildcard (/path/*).')
    path: string?
  }[]?
  @description('List of composite path list.')
  compositeIndexes: {
    @description('The path for which the indexing behavior applies to. Index paths typically start with root and end with wildcard (/path/*).')
    path: string?
    @description('The sort order for composite paths.')
    order: 'ascending' | 'descending'?
  }[]?
  @description('The spatial indexes')
  spatialIndexes: {
    @description('The path for which the indexing behavior applies to. Index paths typically start with root and end with wildcard (/path/*).')
    path: string?
    @description('The spatial type')
    types: 'Point' | 'Polygon' | 'LineString' | 'MultiPolygon'?
  }[]?
}

@description('The type definition of SQL database container.')
type sqlContainerType = {
  @description('The analytical storage TTL in seconds.')
  analyticalStorageTtl: int?
  @description('Default time to live (TTL) in seconds.')
  defaultTtl: int?
  @description('The client encryption policy for the container.')
  clientEncryptionPolicy: ClientEncryptionPolicyType?
  @description('The conflict resolution policy for the container.')
  conflictResolutionPolicy: {
    @description('The conflict resolution path in the container.')
    conflictResolutionPath: string?
    @description('The conflict resolution procedure in the container.')
    conflictResolutionProcedure: string?
    @description('The conflict resolution mode.')
    mode: 'Custom' | 'LastWriterWins'?
  }?
  @description('The indexing policy for the container. The configuration of the indexing policy. By default, the indexing is automatic for all document paths within the container.')
  indexingPolicy: sqlDatabaseContainerIndexingPolicyType?
  @description('The configuration of the partition key to be used for partitioning data into multiple partitions.')
  partitionKey: {
    @description('Indicates the kind of algorithm used for partitioning. For MultiHash, multiple partition keys (upto three maximum) are supported for container create')
    kind: 'Hash' | 'MultiHash' | 'Range'?
    @description('List of paths using which data within the container can be partitioned.')
    paths: string[]?
    @description('Indicates the version of the partition key definition.')
    version: int?
  }?
  @description('The unique key policy configuration for specifying uniqueness constraints on documents in the collection in the Azure Cosmos DB service.')
  uniqueKeyPolicy: {
    @description('List of unique keys.')
    uniqueKeys: {
      @description('List of paths must be unique for each document in the Azure Cosmos DB service.')
      paths: string[]?
    }[]?
  }?
  @description('Configuration of stored procedures in the container.')
  storedProcedures: { *: {
      @description('The body of the stored procedure.')
      body: string?
      @description('Performance configs.')
      performance: performanceConfig?
    } }?
  @description('Configuration of user defined functions in the container.')
  userDefinedFunctions: { *: {
      @description('The body of the user defined functions.')
      body: string?
      @description('Performance configs.')
      performance: performanceConfig?
    } }?
  @description('Configuration of triggers in the container.')
  triggers: { *: {
      @description('The body of the triggers.')
      body: string?
      @description('Performance configs.')
      performance: performanceConfig?
      @description('Type of the Trigger')
      triggerType: 'Pre' | 'Post'?
      @description('The operation the trigger is associated with.')
      triggerOperation: ('Create' | 'Delete' | 'Replace' | 'Update')[]?
    } }?
}

@description('The type definition of SQL database configuration.')
type sqlDatabasetype = {
  @description('The throughput of SQL database.')
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

@description('The list of SQL role definitions.')
param sqlRoleDefinitions array = []

@description('The list of SQL role assignments.')
param sqlRoleAssignments array = []

@description('The list of MongoDB databases configurations with collections, its indexes, Shard Keys.')
param mongodbDatabases array = []

@description('The list of Gremlin databases configurations with graphs.')
param gremlinDatabases array = []

@description('The list of Table databases configurations.')
param tables array = []

@description('Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11"')
param roleAssignments array = []

@description('The type of identity used for the Cosmos DB account. The type "SystemAssigned, UserAssigned" includes both an implicitly created identity and a set of user-assigned identities. The type "None" will remove any identities from the Cosmos DB account.')
@allowed([ 'None', 'SystemAssigned', 'SystemAssigned,UserAssigned', 'UserAssigned' ])
param identityType string = 'None'

@description('The list of user-assigned managed identities. The user identity dictionary key references will be ARM resource ids in the form: "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.ManagedIdentity/userAssignedIdentities/{identityName}"')
param userAssignedIdentities string[] = []

@description('Private Endpoints that should be created for Azure Cosmos DB account.')
param privateEndpoints array = []

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

var privateEndpointsWithDefaults = [for endpoint in privateEndpoints: {
  name: '${cosmosDBAccount.name}-${endpoint.name}'
  privateLinkServiceId: cosmosDBAccount.id
  groupIds: [
    endpoint.groupId
  ]
  subnetId: endpoint.subnetId
  privateDnsZones: contains(endpoint, 'privateDnsZoneId') ? [
    {
      name: 'default'
      zoneId: endpoint.privateDnsZoneId
    }
  ] : []
  manualApprovalEnabled: endpoint.?manualApprovalEnabled ?? false
}]

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

@batchSize(1)
module cosmosDBAccount_mongodbDatabases 'modules/mongodb.bicep' = [for (mongodbDatabase, index) in mongodbDatabases: if (backendApi == 'mongodb') {
  name: 'mongodb-database-${uniqueString(mongodbDatabase.name, resourceGroup().name)}-${index}'
  dependsOn: [
    cosmosDBAccount
  ]
  params: {
    cosmosDBAccountName: name
    databaseName: mongodbDatabase.name
    databaseCollections: mongodbDatabase.?collections ?? []
    autoscaleMaxThroughput: mongodbDatabase.?autoscaleMaxThroughput ?? 0
    manualProvisionedThroughput: mongodbDatabase.?manualProvisionedThroughput ?? 0
    enableServerless: enableServerless
  }
}]

@batchSize(1)
module cosmosDBAccount_tables 'modules/table.bicep' = [for (table, index) in tables: if (backendApi == 'table') {
  name: 'table-${uniqueString(table.name, resourceGroup().name)}-${index}'
  dependsOn: [
    cosmosDBAccount
  ]
  params: {
    cosmosDBAccountName: name
    tableName: table.name
    autoscaleMaxThroughput: table.?autoscaleMaxThroughput ?? 0
    manualProvisionedThroughput: table.?manualProvisionedThroughput ?? 0
    enableServerless: enableServerless
  }
}]

@batchSize(1)
module cosmosDBAccount_gremlinDatabases 'modules/gremlin.bicep' = [for (gremlinDatabase, index) in gremlinDatabases: if (backendApi == 'gremlin') {
  name: 'gremlin-database-${uniqueString(gremlinDatabase.name, resourceGroup().name)}-${index}'
  dependsOn: [
    cosmosDBAccount
  ]
  params: {
    cosmosDBAccountName: name
    databaseName: gremlinDatabase.name
    databaseGraphs: gremlinDatabase.?graphs ?? []
    autoscaleMaxThroughput: gremlinDatabase.?autoscaleMaxThroughput ?? 0
    manualProvisionedThroughput: gremlinDatabase.?manualProvisionedThroughput ?? 0
    enableServerless: enableServerless
  }
}]

module cosmosDBAccount_sqlRoles 'modules/sql_roles.bicep' = {
  name: 'sql-role-${uniqueString(name, resourceGroup().name)}'
  dependsOn: [
    cosmosDBAccount
  ]
  params: {
    cosmosDBAccountName: name
    roleDefinitions: sqlRoleDefinitions
    roleAssignments: sqlRoleAssignments
  }
}

@batchSize(1)
module cosmosDBAccount_rbac 'modules/rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'cosmosdb-rbac-${uniqueString(deployment().name, primaryLocation)}-${index}'
  dependsOn: [
    cosmosDBAccount
  ]
  params: {
    description: roleAssignment.?description ?? ''
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: roleAssignment.?principalType ?? ''
    cosmosDBAccountName: name
  }
}]

module cosmosDBAccount_privateEndpoint 'modules/privateEndpoint.bicep' = {
  name: '${name}-${uniqueString(deployment().name, primaryLocation)}-private-endpoints'
  params: {
    location: primaryLocation
    privateEndpoints: privateEndpointsWithDefaults
    tags: tags
  }
}

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
output sqlRoleDefinitionIds array = !empty(sqlRoleDefinitions) ? cosmosDBAccount_sqlRoles.outputs.roleDefinitionIds : []