@description('The bakend API type of Cosmos DB database account. The API selection cannot be changed after account creation. Possible values: "cassandra", "gremlin", "mongodb", "sql", "table".')
@allowed([ 'cassandra', 'gremlin', 'mongodb', 'sql', 'table' ])
param backendApi string = 'sql'

@description('The name of the Cosmos DB account. Character limit: 3-44, valid characters: lowercase letters, numbers, and hyphens. It must me unique across Azure.')
@maxLength(44)
@minLength(3)
param name string = uniqueString(resourceGroup().id, resourceGroup().location)

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

@description('MongoDB server version. Required for mongodb API type Cosmos DB account')
@allowed([ '3.2', '3.6', '4.0', '4.2' ])
param MongoDBServerVersion string = '4.2'

@description('''
List of CORS rules. Each CORS rule allows or denies requests from a set of origins to a Cosmos DB account or a database.
parameters:
- Name: allowedOrigins
  Description: The origin domains that are permitted to make a request against the service via CORS.
- Name: allowedMethods
  Description: The methods (HTTP request verbs) that the origin domain may use for a CORS request. (comma separated)
- Name: allowedHeaders
  Description: The response headers that should be sent back to the client for CORS requests. (comma separated)
- Name: exposedHeaders
  Description: The response headers that should be exposed to the client for CORS requests. (comma separated)
- Name: maxAgeInSeconds
  Description: The maximum amount time that a browser should cache the preflight OPTIONS request.
''')
param cors {
  allowedOrigins: string
  allowedMethods: string?
  allowedHeaders: string?
  exposedHeaders: string?
  maxAgeInSeconds: int?
}[] = []

@description('The mode of the Cosmos Account creation. Set to Restore to restore from an existing account.')
@allowed([ 'Default', 'Restore' ])
param createMode string = 'Default'

@description('Disable write operations on metadata resources (databases, containers, throughput) via account keys.')
param disableKeyBasedMetadataWriteAccess bool = false

@description('Whether requests from public network allowed.')
param enablePublicNetworkAccess bool = 'Enabled'

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

type casandrakeyspace = {
  enableThroughputAutoScale: bool
  @maxValue(100000)
  @minValue(400)
  throughput: int
  tables:{}
  tags: objectOfString
}

type objectOfString = {
  *: string
}

@description('''
The object of Cassandra keyspaces configurations with tables.
The key of each element is the name of the Cassandra keyspace.
The value of each element is an object with the following parameters:
- Name: enableThroughputAutoScale
  Description: Flag to enable/disable automatic throughput scaling for this keyspace.
- Name: throughput
  Description: When enableThroughputAutoScale is set to true, this parameter is the static throughput capability of Cassandra keyspace expressed in units of 100 requests per second. 400 RU/s is the minimum for production workloads. It ranges from 400 to 100,000 inclusive.
               When enableThroughputAutoScale is set to false, this parameter is the maximum of the autoscaled throughput capability of Cassandra keyspace. It would scale down to a minimum of 10% of this max throughput based on usage. It ranges from 4000 to 100,000 inclusive.
- Name: tags
  Description: The tags that will be assigned to the Cassandra keyspace.
''')
param cassandraKeyspaces { *: casandrakeyspace } = {}

@description('The list of SQL databases configurations with containers, its triggers, storedProcedures and userDefinedFunctions.')
param sqlDatabases array = []

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
param tags object = {}

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Specify the type of lock on Cosmos DB account resource.')
param lock string = 'NotSpecified'

@description('''
The consistency policy for the Cosmos DB account.
parameters:
- Name: defaultConsistencyLevel
  Description: The default consistency level and configuration settings of the Cosmos DB account.
- Name: maxStalenessPrefix
  Required: Required only when defaultConsistencyPolicy is set to 'BoundedStaleness'.
  Description: When used with the Bounded Staleness consistency level, this value represents the time amount of staleness (in seconds) tolerated.
  Valid ranges:
  - Single Region: 10 to 2147483647
  - Multi Region: 100000 to 2147483647.
- Name: maxIntervalInSeconds
  Required: Required only when defaultConsistencyPolicy is set to 'BoundedStaleness'.
  Description: When used with the Bounded Staleness consistency level, this value represents the number of stale requests tolerated.
  Valid ranges:
  - Single Region: 5 to 84600.
  - Multi Region: 300 to 86400.
''')
param consistencyPolicy {
  defaultConsistencyLevel: 'Eventual' | 'ConsistentPrefix' | 'Session' | 'BoundedStaleness' | 'Strong'
  @minValue(10)
  @maxValue(2147483647)
  maxStalenessPrefix: int?
  @minValue(5)
  @maxValue(86400)
  maxIntervalInSeconds: int?
} = {
  defaultConsistencyLevel: 'Session'
}

var primaryLocation = locations[0].name

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
module cosmosDBAccount_cassandraKeyspaces 'modules/cassandra.bicep' = [for keyspace in cassandraKeyspaces: if (backendApi == 'cassandra') {
  dependsOn: [ cosmosDBAccount ]

  name: keyspace.key
  params: {
    cosmosDBAccountName: name
    keySpace: keyspace.value
    enableServerless: enableServerless
  }
}]

@batchSize(1)
module cosmosDBAccount_sqlDatabases 'modules/sql.bicep' = [for (sqlDatabase, index) in sqlDatabases: if (backendApi == 'sql') {
  name: 'sql-database-${uniqueString(sqlDatabase.name, resourceGroup().name)}-${index}'
  dependsOn: [
    cosmosDBAccount
  ]
  params: {
    cosmosDBAccountName: name
    databaseName: sqlDatabase.name
    databaseContainers: sqlDatabase.?containers ?? []
    autoscaleMaxThroughput: sqlDatabase.?autoscaleMaxThroughput ?? 0
    manualProvisionedThroughput: sqlDatabase.?manualProvisionedThroughput ?? 0
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
