targetScope = 'resourceGroup'

// General params
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
/*
e.g.
[{
    name: 'mysql'
    charset: 'UTF8'             // Default: 'UTF8'
    collation: 'en_US.UTF8'     //Default: 'UTF8_general_ci'
  }
]
*/

@description('Optional. List of server configurations to create on server.')
param serverConfigurations array = []
/*
e.g.
[{
    name: 'backend_flush_after'
    value: '256'
  }
]
*/

@description('Optional. Status showing whether the server enabled infrastructure encryption..')
@allowed([
  'Enabled'
  'Disabled'
])
param infrastructureEncryption string = 'Disabled'

@description('Optional. List of firewall rules to create on server.')
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

@description('Optional. List of privateEndpoints to create on server.')
param privateEndpoints array = []
/*
e.g.
[{
    name: ''
    id: ''
    description: 'Auto-approved by Bicep module'
    status: 'Approved'
  }
]
*/

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

@allowed([
  'Enabled'
  'Disabled'
])
@description('Optional. Auto grow of storage.')
param storageAutogrow string = 'Enabled'

@description('Optional. The storage size of the server.')
param storageSizeGB int = 32

@description('Optional. The version of the MySQL server.')
@allowed([
  '5.6'
  '5.7'
  '8.0'
])
param version string = '8.0'

@description('Optional. Virtual Network Name')
param virtualNetworkName string = 'azure_mysql_vnet'

@description('Optional. Subnet Name')
param subnetName string = 'azure_mysql_subnet'

@description('Optional. Virtual Network RuleName')
param virtualNetworkRuleName string = 'AllowSubnet'

@description('Optional. Virtual Network Address Prefix')
param vnetAddressPrefix string = '10.0.0.0/16'

@description('Optional. Subnet Address Prefix')
param subnetPrefix string = '10.0.0.0/16'

@description('Optional. Create firewall rule before the virtual network has vnet service endpoint enabled')
param ignoreMissingVnetServiceEndpoint bool = true

@description('Optional. Private DNS zone name for the private endpoint. Default is privatelink.mysql.database.azure.com')
param privateDnsZoneName string = 'privatelink.mysql.database.azure.com'

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' = {
  name: virtualNetworkName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetAddressPrefix
      ]
    }
  }
}

resource subnet 'Microsoft.Network/virtualNetworks/subnets@2021-05-01' = {
  parent: vnet
  name: subnetName
  properties: {
    addressPrefix: subnetPrefix
  }
}

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
      storageAutogrow: storageAutogrow
    }
    publicNetworkAccess: publicNetworkAccess
    sourceServerId: createMode != 'Default' ? sourceServerResourceId : json('null')
    restorePointInTime: createMode == 'PointInTimeRestore' ? restorePointInTime : json('null')
  }
}

resource virtualNetworkRule 'Microsoft.DBforMySQL/servers/virtualNetworkRules@2017-12-01' = {
  name: virtualNetworkRuleName
  properties: {
    ignoreMissingVnetServiceEndpoint: ignoreMissingVnetServiceEndpoint
    virtualNetworkSubnetId: subnet.id
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
resource mysqlServerprivateEndpoint 'Microsoft.DBforMySQL/servers/privateEndpointConnections@2018-06-01' = [for privateEndpoint in privateEndpoints:{
  name: privateEndpoint.name
  parent: mysqlServer
  properties: {
    privateEndpoint: {
      id: privateEndpoint.id
    }
    privateLinkServiceConnectionState: {
      description: privateEndpoint.description
      status: privateEndpoint.status
    }
  }
}]

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZoneName
  location: location
}

@description('MySQL server Resource id')
output id string = mysqlServer.id
@description('MySQL fully Qualified Domain Name')
output fqdn string = mysqlServer.properties.fullyQualifiedDomainName
