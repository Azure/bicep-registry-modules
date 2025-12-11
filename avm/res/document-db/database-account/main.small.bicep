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
@description('Optional. Disable write operations on metadata resources (databases, containers, throughput) via account keys. Defaults to true.')
param disableKeyBasedMetadataWriteAccess bool = true

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
  kind: 'GlobalDocumentDB'
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
    disableKeyBasedMetadataWriteAccess: disableKeyBasedMetadataWriteAccess
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
