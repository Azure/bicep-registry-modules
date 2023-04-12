type CosmosDB = {
  name: _name
  location: _location
  tags: _tags?
  kind: _kind?
  identity: _identity?
  properties: _properties
}

@description('The resource name.')
@minLength(3)
@maxLength(64)
type _name = string

@description('The location of the resource group to which the resource belongs.')
type _location = 'eastus' | 'eastus2' | 'westus' | 'westus2' | 'westcentralus' | 'westeurope' | 'southeastasia' | 'northeurope' | 'uksouth' | 'ukwest' | 'australiaeast' | 'australiasoutheast' | 'brazilsouth' | 'southindia' | 'centralindia' | 'westindia' | 'canadacentral' | 'canadaeast' | 'japaneast' | 'japanwest' | 'koreacentral' | 'koreasouth' | 'francecentral' | 'southafricanorth' | 'uaenorth' | 'switzerlandnorth' | 'germanywestcentral' | 'norwayeast'

@maxLength(128)
type _tag_key = string

@maxLength(256)
type _tag_value = string

@description('Tags are a list of key-value pairs that describe the resource. These tags can be used in viewing and grouping this resource (across resource groups). A maximum of 15 tags can be provided for a resource. Each tag must have a key no greater than 128 characters and value no greater than 256 characters. For example, the default experience for a template type is set with "defaultExperience": "Cassandra". Current "defaultExperience" values also include "Table", "Graph", "DocumentDB", and "MongoDB".')
@maxLength(15)
type _tags = {
  'key': _tag_key
  'value': _tag_value
}[]

@description('Indicates the type of database account. This can only be set at database account creation.')
type _kind = 'GlobalDocumentDB' | 'MongoDB' | 'Parse'

@description('Identity for the resource.')
type _identity = {
  type: 'SystemAssigned' | 'UserAssigned' | 'SystemAssigned,UserAssigned'
  userAssignedIdentities: object
}

@description('Properties to create and update Azure Cosmos DB database accounts.')
type _properties = {
  analyticalStorageConfiguration: _analyticalStorageConfiguration?
  apiProperties: _apiProperties?
  backupPolicy: _backupPolicy?
  capabilities: _capabilities?
  capacity: _capacity?
  connectorOffer: _connectorOffer?
  consistencyPolicy: _consistencyPolicy?
  cors: _cors?
  createMode: _createMode?
  databaseAccountOfferType: _databaseAccountOfferType
  defaultIdentity: _defaultIdentity?
  disableKeyBasedMetadataWriteAccess: _disableKeyBasedMetadataWriteAccess?
  disableLocalAuth: _disableLocalAuth?
  enableAnalyticalStorage: _enableAnalyticalStorage?
  enableAutomaticFailover: _enableAutomaticFailover?
  enableCassandraConnector: _enableCassandraConnector?
  enableFreeTier: _enableFreeTier?
  enableMultipleWriteLocations: _enableMultipleWriteLocations?
  enablePartitionMerge: _enablePartitionMerge?
  ipRules: _ipRules?
  isVirtualNetworkFilterEnabled: _isVirtualNetworkFilterEnabled?
  keyVaultKeyUri: _keyVaultKeyUri?
  locations: _locations
  networkAclBypass: _networkAclBypass?
  networkAclBypassResourceIds: _networkAclBypassResourceIds?
  publicNetworkAccess: _publicNetworkAccess?
  restoreParameters: _restoreParameters?
  virtualNetworkRules: _virtualNetworkRules?
}

@description('Analytical storage specific properties.')
type _analyticalStorageConfiguration = {
  schemaType: _schemaType
}

@description('Describes the types of schema for analytical storage.')
type _schemaType = 'FullFidelity' | 'WellDefined'

@description('API specific properties. Currently, supported only for MongoDB API.')
type _apiProperties = {
  serverVersion: _serverVersion
}

@description('Describes the ServerVersion of an a MongoDB account.')
type _serverVersion = '3.2' | '3.6' | '4.0' | '4.2'

@description('The object representing the policy for taking backups on an account.')
type _backupPolicy = {
  migrationState: _backupPolicyMigrationState?
  type: string
}

@description('Time at which the backup policy migration started (ISO-8601 format).')
type _startTime = string

@description('Describes the status of migration between backup policy types.')
type _status = 'Completed' | 'Failed' | 'InProgress' | 'Invalid'?

@description('Describes the target backup policy type of the backup policy migration.')
type _targetType = 'Continuous' | 'Periodic'

@description('The object representing the state of the migration between the backup policies.')
type _backupPolicyMigrationState = {
  startTime: _startTime?
  status: _status
  targetType: _targetType?
}

@description('List of Cosmos DB capabilities for the account')
type _capabilities = _capability[]

@description('Name of the Cosmos DB capability. For example, "name": "EnableCassandra". Current values also include "EnableTable" and "EnableGremlin".')
type _capability = {
  name: 'EnableCassandra' | 'EnableServerless' | 'EnableTable' | 'EnableGremlin'
}

@description('The total throughput limit imposed on the account. A totalThroughputLimit of 2000 imposes a strict limit of max throughput that can be provisioned on that account to be 2000. A totalThroughputLimit of -1 indicates no limits on provisioning of throughput.')
@minValue(-1)
type _totalThroughputLimit = int

@description('The object that represents all properties related to capacity enforcement on an account.')
type _capacity = {
  totalThroughputLimit: _totalThroughputLimit
}

@description('The cassandra connector offer type for the Cosmos DB database C* account.')
type _connectorOffer = 'Small'

@description('The default consistency level and configuration settings of the Cosmos DB account.')
type _defaultConsistencyLevel = 'BoundedStaleness' | 'ConsistentPrefix' | 'Eventual' | 'Session' | 'Strong'

@description('The maximum interval, in seconds, between requests when using the Bounded Staleness consistency level.')
@minValue(5)
@maxValue(86400)
type _maxIntervalInSeconds = int

@description('The maximum staleness prefix that can be used when using the Bounded Staleness consistency level.')
@minValue(10)
@maxValue(2147483647)
type _maxStalenessPrefix = int

@description('The consistency policy for the Cosmos DB database account.')
type _consistencyPolicy = {
  defaultConsistencyLevel: _defaultConsistencyLevel
  maxIntervalInSeconds: _maxIntervalInSeconds?
  maxStalenessPrefix: _maxStalenessPrefix?
}

@description('The CORS policy for the Cosmos DB database account.')
type _cors = {
  allowedHeaders: string?
  allowedMethods: string?
  allowedOrigins: string
  exposedHeaders: string?
  maxAgeInSeconds: int?
}[]

@description('Enum to indicate the mode of account creation.')
type _createMode = 'Default' | 'Restore'

@description('The offer type for the database. Required.')
type _databaseAccountOfferType = 'Standard'

@description('The default identity for accessing key vault used in features like customer managed keys. The default identity needs to be explicitly set by the users. It can be "FirstPartyIdentity", "SystemAssignedIdentity" and more.')
type _defaultIdentity = 'SystemAssignedIdentity' | 'FirstPartyIdentity'

@description('Disable write operations on metadata resources (databases, containers, throughput) via account keys')
type _disableKeyBasedMetadataWriteAccess = bool

@description('Opt-out of local authentication and ensure only MSI and AAD can be used exclusively for authentication.')
type _disableLocalAuth = bool

@description('Flag to indicate whether to enable storage analytics.')
type _enableAnalyticalStorage = bool

@description('Enables automatic failover of the write region in the rare event that the region is unavailable due to an outage. Automatic failover will result in a new write region for the account and is chosen based on the failover priorities configured for the account.')
type _enableAutomaticFailover = bool

@description('Enables the cassandra connector on the Cosmos DB C* account')
type _enableCassandraConnector = bool

@description('Flag to indicate whether Free Tier is enabled.')
type _enableFreeTier = bool

@description('Enables the account to write in multiple locations')
type _enableMultipleWriteLocations = bool

@description('Flag to indicate enabling/disabling of Partition Merge feature on the account')
type _enablePartitionMerge = bool

@description('List of IpRules.')
type _ipRules = {
  ipAddressOrRange: _ipAddressOrRange
}[]

@description('A single IPv4 address or a single IPv4 address range in CIDR format. Provided IPs must be well-formatted and cannot be contained in one of the following ranges: 10.0.0.0/8, 100.64.0.0/10, 172.16.0.0/12, 192.168.0.0/16, since these are not enforceable by the IP address filter. Example of valid inputs: “23.40.210.245” or “23.40.210.0/8”.')
type _ipAddressOrRange = string

@description('Flag to indicate whether to enable/disable Virtual Network ACL rules.')
type _isVirtualNetworkFilterEnabled = bool

@description('The URI of the key vault')
type _keyVaultKeyUri = string

@description('An array that contains the georeplication locations enabled for the Cosmos DB account. Required.')
@minLength(1)
type _locations = {
  failoverPriority: _failoverPriority
  isZoneRedundant: _isZoneRedundant
  locationName: _locationName
}[]

@description('The failover priority of the region. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.')
type _failoverPriority = int

@description('Flag to indicate whether or not this region is an AvailabilityZone region')
type _isZoneRedundant = bool

@description('The name of the region.')
type _locationName = _location

@description('Indicates what services are allowed to bypass firewall checks.')
type _networkAclBypass = 'AzureServices' | 'None'

@description('An array that contains the Resource Ids for Network Acl Bypass for the Cosmos DB account.')
type _networkAclBypassResourceIds = string[]

@description('Whether requests from Public Network are allowed')
type _publicNetworkAccess = 'Enabled' | 'Disabled'

@description('Parameters to indicate the information about the restore.')
type _restoreParameters = {
  databasesToRestore: _databasesToRestore[]?
  restoreMode: _restoreMode?
  restoreSource: _restoreSource?
  restoreTimestampInUtc: _restoreTimestampInUtc?
}

@description('List of Virtual Network ACL rules configured for the Cosmos DB account.')
type _databasesToRestore = {
  collectionNames: _collectionNames[]?
  databaseName: _databaseName?
}[]

@description('The names of the collections available for restore.')
type _collectionNames = string

@description('The name of the database available for restore.')
type _databaseName = string

@description('Describes the mode of the restore.')
type _restoreMode = 'PointInTime'

@description('The id of the restorable database account from which the restore has to be initiated. For example: /subscriptions/{subscriptionId}/providers/Microsoft.DocumentDB/locations/{location}/restorableDatabaseAccounts/{restorableDatabaseAccountName}')
type _restoreSource = string

@description('Time to which the account has to be restored (ISO-8601 format).')
type _restoreTimestampInUtc = string

@description('List of Virtual Network ACL rules configured for the Cosmos DB account.')
type _virtualNetworkRules = {
  id: _id
  ignoreMissingVNetServiceEndpoint: _ignoreMissingVNetServiceEndpoint
}[]

@description('Resource ID of a subnet, for example: /subscriptions/{subscriptionId}/resourceGroups/{groupName}/providers/Microsoft.Network/virtualNetworks/{virtualNetworkName}/subnets/{subnetName}.')
type _id = string

@description('Create firewall rule before the virtual network has vnet service endpoint enabled.')
type _ignoreMissingVNetServiceEndpoint = bool
