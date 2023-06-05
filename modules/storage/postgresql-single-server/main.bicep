@description('The location into which your Azure resources should be deployed.')
param location string = resourceGroup().location

@minLength(3)
@maxLength(63)
// Must contain only lowercase letters, hyphens and numbers
// Must contain at least 3 through 63 characters
// Can't start or end with hyphen
@description('The name of the Postgresql Single Server instance.')
param sqlServerName string

@description('The tags to apply to each resource.')
param tags object = {}

@description('The administrator username of the server. Can only be specified when the server is being created.')
// The user name for the admin user can't be azure_superuser, admin, administrator, root, guest, or public
param sqlServerAdministratorLogin string

@secure()
@minLength(8)
@maxLength(128)
@description('The administrator login password for the SQL server. Can only be specified when the server is being created.')
// The password must contain 8 to 128 characters
// Only English uppercase letters, English lowercase letters, numbers, and non-alphanumeric characters
param sqlServerAdministratorPassword string

@description('Number of days a backup is retained for point-in-time restores.')
@minValue(7)
@maxValue(35)
param backupRetentionDays int = 7

@description('The mode to create a new server.')
@allowed([
  'Default'
  'PointInTimeRestore'
  'GeoRestore'
  'Replica'
])
param createMode string = 'Default'

@description('List of databases to create on server.')
param databases array = []
/*
e.g.
[{
    name: 'postgres'            // Database names must contain 1-63 characters
    charset: 'UTF8'             // Default: 'UTF8'
    collation: 'en_US.UTF8'     //Default: 'en_US.UTF8'
  }
]
*/

@description('List of firewall rules to create on server.')
param firewallRules array = []
/*
e.g.
[{
    name: 'AllowAll'
    startIpAddress: ''
    endIpAddress: ''
  }
]
*/

@description('Toggle geo-redundant backups. Cannot be changed after server creation.')
param geoRedundantBackup bool = true

@description('Toggle infrastructure double encryption. Cannot be changed after server creation.')
param infrastructureEncryption bool = false

@description('Minimal supported TLS version.')
@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
  'TLSEnforcementDisabled'
])
param minimalTlsVersion string = 'TLS1_2'

@description('Toggle public network access.')
param publicNetworkAccess bool = false

@description('PostgreSQL version')
@allowed([
  '9.5'
  '9.6'
  '10'
  '10.0'
  '10.2'
  '11'
])
param sqlServerPostgresqlVersion string = '11'

@description('List of privateEndpoints to create on server.')
param privateEndpoints array = []

@description('The point in time (ISO8601 format) of the source server to restore from.')
param restorePointInTime string = ''

@description('List of server configurations to create on server.')
param sqlServerConfigurations array = []
/*
e.g.
[{
    name: 'backend_flush_after'
    value: '256'
  }
]
*/

@description('The name of the sku, typically, tier + family + cores, e.g. B_Gen4_1.')
param skuName string = 'GP_Gen5_2'

@description('Storage size for Postgresql Single Server. Expressed in Mebibytes. Cannot be scaled down.')
param sqlServerStorageSize int = 51200

@description('The source server id to restore from. Leave empty if creating from scratch.')
param sourceServerResourceId string = ''

@description('Toggle SSL enforcement for incoming connections.')
param sslEnforcement bool = true

@description('Toggle storage autogrow.')
param storageAutogrow bool = true

@description('Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11"')
param roleAssignments array = []

var varPrivateEndpoints = [for endpoint in privateEndpoints: {
  name: '${postgresqlSingleServer.name}-${endpoint.name}'
  privateLinkServiceId: postgresqlSingleServer.id
  groupIds: [
    endpoint.groupId
  ]
  subnetId: endpoint.subnetId
  privateDnsZones: contains(endpoint, 'privateDnsZoneId') ? [
    {
      name: 'default'
      zoneId: endpoint.privateDnsZoneId
    }
  ] : []
  manualApprovalEnabled: contains(endpoint, 'manualApprovalEnabled') ? endpoint.manualApprovalEnabled : false
}]

resource postgresqlSingleServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: toLower(sqlServerName)
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    administratorLogin: sqlServerAdministratorLogin
    administratorLoginPassword: sqlServerAdministratorPassword
    createMode: createMode
    storageProfile: {
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup ? 'Enabled' : 'Disabled'
      storageMB: sqlServerStorageSize
      storageAutogrow: createMode == 'Replica' ? null : (storageAutogrow ? 'Enabled' : 'Disabled')
    }
    version: sqlServerPostgresqlVersion
    sslEnforcement: sslEnforcement ? 'Enabled' : 'Disabled'
    publicNetworkAccess: publicNetworkAccess ? 'Enabled' : 'Disabled'
    minimalTlsVersion: minimalTlsVersion
    infrastructureEncryption: infrastructureEncryption ? 'Enabled' : 'Disabled'
    sourceServerId: createMode != 'Default' ? sourceServerResourceId : null
    restorePointInTime: createMode == 'PointInTimeRestore' ? restorePointInTime : null
  }
}

@batchSize(1)
resource postgresqlSingleServerFirewallRules 'Microsoft.DBforPostgreSQL/servers/firewallRules@2017-12-01' = [for firewallRule in firewallRules: {
  name: firewallRule.name
  parent: postgresqlSingleServer

  properties: {
    startIpAddress: firewallRule.startIpAddress
    endIpAddress: firewallRule.endIpAddress
  }
}]

@batchSize(1)
resource postgresqlSingleServerDatabases 'Microsoft.DBforPostgreSQL/servers/databases@2017-12-01' = [for database in databases: {
  name: database.name
  parent: postgresqlSingleServer

  properties: {
    charset: contains(database, 'charset') ? database.charset : 'UTF8'
    collation: contains(database, 'collation') ? database.collation : 'English_United States.1252'
  }
}]

@batchSize(1)
resource postgresqlSingleServerConfig 'Microsoft.DBforPostgreSQL/servers/configurations@2017-12-01' = [for configuration in sqlServerConfigurations: {
  name: configuration.name
  dependsOn: [
    postgresqlSingleServerFirewallRules
  ]
  parent: postgresqlSingleServer

  properties: {
    value: configuration.value
    source: 'user-override'
  }
}]

@batchSize(1)
module postgresqlSingleServerRBAC 'modules/rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'postgresql-rbac-${uniqueString(deployment().name, location)}-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    serverName: sqlServerName
  }
}]

module postgresqlSingleServerPrivateEndpoint 'modules/privateEndpoint.bicep' = {
  name: '${sqlServerName}-${uniqueString(deployment().name, location)}-private-endpoints'
  params: {
    location: location
    privateEndpoints: varPrivateEndpoints
    tags: tags
  }
}

@description('The resource group the Postgresql Single Server was deployed into.')
output resourceGroupName string = resourceGroup().name

@description('FQDN of the generated Postgresql Single Server')
output fqdn string = postgresqlSingleServer.properties.fullyQualifiedDomainName

@description('The resource ID of the Postgresql Single Server.')
output id string = postgresqlSingleServer.id
