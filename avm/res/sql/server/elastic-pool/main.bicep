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

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. The lock settings of the elastic pool.')
param lock lockType?

@description('Optional. The elastic pool SKU.')
param sku skuType = {
  capacity: 2
  name: 'GP_Gen5'
  tier: 'GeneralPurpose'
}

@description('Optional. Time in minutes after which elastic pool is automatically paused. A value of -1 means that automatic pause is disabled.')
param autoPauseDelay int = -1

@description('Required. If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).')
@allowed([
  -1
  1
  2
  3
])
param availabilityZone int

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
param perDatabaseSettings perDatabaseSettingsType = {
  autoPauseDelay: -1
  maxCapacity: '2'
  minCapacity: '0'
}

@description('Optional. Type of enclave requested on the elastic pool.')
param preferredEnclaveType 'Default' | 'VBS' = 'Default'

@description('Optional. Whether or not this elastic pool is zone redundant, which means the replicas of this elastic pool will be spread across multiple availability zones.')
param zoneRedundant bool = true

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.5.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

// ============= //
//   Variables   //
// ============= //

var builtInRoleNames = {
  // Add other relevant built-in roles here for your resource as per BCPNFR5
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Log Analytics Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '92aaf0da-9dab-42b6-94a3-d43ce8d16293'
  )
  'Log Analytics Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '73c42c96-874c-492b-b04d-ab87d138a893'
  )
  'Monitoring Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
  )
  'Monitoring Metrics Publisher': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '3913510d-42f4-4e42-8a64-420c390055eb'
  )
  'Monitoring Reader': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
  )
  'Reservation Purchaser': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f7b75c60-3036-4b75-91c3-6b41c27c1689'
  )
  'Resource Policy Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '36243c78-bf99-498c-9df9-86d9f8d28608'
  )
  'SQL DB Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '9b7fa17d-e63e-47b0-bb0a-15c516ac86ec'
  )
  'SQL Security Manager': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '056cd41c-7e88-42e1-933e-88ba6a50c9c3'
  )
  'SQL Server Contributor': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '6d8ee4ec-f05a-4a1d-8b00-a9b17e38b437'
  )
  'SqlDb Migration Role': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '189207d4-bb67-4208-a635-b06afe8b2c57'
  )
}

var formattedRoleAssignments = [
  for (roleAssignment, index) in (roleAssignments ?? []): union(roleAssignment, {
    roleDefinitionId: builtInRoleNames[?roleAssignment.roleDefinitionIdOrName] ?? (contains(
        roleAssignment.roleDefinitionIdOrName,
        '/providers/Microsoft.Authorization/roleDefinitions/'
      )
      ? roleAssignment.roleDefinitionIdOrName
      : subscriptionResourceId('Microsoft.Authorization/roleDefinitions', roleAssignment.roleDefinitionIdOrName))
  })
]

resource server 'Microsoft.Sql/servers@2023-08-01' existing = {
  name: serverName
}

resource elasticPool 'Microsoft.Sql/servers/elasticPools@2023-08-01' = {
  name: name
  location: location
  parent: server
  tags: tags
  sku: sku
  properties: {
    autoPauseDelay: autoPauseDelay
    availabilityZone: availabilityZone != -1 ? string(availabilityZone) : 'NoPreference'
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

resource elasticPool_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: elasticPool
}

resource elasticPool_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(server.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: elasticPool
  }
]

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
type perDatabaseSettingsType = {
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
type skuType = {
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
