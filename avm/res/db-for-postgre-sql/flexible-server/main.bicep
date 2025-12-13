metadata name = 'DBforPostgreSQL Flexible Servers'
metadata description = 'This module deploys a DBforPostgreSQL Flexible Server.'

@description('Required. The name of the PostgreSQL flexible server.')
param name string

@description('Optional. The administrator login name of the server. Can only be specified when the PostgreSQL server is being created.')
param administratorLogin string?

@description('Optional. The administrator login password.')
@secure()
param administratorLoginPassword string?

@description('Optional. The Azure AD administrators when AAD authentication enabled.')
param administrators administratorType[]?

@description('Optional. The authentication configuration for the server.')
param authConfig resourceInput<'Microsoft.DBforPostgreSQL/flexibleServers@2025-06-01-preview'>.properties.authConfig = {
  activeDirectoryAuth: 'Enabled'
  passwordAuth: 'Disabled'
}

@description('Optional. Location for all resources.')
param location string = resourceGroup().location

@description('Required. The name of the sku, typically, tier + family + cores, e.g. Standard_D4s_v3.')
param skuName string

@allowed([
  'GeneralPurpose'
  'Burstable'
  'MemoryOptimized'
])
@description('Required. The tier of the particular SKU. Tier must align with the \'skuName\' property. Example, tier cannot be \'Burstable\' if skuName is \'Standard_D4s_v3\'.')
param tier string

@description('Required. If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Note that the availability zone numbers here are the logical availability zone in your Azure subscription. Different subscriptions might have a different mapping of the physical zone and logical zone. To understand more, please refer to [Physical and logical availability zones](https://learn.microsoft.com/en-us/azure/reliability/availability-zones-overview?tabs=azure-cli#physical-and-logical-availability-zones).')
@allowed([
  -1
  1
  2
  3
])
param availabilityZone int

@description('Optional. Standby availability zone information of the server. If set to 1, 2 or 3, the availability zone is hardcoded to that value. If set to -1, no zone is defined. Default will have no preference set.')
@allowed([
  -1
  1
  2
  3
])
param highAvailabilityZone int = -1

@allowed([
  'Disabled'
  'SameZone'
  'ZoneRedundant'
])
@description('Optional. The mode for high availability.')
param highAvailability string = 'ZoneRedundant'

@minValue(7)
@maxValue(35)
@description('Optional. Backup retention days for the server.')
param backupRetentionDays int = 7

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. A value indicating whether Geo-Redundant backup is enabled on the server. Should be disabled if \'cMKKeyName\' is not empty.')
param geoRedundantBackup string = 'Enabled' // Enabled by default for WAF-alignment (ref: https://azure.github.io/PSRule.Rules.Azure/en/rules/Azure.PostgreSQL.GeoRedundantBackup/)

@allowed([
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
@description('Optional. Max storage allowed for a server.')
param storageSizeGB int = 32

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Flag to enable / disable Storage Auto grow for flexible server.')
param autoGrow string?

@allowed([
  '11'
  '12'
  '13'
  '14'
  '15'
  '16'
  '17'
  '18'
])
@description('Optional. PostgreSQL Server version.')
param version string = '18'

@allowed([
  'Create'
  'Default'
  'GeoRestore'
  'PointInTimeRestore'
  'Replica'
  'Update'
])
@description('Optional. The mode to create a new PostgreSQL server.')
param createMode string = 'Default'

import { managedIdentityAllType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Conditional. The managed identity definition for this resource. Required if \'cMKKeyName\' is not empty.')
param managedIdentities managedIdentityAllType?

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. Specifies the state of the Threat Protection, whether it is enabled or disabled or a state has not been applied yet on the specific server.')
param serverThreatProtection string = 'Enabled'

import { customerManagedKeyWithAutoRotateType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyWithAutoRotateType?

@description('Optional. Properties for the maintenence window. If provided, \'customWindow\' property must exist and set to \'Enabled\'.')
param maintenanceWindow resourceInput<'Microsoft.DBforPostgreSQL/flexibleServers@2025-06-01-preview'>.properties.maintenanceWindow = {
  customWindow: 'Enabled'
  dayOfWeek: 0
  startHour: 1
  startMinute: 0
}

@description('Conditional. Required if \'createMode\' is set to \'PointInTimeRestore\'.')
param pointInTimeUTC string = ''

@description('Conditional. Required if \'createMode\' is set to \'PointInTimeRestore\'.')
param sourceServerResourceId string = ''

@description('Optional. Delegated subnet arm resource ID. Used when the desired connectivity mode is \'Private Access\' - virtual network integration.')
param delegatedSubnetResourceId string?

@description('Optional. Private dns zone arm resource ID. Used when the desired connectivity mode is \'Private Access\' and required when \'delegatedSubnetResourceId\' is used. The Private DNS Zone must be linked to the Virtual Network referenced in \'delegatedSubnetResourceId\'.')
param privateDnsZoneArmResourceId string = ''

@description('Optional. The firewall rules to create in the PostgreSQL flexible server.')
param firewallRules firewallRuleType[]?

@description('Optional. Determines whether or not public network access is enabled or disabled.')
@allowed([
  'Disabled'
  'Enabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Optional. The databases to create in the server.')
param databases array = []

@description('Optional. The configurations to create in the server.')
param configurations array = []

import { lockType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The lock settings of the service.')
param lock lockType?

@description('Optional. The replication settings for the server. Can only be set on existing flexible servers.')
param replica replicaType?

@description('Optional. The replication role for the server.')
@allowed([
  'Primary'
  'AsyncReplica'
  'GeoAsyncReplica'
  'None'
])
param replicationRole string = 'None'

@description('Optional. Enable/Disable advanced threat protection.')
param enableAdvancedThreatProtection bool = true

import { roleAssignmentType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType[]?

@description('Optional. Tags of the resource.')
param tags resourceInput<'Microsoft.DBforPostgreSQL/flexibleServers@2025-06-01-preview'>.tags?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

import { diagnosticSettingFullType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingFullType[]?

import { privateEndpointSingleServiceType } from 'br/public:avm/utl/types/avm-common-types:0.6.1'
@description('Optional. Configuration details for private endpoints. Used when the desired connectivity mode is \'Public Access\' and \'delegatedSubnetResourceId\' is NOT used.')
param privateEndpoints privateEndpointSingleServiceType[]?

var enableReferencedModulesTelemetry = false

var standByAvailabilityZone = {
  Disabled: -1
  SameZone: availabilityZone
  ZoneRedundant: highAvailabilityZone
}[?highAvailability]

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: (managedIdentities.?systemAssigned ?? false)
        ? (!empty(formattedUserAssignedIdentities) ? 'SystemAssigned,UserAssigned' : 'SystemAssigned')
        : (!empty(formattedUserAssignedIdentities) ? 'UserAssigned' : 'None')
      userAssignedIdentities: !empty(formattedUserAssignedIdentities) ? formattedUserAssignedIdentities : null
    }
  : null

var builtInRoleNames = {
  Contributor: subscriptionResourceId('Microsoft.Authorization/roleDefinitions', 'b24988ac-6180-42a0-ab88-20f7382dd24c')
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
  name: '46d3xbcp.res.dbforpostgresql-flexibleserver.${replace('-..--..-', '.', '-')}.${substring(uniqueString(deployment().name, location), 0, 4)}'
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
  name: last(split((customerManagedKey.?keyVaultResourceId!), '/'))
  scope: resourceGroup(
    split(customerManagedKey.?keyVaultResourceId!, '/')[2],
    split(customerManagedKey.?keyVaultResourceId!, '/')[4]
  )

  resource cMKKey 'keys@2024-11-01' existing = if (!empty(customerManagedKey) && !isHSMManagedCMK) {
    name: customerManagedKey.?keyName!
  }
}

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2025-06-01-preview' = {
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
    #disable-next-line use-secure-value-for-secure-inputs // Is defined as secure(). False-positive
    administratorLoginPassword: administratorLoginPassword
    authConfig: authConfig
    availabilityZone: availabilityZone != -1 ? string(availabilityZone) : null
    highAvailability: {
      mode: highAvailability
      standbyAvailabilityZone: standByAvailabilityZone != -1 ? string(standByAvailabilityZone) : null
    }
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: createMode != 'Replica' ? geoRedundantBackup : null
    }
    createMode: createMode
    dataEncryption: !empty(customerManagedKey)
      ? {
          primaryKeyURI: !empty(customerManagedKey.?keyVersion)
            ? (!isHSMManagedCMK
                ? '${cMKKeyVault::cMKKey!.properties.keyUri}/${customerManagedKey!.keyVersion!}'
                : 'https://${last(split((customerManagedKey.?keyVaultResourceId!), '/'))}.managedhsm.azure.net/${customerManagedKey!.keyVersion!}')
            : (customerManagedKey.?autoRotationEnabled ?? true)
                ? (!isHSMManagedCMK
                    ? cMKKeyVault::cMKKey!.properties.keyUri
                    : 'https://${last(split((customerManagedKey.?keyVaultResourceId!), '/'))}.managedhsm.azure.net/keys/${customerManagedKey!.keyName}')
                : (!isHSMManagedCMK
                    ? cMKKeyVault::cMKKey!.properties.keyUriWithVersion
                    : fail('Managed HSM CMK encryption requires either specifying the \'keyVersion\' or omitting the \'autoRotationEnabled\' property. Setting \'autoRotationEnabled\' to false without a \'keyVersion\' is not allowed.'))
          primaryUserAssignedIdentityId: customerManagedKey.?userAssignedIdentityResourceId
          type: 'AzureKeyVault'
        }
      : null
    maintenanceWindow: !empty(maintenanceWindow)
      ? {
          customWindow: maintenanceWindow.customWindow
          dayOfWeek: maintenanceWindow.customWindow == 'Enabled' ? maintenanceWindow.dayOfWeek : 0
          startHour: maintenanceWindow.customWindow == 'Enabled' ? maintenanceWindow.startHour : 0
          startMinute: maintenanceWindow.customWindow == 'Enabled' ? maintenanceWindow.startMinute : 0
        }
      : null
    network: !empty(delegatedSubnetResourceId) && empty(firewallRules)
      ? {
          delegatedSubnetResourceId: delegatedSubnetResourceId
          privateDnsZoneArmResourceId: privateDnsZoneArmResourceId
          publicNetworkAccess: publicNetworkAccess
        }
      : { publicNetworkAccess: publicNetworkAccess }
    pointInTimeUTC: createMode == 'PointInTimeRestore' ? pointInTimeUTC : null
    replica: !empty(replica) ? replica : null
    replicationRole: replicationRole
    sourceServerResourceId: (createMode == 'PointInTimeRestore' || createMode == 'Replica')
      ? sourceServerResourceId
      : null
    storage: {
      storageSizeGB: storageSizeGB
      autoGrow: autoGrow
    }
    version: version
  }
}

resource flexibleServer_lock 'Microsoft.Authorization/locks@2020-05-01' = if (!empty(lock ?? {}) && lock.?kind != 'None') {
  name: lock.?name ?? 'lock-${name}'
  properties: {
    level: lock.?kind ?? ''
    notes: lock.?notes ?? (lock.?kind == 'CanNotDelete'
      ? 'Cannot delete resource or child resources.'
      : 'Cannot delete or modify the resource or child resources.')
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
    name: '${uniqueString(deployment().name, location)}-PostgreSQL-DB-${index}'
    params: {
      name: database.name
      flexibleServerName: flexibleServer.name
      collation: database.?collation
      charset: database.?charset
    }
    dependsOn: [
      flexibleServer_roleAssignments
    ]
  }
]

module flexibleServer_firewallRules 'firewall-rule/main.bicep' = [
  for (firewallRule, index) in (firewallRules ?? []): {
    name: '${uniqueString(deployment().name, location)}-PostgreSQL-FirewallRules-${index}'
    params: {
      name: firewallRule.name
      flexibleServerName: flexibleServer.name
      startIpAddress: firewallRule.startIpAddress
      endIpAddress: firewallRule.endIpAddress
    }
    dependsOn: [
      flexibleServer_databases
    ]
  }
]

@batchSize(1)
module flexibleServer_configurations 'configuration/main.bicep' = [
  for (configuration, index) in configurations: {
    name: '${uniqueString(deployment().name, location)}-PostgreSQL-Configurations-${index}'
    params: {
      name: configuration.name
      flexibleServerName: flexibleServer.name
      source: configuration.?source
      value: configuration.?value
    }
    dependsOn: [
      flexibleServer_firewallRules
    ]
  }
]

module flexibleServer_administrators 'administrator/main.bicep' = [
  for (administrator, index) in (administrators ?? []): {
    name: '${uniqueString(deployment().name, location)}-PostgreSQL-Administrators-${index}'
    params: {
      flexibleServerName: flexibleServer.name
      objectId: administrator.objectId
      principalName: administrator.principalName
      principalType: administrator.principalType
      tenantId: administrator.?tenantId
    }
    dependsOn: [
      flexibleServer_configurations
    ]
  }
]

module flexibleServer_advancedThreatProtection 'advanced-threat-protection-setting/main.bicep' = if (enableAdvancedThreatProtection) {
  name: '${uniqueString(deployment().name, location)}-PostgreSQL-Threat'
  params: {
    serverThreatProtection: serverThreatProtection
    flexibleServerName: flexibleServer.name
  }
  dependsOn: [
    flexibleServer_administrators
  ]
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

module server_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.11.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): if (empty(delegatedSubnetResourceId)) {
    name: '${uniqueString(deployment().name, location)}-PostgreSQL-PrivateEndpoint-${index}'
    scope: resourceGroup(
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[2],
      split(privateEndpoint.?resourceGroupResourceId ?? resourceGroup().id, '/')[4]
    )
    params: {
      name: privateEndpoint.?name ?? 'pep-${last(split(flexibleServer.id, '/'))}-${privateEndpoint.?service ?? 'postgresqlServer'}-${index}'
      privateLinkServiceConnections: privateEndpoint.?isManualConnection != true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(flexibleServer.id, '/'))}-${privateEndpoint.?service ?? 'postgresqlServer'}-${index}'
              properties: {
                privateLinkServiceId: flexibleServer.id
                groupIds: [
                  privateEndpoint.?service ?? 'postgresqlServer'
                ]
              }
            }
          ]
        : null
      manualPrivateLinkServiceConnections: privateEndpoint.?isManualConnection == true
        ? [
            {
              name: privateEndpoint.?privateLinkServiceConnectionName ?? '${last(split(flexibleServer.id, '/'))}-${privateEndpoint.?service ?? 'postgresqlServer'}-${index}'
              properties: {
                privateLinkServiceId: flexibleServer.id
                groupIds: [
                  privateEndpoint.?service ?? 'postgresqlServer'
                ]
                requestMessage: privateEndpoint.?manualConnectionRequestMessage ?? 'Manual approval required.'
              }
            }
          ]
        : null
      subnetResourceId: privateEndpoint.subnetResourceId
      enableTelemetry: enableReferencedModulesTelemetry
      location: privateEndpoint.?location ?? reference(
        split(privateEndpoint.subnetResourceId, '/subnets/')[0],
        '2020-06-01',
        'Full'
      ).location
      lock: privateEndpoint.?lock ?? lock
      privateDnsZoneGroup: privateEndpoint.?privateDnsZoneGroup
      roleAssignments: privateEndpoint.?roleAssignments
      tags: privateEndpoint.?tags ?? tags
      customDnsConfigs: privateEndpoint.?customDnsConfigs
      ipConfigurations: privateEndpoint.?ipConfigurations
      applicationSecurityGroupResourceIds: privateEndpoint.?applicationSecurityGroupResourceIds
      customNetworkInterfaceName: privateEndpoint.?customNetworkInterfaceName
    }
  }
]

@description('The name of the deployed PostgreSQL Flexible server.')
output name string = flexibleServer.name

@description('The resource ID of the deployed PostgreSQL Flexible server.')
output resourceId string = flexibleServer.id

@description('The resource group of the deployed PostgreSQL Flexible server.')
output resourceGroupName string = resourceGroup().name

@description('The location the resource was deployed into.')
output location string = flexibleServer.location

@description('The FQDN of the PostgreSQL Flexible server.')
output fqdn string? = flexibleServer.properties.?fullyQualifiedDomainName

@description('The private endpoints of the PostgreSQL Flexible server.')
output privateEndpoints privateEndpointOutputType[] = [
  for (item, index) in (privateEndpoints ?? []): {
    name: server_privateEndpoints[index]!.outputs.name
    resourceId: server_privateEndpoints[index]!.outputs.resourceId
    groupId: server_privateEndpoints[index]!.outputs.?groupId!
    customDnsConfigs: server_privateEndpoints[index]!.outputs.customDnsConfigs
    networkInterfaceResourceIds: server_privateEndpoints[index]!.outputs.networkInterfaceResourceIds
  }
]

@description('The principal ID of the system assigned managed identity.')
output systemAssignedMIPrincipalId string? = flexibleServer.?identity.?principalId

// =============== //
//   Definitions   //
// =============== //

@export()
type privateEndpointOutputType = {
  @description('The name of the private endpoint.')
  name: string

  @description('The resource ID of the private endpoint.')
  resourceId: string

  @description('The group Id for the private endpoint Group.')
  groupId: string?

  @description('The custom DNS configurations of the private endpoint.')
  customDnsConfigs: {
    @description('FQDN that resolves to private endpoint IP address.')
    fqdn: string?

    @description('A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]

  @description('The IDs of the network interfaces associated with the private endpoint.')
  networkInterfaceResourceIds: string[]
}

@export()
@description('The type of replication settings for the server. Can only be set on existing flexible servers.')
type replicaType = {
  @description('Conditional. Sets the promote mode for a replica server. This is a write only property. Required if enabling replication.')
  promoteMode: ('standalone' | 'switchover')

  @description('Conditional. Sets the promote options for a replica server. This is a write only property. Required if enabling replication.')
  promoteOption: ('forced' | 'planned')

  @description('Conditional. Used to indicate role of the server in replication set. Required if enabling replication.')
  role: ('AsyncReplica' | 'GeoAsyncReplica' | 'None' | 'Primary')
}

@export()
@description('The type of an administrator.')
type administratorType = {
  @description('Required. The objectId of the Active Directory administrator.')
  objectId: string

  @description('Required. Active Directory administrator principal name.')
  principalName: string

  @description('Required. The principal type used to represent the type of Active Directory Administrator.')
  principalType: ('Group' | 'ServicePrincipal' | 'Unknown' | 'User')

  @description('Optional. The tenantId of the Active Directory administrator.')
  tenantId: string?
}

@export()
@description('The type of a firewall rule.')
type firewallRuleType = {
  @description('Required. The name of the PostgreSQL flexible server Firewall Rule.')
  name: string

  @description('Required. The start IP address of the firewall rule. Must be IPv4 format. Use value \'0.0.0.0\' for all Azure-internal IP addresses.')
  startIpAddress: string

  @description('Required. The end IP address of the firewall rule. Must be IPv4 format. Must be greater than or equal to startIpAddress. Use value \'0.0.0.0\' for all Azure-internal IP addresses.')
  endIpAddress: string
}
