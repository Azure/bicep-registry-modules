metadata name = 'SQL Server Elastic Pool'
metadata description = 'This module deploys an Azure SQL Server Elastic Pool.'

@description('Required. The name of the Elastic Pool.')
param name string

@description('Conditional. The name of the parent SQL Server. Required if the template is used in a standalone deployment.')
param serverName string

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. The elastic pool SKU.')
param sku elasticPoolSkuType = {
  capacity: 2
  name: 'GP_Gen5'
  tier: 'GeneralPurpose'
}

@description('Optional. Time in minutes after which elastic pool is automatically paused. A value of -1 means that automatic pause is disabled.')
param autoPauseDelay int = -1

@description('Optional. Specifies the availability zone the pool\'s primary replica is pinned to.')
param availabilityZone '1' | '2' | '3' | 'NoPreference' = 'NoPreference'

@description('Optional. The number of secondary replicas associated with the elastic pool that are used to provide high availability. Applicable only to Hyperscale elastic pools.')
param highAvailabilityReplicaCount int?

@description('Optional. The license type to apply for this elastic pool.')
@allowed([
  'BasePrice'
  'LicenseIncluded'
])
param licenseType string = 'LicenseIncluded'

@description('Optional. Maintenance configuration resource ID assigned to the elastic pool. This configuration defines the period when the maintenance updates will will occur.')
param maintenanceConfigurationId string?

@description('Optional. The storage limit for the database elastic pool in bytes.')
param maxSizeBytes int = 34359738368

@description('Optional. Minimal capacity that serverless pool will not shrink below, if not paused.')
param minCapacity int?

@description('Optional. The per database settings for the elastic pool.')
param perDatabaseSettings elasticPoolPerDatabaseSettingsType = {
  autoPauseDelay: -1
  maxCapacity: '2'
  minCapacity: '0'
}

@description('Optional. Type of enclave requested on the elastic pool.')
param preferredEnclaveType 'Default' | 'VBS' = 'Default'

@description('Optional. Whether or not this elastic pool is zone redundant, which means the replicas of this elastic pool will be spread across multiple availability zones.')
param zoneRedundant bool = true

resource server 'Microsoft.Sql/servers@2023-08-01-preview' existing = {
  name: serverName
}

resource elasticPool 'Microsoft.Sql/servers/elasticPools@2023-08-01-preview' = {
  name: name
  location: location
  parent: server
  tags: tags
  sku: sku
  properties: {
    autoPauseDelay: autoPauseDelay
    availabilityZone: availabilityZone
    highAvailabilityReplicaCount: highAvailabilityReplicaCount
    licenseType: licenseType
    maintenanceConfigurationId: maintenanceConfigurationId
    maxSizeBytes: maxSizeBytes
    minCapacity: minCapacity
    perDatabaseSettings: !empty(perDatabaseSettings)
      ? {
          autoPauseDelay: perDatabaseSettings.?autoPauseDelay
          // To handle fractional values, we need to convert from string :(
          maxCapacity: json(perDatabaseSettings.?maxCapacity)
          minCapacity: json(perDatabaseSettings.?minCapacity)
        }
      : null
    preferredEnclaveType: preferredEnclaveType
    zoneRedundant: zoneRedundant
  }
}

@description('The name of the deployed Elastic Pool.')
output name string = elasticPool.name

@description('The resource ID of the deployed Elastic Pool.')
output resourceId string = elasticPool.id

@description('The resource group of the deployed Elastic Pool.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = elasticPool.location

// =============== //
//   Definitions   //
// =============== //

@export()
@description('The per database settings for the elastic pool.')
type elasticPoolPerDatabaseSettingsType = {
  @description('Optional. Auto Pause Delay for per database within pool.')
  autoPauseDelay: int?

  @description('Required. The maximum capacity any one database can consume. Examples: \'0.5\', \'2\'.')
  maxCapacity: string

  // using string as minCapacity can be fractional
  @description('Required. The minimum capacity all databases are guaranteed. Examples: \'0.5\', \'1\'.')
  minCapacity: string
}

@export()
@description('The elastic pool SKU.')
type elasticPoolSkuType = {
  @description('Optional. The capacity of the particular SKU.')
  capacity: int?

  @description('Optional. If the service has different generations of hardware, for the same SKU, then that can be captured here.')
  family: string?

  @description('Required. The name of the SKU, typically, a letter + Number code, e.g. P3.')
  name:
    | 'BasicPool'
    | 'StandardPool'
    | 'PremiumPool'
    | 'GP_Gen5'
    | 'GP_DC'
    | 'GP_FSv2'
    | 'BC_Gen5'
    | 'BC_DC'
    | 'HS_Gen5'
    | 'HS_PRMS'
    | 'HS_MOPRMS'
    | 'ServerlessPool'

  @description('Optional. Size of the particular SKU.')
  size: string?

  @description('Optional. The tier or edition of the particular SKU, e.g. Basic, Premium.')
  tier: string?
}
