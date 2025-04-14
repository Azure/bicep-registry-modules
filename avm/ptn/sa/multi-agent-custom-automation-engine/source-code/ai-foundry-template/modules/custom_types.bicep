// Reference: https://github.com/Azure/bicep-registry-modules/tree/main/avm/res/document-db/database-account
@export()
type sqlDatabaseType = {
  @description('Required. Name of the SQL database .')
  name: string

  @description('Optional. Default to 400. Request units per second. Will be ignored if autoscaleSettingsMaxThroughput is used. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level.')
  throughput: int?

  @description('Optional. Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. Setting throughput at the database level is only recommended for development/test or when workload across all containers in the shared throughput database is uniform. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level and not at the database level.')
  autoscaleSettingsMaxThroughput: int?

  @description('Optional. Array of containers to deploy in the SQL database.')
  containers: {
    @description('Required. Name of the container.')
    name: string

    @maxLength(3)
    @minLength(1)
    @description('Required. List of paths using which data within the container can be partitioned. For kind=MultiHash it can be up to 3. For anything else it needs to be exactly 1.')
    paths: string[]

    @description('Optional. Default to 0. Indicates how long data should be retained in the analytical store, for a container. Analytical store is enabled when ATTL is set with a value other than 0. If the value is set to -1, the analytical store retains all historical data, irrespective of the retention of the data in the transactional store.')
    analyticalStorageTtl: int?

    @maxValue(1000000)
    @description('Optional. Specifies the Autoscale settings and represents maximum throughput, the resource can scale up to. The autoscale throughput should have valid throughput values between 1000 and 1000000 inclusive in increments of 1000. If value is set to null, then autoscale will be disabled. For best performance for large production workloads, it is recommended to set dedicated throughput (autoscale or manual) at the container level.')
    autoscaleSettingsMaxThroughput: int?

    @description('Optional. The conflict resolution policy for the container. Conflicts and conflict resolution policies are applicable if the Azure Cosmos DB account is configured with multiple write regions.')
    conflictResolutionPolicy: {
      @description('Conditional. The conflict resolution path in the case of LastWriterWins mode. Required if `mode` is set to \'LastWriterWins\'.')
      conflictResolutionPath: string?

      @description('Conditional. The procedure to resolve conflicts in the case of custom mode. Required if `mode` is set to \'Custom\'.')
      conflictResolutionProcedure: string?

      @description('Required. Indicates the conflict resolution mode.')
      mode: ('Custom' | 'LastWriterWins')
    }?

    @maxValue(2147483647)
    @minValue(-1)
    @description('Optional. Default to -1. Default time to live (in seconds). With Time to Live or TTL, Azure Cosmos DB provides the ability to delete items automatically from a container after a certain time period. If the value is set to "-1", it is equal to infinity, and items don\'t expire by default.')
    defaultTtl: int?

    @description('Optional. Indexing policy of the container.')
    indexingPolicy: object?

    @description('Optional. Default to Hash. Indicates the kind of algorithm used for partitioning.')
    kind: ('Hash' | 'MultiHash')?

    @description('Optional. Default to 1 for Hash and 2 for MultiHash - 1 is not allowed for MultiHash. Version of the partition key definition.')
    version: (1 | 2)?

    @description('Optional. Default to 400. Request Units per second. Will be ignored if autoscaleSettingsMaxThroughput is used.')
    throughput: int?

    @description('Optional. The unique key policy configuration containing a list of unique keys that enforces uniqueness constraint on documents in the collection in the Azure Cosmos DB service.')
    uniqueKeyPolicyKeys: {
      @description('Required. List of paths must be unique for each document in the Azure Cosmos DB service.')
      paths: string[]
    }[]?
  }[]?
}

// Reference: https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/main.bicep
@export()
type databasePropertyType = {
  @description('Required. The name of the Elastic Pool.')
  name: string

  @description('Optional. Tags of the resource.')
  tags: object?

  @description('Optional. The database SKU.')
  sku: databaseSkuType?

  @description('Optional. Time in minutes after which database is automatically paused. A value of -1 means that automatic pause is disabled.')
  autoPauseDelay: int?

  @description('Optional. Specifies the availability zone the database is pinned to.')
  availabilityZone: '1' | '2' | '3' | 'NoPreference'?

  @description('Optional. Collation of the metadata catalog.')
  catalogCollation: string?

  @description('Optional. The collation of the database.')
  collation: string?

  @description('Optional. Specifies the mode of database creation.')
  createMode:
    | 'Copy'
    | 'Default'
    | 'OnlineSecondary'
    | 'PointInTimeRestore'
    | 'Recovery'
    | 'Restore'
    | 'RestoreExternalBackup'
    | 'RestoreExternalBackupSecondary'
    | 'RestoreLongTermRetentionBackup'
    | 'Secondary'?

  @description('Optional. The resource identifier of the elastic pool containing this database.')
  elasticPoolResourceId: string?

  @description('Optional. The azure key vault URI of the database if it\'s configured with per Database Customer Managed Keys.')
  encryptionProtector: string?

  @description('Optional. The flag to enable or disable auto rotation of database encryption protector AKV key.')
  encryptionProtectorAutoRotation: bool?

  @description('Optional. The Client id used for cross tenant per database CMK scenario.')
  @minLength(36)
  @maxLength(36)
  federatedClientId: string?

  @description('Optional. Specifies the behavior when monthly free limits are exhausted for the free database.')
  freeLimitExhaustionBehavior: 'AutoPause' | 'BillOverUsage'?

  @description('Optional. The number of secondary replicas associated with the database that are used to provide high availability. Not applicable to a Hyperscale database within an elastic pool.')
  highAvailabilityReplicaCount: int?

  @description('Optional. Whether or not this database is a ledger database, which means all tables in the database are ledger tables.')
  isLedgerOn: bool?

  // keys
  @description('Optional. The license type to apply for this database.')
  licenseType: 'BasePrice' | 'LicenseIncluded'?

  @description('Optional. The resource identifier of the long term retention backup associated with create operation of this database.')
  longTermRetentionBackupResourceId: string?

  @description('Optional. Maintenance configuration id assigned to the database. This configuration defines the period when the maintenance updates will occur.')
  maintenanceConfigurationId: string?

  @description('Optional. Whether or not customer controlled manual cutover needs to be done during Update Database operation to Hyperscale tier.')
  manualCutover: bool?

  @description('Optional. The max size of the database expressed in bytes.')
  maxSizeBytes: int?

  // string to enable fractional values
  @description('Optional. Minimal capacity that database will always have allocated, if not paused.')
  minCapacity: string?

  @description('Optional. To trigger customer controlled manual cutover during the wait state while Scaling operation is in progress.')
  performCutover: bool?

  @description('Optional. Type of enclave requested on the database.')
  preferredEnclaveType: 'Default' | 'VBS'?

  @description('Optional. The state of read-only routing. If enabled, connections that have application intent set to readonly in their connection string may be routed to a readonly secondary replica in the same region. Not applicable to a Hyperscale database within an elastic pool.')
  readScale: 'Disabled' | 'Enabled'?

  @description('Optional. The resource identifier of the recoverable database associated with create operation of this database.')
  recoverableDatabaseResourceId: string?

  @description('Optional. The resource identifier of the recovery point associated with create operation of this database.')
  recoveryServicesRecoveryPointResourceId: string?

  @description('Optional. The storage account type to be used to store backups for this database.')
  requestedBackupStorageRedundancy: 'Geo' | 'GeoZone' | 'Local' | 'Zone'?

  @description('Optional. The resource identifier of the restorable dropped database associated with create operation of this database.')
  restorableDroppedDatabaseResourceId: string?

  @description('Optional. Specifies the point in time (ISO8601 format) of the source database that will be restored to create the new database.')
  restorePointInTime: string?

  @description('Optional. The name of the sample schema to apply when creating this database.')
  sampleName: string?

  @description('Optional. The secondary type of the database if it is a secondary.')
  secondaryType: 'Geo' | 'Named' | 'Standby'?

  @description('Optional. Specifies the time that the database was deleted.')
  sourceDatabaseDeletionDate: string?

  @description('Optional. The resource identifier of the source database associated with create operation of this database.')
  sourceDatabaseResourceId: string?

  @description('Optional. The resource identifier of the source associated with the create operation of this database.')
  sourceResourceId: string?

  @description('Optional. Whether or not the database uses free monthly limits. Allowed on one database in a subscription.')
  useFreeLimit: bool?

  @description('Optional. Whether or not this database is zone redundant, which means the replicas of this database will be spread across multiple availability zones.')
  zoneRedundant: bool?

  @description('Optional. The diagnostic settings of the service.')
  diagnosticSettings: diagnosticSettingFullType[]?

  @description('Optional. The short term backup retention policy for the database.')
  backupShortTermRetentionPolicy: shortTermBackupRetentionPolicyType?

  @description('Optional. The long term backup retention policy for the database.')
  backupLongTermRetentionPolicy: longTermBackupRetentionPolicyType?
}

// Reference: https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/database/main.bicep
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

// Reference: https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/database/main.bicep
@export()
@description('The short-term backup retention policy for the database.')
type shortTermBackupRetentionPolicyType = {
  @description('Optional. Differential backup interval in hours. For Hyperscale tiers this value will be ignored.')
  diffBackupIntervalInHours: int?

  @description('Optional. Point-in-time retention in days.')
  retentionDays: int?
}

// Reference: https://github.com/Azure/bicep-registry-modules/blob/main/avm/res/sql/server/database/main.bicep
@export()
@description('The long-term backup retention policy for the database.')
type longTermBackupRetentionPolicyType = {
  @description('Optional. The BackupStorageAccessTier for the LTR backups.')
  backupStorageAccessTier: 'Archive' | 'Hot'?

  @description('Optional. The setting whether to make LTR backups immutable.')
  makeBackupsImmutable: bool?

  @description('Optional. Monthly retention in ISO 8601 duration format.')
  monthlyRetention: string?

  @description('Optional. Weekly retention in ISO 8601 duration format.')
  weeklyRetention: string?

  @description('Optional. Week of year backup to keep for yearly retention.')
  weekOfYear: int?

  @description('Optional. Yearly retention in ISO 8601 duration format.')
  yearlyRetention: string?
}


import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
