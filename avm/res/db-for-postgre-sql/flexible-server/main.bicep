metadata name = 'DBforPostgreSQL Flexible Servers'
metadata description = 'This module deploys a DBforPostgreSQL Flexible Server.'
metadata owner = 'Azure/module-maintainers'

@description('Required. The name of the PostgreSQL flexible server.')
param name string

@description('Optional. The administrator login name of a server. Can only be specified when the PostgreSQL server is being created.')
param administratorLogin string = ''

@description('Optional. The administrator login password.')
@secure()
param administratorLoginPassword string = ''

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. If Enabled, Azure Active Directory authentication is enabled.')
param activeDirectoryAuth string = 'Enabled'

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. If Enabled, password authentication is enabled.')
#disable-next-line secure-secrets-in-params
param passwordAuth string = 'Disabled'

@description('Optional. Tenant id of the server.')
param tenantId string = ''

@description('Optional. The Azure AD administrators when AAD authentication enabled.')
param administrators array = []

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

@allowed([
  ''
  '1'
  '2'
  '3'
])
@description('Optional. Availability zone information of the server. Default will have no preference set.')
param availabilityZone string = ''

@minValue(7)
@maxValue(35)
@description('Optional. Backup retention days for the server.')
param backupRetentionDays int = 7

@allowed([
  'Disabled'
  'Enabled'
])
@description('Optional. A value indicating whether Geo-Redundant backup is enabled on the server. Should be left disabled if \'cMKKeyName\' is not empty.')
param geoRedundantBackup string = 'Disabled'

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
  '11'
  '12'
  '13'
  '14'
  '15'
  '16'
])
@description('Optional. PostgreSQL Server version.')
param version string = '16'

@allowed([
  'Disabled'
  'SameZone'
  'ZoneRedundant'
])
@description('Optional. The mode for high availability.')
param highAvailability string = 'ZoneRedundant'

@allowed([
  'Create'
  'Default'
  'PointInTimeRestore'
  'Update'
])
@description('Optional. The mode to create a new PostgreSQL server.')
param createMode string = 'Default'

@description('Conditional. The managed identity definition for this resource. Required if \'cMKKeyName\' is not empty.')
param managedIdentities managedIdentitiesType

@description('Optional. The customer managed key definition.')
param customerManagedKey customerManagedKeyType

@description('Optional. Properties for the maintenence window. If provided, \'customWindow\' property must exist and set to \'Enabled\'.')
param maintenanceWindow object = {
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
param delegatedSubnetResourceId string = ''

@description('Optional. Private dns zone arm resource ID. Used when the desired connectivity mode is \'Private Access\' and required when \'delegatedSubnetResourceId\' is used. The Private DNS Zone must be linked to the Virtual Network referenced in \'delegatedSubnetResourceId\'.')
param privateDnsZoneArmResourceId string = ''

@description('Optional. The firewall rules to create in the PostgreSQL flexible server.')
param firewallRules array = []

@description('Optional. The databases to create in the server.')
param databases array = []

@description('Optional. The configurations to create in the server.')
param configurations array = []

@description('Optional. The lock settings of the service.')
param lock lockType

@description('Optional. Array of role assignments to create.')
param roleAssignments roleAssignmentType

@description('Optional. Tags of the resource.')
param tags object?

@description('Optional. Enable/Disable usage telemetry for module.')
param enableTelemetry bool = true

@description('Optional. The diagnostic settings of the service.')
param diagnosticSettings diagnosticSettingType

@description('Optional. Configuration details for private endpoints. Used when the desired connectivy mode is \'Public Access\' and \'delegatedSubnetResourceId\' is NOT used.')
param privateEndpoints privateEndpointType

var formattedUserAssignedIdentities = reduce(
  map((managedIdentities.?userAssignedResourceIds ?? []), (id) => { '${id}': {} }),
  {},
  (cur, next) => union(cur, next)
) // Converts the flat array to an object like { '${id1}': {}, '${id2}': {} }

var identity = !empty(managedIdentities)
  ? {
      type: !empty(managedIdentities.?userAssignedResourceIds ?? {}) ? 'UserAssigned' : 'None'
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

resource cMKKeyVault 'Microsoft.KeyVault/vaults@2023-07-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId)) {
  name: last(split((customerManagedKey.?keyVaultResourceId ?? 'dummyVault'), '/'))
  scope: resourceGroup(
    split((customerManagedKey.?keyVaultResourceId ?? '//'), '/')[2],
    split((customerManagedKey.?keyVaultResourceId ?? '////'), '/')[4]
  )

  resource cMKKey 'keys@2023-07-01' existing = if (!empty(customerManagedKey.?keyVaultResourceId) && !empty(customerManagedKey.?keyName)) {
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

resource flexibleServer 'Microsoft.DBforPostgreSQL/flexibleServers@2022-12-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    name: skuName
    tier: tier
  }
  identity: identity
  properties: {
    administratorLogin: !empty(administratorLogin) ? administratorLogin : null
    administratorLoginPassword: !empty(administratorLoginPassword) ? administratorLoginPassword : null
    authConfig: {
      activeDirectoryAuth: activeDirectoryAuth
      passwordAuth: passwordAuth
      tenantId: !empty(tenantId) ? tenantId : null
    }
    availabilityZone: availabilityZone
    backup: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
    }
    createMode: createMode
    dataEncryption: !empty(customerManagedKey)
      ? {
          primaryKeyURI: !empty(customerManagedKey.?keyVersion ?? '')
            ? '${cMKKeyVault::cMKKey.properties.keyUri}/${customerManagedKey!.keyVersion}'
            : cMKKeyVault::cMKKey.properties.keyUriWithVersion
          primaryUserAssignedIdentityId: cMKUserAssignedIdentity.id
          type: 'AzureKeyVault'
        }
      : null
    highAvailability: {
      mode: highAvailability
      standbyAvailabilityZone: highAvailability == 'SameZone' ? availabilityZone : null
    }
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
        }
      : null
    pointInTimeUTC: createMode == 'PointInTimeRestore' ? pointInTimeUTC : null
    sourceServerResourceId: createMode == 'PointInTimeRestore' ? sourceServerResourceId : null
    storage: {
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
    name: '${uniqueString(deployment().name, location)}-PostgreSQL-DB-${index}'
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
      source: configuration.?source ?? ''
      value: configuration.?value ?? ''
    }
    dependsOn: [
      flexibleServer_firewallRules
    ]
  }
]

module flexibleServer_administrators 'administrator/main.bicep' = [
  for (administrator, index) in administrators: {
    name: '${uniqueString(deployment().name, location)}-PostgreSQL-Administrators-${index}'
    params: {
      flexibleServerName: flexibleServer.name
      objectId: administrator.objectId
      principalName: administrator.principalName
      principalType: administrator.principalType
      tenantId: administrator.?tenantId ?? tenant().tenantId
    }
    dependsOn: [
      flexibleServer_configurations
    ]
  }
]

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

module server_privateEndpoints 'br/public:avm/res/network/private-endpoint:0.4.1' = [
  for (privateEndpoint, index) in (privateEndpoints ?? []): if (empty(delegatedSubnetResourceId)) {
    name: '${uniqueString(deployment().name, location)}-flexibleserver-PrivateEndpoint-${index}'
    scope: resourceGroup(privateEndpoint.?resourceGroupName ?? '')
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
      enableTelemetry: privateEndpoint.?enableTelemetry ?? enableTelemetry
      location: privateEndpoint.?location ?? reference(
        split(privateEndpoint.subnetResourceId, '/subnets/')[0],
        '2020-06-01',
        'Full'
      ).location
      lock: privateEndpoint.?lock ?? lock
      privateDnsZoneGroupName: privateEndpoint.?privateDnsZoneGroupName
      privateDnsZoneResourceIds: privateEndpoint.?privateDnsZoneResourceIds
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
output fqdn string = flexibleServer.properties.fullyQualifiedDomainName

// =============== //
//   Definitions   //
// =============== //

type managedIdentitiesType = {
  @description('Optional. The resource ID(s) to assign to the resource.')
  userAssignedResourceIds: string[]
}?

type lockType = {
  @description('Optional. Specify the name of lock.')
  name: string?

  @description('Optional. Specify the type of lock.')
  kind: ('CanNotDelete' | 'ReadOnly' | 'None')?
}?

type roleAssignmentType = {
  @description('Optional. The name (as GUID) of the role assignment. If not provided, a GUID will be generated.')
  name: string?

  @description('Required. The role to assign. You can provide either the display name of the role definition, the role definition GUID, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'.')
  roleDefinitionIdOrName: string

  @description('Required. The principal ID of the principal (user/group/identity) to assign the role to.')
  principalId: string

  @description('Optional. The principal type of the assigned principal ID.')
  principalType: ('ServicePrincipal' | 'Group' | 'User' | 'ForeignGroup' | 'Device')?

  @description('Optional. The description of the role assignment.')
  description: string?

  @description('Optional. The conditions on the role assignment. This limits the resources it can be assigned to. e.g.: @Resource[Microsoft.Storage/storageAccounts/blobServices/containers:ContainerName] StringEqualsIgnoreCase "foo_storage_container".')
  condition: string?

  @description('Optional. Version of the condition.')
  conditionVersion: '2.0'?

  @description('Optional. The Resource Id of the delegated managed identity resource.')
  delegatedManagedIdentityResourceId: string?
}[]?

type diagnosticSettingType = {
  @description('Optional. The name of diagnostic setting.')
  name: string?

  @description('Optional. The name of logs that will be streamed. "allLogs" includes all possible logs for the resource. Set to `[]` to disable log collection.')
  logCategoriesAndGroups: {
    @description('Optional. Name of a Diagnostic Log category for a resource type this setting is applied to. Set the specific logs to collect here.')
    category: string?

    @description('Optional. Name of a Diagnostic Log category group for a resource type this setting is applied to. Set to `allLogs` to collect all logs.')
    categoryGroup: string?

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. The name of metrics that will be streamed. "allMetrics" includes all possible metrics for the resource. Set to `[]` to disable metric collection.')
  metricCategories: {
    @description('Required. Name of a Diagnostic Metric category for a resource type this setting is applied to. Set to `AllMetrics` to collect all metrics.')
    category: string

    @description('Optional. Enable or disable the category explicitly. Default is `true`.')
    enabled: bool?
  }[]?

  @description('Optional. A string indicating whether the export to Log Analytics should use the default destination type, i.e. AzureDiagnostics, or use a destination type.')
  logAnalyticsDestinationType: ('Dedicated' | 'AzureDiagnostics')?

  @description('Optional. Resource ID of the diagnostic log analytics workspace. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  workspaceResourceId: string?

  @description('Optional. Resource ID of the diagnostic storage account. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  storageAccountResourceId: string?

  @description('Optional. Resource ID of the diagnostic event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
  eventHubAuthorizationRuleResourceId: string?

  @description('Optional. Name of the diagnostic event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category. For security reasons, it is recommended to set diagnostic settings to send data to either storage account, log analytics workspace or event hub.')
  eventHubName: string?

  @description('Optional. The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic Logs.')
  marketplacePartnerResourceId: string?
}[]?

type customerManagedKeyType = {
  @description('Required. The resource ID of a key vault to reference a customer managed key for encryption from.')
  keyVaultResourceId: string

  @description('Required. The name of the customer managed key to use for encryption.')
  keyName: string

  @description('Optional. The version of the customer managed key to reference for encryption. If not provided, using \'latest\'.')
  keyVersion: string?

  @description('Required. User assigned identity to use when fetching the customer managed key.')
  userAssignedIdentityResourceId: string
}?

type privateEndpointType = {
  @description('Optional. The name of the private endpoint.')
  name: string?

  @description('Optional. The location to deploy the private endpoint to.')
  location: string?

  @description('Optional. The name of the private link connection to create.')
  privateLinkServiceConnectionName: string?

  @description('Optional. The subresource to deploy the private endpoint for. For example "vault", "mysqlServer" or "dataFactory".')
  service: string?

  @description('Required. Resource ID of the subnet where the endpoint needs to be created.')
  subnetResourceId: string

  @description('Optional. The name of the private DNS zone group to create if `privateDnsZoneResourceIds` were provided.')
  privateDnsZoneGroupName: string?

  @description('Optional. The private DNS zone groups to associate the private endpoint with. A DNS zone group can support up to 5 DNS zones.')
  privateDnsZoneResourceIds: string[]?

  @description('Optional. If Manual Private Link Connection is required.')
  isManualConnection: bool?

  @description('Optional. A message passed to the owner of the remote resource with the manual connection request.')
  @maxLength(140)
  manualConnectionRequestMessage: string?

  @description('Optional. Custom DNS configurations.')
  customDnsConfigs: {
    @description('Required. Fqdn that resolves to private endpoint IP address.')
    fqdn: string?

    @description('Required. A list of private IP addresses of the private endpoint.')
    ipAddresses: string[]
  }[]?

  @description('Optional. A list of IP configurations of the private endpoint. This will be used to map to the First Party Service endpoints.')
  ipConfigurations: {
    @description('Required. The name of the resource that is unique within a resource group.')
    name: string

    @description('Required. Properties of private endpoint IP configurations.')
    properties: {
      @description('Required. The ID of a group obtained from the remote resource that this private endpoint should connect to.')
      groupId: string

      @description('Required. The member name of a group obtained from the remote resource that this private endpoint should connect to.')
      memberName: string

      @description('Required. A private IP address obtained from the private endpoint\'s subnet.')
      privateIPAddress: string
    }
  }[]?

  @description('Optional. Application security groups in which the private endpoint IP configuration is included.')
  applicationSecurityGroupResourceIds: string[]?

  @description('Optional. The custom name of the network interface attached to the private endpoint.')
  customNetworkInterfaceName: string?

  @description('Optional. Specify the type of lock.')
  lock: lockType

  @description('Optional. Array of role assignments to create.')
  roleAssignments: roleAssignmentType

  @description('Optional. Tags to be applied on all resources/resource groups in this deployment.')
  tags: object?

  @description('Optional. Enable/Disable usage telemetry for module.')
  enableTelemetry: bool?

  @description('Optional. Specify if you want to deploy the Private Endpoint into a different resource group than the main resource.')
  resourceGroupName: string?
}[]?
