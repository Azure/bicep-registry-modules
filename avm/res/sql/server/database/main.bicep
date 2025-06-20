metadata name = 'SQL Server Database'
metadata description = 'This module deploys an Azure SQL Server Database.'

// START OF DATABASE PROPERTIES

@description('Required. The name of the database.')
param name string

@description('Conditional. The name of the parent SQL Server. Required if the template is used in a standalone deployment.')
param serverName string

@description('Optional. The database SKU.')
param sku databaseSkuType = {
  name: 'GP_Gen5_2'
  tier: 'GeneralPurpose'
}

@description('Optional. Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled.')
param autoPauseDelay int = -1

@description('Required. If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).')
@allowed([
  -1
  1
  2
  3
])
param availabilityZone int

@description('Optional. Collation of the metadata catalog.')
param catalogCollation string = 'DATABASE_DEFAULT'

@description('Optional. The collation of the database.')
param collation string = 'SQL_Latin1_General_CP1_CI_AS'

@description('Optional. Specifies the mode of database creation.')
param createMode
  | 'Default'
  | 'Copy'
  | 'OnlineSecondary'
  | 'PointInTimeRestore'
  | 'Recovery'
  | 'Restore'
  | 'RestoreExternalBackup'
  | 'RestoreExternalBackupSecondary'
  | 'RestoreLongTermRetentionBackup'
  | 'Secondary' = 'Default'

@description('Optional. The resource ID of the elastic pool containing this database.')
param elasticPoolResourceId string?

@description('Optional. The Client id used for cross tenant per database CMK scenario.')
@minLength(36)
@maxLength(36)
param federatedClientId string?

@description('Optional. Specifies the behavior when monthly free limits are exhausted for the free database.')
param freeLimitExhaustionBehavior 'AutoPause' | 'BillOverUsage'?

@description('Optional. The number of readonly secondary replicas associated with the database.')
param highAvailabilityReplicaCount int = 0

@description('Optional. Whether or not this database is a ledger database, which means all tables in the database are ledger tables. Note: the value of this property cannot be changed after the database has been created.')
param isLedgerOn bool = false

@description('Optional. The license type to apply for this database.')
param licenseType 'BasePrice' | 'LicenseIncluded'?

@description('Optional. The resource identifier of the long term retention backup associated with create operation of this database.')
param longTermRetentionBackupResourceId string?

@description('Optional. Maintenance configuration ID assigned to the database. This configuration defines the period when the maintenance updates will occur.')
param maintenanceConfigurationId string?

@description('Optional. Whether or not customer controlled manual cutover needs to be done during Update Database operation to Hyperscale tier.')
param manualCutover bool?

@description('Optional. The max size of the database expressed in bytes.')
param maxSizeBytes int = 34359738368

@description('Optional. Minimal capacity that database will always have allocated.')
param minCapacity string = '0'

@description('Optional. To trigger customer controlled manual cutover during the wait state while Scaling operation is in progress.')
param performCutover bool?

@description('Optional. Type of enclave requested on the database i.e. Default or VBS enclaves.')
param preferredEnclaveType 'Default' | 'VBS'?

@description('Optional. The state of read-only routing.')
param readScale 'Enabled' | 'Disabled' = 'Disabled'

@description('Optional. The resource identifier of the recoverable database associated with create operation of this database.')
param recoverableDatabaseResourceId string?

@description('Optional. The resource identifier of the recovery point associated with create operation of this database.')
param recoveryServicesRecoveryPointResourceId string?

@description('Optional. The storage account type to be used to store backups for this database.')
param requestedBackupStorageRedundancy 'Geo' | 'GeoZone' | 'Local' | 'Zone' = 'Local'

@description('Optional. The resource identifier of the restorable dropped database associated with create operation of this database.')
param restorableDroppedDatabaseResourceId string?

@description('Optional. Point in time (ISO8601 format) of the source database to restore when createMode set to Restore or PointInTimeRestore.')
param restorePointInTime string?

@description('Optional. The name of the sample schema to apply when creating this database.')
param sampleName string = ''

@description('Optional. The secondary type of the database if it is a secondary.')
param secondaryType 'Geo' | 'Named' | 'Standby'?

@description('Optional. The time that the database was deleted when restoring a deleted database.')
param sourceDatabaseDeletionDate string?

@description('Optional. The resource identifier of the source database associated with create operation of this database.')
param sourceDatabaseResourceId string?

@description('Optional. The resource identifier of the source associated with the create operation of this database.')
param sourceResourceId string?

@description('Optional. Whether or not the database uses free monthly limits. Allowed on one database in a subscription.')
param useFreeLimit bool?

@description('Optional. Whether or not this database is zone redundant.')
param zoneRedundant bool = true

// END OF DATABASE PROPERTIES

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the databse.')
param lock lockType?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. The short term backup retention policy to create for the database.')
param backupShortTermRetentionPolicy shortTermBackupRetentionPolicyType?

@description('Optional. The long term backup retention policy to create for the database.')
param backupLongTermRetentionPolicy longTermBackupRetentionPolicyType?

import { managedIdentityOnlyUserAssignedType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The managed identity definition for this resource.')
param managedIdentities managedIdentityOnlyUserAssignedType?

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The customer managed key definition for database TDE.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName
}

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (!empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null)
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split(customerManagedKey.?keyVaultResourceId!, '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2023-07-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName!
  }
}

resource database 'Microsoft.Sql/servers/databases@2023-08-01' = {
  name: name
  parent: server
  location: location
  tags: tags
  sku: sku
  identity: identity
  properties: {
    autoPauseDelay: autoPauseDelay
    availabilityZone: availabilityZone != -1 ? string(availabilityZone) : 'NoPreference'
    catalogCollation: catalogCollation
    collation: collation
    createMode: createMode
    elasticPoolId: elasticPoolResourceId
    encryptionProtector: customerManagedKey != null
      ? !empty(customerManagedKey.?keyVersion)
          ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.?keyVersion}'
          : cMKKeyVault::cMKKey.properties.keyUriWithVersion
      : null
    encryptionProtectorAutoRotation: customerManagedKey.?autoRotationEnabled
    federatedClientId: federatedClientId
    freeLimitExhaustionBehavior: freeLimitExhaustionBehavior
    highAvailabilityReplicaCount: highAvailabilityReplicaCount
    isLedgerOn: isLedgerOn
    licenseType: licenseType
    longTermRetentionBackupResourceId: longTermRetentionBackupResourceId
    maintenanceConfigurationId: maintenanceConfigurationId
    manualCutover: manualCutover
    maxSizeBytes: maxSizeBytes
    // The json() function is used to allow specifying a decimal value.
    minCapacity: !empty(minCapacity) ? json(minCapacity) : 0
    performCutover: performCutover
    preferredEnclaveType: preferredEnclaveType
    readScale: readScale
    recoverableDatabaseId: recoverableDatabaseResourceId
    recoveryServicesRecoveryPointId: recoveryServicesRecoveryPointResourceId
    requestedBackupStorageRedundancy: requestedBackupStorageRedundancy
    restorableDroppedDatabaseId: restorableDroppedDatabaseResourceId
    restorePointInTime: restorePointInTime
    sampleName: sampleName
    secondaryType: secondaryType
    sourceDatabaseDeletionDate: sourceDatabaseDeletionDate
    sourceDatabaseId: sourceDatabaseResourceId
    sourceResourceId: sourceResourceId
    useFreeLimit: useFreeLimit
    zoneRedundant: zoneRedundant
  }
}

resource database_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${replace(name, ' ', '_')}-diagnosticSettings'
    properties: {
      storageAccountId: diagnosticSetting.?storageAccountResourceId
      workspaceId: diagnosticSetting.?workspaceResourceId
      eventHubAuthorizationRuleId: diagnosticSetting.?eventHubAuthorizationRuleResourceId
      eventHubName: diagnosticSetting.?eventHubName
      metrics: [
        for group in (diagnosticSetting.?metricCategories ?? [{ category: 'AllMetrics' }]): {
          category: group.category
          enabled: group.?enabled ?? true
          timeGrain: null
        }
      ]
      logs: [
        for group in (diagnosticSetting.?logCategoriesAndGroups ?? [{ categoryGroup: 'allLogs' }]): {
          categoryGroup: group.?categoryGroup
          category: group.?category
          enabled: group.?enabled ?? true
        }
      ]
      marketplacePartnerId: diagnosticSetting.?marketplacePartnerResourceId
      logAnalyticsDestinationType: diagnosticSetting.?logAnalyticsDestinationType
    }
    scope: database
  }
]

resource database_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: database
}

module database_backupShortTermRetentionPolicy 'backup-short-term-retention-policy/main.bicep' = if (!empty(backupShortTermRetentionPolicy)) {
  name: '${uniqueString(deployment().name, location)}-shBakRetPol'
  params: {
    serverName: serverName
    databaseName: database.name
    diffBackupIntervalInHours: backupShortTermRetentionPolicy.?diffBackupIntervalInHours
    retentionDays: backupShortTermRetentionPolicy.?retentionDays
  }
}

module database_backupLongTermRetentionPolicy 'backup-long-term-retention-policy/main.bicep' = if (!empty(backupLongTermRetentionPolicy)) {
  name: '${uniqueString(deployment().name, location)}-lgBakRetPol'
  params: {
    serverName: serverName
    databaseName: database.name
    weeklyRetention: backupLongTermRetentionPolicy.?weeklyRetention
    monthlyRetention: backupLongTermRetentionPolicy.?monthlyRetention
    yearlyRetention: backupLongTermRetentionPolicy.?yearlyRetention
    weekOfYear: backupLongTermRetentionPolicy.?weekOfYear
  }
}

// =============== //
//     Outputs     //
// =============== //

@description('The name of the deployed database.')
output name string = database.name

@description('The resource ID of the deployed database.')
output resourceId string = database.id

@description('The resource group of the deployed database.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = database.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The database SKU.')
type databaseSkuType = {
  @description('Optional. The capacity of the particular SKU.')
  capacity: int?

  @description('Optional. If the service has different generations of hardware, for the same SKU, then that can be captured here.')
  family: string?

  @description('Required. The name of the SKU, typically, a letter + Number code, e.g. P3.')
  name: string

  @description('Optional. Size of the particular SKU.')
  size: string?

  @description('Optional. The tier or edition of the particular SKU, e.g. Basic, Premium.')
  tier: string?
}

@export()
@description('The short-term backup retention policy for the database.')
type shortTermBackupRetentionPolicyType = {
  @description('Optional. Differential backup interval in hours. For Hyperscale tiers this value will be ignored.')
  diffBackupIntervalInHours: int?

  @description('Optional. Point-in-time retention in days.')
  retentionDays: int?
}

@export()
@description('The long-term backup retention policy for the database.')
type longTermBackupRetentionPolicyType = {
  @description('Optional. Monthly retention in ISO 8601 duration format.')
  monthlyRetention: string?

  @description('Optional. Weekly retention in ISO 8601 duration format.')
  weeklyRetention: string?

  @description('Optional. Week of year backup to keep for yearly retention.')
  weekOfYear: int?

  @description('Optional. Yearly retention in ISO 8601 duration format.')
  yearlyRetention: string?
}
