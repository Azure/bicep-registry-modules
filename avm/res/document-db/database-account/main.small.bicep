metadata name = 'Azure Cosmos DB account'
metadata description = 'This module deploys an Azure Cosmos DB account. The API used for the account is determined by the child resources that are deployed.'

@description('Required. The name of the account.')
param name string

@description('Optional. Defaults to the current resource group scope location. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags for the resource.')
param tags resourceInput<'Microsoft.DocumentDB/databaseAccounts@2024-11-15'>.tags?

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityAllType?

@description('Optional. The offer type for the account. Defaults to "Standard".')
@allowed([
  'Standard'
])
param databaseAccountOfferType string = 'Standard'

@description('Optional. The set of locations enabled for the account. Defaults to the location where the account is deployed.')
param failoverLocations failoverLocationType[]?

@description('Optional. Indicates whether the single-region account is zone redundant. Defaults to true. This property is ignored for multi-region accounts.')
param zoneRedundant bool = true

@allowed([
  'Eventual'
  'ConsistentPrefix'
  'Session'
  'BoundedStaleness'
  'Strong'
])
@description('Optional. The default consistency level of the account. Defaults to "Session".')
param defaultConsistencyLevel string = 'Session'

@description('Optional. Opt-out of local authentication and ensure that only Microsoft Entra can be used exclusively for authentication. Defaults to true.')
param disableLocalAuthentication bool = true

@description('Optional. Flag to indicate whether to enable storage analytics. Defaults to false.')
param enableAnalyticalStorage bool = false

@description('Optional. Enable automatic failover for regions. Defaults to true.')
param enableAutomaticFailover bool = true

@description('Optional. Flag to indicate whether "Free Tier" is enabled. Defaults to false.')
param enableFreeTier bool = false

@description('Optional. Enables the account to write in multiple locations. Periodic backup must be used if enabled. Defaults to false.')
param enableMultipleWriteLocations bool = false

@description('Optional. Disable write operations on metadata resources (databases, containers, throughput) via account keys. Defaults to true.')
param disableKeyBasedMetadataWriteAccess bool = true

@minValue(1)
@maxValue(2147483647)
@description('Optional. The maximum stale requests. Required for "BoundedStaleness" consistency level. Valid ranges, Single Region: 10 to 1000000. Multi Region: 100000 to 1000000. Defaults to 100000.')
param maxStalenessPrefix int = 100000

@minValue(5)
@maxValue(86400)
@description('Optional. The maximum lag time in minutes. Required for "BoundedStaleness" consistency level. Valid ranges, Single Region: 5 to 84600. Multi Region: 300 to 86400. Defaults to 300.')
param maxIntervalInSeconds int = 300

@description('Optional. Specifies the MongoDB server version to use if using Azure Cosmos DB for MongoDB RU. Defaults to "4.2".')
@allowed([
  '3.2'
  '3.6'
  '4.0'
  '4.2'
  '5.0'
  '6.0'
  '7.0'
])
param serverVersion string = '4.2'

@description('Optional. Configuration for databases when using Azure Cosmos DB for NoSQL.')
param sqlDatabases sqlDatabaseType[]?

@description('Optional. Configuration for databases when using Azure Cosmos DB for MongoDB RU.')
param mongodbDatabases mongoDbType[]?

@description('Optional. Configuration for databases when using Azure Cosmos DB for Apache Gremlin.')
param gremlinDatabases gremlinDatabaseType[]?

@description('Optional. Configuration for databases when using Azure Cosmos DB for Table.')
param tables tableType[]?

@description('Optional. Configuration for keyspaces when using Azure Cosmos DB for Apache Cassandra.')
param cassandraKeyspaces cassandraKeyspaceType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The total throughput limit imposed on this account in request units per second (RU/s). Default to unlimited throughput.')
param totalThroughputLimit int = -1

@allowed([
  'EnableCassandra'
  'EnableTable'
  'EnableGremlin'
  'EnableMongo'
  'DisableRateLimitingResponses'
  'EnableServerless'
  'EnableNoSQLVectorSearch'
  'EnableNoSQLFullTextSearch'
  'EnableMaterializedViews'
  'DeleteAllItemsByPartitionKey'
])
@description('Optional. A list of Azure Cosmos DB specific capabilities for the account.')
param capabilitiesToAdd string[]?

@allowed([
  'Periodic'
  'Continuous'
])
@description('Optional. Configures the backup mode. Periodic backup must be used if multiple write locations are used. Defaults to "Continuous".')
param backupPolicyType string = 'Continuous'

@allowed([
  'Continuous30Days'
  'Continuous7Days'
])
@description('Optional. Configuration values to specify the retention period for continuous mode backup. Default to "Continuous30Days".')
param backupPolicyContinuousTier string = 'Continuous30Days'

@minValue(60)
@maxValue(1440)
@description('Optional. An integer representing the interval in minutes between two backups. This setting only applies to the periodic backup type. Defaults to 240.')
param backupIntervalInMinutes int = 240

@minValue(2)
@maxValue(720)
@description('Optional. An integer representing the time (in hours) that each backup is retained. This setting only applies to the periodic backup type. Defaults to 8.')
param backupRetentionIntervalInHours int = 8

@allowed([
  'Geo'
  'Local'
  'Zone'
])
@description('Optional. Setting that indicates the type of backup residency. This setting only applies to the periodic backup type. Defaults to "Local".')
param backupStorageRedundancy string = 'Local'

@description('Optional. The network configuration of this module. Defaults to `{ ipRules: [], virtualNetworkRules: [], publicNetworkAccess: \'Disabled\' }`.')
param networkRestrictions networkRestrictionType = {
  ipRules: []
  virtualNetworkRules: []
  publicNetworkAccess: 'Disabled'
}

@allowed([
  'Tls12'
])
@description('Optional. Setting that indicates the minimum allowed TLS version. Azure Cosmos DB for MongoDB RU and Apache Cassandra only work with TLS 1.2 or later. Defaults to "Tls12" (TLS 1.2).')
param minimumTlsVersion string = 'Tls12'

@description('Optional. Flag to indicate enabling/disabling of Burst Capacity feature on the account. Cannot be enabled for serverless accounts.')
param enableBurstCapacity bool = true

@description('Optional. Enables the cassandra connector on the Cosmos DB C* account.')
param enableCassandraConnector bool = false

@description('Optional. Flag to enable/disable the \'Partition Merge\' feature on the account.')
param enablePartitionMerge bool = false

@description('Optional. Flag to enable/disable the \'PerRegionPerPartitionAutoscale\' feature on the account.')
param enablePerRegionPerPartitionAutoscale bool = false

@description('Optional. Analytical storage specific properties.')
param analyticalStorageConfiguration resourceInput<'Microsoft.DocumentDB/databaseAccounts@2025-04-15'>.properties.analyticalStorageConfiguration?

@description('Optional. The CORS policy for the Cosmos DB database account.')
param cors resourceInput<'Microsoft.DocumentDB/databaseAccounts@2025-04-15'>.properties.cors?

@description('Optional. The default identity for accessing key vault used in features like customer managed keys. Use `FirstPartyIdentity` to use the tenant-level CosmosDB enterprise application. The default identity needs to be explicitly set by the users.')
param defaultIdentity defaultIdentityType = {
  name: 'FirstPartyIdentity'
}

@description('Optional. The customer managed key definition. If specified, the parameter `defaultIdentity` must be configured as well.')
param customerManagedKey customerManagedKeyType?

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(formattedUserAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(formattedUserAssignedIdentities) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-07-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.documentdb-databaseaccount.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
  properties: {
    mode: 'Incremental'
    template: {
      '$schema': 'https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#'
      contentVersion: '1.0.0.0'
      resources: []
      outputs: {
        telemetry: {
          type: 'String'
          value: 'For more information, see https://aka.ms/avm/TelemetryInfo'
        }
      }
    }
  }
}

var isHSMManagedCMK = split(customerManagedKey.?keyVaultResourceId ?? '', '/')[?7] == 'managedHSMs'
resource cMKKeyVault 'Microsoft.KeyVault/vaults@2024-11-01' existing = if (!empty(customerManagedKey) && !isHSMManagedCMK) {
  name: last(split((customerManagedKey!.keyVaultResourceId!), '/'))
  scope: resourceGroup(
    split(customerManagedKey!.keyVaultResourceId!, '/')[2],
    split(customerManagedKey!.keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2024-11-01' existing = if (!empty(customerManagedKey) && !isHSMManagedCMK) {
    name: customerManagedKey!.keyName
  }
}

resource databaseAccount 'Microsoft.DocumentDB/databaseAccounts@2025-04-15' = {
  name: name
  location: location
  tags: tags
  identity: identity
  kind: !empty(mongodbDatabases) ? 'MongoDB' : 'GlobalDocumentDB'
  properties: {
    enableBurstCapacity: !contains((capabilitiesToAdd ?? []), 'EnableServerless') ? enableBurstCapacity : false
    databaseAccountOfferType: databaseAccountOfferType
    analyticalStorageConfiguration: analyticalStorageConfiguration
    // defaultIdentity: 'UserAssignedIdentity=/subscriptions/cfa4dc0b-3d25-4e58-a70a-7085359080c5/resourceGroups/dep-avmx-documentdb.databaseaccounts-dddaenc-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/dep-avmx-msi-dddaenc'
    defaultIdentity: !empty(defaultIdentity) && defaultIdentity.?name != 'UserAssignedIdentity'
      ? defaultIdentity!.name
      : 'UserAssignedIdentity=${defaultIdentity!.?resourceId}'
    // keyVaultKeyUri: 'https://dep-avmx-kv-dddaenc-jip.vault.azure.net/keys/keyEncryptionKey'
    keyVaultKeyUri: !empty(customerManagedKey)
      ? !isHSMManagedCMK
          ? '${cMKKeyVault::cMKKey!.properties.keyUri}'
          : 'https://${last(split((customerManagedKey!.keyVaultResourceId), '/'))}.managedhsm.azure.net/keys/${customerManagedKey!.keyName}'
      : null
    cors: cors
    enablePartitionMerge: enablePartitionMerge
    enablePerRegionPerPartitionAutoscale: enablePerRegionPerPartitionAutoscale
    backupPolicy: {
      #disable-next-line BCP225 // Value has a default
      type: backupPolicyType
      ...(backupPolicyType == 'Continuous'
        ? {
            continuousModeProperties: {
              tier: backupPolicyContinuousTier
            }
          }
        : {})
      ...(backupPolicyType == 'Periodic'
        ? {
            periodicModeProperties: {
              backupIntervalInMinutes: backupIntervalInMinutes
              backupRetentionIntervalInHours: backupRetentionIntervalInHours
              backupStorageRedundancy: backupStorageRedundancy
            }
          }
        : {})
    }
    capabilities: map(capabilitiesToAdd ?? [], capability => {
      name: capability
    })
    ...(!empty(cors) ? { cors: cors } : {}) // Cors can only be provided if not null/empty
    ...(contains(capabilitiesToAdd ?? [], 'EnableCassandra')
      ? {
          connectorOffer: enableCassandraConnector ? 'Small' : null
          enableCassandraConnector: enableCassandraConnector
        }
      : {})
    minimalTlsVersion: minimumTlsVersion
    capacity: {
      totalThroughputLimit: totalThroughputLimit
    }
    publicNetworkAccess: networkRestrictions.?publicNetworkAccess ?? 'Disabled'
    ...((!empty(sqlDatabases) || !empty(mongodbDatabases) || !empty(gremlinDatabases) || !empty(tables) || !empty(cassandraKeyspaces))
      ? {
          // NoSQL, MongoDB RU, Table, Apache Gremlin, and Apache Cassandra common properties
          consistencyPolicy: {
            defaultConsistencyLevel: defaultConsistencyLevel
            ...(defaultConsistencyLevel == 'BoundedStaleness'
              ? {
                  maxStalenessPrefix: maxStalenessPrefix
                  maxIntervalInSeconds: maxIntervalInSeconds
                }
              : {})
          }
          enableMultipleWriteLocations: enableMultipleWriteLocations
          locations: !empty(failoverLocations)
            ? map(failoverLocations!, failoverLocation => {
                failoverPriority: failoverLocation.failoverPriority
                locationName: failoverLocation.locationName
                isZoneRedundant: failoverLocation.?isZoneRedundant ?? true
              })
            : [
                {
                  failoverPriority: 0
                  locationName: location
                  isZoneRedundant: zoneRedundant
                }
              ]
          ipRules: map(networkRestrictions.?ipRules ?? [], ipRule => {
            ipAddressOrRange: ipRule
          })
          virtualNetworkRules: map(networkRestrictions.?virtualNetworkRules ?? [], rule => {
            id: rule.subnetResourceId
            ignoreMissingVNetServiceEndpoint: false
          })
          networkAclBypass: networkRestrictions.?networkAclBypass ?? 'None'
          networkAclBypassResourceIds: networkRestrictions.?networkAclBypassResourceIds
          isVirtualNetworkFilterEnabled: !empty(networkRestrictions.?ipRules) || !empty(networkRestrictions.?virtualNetworkRules)
          enableFreeTier: enableFreeTier
          enableAutomaticFailover: enableAutomaticFailover
          enableAnalyticalStorage: enableAnalyticalStorage
        }
      : {})
    ...((!empty(mongodbDatabases) || !empty(gremlinDatabases) || !empty(cassandraKeyspaces))
      ? {
          // Key-based authentication is the only allowed authentication method with Azure Cosmos DB for MongoDB RU, Apache Gremlin, and Apache Cassandra.
          disableLocalAuth: false
          disableKeyBasedMetadataWriteAccess: false
        }
      : {
          // Microsoft Entra authentication is supported for Azure Cosmos DB for NoSQL and Table. Disable key-based authentication by default.
          disableLocalAuth: disableLocalAuthentication
          disableKeyBasedMetadataWriteAccess: disableKeyBasedMetadataWriteAccess
        })
    ...(!empty(mongodbDatabases)
      ? {
          // MongoDB RU properties
          apiProperties: {
            serverVersion: serverVersion
          }
        }
      : {})
  }
}

@description('The name of the database account.')
output name string = databaseAccount.name

@description('The resource ID of the database account.')
output resourceId string = databaseAccount.id

@description('The name of the resource group the database account was created in.')
output resourceGroupName string = resourceGroup().name

@description('The principal ID of the system assigned identity.')
output systemAssignedMIPrincipalId string? = databaseAccount.?identity.?principalId

@description('The location the resource was deployed into.')
output location string = databaseAccount.location

@description('The endpoint of the database account.')
output endpoint string = databaseAccount.properties.documentEndpoint

@secure()
@description('The primary read-write key.')
output primaryReadWriteKey string = databaseAccount.listKeys().primaryMasterKey

@secure()
@description('The primary read-only key.')
output primaryReadOnlyKey string = databaseAccount.listKeys().primaryReadonlyMasterKey

@secure()
@description('The primary read-write connection string.')
output primaryReadWriteConnectionString string = databaseAccount.listConnectionStrings().connectionStrings[0].connectionString

@secure()
@description('The primary read-only connection string.')
output primaryReadOnlyConnectionString string = databaseAccount.listConnectionStrings().connectionStrings[2].connectionString

@secure()
@description('The secondary read-write key.')
output secondaryReadWriteKey string = databaseAccount.listKeys().secondaryMasterKey

@secure()
@description('The secondary read-only key.')
output secondaryReadOnlyKey string = databaseAccount.listKeys().secondaryReadonlyMasterKey

@secure()
@description('The secondary read-write connection string.')
output secondaryReadWriteConnectionString string = databaseAccount.listConnectionStrings().connectionStrings[1].connectionString

@secure()
@description('The secondary read-only connection string.')
output secondaryReadOnlyConnectionString string = databaseAccount.listConnectionStrings().connectionStrings[3].connectionString

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The type of a customer-managed key configuration.')
type customerManagedKeyType = {
  @description('Required. The resource ID of a key vault to reference a customer managed key for encryption from.')
  keyVaultResourceId: string

  @description('Required. The name of the customer managed key to use for encryption.')
  keyName: string
}

@export()
@description('The type for the private endpoint output.')
type privateEndpointOutputType = {
  @description('The name of the private endpoint.')
  name: string

  @description('The resource ID of the private endpoint.')
  resourceId: string

  @description('The group ID for the private endpoint group.')
  groupId: string?

  @description('The custom DNS configurations of the private endpoint.')
  customDnsConfigs: {
    @description('fully-qualified domain name (FQDN) that resolves to private endpoint IP address.')
    fqdn: string?

    @description('A list of private IP addresses for the private endpoint.')
    ipAddresses: string[]
  }[]

  @description('The IDs of the network interfaces associated with the private endpoint.')
  networkInterfaceResourceIds: string[]
}

@export()
@description('The type for the failover location.')
type failoverLocationType = {
  @description('Required. The failover priority of the region. A failover priority of 0 indicates a write region. The maximum value for a failover priority = (total number of regions - 1). Failover priority values must be unique for each of the regions in which the database account exists.')
  failoverPriority: int

  @description('Optional. Flag to indicate whether or not this region is an AvailabilityZone region. Defaults to true.')
  isZoneRedundant: bool?

  @description('Required. The name of the region.')
  locationName: string
}

@export()
@description('The type for an Azure Cosmos DB for NoSQL native role-based access control assignment.')
type sqlRoleAssignmentType = {
  @description('Optional. The unique name of the role assignment.')
  name: string?

  @description('Required. The unique identifier of the Azure Cosmos DB for NoSQL native role-based access control definition.')
  roleDefinitionId: string

  @description('Required. The unique identifier for the associated Microsoft Entra ID principal to which access is being granted through this role-based access control assignment. The tenant ID for the principal is inferred using the tenant associated with the subscription.')
  principalId: string

  @description('Optional. The data plane resource id for which access is being granted through this Role Assignment. Defaults to the root of the database account, but can also be scoped to e.g., the container and database level.')
  scope: string?
}

import { sqlRoleAssignmentType as nestedSqlRoleAssignmentType } from 'sql-role-definition/main.bicep'
import { tableType as cassandraTableType, viewType as cassandraViewType } from 'cassandra-keyspace/main.bicep'

@export()
@description('The type for an Azure Cosmos DB for NoSQL or Table native role-based access control definition.')
type sqlRoleDefinitionType = {
  @description('Optional. The unique identifier of the role-based access control definition.')
  name: string?

  @description('Required. A user-friendly name for the role-based access control definition. This must be unique within the database account.')
  roleName: string

  @description('Required. An array of data actions that are allowed.')
  @minLength(1)
  dataActions: string[]

  @description('Optional. A set of fully-qualified scopes at or below which role-based access control assignments may be created using this definition. This setting allows application of this definition on the entire account or any underlying resource. This setting must have at least one element. Scopes higher than the account level are not enforceable as assignable scopes. Resources referenced in assignable scopes do not need to exist at creation. Defaults to the current account scope.')
  assignableScopes: string[]?

  @description('Optional. An array of role-based access control assignments to be created for the definition.')
  assignments: nestedSqlRoleAssignmentType[]?
}

@export()
@description('The type for the network restriction.')
type networkRestrictionType = {
  @description('Optional. A single IPv4 address or a single IPv4 address range in Classless Inter-Domain Routing (CIDR) format. Provided IPs must be well-formatted and cannot be contained in one of the following ranges: `10.0.0.0/8`, `100.64.0.0/10`, `172.16.0.0/12`, `192.168.0.0/16`, since these are not enforceable by the IP address filter. Example of valid inputs: `23.40.210.245` or `23.40.210.0/8`.')
  ipRules: string[]?

  @description('Optional. Specifies the network ACL bypass for Azure services. Default to "None".')
  networkAclBypass: ('AzureServices' | 'None')?

  @description('Optional. Whether requests from the public network are allowed. Default to "Disabled".')
  publicNetworkAccess: ('Enabled' | 'Disabled')?

  @description('Optional. List of virtual network access control list (ACL) rules configured for the account.')
  virtualNetworkRules: {
    @description('Required. Resource ID of a subnet.')
    subnetResourceId: string
  }[]?

  @description('Optional. An array that contains the Resource Ids for Network Acl Bypass for the Cosmos DB account.')
  networkAclBypassResourceIds: string[]?
}

import { graphType } from 'gremlin-database/main.bicep'
@export()
@description('The type for a gremlin databae.')
type gremlinDatabaseType = {
  @description('Required. Name of the Gremlin database.')
  name: string

  @description('Optional. Tags of the Gremlin database resource.')
  tags: resourceInput<'Microsoft.DocumentDB/databaseAccounts/gremlinDatabases@2024-11-15'>.tags?

  @description('Optional. Array of graphs to deploy in the Gremlin database.')
  graphs: graphType[]?

  @description('Optional. Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored. Setting throughput at the database level is only recommended for development/test or when workload across all graphs in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the graph level and not at the database level.')
  maxThroughput: int?

  @description('Optional. Request Units per second (for example 10000). Cannot be set together with `maxThroughput`. Setting throughput at the database level is only recommended for development/test or when workload across all graphs in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the graph level and not at the database level.')
  throughput: int?
}

import { collectionType } from 'mongodb-database/main.bicep'
@export()
@description('The type for a mongo databae.')
type mongoDbType = {
  @description('Required. Name of the mongodb database.')
  name: string

  @description('Optional. Request Units per second. Setting throughput at the database level is only recommended for development/test or when workload across all collections in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the collection level and not at the database level.')
  throughput: int?

  @description('Optional. Collections in the mongodb database.')
  collections: collectionType[]?

  @description('Optional. Specifies the Autoscale settings. Note: Either throughput or autoscaleSettings is required, but not both.')
  autoscaleSettings: resourceInput<'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2025-04-15'>.properties.options.autoscaleSettings?

  @description('Optional. Tags of the resource.')
  tags: resourceInput<'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2025-04-15'>.tags?
}

import { containerType } from 'sql-database/main.bicep'
@export()
@description('The type for a sql database.')
type sqlDatabaseType = {
  @description('Required. Name of the SQL database .')
  name: string

  @description('Optional. Array of containers to deploy in the SQL database.')
  containers: containerType[]?

  @description('Optional. Request units per second. Will be ignored if autoscaleSettingsMaxThroughput is used. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level.')
  throughput: int?

  @description('Optional. Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level.')
  autoscaleSettingsMaxThroughput: int?

  @description('Optional. Tags of the SQL database resource.')
  tags: resourceInput<'Microsoft.DocumentDB/databaseAccounts/sqlDatabases@2025-04-15'>.tags?
}

@export()
@description('The type for a table.')
type tableType = {
  @description('Required. Name of the table.')
  name: string

  @description('Optional. Tags for the table.')
  tags: resourceInput<'Microsoft.DocumentDB/databaseAccounts/tables@2025-04-15'>.tags?

  @description('Optional. Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored.')
  maxThroughput: int?

  @description('Optional. Request Units per second (for example 10000). Cannot be set together with `maxThroughput`.')
  throughput: int?
}

import { cassandraRoleAssignmentType } from 'cassandra-role-definition/main.bicep'
@export()
@description('The type for an Azure Cosmos DB for Apache Cassandra native role-based access control assignment.')
type cassandraStandaloneRoleAssignmentType = {
  @description('Optional. The unique name of the role assignment.')
  name: string?

  @description('Required. The unique identifier of the Azure Cosmos DB for Apache Cassandra native role-based access control definition.')
  roleDefinitionId: string

  @description('Required. The unique identifier for the associated Microsoft Entra ID principal to which access is being granted through this role-based access control assignment. The tenant ID for the principal is inferred using the tenant associated with the subscription.')
  principalId: string

  @description('Optional. The data plane resource path for which access is being granted through this role-based access control assignment. Defaults to the current account.')
  scope: string?
}

@export()
@description('The type for an Azure Cosmos DB for Apache Cassandra native role-based access control definition.')
type cassandraRoleDefinitionType = {
  @description('Optional. The unique identifier of the role-based access control definition.')
  name: string?

  @description('Required. A user-friendly name for the role-based access control definition. Must be unique for the database account.')
  roleName: string

  @description('Optional. An array of data actions that are allowed. Note: Valid data action strings are currently undocumented (API version 2025-05-01-preview). Expected to follow format similar to SQL RBAC once documented by Microsoft.')
  dataActions: string[]?

  @description('Optional. An array of data actions that are denied. Note: Unlike SQL RBAC, Cassandra supports deny rules for granular access control. Valid data action strings are currently undocumented (API version 2025-05-01-preview).')
  notDataActions: string[]?

  @description('Optional. A set of fully qualified Scopes at or below which Role Assignments may be created using this Role Definition.')
  assignableScopes: string[]?

  @description('Optional. An array of role-based access control assignments to be created for the definition.')
  assignments: cassandraRoleAssignmentType[]?
}

@export()
@description('The type for an Azure Cosmos DB Cassandra keyspace.')
type cassandraKeyspaceType = {
  @description('Required. Name of the Cassandra keyspace.')
  name: string

  @description('Optional. Array of Cassandra tables to deploy in the keyspace.')
  tables: cassandraTableType[]?

  @description('Optional. Array of Cassandra views (materialized views) to deploy in the keyspace.')
  views: cassandraViewType[]?

  @description('Optional. Represents maximum throughput, the resource can scale up to. Cannot be set together with `throughput`. If `throughput` is set to something else than -1, this autoscale setting is ignored. Setting throughput at the keyspace level is only recommended for development/test or when workload across all tables in the shared throughput keyspace is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the table level and not at the keyspace level.')
  autoscaleSettingsMaxThroughput: int?

  @description('Optional. Request Units per second (for example 10000). Cannot be set together with `autoscaleSettingsMaxThroughput`. Setting throughput at the keyspace level is only recommended for development/test or when workload across all tables in the shared throughput keyspace is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the table level and not at the keyspace level.')
  throughput: int?

  @description('Optional. Tags of the Cassandra keyspace resource.')
  tags: resourceInput<'Microsoft.DocumentDB/databaseAccounts/cassandraKeyspaces@2024-11-15'>.tags?
}

@export()
@discriminator('name')
@description('The type for the default identity.')
type defaultIdentityType =
  | defaultIdentityFirstPartyType
  | defaultIdentitySystemAssignedType
  | defaultIdentityUserAssignedType
type defaultIdentityFirstPartyType = {
  @description('Required. The type of default identity to use.')
  name: 'FirstPartyIdentity'
}
type defaultIdentitySystemAssignedType = {
  @description('Required. The type of default identity to use.')
  name: 'SystemAssignedIdentity'
}
type defaultIdentityUserAssignedType = {
  @description('Required. The type of default identity to use.')
  name: 'UserAssignedIdentity'

  @description('Required. The resource ID of the user assigned identity to use as the default identity.')
  resourceId: string
}
