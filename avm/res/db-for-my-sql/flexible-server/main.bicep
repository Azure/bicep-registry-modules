metadata name = 'DBforMySQL Flexible Servers'
metadata description = 'This module deploys a DBforMySQL Flexible Server.'

@description('Required. The name of the MySQL flexible server.')
param name string

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. The administrator login name of a server. Can only be specified when the MySQL server is being created.')
param administratorLogin string?

@description('Optional. The administrator login password.')
@secure()
param administratorLoginPassword string?

@description('Optional. The Azure AD administrators when AAD authentication enabled.')
param administrators array = []

@description('Required. The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3.')
param skuName string

@allowed([
  'GeneralPurpose'
  'Burstable'
  'MemoryOptimized'
])
@description('Required. The tier of the particular SKU. Tier must align with the "skuName" property. Example, tier cannot be "Burstable" if skuName is "Standard_D4s_v3".')
param tier string

@allowed([
  ''
  '1'
  '2'
  '3'
])
@description('Optional. Availability zone information of the server. Default will have no preference set.')
param availabilityZone string = ''

@description('Optional. Standby availability zone information of the server. Default will have no preference set.')
param highAvailabilityZone string = ''

@minValue(1)
@maxValue(35)
@description('Optional. Backup retention days for the server.')
param backupRetentionDays int = 7

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. A value indicating whether Geo-Redundant backup is enabled on the server. If "Enabled" and "cMKKeyName" is not empty, then "geoBackupCMKKeyVaultResourceId" and "cMKUserAssignedIdentityResourceId" are also required.')
param geoRedundantBackup string = 'Enabled'

@allowed([
  'Default'
  'GeoRestore'
  'PointInTimeRestore'
  'Replica'
])
@description('Optional. The mode to create a new MySQL server.')
param createMode string = 'Default'

import { managedIdentityOnlyUserAssignedType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Conditional. The managed identity definition for this resource. Required if \'customerManagedKey\' is not empty.')
param managedIdentities managedIdentityOnlyUserAssignedType?

import { customerManagedKeyType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The customer managed key definition to use for the managed service.')
param customerManagedKey customerManagedKeyType?

@description('Optional. The customer managed key definition to use when geoRedundantBackup is "Enabled".')
param customerManagedKeyGeo customerManagedKeyType?

@allowed([
  'Disabled'
  'SameZone'
  'ZoneRedundant'
])
@description('Optional. The mode for High Availability (HA). It is not supported for the Burstable pricing tier and Zone redundant HA can only be set during server provisioning.')
param highAvailability string = 'ZoneRedundant'

@description('Optional. Properties for the maintenence window. If provided, "customWindow" property must exist and set to "Enabled".')
param maintenanceWindow object = {}

@description('Optional. Delegated subnet arm resource ID. Used when the desired connectivity mode is "Private Access" - virtual network integration. Delegation must be enabled on the subnet for MySQL Flexible Servers and subnet CIDR size is /29.')
param delegatedSubnetResourceId string?

@description('Conditional. Private dns zone arm resource ID. Used when the desired connectivity mode is "Private Access". Required if "delegatedSubnetResourceId" is used and the Private DNS Zone name must end with mysql.database.azure.com in order to be linked to the MySQL Flexible Server.')
param privateDnsZoneResourceId string?

@description('Optional. Specifies whether public network access is allowed for this server. Set to "Enabled" to allow public access, or "Disabled" (default) when the server has VNet integration.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Conditional. Restore point creation time (ISO8601 format), specifying the time to restore from. Required if "createMode" is set to "PointInTimeRestore".')
param restorePointInTime string = ''

@allowed([
  'None'
  'Replica'
  'Source'
])
@description('Optional. The replication role.')
param replicationRole string = 'None'

@description('Conditional. The source MySQL server ID. Required if "createMode" is set to "PointInTimeRestore".')
param sourceServerResourceId string?

@allowed([
  'Disabled'
  'Enabled'
])
@description('Conditional. Enable Storage Auto Grow or not. Storage auto-growth prevents a server from running out of storage and becoming read-only. Required if "highAvailability" is not "Disabled".')
param storageAutoGrow string = 'Disabled'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Enable IO Auto Scaling or not. The server scales IOPs up or down automatically depending on your workload needs.')
param storageAutoIoScaling string = 'Disabled'

@minValue(360)
@maxValue(48000)
@description('Optional. Storage IOPS for a server. Max IOPS are determined by compute size.')
param storageIOPS int = 1000

@allowed([
  20
  32
  64
  128
  256
  512
  1024
  2048
  4096
  8192
  16384
])
@description('Optional. Max storage allowed for a server. In all compute tiers, the minimum storage supported is 20 GiB and maximum is 16 TiB.')
param storageSizeGB int = 64

@allowed([
  '5.7'
  '8.0.21'
])
@description('Optional. MySQL Server version.')
param version string = '8.0.21'

@description('Optional. The databases to create in the server.')
param databases array = []

@description('Optional. The firewall rules to create in the MySQL flexible server.')
param firewallRules array = []

@description('Optional. Enable/Disable Advanced Threat Protection (Microsoft Defender) for the server.')
@allowed([
  'Enabled'
  'Disabled'
])
param advancedThreatProtection string = 'Enabled'

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.4.0'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

var standByAvailabilityZoneTable = {
  Disabled: null
  SameZone: availabilityZone
  ZoneRedundant: highAvailabilityZone
}

var standByAvailabilityZone = standByAvailabilityZoneTable[?highAvailability]

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: !empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : null
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  'MySQL Backup And Export Operator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'd18ad5f3-1baf-4119-b49b-d944edb1f9d0'
  )
  Owner: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', '8e3af657-a8ff-443c-a75c-2fe8c4bcb635')
  Reader: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'acdd72a7-3385-48ef-bd42-f606fba81ae7')
  'Role Based Access Control Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    'f58310d9-a9f6-439a-9e8d-f62e7b41a168'
  )
  'User Access Administrator': subscriptionResourceId(
    'Microsoft.Authorization/roleDefinitions',
    '18d7d88d-d35e-4fb5-a5c3-7773c20a72d9'
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

#disable-next-line no-deployments-resources
resource avmTelemetry 'Microsoft.Resources/deployments@2024-03-01' = if (enableTelemetry) {
  name: '46d3xbcp.res.dbformysql-flexibleserver.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
    name: customerManagedKey.?keyName ?? 'dummyKey'
  }
}

resource cMKUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKey.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKey.?userAssignedIdentityResourceId ?? 'dummyMsi', '/'))
  scope: resourceGroup(
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?userAssignedIdentityResourceId ?? '////'), '/')[4]
  )
}

resource cMKGeoKeyVault 'Microsoft.KeyVault/vaults@2023-02-01' existing = if (!empty(customerManagedKeyGeo.?keyVaultResourceId)) {
  name: last(split((customerManagedKeyGeo.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKeyGeo.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKeyGeo.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-02-01' existing = if (!empty(customerManagedKeyGeo.?keyVaultResourceId) && !empty(customerManagedKeyGeo.?keyName)) {
    name: customerManagedKeyGeo.?keyName ?? 'dummyKey'
  }
}

resource cMKGeoUserAssignedIdentity 'Microsoft.ManagedIdentity/userAssignedIdentities@2023-01-31' existing = if (!empty(customerManagedKeyGeo.?userAssignedIdentityResourceId)) {
  name: last(split(customerManagedKeyGeo.?userAssignedIdentityResourceId ?? 'dummyMsi', '/'))
  scope: resourceGroup(
    split((customerManagedKeyGeo.?userAssignedIdentityResourceId ?? '//'), '/')[2],
    split((customerManagedKeyGeo.?userAssignedIdentityResourceId ?? '////'), '/')[4]
  )
}

resource flexibleServer 'Microsoft.DBforMySQL/flexibleServers@2023-12-30' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: tier
  }
  identity: identity
  properties: {
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    availabilityZone: availabilityZone
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }
    createMode: createMode
    dataEncryption: !empty(customerManagedKey)
      ? {
          type: 'AzureKeyVault'
          geoBackupKeyURI: geoRedundantBackup == 'Enabled'
            ? (!empty(customerManagedKeyGeo.?keyVersion ?? '')
                ? '${cMKGeoKeyVault::cMKKey.properties.keyUri}/${customerManagedKeyGeo!.keyVersion}'
                : cMKGeoKeyVault::cMKKey.properties.keyUriWithVersion)
            : null
          geoBackupUserAssignedIdentityId: geoRedundantBackup == 'Enabled' ? cMKGeoUserAssignedIdentity.id : null
          primaryKeyURI: !empty(customerManagedKey.?keyVersion ?? '')
            ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.keyVersion}'
            : cMKKeyVault::cMKKey.properties.keyUriWithVersion
          primaryUserAssignedIdentityId: cMKUserAssignedIdentity.id
        }
      : null
    highAvailability: {
      mode: highAvailability
      standbyAvailabilityZone: standByAvailabilityZone
    }
    maintenanceWindow: !empty(maintenanceWindow)
      ? {
          customWindow: maintenanceWindow.customWindow
          dayOfWeek: maintenanceWindow.customWindow == 'Enabled' ? maintenanceWindow.dayOfWeek : 0
          startHour: maintenanceWindow.customWindow == 'Enabled' ? maintenanceWindow.startHour : 0
          startMinute: maintenanceWindow.customWindow == 'Enabled' ? maintenanceWindow.startMinute : 0
        }
      : null
    network: {
      delegatedSubnetResourceId: delegatedSubnetResourceId
      privateDnsZoneResourceId: privateDnsZoneResourceId
      publicNetworkAccess: publicNetworkAccess
    }
    replicationRole: replicationRole
    restorePointInTime: restorePointInTime
    sourceServerResourceId: sourceServerResourceId
    storage: {
      autoGrow: storageAutoGrow
      autoIoScaling: storageAutoIoScaling
      iops: storageIOPS
      storageSizeGB: storageSizeGB
    }
    version: version
  }
}

resource flexibleServer_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.'
  }
  scope: flexibleServer
}

resource flexibleServer_roleAssignments 'Microsoft.Authorization/roleAssignments@2022-04-01' = [
  for (roleAssignment, index) in (formattedRoleAssignments ?? []): {
    name: roleAssignment.?name ?? guid(flexibleServer.id, roleAssignment.principalId, roleAssignment.roleDefinitionId)
    properties: {
      roleDefinitionId: roleAssignment.roleDefinitionId
      principalId: roleAssignment.principalId
      description: roleAssignment.?description
      principalType: roleAssignment.?principalType
      condition: roleAssignment.?condition
      conditionVersion: !empty(roleAssignment.?condition) ? (roleAssignment.?conditionVersion ?? '2.0') : null // Must only be set if condtion is set
      delegatedManagedIdentityResourceId: roleAssignment.?delegatedManagedIdentityResourceId
    }
    scope: flexibleServer
  }
]

module flexibleServer_databases 'database/main.bicep' = [
  for (database, index) in databases: {
    name: '${uniqueString(deployment().name, location)}-MySQL-DB-${index}'
    params: {
      name: database.name
      flexibleServerName: flexibleServer.name
      collation: database.?collation ?? ''
      charset: database.?charset ?? ''
    }
  }
]

module flexibleServer_firewallRules 'firewall-rule/main.bicep' = [
  for (firewallRule, index) in firewallRules: {
    name: '${uniqueString(deployment().name, location)}-MySQL-FirewallRules-${index}'
    params: {
      name: firewallRule.name
      flexibleServerName: flexibleServer.name
      startIpAddress: firewallRule.startIpAddress
      endIpAddress: firewallRule.endIpAddress
    }
  }
]

module flexibleServer_administrators 'administrator/main.bicep' = [
  for (administrator, index) in administrators: {
    name: '${uniqueString(deployment().name, location)}-MySQL-Administrators-${index}'
    params: {
      flexibleServerName: flexibleServer.name
      login: administrator.login
      sid: administrator.sid
      identityResourceId: administrator.identityResourceId
      tenantId: administrator.?tenantId ?? tenant().tenantId
    }
  }
]

module flexibleServer_advancedThreatProtection 'advanced-threat-protection/main.bicep' = {
  name: '${uniqueString(deployment().name, location)}-MySQL-AdvancedThreatProtection'
  params: {
    flexibleServerName: flexibleServer.name
    advancedThreatProtection: advancedThreatProtection
  }
}

resource flexibleServer_diagnosticSettings 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = [
  for (diagnosticSetting, index) in (diagnosticSettings ?? []): {
    name: diagnosticSetting.?name ?? '${name}-diagnosticSettings'
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
    scope: flexibleServer
  }
]

@description('The name of the deployed MySQL Flexible server.')
output name string = flexibleServer.name

@description('The resource ID of the deployed MySQL Flexible server.')
output resourceId string = flexibleServer.id

@description('The resource group of the deployed MySQL Flexible server.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = flexibleServer.location

@description('The FQDN of the MySQL Flexible server.')
output fqdn string = flexibleServer.properties.fullyQualifiedDomainName
