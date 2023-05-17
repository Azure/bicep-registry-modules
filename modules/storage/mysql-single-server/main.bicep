targetScope = 'resourceGroup'

@description('Deployment region name. Default is the location of the resource group.')
param location string = resourceGroup().location

@description('Deployment tags. Default is empty map.')
param tags object = {}

@description('Required. The administrator username of the server. Can only be specified when the server is being created.')
param administratorLogin string

@secure()
@description('Required. The administrator password of the server. Can only be specified when the server is being created.')
param administratorLoginPassword string

@description('Optional. The number of days a backup is retained.')
@minValue(7)
@maxValue(35)
param backupRetentionDays int = 35

@description('Optional. The mode to create a new server.')
@allowed([
  'Default'
  'GeoRestore'
  'PointInTimeRestore'
  'Replica'
])
param createMode string = 'Default'

@description('Optional. List of databases to create on server.')
param databases array = []

@description('Optional. List of server configurations to create on server.')
param serverConfigurations array = []

@description('Optional. Status showing whether the server enabled infrastructure encryption..')
@allowed([
  'Enabled'
  'Disabled'
])
param infrastructureEncryption string = 'Disabled'

@description('Optional. List of firewall rules to create on server.')
param firewallRules array = []

@description('Optional. List of privateEndpoints to create on mysql server.')
param privateEndpoints array = []

@description('Optional. Enable or disable geo-redundant backups.')
@allowed([
  'Enabled'
  'Disabled'
])
param geoRedundantBackup string = 'Enabled'

@description('Optional. Enforce a minimal Tls version for the server.')
@allowed([
  'TLS1_0'
  'TLS1_1'
  'TLS1_2'
  'TLSEnforcementDisabled'
])
param minimalTlsVersion string = 'TLS1_2'

@description('Optional. Restore point creation time (ISO8601 format), specifying the time to restore from.')
param restorePointInTime string = ''

@description('Optional. Whether or not public network access is allowed for this server.')
@allowed([
  'Enabled'
  'Disabled'
])
param publicNetworkAccess string = 'Disabled'

@description('Required. The name of the server.')
param serverName string

@description('Optional.	The name of the sku, typically, tier + family + cores, e.g. B_Gen4_1, GP_Gen5_8.')
param skuName string = 'GP_Gen5_2'

@description('Optional. The source server resource id to restore from, e.g. "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg1/providers/Microsoft.DBforMySQL/flexibleServers/server1" . It\'s required when "createMode" is "GeoRestore" or "Replica" or "PointInTimeRestore".')
param sourceServerResourceId string = ''

@description('Optional. Enable ssl enforcement or not when connect to server.')
@allowed([
  'Enabled'
  'Disabled'
])
param sslEnforcement string = 'Enabled'

@description('Optional. Auto grow of storage.')
param storageAutogrow bool = true

@description('Optional. The storage size of the server.')
param storageSizeGB int = 32

@description('Optional. The version of the MySQL server.')
@allowed([
  '5.6'
  '5.7'
  '8.0'
])
param version string = '8.0'

@description('Array of role assignment objects that contain the "roleDefinitionIdOrName" and "principalId" to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, provide either the display name of the role definition, or its fully qualified ID in the following format: "/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11"')
param roleAssignments array = []

var varPrivateEndpoints = [for endpoint in privateEndpoints: {
  name: '${mysqlServer.name}-${endpoint.name}'
  privateLinkServiceId: mysqlServer.id
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

resource mysqlServer 'Microsoft.DBforMySQL/servers@2017-12-01' = {
  name: serverName
  location: location
  tags: tags
  sku: {
    name: skuName
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    createMode: createMode
    administratorLogin: administratorLogin
    administratorLoginPassword: administratorLoginPassword
    version: version
    minimalTlsVersion: minimalTlsVersion
    infrastructureEncryption: infrastructureEncryption
    sslEnforcement: sslEnforcement
    storageProfile: {
      storageMB: storageSizeGB * 1024
      backupRetentionDays: backupRetentionDays
      geoRedundantBackup: geoRedundantBackup
      storageAutogrow: createMode == 'Replica' ? null : (storageAutogrow ? 'Enabled' : 'Disabled')
    }
    publicNetworkAccess: publicNetworkAccess
    sourceServerId: createMode != 'Default' ? sourceServerResourceId : json('null')
    restorePointInTime: createMode == 'PointInTimeRestore' ? restorePointInTime : json('null')
  }
}

@batchSize(1)
resource mysqlServerFirewallRules 'Microsoft.DBforMySQL/servers/firewallRules@2017-12-01' = [for firewallRule in firewallRules: {
  name: firewallRule.name
  parent: mysqlServer
  properties: {
    startIpAddress: firewallRule.startIpAddress
    endIpAddress: firewallRule.endIpAddress
  }
}]

@batchSize(1)
resource mysqlServerDatabases 'Microsoft.DBforMySQL/servers/databases@2017-12-01' = [for database in databases: {
  name: database.name
  parent: mysqlServer

  properties: {
    charset: contains(database, 'charset') ? database.charset : 'utf8'
    collation: contains(database, 'collation') ? database.collation : 'utf8_general_ci'
  }
}]

@batchSize(1)
resource mysqlServerConfig 'Microsoft.DBforMySQL/servers/configurations@2017-12-01' = [for configuration in serverConfigurations: {
  name: configuration.name
  dependsOn: [
    mysqlServerFirewallRules
  ]
  parent: mysqlServer
  properties: {
    value: configuration.value
    source: 'user-override'
  }
}]

@batchSize(1)
module MySQLDBAccount_rbac 'modules/rbac.bicep' = [for (roleAssignment, index) in roleAssignments: {
  name: 'mysqldb-rbac-${uniqueString(deployment().name, location)}-${index}'
  params: {
    description: contains(roleAssignment, 'description') ? roleAssignment.description : ''
    principalIds: roleAssignment.principalIds
    roleDefinitionIdOrName: roleAssignment.roleDefinitionIdOrName
    principalType: contains(roleAssignment, 'principalType') ? roleAssignment.principalType : ''
    serverName: serverName
  }
}]

module MySQLDB_privateEndpoint 'modules/privateEndpoint.bicep' = {
  name: '${serverName}-${uniqueString(deployment().name, location)}-private-endpoints'
  params: {
    location: location
    privateEndpoints: varPrivateEndpoints
    tags: tags
  }
}

@description('MySQL Single Server Resource id')
output id string = mysqlServer.id
@description('MySQL Single Server fully Qualified Domain Name')
output fqdn string = mysqlServer.properties.fullyQualifiedDomainName
