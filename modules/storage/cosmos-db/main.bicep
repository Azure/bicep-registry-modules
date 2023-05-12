@description('Deployment region name. Default is the location of the resource group.')
param location string = resourceGroup().location

@description('The bakend API type of Cosmos DB database account. The API selection cannot be changed after account creation. Possible values: "cassandra", "gremlin", "mongodb", "sql", "table".')
@allowed([ 'cassandra', 'gremlin', 'mongodb', 'sql', 'table' ])
param backendApi string = 'sql'

@description('Prefix of Cosmos DB Resource Name. Not used if name is provided.')
param prefix string = { cassandra: 'coscas', gremlin: 'cosgrm', mongodb: 'cosmon', sql: 'cosmos', table: 'costab' }[backendApi]

@description('The name of the Cosmos DB account. Character limit: 3-44, valid characters: lowercase letters, numbers, and hyphens. It must me unique across Azure.')
param name string = take('${prefix}-${uniqueString(resourceGroup().id, location)}', 44)

@description('Enables automatic failover of the write region in the rare event that the region is unavailable due to an outage. Automatic failover will result in a new write region for the account and is chosen based on the failover priorities configured for the account.')
param enableAutomaticFailover bool = true

@description('Multi-region writes capability allows you to take advantage of the provisioned throughput for your databases and containers across the globe.')
param enableMultipleWriteLocations bool = true

@description('Enable Serverless for consumption-based usage.')
param enableServerless bool = false

@description('Flag to indicate whether or not this region is an AvailabilityZone region')
param isZoneRedundant bool = false

@description('Flag to indicate whether Free Tier is enabled, up to one account per subscription is allowed.')
param enableFreeTier bool = false

@description('The total throughput limit of the Cosmos DB account in measurement of requests units (RUs) per second, -1 indicates no limits on provisioning of throughput.')
@minValue(-1)
param totalThroughputLimit int = -1

@description('The array of secondary locations.')
param secondaryLocations array = []

@allowed([ 'Eventual', 'ConsistentPrefix', 'Session', 'BoundedStaleness', 'Strong' ])
@description('The default consistency level. Possible values: "Eventual", "ConsistentPrefix", "Session", "BoundedStaleness", "Strong".')
param defaultConsistencyLevel string = 'Session'

@description('Max stale requests required for "BoundedStaleness" Consistency Level. Valid ranges, Single Region: 10 to 2147483647. Multi Region: 100000 to 2147483647.')
@minValue(10)
@maxValue(2147483647)
param maxStalenessPrefix int = 100000

@description('Max lag time (minutes). Required for BoundedStaleness. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400.')
@minValue(5)
@maxValue(86400)
param maxIntervalInSeconds int = 300

@description('MongoDB server version. Required for mongodb API type Cosmos DB account')
@allowed([ '3.2', '3.6', '4.0', '4.2' ])
param serverVersion string = '4.2'

@description('List of CORS rules.')
param cors array = []

@description('Disable write operations on metadata resources (databases, containers, throughput) via account keys.')
param disableKeyBasedMetadataWriteAccess bool = false

@description('Whether requests from public network allowed.')
@allowed([ 'Enabled', 'Disabled' ])
param publicNetworkAccess string = 'Enabled'

@description('Flag to indicate whether to enable/disable Virtual Network ACL rules.')
param isVirtualNetworkFilterEnabled bool = false

@allowed([ 'AzureServices', 'None' ])
@description('Indicates what services are allowed to bypass firewall checks.')
param networkAclBypass string = 'None'

@description('List of IpRules to be allowed. A single IPv4 address or a single IPv4 address range in CIDR format.')
param ipRules array = []

@description('The list of virtual network ACL rules, "isVirtualNetworkFilterEnabled" must be set to "true". format: {id: string, ignoreMissingVNetServiceEndpoint: bool}')
param virtualNetworkRules array = []

@description('An array that contains the Resource Ids for Network Acl Bypass.')
param networkAclBypassResourceIds array = []

@description('Non-default extra capabilities.')
param capabilities array = []

@description('Opt-out of local authentication and ensure only MSI and AAD can be used exclusively for authentication.')
param disableLocalAuth bool = false

@description('Flag to indicate whether to enable storage analytics.')
param enableAnalyticalStorage bool = false

@description('The type of schema for analytical storage.')
@allowed([ 'FullFidelity', 'WellDefined' ])
param analyticalStorageSchemaType string = 'WellDefined'

@description('The list of Cassandra keyspaces configurations with tables.')
param cassandraKeyspaces array = []

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
param userAssignedIdentities object = {}

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

var varConsistencyPolicy = (defaultConsistencyLevel == 'BoundedStaleness') ? {
  defaultConsistencyLevel: 'BoundedStaleness'
  maxStalenessPrefix: maxStalenessPrefix
  maxIntervalInSeconds: maxIntervalInSeconds
} : {
  defaultConsistencyLevel: defaultConsistencyLevel
}

var secondaryRegionsWithDefaults = [for (region, i) in secondaryLocations: {
  locationName: region.?locationName ?? region
  failoverPriority: region.?failoverPriority ?? i + 1
  isZoneRedundant: region.?isZoneRedundant ?? isZoneRedundant
}]

var locationsWithDefaults = union([
    {
      locationName: location
      failoverPriority: 0
      isZoneRedundant: isZoneRedundant
    }
  ],
  enableServerless ? [] : secondaryRegionsWithDefaults
)

var capabilityMappings = {
  cassandra: 'EnableCassandra'
  gremlin: 'EnableGremlin'
  mongodb: 'EnableMongo'
  table: 'EnableTable'
}

var capabilitiesWithDefaults = union(
  capabilities,
  enableServerless ? [ 'EnableServerless' ] : [],
  contains(capabilityMappings, backendApi) ? [ capabilityMappings[backendApi] ] : []
)

var ipRulesWithDefaults = [for ipRule in ipRules: {
  ipAddressOrRange: ipRule
}]

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

resource cosmosDBAccount 'Microsoft.DocumentDB/databaseAccounts@2022-11-15' = {
  name: toLower(name)
  location: location
  kind: (backendApi == 'mongodb') ? 'MongoDB' : 'GlobalDocumentDB'
  properties: {
    analyticalStorageConfiguration: enableAnalyticalStorage ? { schemaType: analyticalStorageSchemaType } : null
    apiProperties: (backendApi == 'mongodb') ? { serverVersion: serverVersion } : null

    capabilities: [for capability in capabilitiesWithDefaults: { name: capability }]
    capacity: enableServerless ? null : { totalThroughputLimit: totalThroughputLimit }
    consistencyPolicy: varConsistencyPolicy
    cors: cors
    databaseAccountOfferType: 'Standard'
    disableKeyBasedMetadataWriteAccess: disableKeyBasedMetadataWriteAccess
    disableLocalAuth: disableLocalAuth
    enableAnalyticalStorage: enableAnalyticalStorage
    enableAutomaticFailover: enableAutomaticFailover
    enableFreeTier: enableFreeTier
    enableMultipleWriteLocations: enableServerless ? false : enableMultipleWriteLocations
    ipRules: ipRulesWithDefaults
    isVirtualNetworkFilterEnabled: isVirtualNetworkFilterEnabled
    locations: locationsWithDefaults
    networkAclBypass: networkAclBypass
    networkAclBypassResourceIds: networkAclBypassResourceIds
    publicNetworkAccess: publicNetworkAccess
    virtualNetworkRules: virtualNetworkRules
  }
  identity: contains(identityType, 'UserAssigned') ? {
    type: identityType
    userAssignedIdentities: contains(identityType, 'UserAssigned') ? userAssignedIdentities : {}
  } : { type: identityType }
  tags: tags
}

@batchSize(1)
module cosmosDBAccount_cassandraKeyspaces 'modules/cassandra.bicep' = [for (keyspace, index) in cassandraKeyspaces: if (backendApi == 'cassandra') {
  name: 'cassandra-keyspace-${uniqueString(keyspace.name, resourceGroup().name)}-${index}'
  dependsOn: [
    cosmosDBAccount
  ]
  params: {
    cosmosDBAccountName: name
    keyspaceName: keyspace.name
    tables: keyspace.tables
    autoscaleMaxThroughput: keyspace.?autoscaleMaxThroughput ?? 0
    manualProvisionedThroughput: keyspace.?manualProvisionedThroughput ?? 0
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
  name: 'cosmosdb-rbac-${uniqueString(deployment().name, location)}-${index}'
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
  name: '${name}-${uniqueString(deployment().name, location)}-private-endpoints'
  params: {
    location: location
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
