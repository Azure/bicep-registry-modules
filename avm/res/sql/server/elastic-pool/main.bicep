metadata name = 'SQL Server Elastic Pool'
metadata description = 'This module deploys an Azure SQL Server Elastic Pool.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the Elastic Pool.')
param name string

@description('Conditional. The name of the parent SQL Server. Required if the template is used in a standalone deployment.')
param serverName string

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Capacity of the particular SKU.')
param skuCapacity int = 2

@description('Optional. The name of the SKU, typically, a letter + Number code, e.g. P3.')
param skuName string = 'GP_Gen5'

@description('Optional. The tier or edition of the particular SKU, e.g. Basic, Premium.')
param skuTier string = 'GeneralPurpose'

@description('Optional. The number of secondary replicas associated with the elastic pool that are used to provide high availability. Applicable only to Hyperscale elastic pools.')
param highAvailabilityReplicaCount int?

@description('Optional. The license type to apply for this elastic pool.')
@allowed([
  'BasePrice'
  'LicenseIncluded'
])
param licenseType string = 'LicenseIncluded'

@description('Optional. Maintenance configuration resource ID assigned to the elastic pool. This configuration defines the period when the maintenance updates will will occur.')
param maintenanceConfigurationId string = ''

@description('Optional. The storage limit for the database elastic pool in bytes.')
param maxSizeBytes int = 34359738368

@description('Optional. Minimal capacity that serverless pool will not shrink below, if not paused.')
param minCapacity int?

@description('Optional. The maximum capacity any one database can consume.')
param databaseMaxCapacity int = 2

@description('Optional. The minimum capacity all databases are guaranteed.')
param databaseMinCapacity int = 0

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
  sku: {
    capacity: skuCapacity
    name: skuName
    tier: skuTier
  }
  properties: {
    highAvailabilityReplicaCount: highAvailabilityReplicaCount
    licenseType: licenseType
    maintenanceConfigurationId: maintenanceConfigurationId
    maxSizeBytes: maxSizeBytes
    minCapacity: minCapacity
    perDatabaseSettings: {
      minCapacity: databaseMinCapacity
      maxCapacity: databaseMaxCapacity
    }
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
